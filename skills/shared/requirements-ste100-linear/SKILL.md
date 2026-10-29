---
name: requirements-ste100-linear
description: >-
  Use when turning a voice note, transcript, PDF or rough notes into clear
  requirements and Linear issues, written in ASD-STE100 Simplified Technical
  English. Combines interrogate, domain-modeling-linear, show-me, doc review
  and to-tickets-linear, with a problem-first PRD interview.
---
# Requirements in STE100 for Linear

> Written by Ryan Lisse. The problem-first interview in step 2 follows the `create-prd` step of the
> `rpi` plugin in [humanlayer/skills](https://github.com/humanlayer/skills) (MIT); no text was copied.
> Related skills: `domain-modeling-linear`, `to-tickets-linear` (this repo), `show-me` (`skills/software-factory`),
> `grilling` (`skills/dev-workflow`, can stand in for `interrogate`). `interrogate` comes from pstack and
> `ce-doc-review` from the compound-engineering plugin; install those from their own source (see `third-party/`)
> or do those steps by hand. Without a Linear integration, stop after step 8 and hand over the document.

Turn raw input (dictated notes, a transcript, a PDF, a chat) into clear, testable requirements, then into Linear issues. Write all requirement text in ASD-STE100 Simplified Technical English (STE).

## 1. Collect the input
- Read everything: the transcript, the PDF, the earlier issues, the repo GLOSSARY.md and docs/adr if they exist.
- List the goal, the users, the constraints and the open points. Do not write requirements yet.

## 2. Agree on the problem and the success measure (rpi create-prd)
- Write the problem in 1 to 3 STE sentences. Quote it to the user and ask one question to confirm or correct it.
- Then agree on one success measure after release (adoption, error rate, latency, time saved, or a qualitative result). If the work is small and has no useful measure, write that down with the user's agreement.

## 3. Ask questions (interrogate)
- Ask about each vague word, each missing number and each "maybe". Ask one round of at most 5 questions.
- Ask for: who the user is, what the trigger is, what the result is, the limits (time, size, quantity), the error cases and what is out of scope.
- For a product choice, give 2 or 3 options with the trade-offs and a recommendation.
- When the user does not know, write an open point. Do not guess.
- Put technical questions (schema, storage, code structure) under "Deferred to design". Keep the requirements about behaviour.

## 4. Make the terms clear (domain-modeling-linear)
- Choose one word for each concept. Put the other words under _Avoid_ in GLOSSARY.md.
- Use these words, and only these words, in all requirements and issues.

## 5. Write the requirements in STE
Use this form for each requirement:

```
REQ-<n> <short title>
The <system/actor> must <one action> <object> [when/if <condition>].
Why: <one sentence>.
Acceptance:
- Given <state>, when <action>, then <result that you can measure>.
Out of scope: <item, or none>.
```

STE rules to apply:
- One requirement in each sentence. One instruction in each sentence.
- Procedural sentences: at most 20 words. Descriptive sentences: at most 25 words. Paragraphs: at most 6 sentences.
- Use the active voice and the simple tenses (present, past, future).
- Use "must" for a requirement. Use "can" for a permitted option. Do not use "should", "may", "etc.", "and/or" or "as needed".
- Use each word with one meaning only. Use the same word for the same thing every time.
- Do not use -ing forms or phrasal verbs ("set up" becomes "configure"). Keep articles ("the", "a").
- Give numbers and units ("in 2 seconds", "at most 50 items"), not "fast" or "many".
- Technical names (product names, field names, API names) are allowed. Put them in code format.
- Start a warning or a constraint with the condition: "If X, the system must not Y."

## 6. Make it visual (show-me)
- Add the smallest visual that makes the flow clear. Put each visual next to the requirements it explains:
  - a Mermaid sequence diagram for the flow between the user and the systems,
  - a Mermaid state diagram for statuses and transitions,
  - pseudocode for a rule or a calculation,
  - one focused HTML mockup for a UI requirement, with real labels.
- Label each visual with the REQ-ids it covers. Do not add a visual that repeats the text.

## 7. Review (ce-doc-review)
Check each requirement:
- Is it testable? Is there exactly one action? Is there a measurable result?
- Does it use glossary words only? Does it break an STE rule?
- Does it describe behaviour, not a solution in code?
- Does it conflict with another requirement, an ADR or a visual?
Correct the text. Keep the list of open points.

## 8. Show and get approval
- Show the problem, the success measure, the requirements, the visuals and the open points. Ask the user to read the requirements from start to finish and approve them as a whole. Change them until the user approves.
- Creating Linear issues is visible to the team. Get approval first.

## 9. Make the Linear issues (to-tickets-linear)
- Use a parent issue for the feature that contains the problem, the success measure, all the requirements, the visuals and the open points.
- Cut vertical slices. Each slice is a sub-issue that covers one or more REQ-ids and that an agent can complete in one context.
- Put the STE acceptance criteria in each issue as checkboxes. Use Linear relations for blockers.
- Make the issues in dependency order. Report the identifiers and the issues that can start now.

## Output
- A requirements document (Markdown) with the problem, the success measure, REQ-ids, acceptance criteria, visuals, glossary changes, open points and deferred design questions.
- The Linear parent issue and the sub-issues, after approval.
