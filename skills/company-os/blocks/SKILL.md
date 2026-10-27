---
name: blocks
description: Use the repo-local blocks scripts to reduce noisy test output, locate the first failure, or inspect the shape of large JSON without printing its contents.
---

# Blocks

These small, dependency-free helpers are for Herdr work-lanes that need a compact, repeatable view of command output. They are not a replacement for the complete output when debugging requires it.

The scripts live at `.agents/skills/blocks/` after this skill is installed.

## Commands

- `test-summary [FILE]` reads a test-runner log from `FILE` or stdin. It reports only pass, fail, and skip totals, followed by failing test names when present. It understands Bun test, Vitest, and Playwright-style summaries and exits non-zero when failures are reported. With `test-summary -- <cmd...>`, it runs the command itself, merges stdout and stderr, summarizes the output, and preserves any non-zero command exit code.
- `first-error [FILE] [--context N]` reads a log from `FILE` or stdin and prints the first line that looks like an error, `FAIL`, `TypeError`, or a stack-trace start, plus `N` following lines. `N` defaults to 8.
- `json-peek [FILE] [--depth N]` reads JSON from `FILE` or stdin and prints a JSON description of its types, object keys, array lengths, and first-array-element shapes. `N` defaults to 2. String values are never printed; only their lengths are included.

Use a file argument when the command already wrote a log, or pipe directly to stdin. Keep the original log in case the summary is not enough to diagnose the failure. In short work-lane updates, use these scripts instead of ad-hoc `| tail` output.

Prefer `test-summary -- bun test ...` so the command's exit status cannot be lost. If piping, enable `set -o pipefail` so a failed test command still fails the lane: `set -o pipefail; bun test 2>&1 | .agents/skills/blocks/test-summary`. If `test-summary` receives empty stdin, it prints a hint to stderr and exits with status 2; pass a log file when the original output is already saved.

Examples:

```sh
.agents/skills/blocks/test-summary test-output.txt
.agents/skills/blocks/test-summary -- bun test packages/api/test
cat test-output.txt | .agents/skills/blocks/first-error --context 12
.agents/skills/blocks/json-peek data.json --depth 3
```
