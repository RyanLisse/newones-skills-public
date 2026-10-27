---
name: research
description: >-
  Use at the start of a THE-id task, in its own fresh session, to explore how
  the current code works from a neutral question and write
  .agents/artifacts/<THE-id>-slug/NN-research.md. Never reads the ticket.
---

<!-- Adapted from humanlayer/skills plugins/rpi (MIT, Copyright (c) 2026 HumanLayer). Licence text: LICENSE.humanlayer. Rewritten for the factory; no subagent, daemon or CLI parts. -->

# /research: what exists today, without the ticket

Answer one neutral question about the current codebase. The findings feed
`/plan` in a later session, so they must not lean toward the wanted change.

## Rules

- **Do not read the ticket.** No Linear issue, PR, plan, request text or earlier
  `NN-plan.md`. You get a question and a directory name, nothing else. If the
  question names a THE-id, a fix or a wanted behaviour, stop and ask for a
  neutral rewording (`how does X work today?`, `where does Y get checked?`).
- Describe, do not judge: no design choices, no "should", no fixes.
- No secrets: never copy tokens, keys, env values or customer data into the file.
- Read-only on the code; the only file you write is the research file.

## Steps

1. Take the question and the artifact directory `.agents/artifacts/<THE-id>-slug/`
   (create it when missing; it is gitignored). Pick the next free `NN`: `01`
   in an empty directory.
2. Find the relevant code, tests and docs (`rg`, reading files in full). Trace
   behaviour and data flow with `file:line` references. Note how it is tested.
3. Check cited paths against the live code; resolve conflicts in favour of the code.
4. Write `NN-research.md`: the question, a short summary, findings under headers
   that state what is true ("Claims expire after the ttl, not on release"),
   testing patterns, a code-reference list and open questions (or "None.").
   Use short `/show-me` views (file tree, call tree, pseudocode) where they help.
   Distinguish tests you read from checks you ran.
5. Finish with the file path and one line: "Start a fresh session and run
   `/plan <dir>`". Do not start planning in this session.
