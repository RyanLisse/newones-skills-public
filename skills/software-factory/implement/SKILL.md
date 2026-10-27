---
name: implement
description: >-
  Use in a fresh session to build an approved NN-plan.md phase by phase: run
  each phase's Automated Verification, stop for the human at every Manual
  Verification gate, then hand over for review (Luna, 3-round cap).
---

<!-- Adapted from humanlayer/skills plugins/rpi (MIT, Copyright (c) 2026 HumanLayer). Licence text: LICENSE.humanlayer. Rewritten for the factory; no subagent, daemon or CLI parts. -->

# /implement: follow the plan, stop at the gates

Build what the plan says, one phase at a time. The plan is the contract.

## Rules

- The latest `NN-plan.md` in `.agents/artifacts/<THE-id>-slug/` wins. Do not
  re-research or re-plan; the checkboxes in the plan are the progress record.
- Stay inside the plan, and respect **What We're NOT Doing**. If the code and the
  plan disagree in a way that changes the result, stop and tell the human.
- No secrets in code, logs, commits or artifacts. Hooks stay on; never `--no-verify`.
- Never force-push. Commits carry the lane trailers (`Herdr-Lane`, `Linear-Issue`).

## Steps

1. Read the plan and the research file it builds on, then the repo's AGENTS.md
   signposts. Resume at the first phase whose boxes are not all checked.
2. Implement that phase only, following the repo's existing patterns and tests.
3. Run every item under **Automated Verification** and tick it only after it
   passed with its real exit code. Fix failures before going on.
4. **Manual Verification gate.** When the phase has manual items, stop: list
   them, say what you ran, and wait for the human to confirm. Tick them only
   after that. Never start the next phase on a pending manual gate.
5. With no manual items left, mark the phase done in **Implementation Overview**
   and go on to the next phase. When all phases are done, open the PR with the
   `pr` skill (Linear id, rollback step, real test commands).
6. Review: one Luna round on the full diff, then at most 2 fix rounds with
   diff-only reviews. That is the 3-round cap
   ([FACTORY_RULES.md §1](../../../FACTORY_RULES.md)); at the cap, stop and report.
7. Report: what changed, checks run, and the manual checks still pending.
