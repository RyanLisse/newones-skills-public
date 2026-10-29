---
name: get-pr-comments
description: Fetch and summarize review comments on the active pull request into a prioritized action list.
disable-model-invocation: true
allowed-tools: Bash(gh *)
---

<!-- Copied from https://github.com/RyanLisse/claude-code-skills-pack/tree/867fcb1626f321dbc21a854fce0dd39be2f8aaa4/skills/get-pr-comments (Ryan Lisse, MIT). Upstream: cursor/plugins `cursor-team-kit` (MIT, Copyright (c) 2026 Cursor; licence text: LICENSE.cursor). -->

# Get PR comments

## Context

- PR: !`gh pr view --json number,url,title 2>/dev/null || true`
- Review comments: !`gh api repos/{owner}/{repo}/pulls/$(gh pr view --json number -q .number)/comments --jq '.[].body' 2>/dev/null | head -200 || true`
- Issue comments: !`gh pr view --comments 2>/dev/null | head -200 || true`

## Workflow

1. Resolve the active PR for the current branch.
2. Fetch review + discussion comments.
3. Group by severity and actionability.
4. Return a concise action list.

## Output

- Grouped feedback summary
- Action list (priority order)
- Open questions still needing clarification
