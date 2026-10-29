---
name: domain-modeling-linear
description: >-
  Use when sharpening project terminology, editing GLOSSARY.md or recording an
  ADR, and when a Linear project's issue language must match the domain
  glossary.
---
> Adapted from mattpocock/skills (https://github.com/mattpocock/skills), commit 49dd158d1076134a641b33efb035946536778336. MIT License, Copyright (c) 2026 Matt Pocock. Full licence text: LICENSE.mattpocock in this folder. Modified by Ryan Lisse for Linear (states, labels, relations).

# Domain Modeling

Actively build and sharpen the project's domain model while designing: challenge terms, invent edge-case scenarios, and write the glossary and decisions down the moment they crystallise. (Merely reading `GLOSSARY.md` for vocabulary is not this skill.)

## File structure
- Single context (most repos): `GLOSSARY.md` at the root, decisions in `docs/adr/0001-slug.md`, ...
- Multiple contexts: a root `GLOSSARY-MAP.md` lists each context (with its own `GLOSSARY.md` and `docs/adr/`) and how they relate (events, shared types). System-wide ADRs stay in root `docs/adr/`.
- Create files lazily, only when there is something to write. When several contexts exist, infer which one the topic belongs to; if unclear, ask.

## During the session
- **Challenge against the glossary**: when a term conflicts with `GLOSSARY.md`, call it out immediately ("Your glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?").
- **Sharpen fuzzy language**: propose a precise canonical term for vague or overloaded words ("account": Customer or User?).
- **Discuss concrete scenarios** that probe the boundaries between concepts.
- **Cross-reference with code**: when the user states how something works, check the code and surface contradictions.
- **Update GLOSSARY.md inline** as soon as a term is resolved; don't batch. The glossary holds no implementation details; it is a glossary and nothing else.
- **Offer ADRs sparingly**, only when all three hold: hard to reverse, surprising without context, and the result of a real trade-off.

## Glossary format
```md
# {Context Name}
{One or two sentences: what this context is and why it exists.}
## Language
**Order**:
{One or two sentence definition: what it IS, not what it does.}
_Avoid_: Purchase, transaction
```
Rules: be opinionated (pick one word, list the rest under `_Avoid_`); keep definitions to 1-2 sentences; include only terms specific to this context, not general programming concepts; group under subheadings when natural clusters emerge.

## ADR format
`docs/adr/NNNN-slug.md`, numbered by incrementing the highest existing number:
```md
# {Short title of the decision}
{1-3 sentences: the context, what we decided, and why.}
```
Optional sections only when they add value: Status (proposed | accepted | deprecated | superseded by ADR-NNNN), Considered Options, Consequences.
Good candidates: architectural shape, integration patterns between contexts, technology choices with lock-in, boundary and scope decisions, deliberate deviations from the obvious path, constraints not visible in code, non-obvious rejected alternatives.

## Linear adaptation
- Use glossary terms verbatim in Linear issue titles and descriptions; when an issue uses a conflicting term, comment with the canonical term.
- Link ADRs from the Linear project description (Resources) and from the issues they constrain.
- When a term or ADR is resolved during a Linear discussion, update GLOSSARY.md/the ADR in the repo first, then reference the commit in the issue comment.
