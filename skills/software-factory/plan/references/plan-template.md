---
type: plan
issue: THE-123
repos:
  - identifier: <org>/<repo>
    sha: <commit sha at planning time>
---

<!-- Structure from humanlayer/skills plugins/rpi structure_outline_template.md (MIT, Copyright (c) 2026 HumanLayer; LICENSE.humanlayer). "What We're NOT Doing" is added by the factory. -->

# THE-123: Plan title

{Two or three sentences: the approach.}

## Desired End State

{What is true when the change is done, in terms of the ticket's acceptance criteria.}

## What We're NOT Doing

- {Neighbouring work, edge cases and refactors left out on purpose, with a reason.}

## Implementation Overview

- [ ] Phase 1: {Testable result}
- [ ] Phase 2: {Next testable result}

## Phase 1: {Testable result}

{What this phase delivers and why it comes first.}

### Change Outline

<Views that explain the phase: file tree, contract, types, call tree or pseudocode,
each with a short note. Name the tests that support the result.>

### Validation

#### Automated Verification

- [ ] {Runnable command, and what it proves.}

#### Manual Verification

- [ ] {A check that needs human judgment, or "None."}

## Phase 2: {Next testable result}

{Repeat the phase structure.}

## Open Questions

{Unsettled scope or phase choices, or "None."}
