---
name: to-tickets-linear
description: >-
  Use when breaking a plan, spec or conversation into Linear issues as
  tracer-bullet vertical slices with native blocking relations, ready for agent
  dispatch.
---
> Adapted from mattpocock/skills (https://github.com/mattpocock/skills), commit 49dd158d1076134a641b33efb035946536778336. MIT License, Copyright (c) 2026 Matt Pocock. Full licence text: LICENSE.mattpocock in this folder. Modified by Ryan Lisse for Linear (states, labels, relations).

# To tickets (Linear)

## Linear mapping (resolve before drafting)
- **Team**: the team that owns the code (ask if more than one fits; `list_teams`).
- **Project**: the project of the plan/spec; create none without approval (`list_projects`).
- **State**: new tickets go to the team state that maps to `ready-for-agent` (see `triage-linear`); prerequisites/unclear ones to `Triage`/`Backlog`.
- **Labels**: one category label (`bug`/`feature`/`improvement`) + `agent-ready` unless told otherwise.
- **Parent**: if the source is a Linear issue, create each ticket as its sub-issue (`parentId`); never close or edit the parent.
- **Blocking**: use Linear native relations (`blockedBy` on `save_issue`), not text.

## Process
1. Gather context (conversation, spec, or fetched Linear issue with comments).
2. Explore the codebase; use GLOSSARY.md vocabulary, respect ADRs; look for prefactoring ("make the change easy, then make the easy change"). Agree the test seams first: name the seam each slice is tested through; a missing seam becomes the first prefactor ticket.
3. Draft vertical slices:
   - each slice cuts a narrow but complete path through every layer (schema, API, UI, tests);
   - each is demoable/verifiable alone and fits one fresh agent context;
   - prefactoring first;
   - give each slice its blockers; no blockers = can start now.
   - Wide refactors: expand -> migrate in batches (each blocked by expand) -> contract (blocked by all batches).
4. Present a numbered list (Title / Blocked by / What it delivers) and iterate with the user until approved. Creating issues is externally visible: get approval first.
5. Publish in dependency order (blockers first) so relations reference real identifiers, using the template below. Report the identifiers and the frontier (tickets whose blockers are all done) for dispatch.

## Issue template
```
## Parent
<Linear issue, if any>
## What to build
End-to-end behaviour from the user's perspective, not a layer list.
## Acceptance criteria
- [ ] ...
```
Avoid file paths and code snippets (they go stale), except a prototype snippet that encodes a decision (state machine, schema, type shape).
