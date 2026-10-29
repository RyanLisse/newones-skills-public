# Kinds: section structure and failure modes

> Structure adapted from display-dev/visualize (MIT, Copyright (c) 2026 display.dev) templates `implementation-plan`, `plan-review`, `diff-review` and `project-recap` at commit `077004e`, shortened and modified for this pack.

Section headings name the reader's job ("Dependency path", "What to check first"), not generic labels ("Overview", "Details"). Order sections by the reader's decision path, not by the order you did the work.

## plan

1. Header: title, one-line subtitle, metadata (status, owner, branch or base commit, source file).
2. Thesis: what will change, why this shape, smallest useful shipped outcome.
3. Scope: in scope, out of scope, assumptions, non-goals.
4. Execution map, ordered by dependency. Per phase: target files or systems, expected outcome, depends on, check that proves it (command or manual step).
5. Risks: trigger, mitigation, owner, rollback.
6. Validation: automated checks, manual smoke, release preconditions, each tied to the phase it verifies.
7. Open questions. Blockers are marked as blockers and attached to the earliest phase they affect.

Fails when: phases read "implement backend / add tests" with no target or check; blockers hide in prose; "monitor" is the only mitigation or "the team" the only owner; the plan edits something without naming the baseline (branch, commit, version).

## review

1. Header with the plan under review (path, version or commit) and an overall verdict: `ready`, `ready with changes`, or `not ready`.
2. Verdict in one or two sentences, then the must-fix list (numbered, each with the reason and the plan section it touches).
3. Assumptions the plan makes silently, and whether the repo supports them (cite files).
4. Risks the plan misses or under-rates, each with a proposed owner and mitigation.
5. Nice-to-have suggestions, clearly separate from must-fix.
6. Next action: who does what before implementation starts.

Fails when: the overall verdict contradicts the findings (`ready` beside a high-severity gap); praise padding ("great plan!"); critique without a concrete change.

## diff

1. Header: PR number and title or branch, base...head with short SHAs, files changed, +/− lines.
2. Summary: what the change does in two or three sentences, and the reviewer's top question answered first.
3. Change outline: the smallest structural view (file tree, call tree, component tree, or before/after) as a `diff` block or small diagram.
4. Where to look: ranked list of risky hunks with `path:line`, why each matters, and what to check.
5. Selected hunks rendered as diff blocks (not the whole diff). Each line keeps its `+`, `-` or space marker; color only reinforces it.
6. Tests and evidence: what ran, what didn't, what's missing.
7. Follow-ups: requested changes vs optional nits.

Fails when: the whole diff is pasted line by line (over ~300 lines or ~5 files, summarize and link the PR instead); color is the only add/remove signal; risks are listed without a location.

## recap

Use exactly these sections: **Shipped**, **Skipped**, **Shifted**, **Learned** (Learned may be short). Empty Skipped or Shifted sections stay, with "None this period", because the absence is information.

- Header: period, scope (repo, team, milestone), sources (PR list, `PROGRESS.md`).
- A tally line (`Shipped 7 · Skipped 2 · Shifted 1`) whose counts equal the items below.
- Shipped items link the PR or commit. Every Skipped or Shifted item carries its reason as decided at the time.
- Close with next steps: owner and date where known.

Fails when: sections get renamed ("Wins", "Deprioritised"); reasons are missing or retrofitted; tally and items disagree; upbeat filler replaces facts.
