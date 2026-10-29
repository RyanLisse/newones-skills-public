---
name: new-branch-and-pr
description: Create a fresh branch from latest main, finish the work, commit, push, and open a pull request.
argument-hint: "[branch-slug or short goal]"
disable-model-invocation: true
allowed-tools: Bash(gh *) Bash(git *)
---

<!-- Copied from https://github.com/RyanLisse/claude-code-skills-pack/tree/867fcb1626f321dbc21a854fce0dd39be2f8aaa4/skills/new-branch-and-pr (Ryan Lisse, MIT). Upstream: cursor/plugins `cursor-team-kit` (MIT, Copyright (c) 2026 Cursor; licence text: LICENSE.cursor). -->

# New branch and PR

Goal / hint: $ARGUMENTS

## Workflow

1. Ensure the working tree is clean or explicitly handled.
2. Update main and create a descriptive branch.
3. Complete implementation and tests.
4. Commit focused changes and push with `-u`.
5. Open a concise PR (summary + test plan).

## Guardrails

- One change set per branch
- Include verification notes before requesting review
- Author commits as the repo's configured user; never invent co-authors

## Output

- Branch name
- PR summary + test notes
- PR URL
