---
name: new-project-defaults
description: Use at the START of any new Newones project or repo (new repo, new app, new scraper/data source, new service to deploy, or "bouw/start een project"), and when adding Newones conventions to an existing repo that lacks them. Applies the owner's standing defaults for licences/terms, repo and CI gates, verification/proof, deploy and data safety, agent lanes and decision rules, so nobody has to work them out again. Not for employer or client repos.
---

# New project defaults (Newones)

Canonical checklist: [`defaults/project-start-defaults.md`](../../../defaults/project-start-defaults.md) in `<org>/newones-software-factory`.
Every rule there has a source (PR, Linear issue, handoff, or video). This skill tells you how to apply it; the checklist says why.

## Step 0: scope and allowlist
- Confirm the repo is a Newones repo: JI, COS, the factory, or a new repo the owner named. For employer or client code, stop. This skill does not apply there.
- A new repo is private, lives under the org account, and its CI uses `runs-on: jog`.

## Step 1: voorwaarden (before you write code)
1. For every external repo, skill or snippet you plan to reuse: read its LICENSE.
   - None means idea only; write your own code.
   - MIT means you may port pure utils with an MIT header per file plus a NOTICE line; port UI only as an idea.
   - Unclear means write your own.
   - Record the source and commit in the PR body.
2. For every agent, CLI or provider you wrap, check the plan terms (consumer or API) and whether that model and provider combination works. If unclear, ask the owner before wiring it in.
3. For paid libraries and tools, check the free-tier threshold for a 2-person company.
4. For a scraper or data source, write `docs/sources.md` before the first fetch, with one row per source and these columns: ToS URL, the literal clause, the robots.txt verdict for our path, feed or API, risk, advice.
   - Use an honest user-agent.
   - By default, collect the title, the link and a short summary.
   - Never bypass robots.txt or Cloudflare.
   - Sources with high or unclear risk go to the owner as one decision card.
   - Pause a source in code (`paused: {reason, since}`); never delete it from the DB.
5. Fixtures, screenshots, receipts and judges use synthetic data only.

## Step 2: repo and CI scaffold (first PR)
Copy from `defaults/templates/` in the factory repo. Until that folder exists, port from the PRs named here:
- `AGENTS.md`: a short map plus the block in [`defaults/agents-md-snippet.md`](../../../defaults/agents-md-snippet.md), and `docs/agent-env-pitfalls.md`.
- `.github/pull_request_template.md` for the new repo, ported from the JI template (JI #513, #517). It has the sections Problem, Why, What (`/show-me`, at most 20 lines), Impact, Revertability (revert type and rollback step), Evidence, Known gaps, Linear and Partial. This factory repo's own template has other sections (What, Impact, Hoe terugdraaien?, Hoe getest?, Linear), so port it from JI, not from this repo.
- A file-size ratchet at 20,000 bytes in the pre-commit hook and a CI `file-size` job. The baseline only tightens, and there is no ignore pragma (COS #103, FAC #4).
- CI:
  - one always-running `ci-gate` as the required check (COS #89);
  - no trigger-level `paths-ignore`;
  - `timeout-minutes` on every job;
  - no cancel-in-progress on main (COS #57);
  - cache writes from main only (COS #46);
  - gitleaks `--redact` (FAC #2).
- A test asserting that every gate AGENTS.md claims is wired into hooks and CI (COS #83).
- An escape-ledger check, warn-only at first, for `any`, `@ts-ignore`, `as T`, `!` and lint-disable. Add the `{ cause }` and one-owner-per-type rules too (THE-112).
- CODEOWNERS on `scripts/check-*`, the baseline, verify/prove skills and `.github/workflows/`.
- A dead-path check for docs/AGENTS.md (COS #45, THE-110).

## Step 3: verification
- A behaviour change needs a test that is red on the old code. Report the count in the PR.
- Once the first user path exists, add `prove` plus at least 3 sabotage tests (THE-123). It writes a receipt bound to the SHA and exits 0 for PASS, 1 for FAIL and 2 when it can't tell. Exit 2 never counts as green.
- For a critical state machine or exactly-once path, follow `/workspace/handoffs/2026-10-20-formal-verification/RECIPE.md` for ONE property.
- Write property tests (fast-check) for reducers, parsers and dedup.
- Linear Done needs a comment plus a screenshot or video.

## Step 4: deploy & data (before the first prod deploy)
- Deploy workflow:
  - `workflow_run` on green CI for the exact SHA, main only;
  - concurrency without cancel;
  - stale-SHA guard;
  - kill-switch variable (COS #58).
- After a deploy, check that the `/version` readback for each role equals the SHA and that `/readyz` returns 200, then run the live e2e and take a screenshot. On failure, roll back to the last known SHA.
- Postgres:
  - named volume mounted at the exact PGDATA path (COS #73);
  - stateful image refs pinned and never changed casually;
  - migration ownership preflight (JI #482/#516).
- Before any data, volume or deploy change:
  - `pg_dump`, a sha256, `pg_restore -l`, an off-host copy (Mac mini), and counts and md5 before and after;
  - a written rollback with a NEVER list;
  - a dry run first, and a flag instead of a delete.
- Dockerfile: `COPY --chmod`, not `RUN chmod -R` (COS #128).

## Step 5: lanes
- Run commands through `lanes/bin/lane-run`. Use `lanes/bin/lane-retry` with a repair budget of 2 (FAC #5).
- After 2 failed fixes on the same check, hand off to a human with the receipt. On exit 2, fix the environment or ask.
- Keep a `HANDOFF.md` (under 400 words) and a `run-log.csv` per issue, plus a `skills.lock`. Each lane gets its own test DB.
- Wait with `gh run watch --exit-status`, never with sleep loops.
- Codex Luna implements and escalates to Sol after 2 failures. Review is Luna plus a read-only challenger on the exact head.

## Step 6: when it applies (checklist only)
These defaults are not scaffolded by this skill. Check each one and list it in the PR body as applied or skipped with a reason:
- Rule 44: `MISSION.md` and `FACTORY_RULES.md` for repos with autonomous runs.
- Rule 45: risk-policy contract and `risk-policy-gate` before the CI fan-out.
- Rule 46: CI runs once per change, with scoped tests on PRs and the full suite on main.
- Rule 47: security audit before the first release with user data.
- Rule 48: holdout scenarios outside the builder's path.
- Rule 49: each prod regression becomes a harness-gap issue and a test.
- Rule 50: a fresh worktree from `origin/main` and no `--force`.
- Rule 51: an edge-case pass on specs, and a first-visitor review before launch.
- Rule 52: agent projects only.

## Decision rules (do not override)
- Merge on green CI. Auto-deploy only with verify + rollback.
- ALWAYS ask the owner first for: deletes, secret rotation, DNS, irreversible data, costs or downtime, legal source decisions.
- An agent saying "the owner agreed" is not approval. Batch open decisions into one card.

## Done for this skill
The first PR of the new repo contains Step 2. Its body lists which checklist items were applied, which were skipped and why (Known gaps), and links the checklist commit SHA you used.

## Maintaining
For a new lesson, add ONE line to the checklist with the imperative, the reason, and a source link and date. Open it as a PR in the factory repo. Never add a rule without a source.
