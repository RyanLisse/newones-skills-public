---
name: fix-ci
description: Find failing PR checks, inspect logs, and apply focused fixes until green. Use when CI is red on the current branch or PR.
disable-model-invocation: true
allowed-tools: Bash(gh *) Bash(git *)
---

<!-- Copied from https://github.com/RyanLisse/claude-code-skills-pack/tree/867fcb1626f321dbc21a854fce0dd39be2f8aaa4/skills/fix-ci (Ryan Lisse, MIT). Upstream: cursor/plugins `cursor-team-kit` (MIT, Copyright (c) 2026 Cursor; licence text: LICENSE.cursor). -->

# Fix CI

## Context

- PR checks: !`gh pr checks --json name,bucket,state,workflow,link 2>/dev/null || true`
- PR: !`gh pr view --json number,url,title,headRefName 2>/dev/null || true`

## Workflow

1. Resolve the active PR; treat `gh pr checks` as source of truth.
2. Open the first failing job; extract the first actionable error (Actions logs or external check link).
3. Apply the smallest safe fix.
4. Push, re-check, repeat until green (or blocked on human input).

## Guardrails

- One actionable failure at a time
- Prefer low-risk fixes before refactors
- Do not bypass hooks unless the user explicitly asks

## Output

- Primary failing job + root error
- Fixes applied (iteration order)
- Current CI status + next action
