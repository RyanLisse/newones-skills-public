---
name: visual-pr
description: Only use when the user explicitly invokes this skill by name.
---

<!-- Adapted from humanlayer/skills plugins/visual-pr (MIT, Copyright (c) 2026 HumanLayer). Licence text: LICENSE.humanlayer. -->

# Describe a Pull Request

Create or update the pull request for the current task with a concise description that helps a reviewer understand why the change exists and the shape of the implementation.

The description uses the repository's own `.github/pull_request_template.md`. There is no second template: this skill only says how to fill its **What** section.

## Workflow

1. Read the template and keep every heading, in order, plus any marker comments (CI may parse them):

   `Read(.github/pull_request_template.md)`

2. Identify or create the pull request:
   - Check the current branch for a PR with `gh pr view --json url,number,title,state,baseRefName,headRefName 2>/dev/null`.
   - If no PR exists, inspect `git status --short --branch` and the commits on the current branch.
   - Commit task-related changes when needed, push the branch with an upstream, and create a PR for it. Follow the repository's git safety protocol (no force-push, no `--no-verify`).
   - Ask the user to select a PR only when the current branch has no relevant work and there is no safe current-branch PR to create.

3. Gather only the context needed to explain the change:
   - Read the Linear issue (THE-id) and any relevant plan or task files.
   - Read the complete PR diff and enough surrounding code to understand behavior and ownership.
   - Use `gh pr view` to collect PR metadata and changed files.
   - Read `references/show-me.md` for the visual-outline conventions used in the What section.

4. Fill the template sections:
   - **What**: start with exactly one sentence saying what problem this PR solves and what becomes possible after it ships. Below it, a compact `/show-me`-style change outline: a structural view, not prose and not a file-by-file changelog.
   - Include only the outline views that help explain this PR:
     - SQL table and endpoint contract changes, plus pseudocode for business logic.
     - Key data structure / type changes.
     - A shallow file tree showing changed responsibilities.
     - React component tree changes, including important hooks, state, and package boundaries.
     - Call-tree, call-stack, control-flow, or data-flow changes.
   - Prefer `diff` blocks when showing changes to an existing shape. Show the complete target shape when most of it is new or diff notation would obscure ownership or order.
   - Keep each view focused on what a reviewer needs. Omit views that did not change; do not add headings for them.
   - Reviewer warnings (migrations, compatibility constraints, deliberate omissions, surprising decisions) go in the sections the template already has (Impact, Revertability, Known gaps), 1-3 bullets at most. Do not add new headings.
   - Fill every other section as the template's own comments say. Write "none" with a reason rather than deleting a section. Link the plan or other documents next to the Linear id when they exist.

5. Publish the description:
   - Write the body to a temporary file outside the repository (for example under `$TMPDIR`); do not commit it.
   - Update the PR with `gh pr edit {number} --body-file {path}`.
   - Confirm the update with `gh pr view {number}` and check that every section rendered.

6. Report completion:
   - Read `references/describe_pr_final_answer.md`.
   - Respond using that final answer template with the PR URL and a concise list of changed files.

Never put secrets, tokens, customer data or production credentials in the description. Do not expand the PR body beyond the template.

Write as one human talking to another: avoid jargon and slang, and use simple, coherent, concise language.
