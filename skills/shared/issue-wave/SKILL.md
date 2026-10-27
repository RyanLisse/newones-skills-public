---
name: issue-wave
description: "Run a wave of backlog issues end to end in any repo: tracker census, live verification of what is actually buildable, parallel lane agents in git worktrees, own-diff review, serial pushes through the pre-push gate, PRs, clean-room validation, and issue-tracker + docs bookkeeping. Use when asked to pick up the next batch/wave of issues, work a backlog or parent epic in parallel, or fan out several independent implementation tickets at once."
---

# Issue wave workflow

A wave is: **census → lane assignment → parallel build → review → serial push → PR → clean-room → bookkeeping → cleanup.** Each step exists because skipping it cost a wave before.

## 0. Learn the repo first

Before the first wave in a repo, establish (and write down in the wave notes):

- **Verification commands** — lint/format, tests, type-check, secrets scan, and the full gate (`AGENTS.md`, `CLAUDE.md`, `package.json`/`Makefile`, CI config, pre-push hook). "Tests pass" alone is never the bar; the gate is.
- **Tracker + parent** — which tool (Linear, GitHub Issues, Jira) and which parent issue/epic/label scopes the wave.
- **Status doc** — any overview document that must reflect what shipped.
- **Shared resources in the gate** — fixed DB names, ports, lock files, containers. These decide whether pushes can run in parallel (usually: they can't).
- **Clean-room target** — a throwaway VM/container/sandbox, and how the repo bootstraps there (`.env.example`, compose services, volumes).
- **Branch naming** and PR conventions.

## 1. Census before building

- List open issues under the parent and read the status doc. Many are already done — check the code (registries, routes, feature flags) before assuming something is missing.
- Re-verify every premise **live, now** — not from an old investigation. For integrations: probe the endpoint/API. For bugs: reproduce. For features: confirm the dependency exists.
- Classify each item:
  - **build** — premise verified, implementable today
  - **blocked** — needs access, credentials, a decision, or another team; comment with evidence and leave it in backlog
  - **drop** — impossible or duplicate; close/cancel with evidence
- Respect hard boundaries: no bypassing auth, CAPTCHAs, rate limits, or access controls to make an item "buildable".

## 2. Lane assignment

One buildable item per lane. Each lane gets its own:

- **git worktree** outside the main checkout: `git worktree add <tmp>/w<N>-<slug> -b <prefix>/<issue>-<slug>`
- **unique identifiers assigned up front** — any IDs, slugs, migration numbers, ports, or registry keys that must be unique. Never let parallel lanes pick their own; collisions cross-contaminate.
- **subagent brief** containing: the verified premise + evidence, the relevant contract/conventions, explicit scope, and the full verification list (the gate commands from step 0, plus visual proof if UI is touched).

Handle resolve-only items (closures, blocked comments) on the main thread while lanes build.

## 3. Definition of done per lane

Implementation + tests + docs, consistent with repo conventions. In addition:

- **Real fixtures** — recorded from real sources with provenance; mechanical trimming only, never hand-invented data presented as real.
- **Fail closed** — error/blocked states surface as errors, not as empty success.
- **Absent stays absent** — never synthesize data the source doesn't provide; document the gap instead.
- **Honest notes** — known blockers and open acceptance criteria written down, not worked around.

## 4. Review lane diffs yourself

Agent reports are not review. Read every diff and check: scope matches the brief, unique IDs are the assigned ones, conventions followed, error paths fail closed, fixture provenance is real, gaps are documented rather than papered over. **A fix after review voids the review** — re-check the new diff.

## 5. Push serially, open PRs

- Push lanes **one at a time** when the pre-push gate uses shared resources (fixed DB names, ports, containers). If a push fails with shared-resource errors while another gate is running, wait and re-run — no code change needed.
- Worktree commits may skip hooks; the gate at push time is the real verification — run it by hand if unsure.
- PR bodies always via `--body-file` (quotes/apostrophes break inline `--body`). Cover: problem, why, user impact, evidence (commands + exit codes), known gaps, and a `## Partial` section when tracker ACs remain open.
- **Any user-visible UI change needs visual proof**: run the app, capture a short recording (or a screenshot for static changes) of the asserted state, **open and inspect it before attaching**, attach to the PR/issue — never commit it. If infeasible, the PR states the exact blocker; never skip silently. Put this in the lane brief whenever scope includes UI.

## 6. Clean-room validation

Validate each PR on a fresh machine (VM/container/sandbox), not your dev box:

1. Create the environment (right region/image/size); record its name.
2. Install toolchain, clone the branch (use a short-lived token, e.g. `https://x-access-token:$(gh auth token)@github.com/...`).
3. Bootstrap exactly as a new contributor would: `.env` from the example with dev-only placeholder secrets, required volumes, `docker compose up -d <services>`, wait for readiness.
4. Run the full gate **serially** per PR. A lone timeout under load on a small box is a flake only if it passes when re-run in isolation — note it either way.
5. **Destroy the environment and confirm it's gone.** An unstopped lease is a bug.

## 7. Tracker and doc bookkeeping

- One comment per issue: PR link, what changed, evidence (test counts, exit codes), which ACs close, which stay open.
- Status stays In Progress while any AC is open. Never mark Done on partial delivery.
- Update the status doc with targeted edits only when the wave changes a row it tracks; tooling/infra work doesn't touch it.
- Check tool parameter names against the tool schema before calling (e.g. Linear `save_comment` takes `issueId`, not `issue`).

## 8. Cleanup

Remove a worktree only when `git status` is clean **and** `git log origin/<branch>..<branch>` is empty. Dirty or unpushed worktrees hold real work. Tear down every environment in the same session that created it.

## Failure modes already paid for

- Parallel pre-push gates → shared test DB/port collision → push serially.
- `gh pr create --body "...don't..."` → broken quoting → always `--body-file`.
- Lanes choosing their own IDs → collisions → assign up front.
- Stale investigation reused as evidence → building against dead endpoints → re-probe live.
- Trusting agent summaries → unreviewed defects shipped → read the diff.
- Worktree commits skipping hooks → gate never ran → the push gate is the verification.
- Forgotten VM lease → cost + drift → destroy and confirm in-session.

## Project adapters

Repo-specific details (exact commands, ID conventions, VM image, docs to update) belong in a project-level skill or `AGENTS.md` that extends this one — e.g. `ji-source-wave` in our job-intelligence repo.
