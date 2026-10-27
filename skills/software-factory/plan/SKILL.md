---
name: plan
description: >-
  Use in a fresh session after /research (or for a small task, straight from the
  ticket): read the THE-id ticket and NN-research.md, then write a phased
  NN-plan.md with a "What We're NOT Doing" section and Automated and Manual
  Verification per phase. Stops for the human to approve the plan.
---

<!-- Adapted from humanlayer/skills plugins/rpi (MIT, Copyright (c) 2026 HumanLayer). Licence text: LICENSE.humanlayer. Rewritten for the factory; no subagent, daemon or CLI parts. -->

# /plan: phases a human can review

Turn the ticket and the research into small phases, each testable on its own.
Describe intent and code shape, not full code.

## Steps

1. Take the artifact directory `.agents/artifacts/<THE-id>-slug/`. Read the Linear
   issue (acceptance criteria are the goal), the latest `NN-research.md` in
   full, and the code it cites. No research file? Say so and read the code yourself.
2. Read `references/plan-template.md` and write `NN-plan.md` (next free `NN`,
   after the research file).
3. Cut the work into phases that each end with something that runs and can be
   checked: prefer a thin end-to-end result first, then extend it. Order the
   phases so their checks can run with the work done so far.
4. Per phase: the result, a compact change outline (tree, contract or
   pseudocode, with the tests), and a **Validation** block with **Automated
   Verification** (real commands: the repo's gate, `npm run check:map`, targeted
   tests) and **Manual Verification** (what a human must judge, or "None.").
5. Fill **What We're NOT Doing** with the neighbouring work you chose to leave
   out, so scope stays small ([scope and robustness](../../../FACTORY_RULES.md#scope-and-robustness):
   no complexity for speculative edge cases without the owner's buy-in).
6. Mark anything unsettled under **Open Questions**. No secrets in the plan.
7. Stop. The human reads the plan and answers the open questions; apply their
   feedback in place. Then: "Start a fresh session and run `/implement <dir>`".
   Do not implement in this session.
