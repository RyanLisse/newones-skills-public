---
name: make-pr-easy-to-review
description: Prepare a PR for review — cleaner history (only if agreed), better description, reviewer guidance — without changing code behavior.
disable-model-invocation: true
allowed-tools: Bash(gh *) Bash(git *)
---

<!-- Copied from https://github.com/RyanLisse/claude-code-skills-pack/tree/867fcb1626f321dbc21a854fce0dd39be2f8aaa4/skills/make-pr-easy-to-review (Ryan Lisse, MIT). Upstream: cursor/plugins `cursor-team-kit` (MIT, Copyright (c) 2026 Cursor; licence text: LICENSE.cursor). -->

# Make PR easy to review

Goal: reviewability without behavior changes.

## Workflow

1. Resolve PR from URL or current branch.
2. Inspect commits, diff size, paths, generated files, description.
3. Flag reviewability issues: noisy commits, stale description, mixed mechanical + logic changes, unclear entry points.
4. Propose a plan before any history rewrite or force-push.
5. Apply safe improvements; verify tree/diff still matches intended code.

## History cleanup

Only rewrite when the user asks or agrees. Before rewriting, record `ORIGINAL_TREE=$(git rev-parse HEAD^{tree})` (or the remote head tree). After rewrite, trees must match unless an intentional content fix was agreed.

Suggested commit order: schema/API → core logic → wiring → UI → tests.

## Reviewer guidance (prefer when behavior stays put)

- TL;DR matching the actual diff
- Core files vs generated/mechanical files
- Risk, migration/rollout, test coverage
- Links to issues/design docs when they explain intent

## Guardrails

- Never hide behavior changes inside "cleanup"
- Do not bypass hooks unless asked
- If the PR is too large, recommend splitting instead of polishing around the problem
