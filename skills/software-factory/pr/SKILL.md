---
name: pr
description: >-
  Use when opening or updating a pull request: write the PR description from
  the repository's .github/pull_request_template.md (What via /show-me,
  Impact, Hoe terugdraaien? with a rollback step, Hoe getest?, Linear id,
  Accountable) and open it
  with gh. The description is what gets reviewed, since PRs merge on green CI.
---

# /pr: open a PR whose description shows the risk

## Steps

1. Make sure the branch is pushed and up to date with its base (merge, never
   force-push). Find the base: `gh repo view --json defaultBranchRef`.
2. Read `.github/pull_request_template.md` and keep every heading in order.
   Keep any marker comments the template has (for example
   `<!-- evidence:start -->`): CI checks may parse them.
3. Fill the sections:
   - **What.** Run `/show-me` on `git diff <base>...HEAD` and paste the
     pseudocode block (max ~20 lines).
   - **Impact.** List the modules, routes, tables and users the change
     touches, and state the prod, DB and DNS consequences. Write "none" where
     that is true.
   - **Door and blast radius.** Fill `Door: one-way | two-way` and
     `Blast radius: <1-5> - <reason>` using the scale in the template (see
     [glossary](../../../docs/glossary.md)); docs-only changes are 1 even when
     they touch several files.
   - **Hoe terugdraaien?** Say whether it is a plain revert, or a revert plus
     a migration, data fix or config change. Always give the concrete rollback
     step (for example `git revert <merge sha>` then `bun run db:migrate:down 0042`).
   - **Hoe getest?** List the test commands you ran with their real exit codes
     and the CI checks that must be green. For UI changes add a screenshot or a
     short video from seeded data. Do not claim anything you did not run.
   - **Linear.** Give the issue id (`THE-123`), which links the PR to the
     issue. Below it, add `Accountable: <login>` with the human who prompted
     the run (the owner account when an agent acts for the owner). The `risk-preflight`
     check fails without that line, and also when "Hoe getest?" or
     "Hoe terugdraaien?" is empty (THE-138, [RISK_POLICY.md](../../../RISK_POLICY.md)).
4. Write the body to a file and open the PR with
   `gh pr create --base <base> --title "<type>(scope): summary (THE-123)" --body-file <file>`.
   Use `gh pr edit <n> --body-file <file>` when updating.
5. Read the PR back (`gh pr view <n>`) and check every section rendered.

## Rules

- Prefer short over complete, so a reviewer can judge the risk in under a minute.
- Never paste secrets, tokens, customer data or production URLs with
  credentials into the description.
- Opening a PR is externally visible, so only open one when the task asks for it.

Written for The New Ones; the idea comes from the `/pr` skill in
mattpocock/skills (MIT). No text was copied.
