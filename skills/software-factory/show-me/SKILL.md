---
name: show-me
description: >-
  Use when asked to "show me" a change or a diff, or when /pr needs the "What"
  section: summarize what the code now does as short pseudocode (max ~20 lines)
  that names the real files, functions, routes and tables.
---

# /show-me: a diff as pseudocode

Turn a change into the shortest pseudocode that shows what it does.
Reviewers trust green CI and skip the diff, so this summary is where they see
the behaviour and the risk.

## Steps

1. Get the change: `git diff <base>...HEAD` (or the staged diff, or the PR
   diff with `gh pr diff <n>`). Read all of it, but skip generated files and
   lockfiles.
2. Find the behaviour that changed: new branches, new side effects (writes,
   network calls, migrations, jobs), removed paths, changed contracts.
3. Write pseudocode, at most ~20 lines, in a `text` code block:
   - One line per decision or side effect, indented for nesting.
   - Use the real names (`apps/server/src/jobs.ts: enqueueSync`, table
     `job_posting`) so a reader can grep for them.
   - Mark what is new with `+`, what is gone with `-`, and leave unchanged
     context unmarked. Keep context only where it explains order or ownership.
   - Put risky effects in capitals: `WRITE`, `DELETE`, `MIGRATE`, `DEPLOY`,
     `EMAIL`, `DNS`.
4. If one block is not enough (for example a UI tree plus a data flow), give
   two small blocks instead of prose. Add no preamble and no closing summary.

## Example

```text
on POST /api/jobs/:id/archive            (apps/server/src/routes/jobs.ts)
+ require role = admin                   else 403
  load job_posting by id                 else 404
+ WRITE job_posting.archived_at = now()
- DELETE job_posting                     (was a hard delete)
  enqueue search reindex(id)
```

## Rules

- Describe behaviour, not edits: "retries 3x then alerts", not "added a loop".
- Never invent: if the diff does not show a side effect, do not draw it.
- For a docs-only or config-only change, say so in one line and list the files.

Written for The New Ones; the idea comes from the `/show-me` skill in
humanlayer/skills (MIT). No text was copied.
