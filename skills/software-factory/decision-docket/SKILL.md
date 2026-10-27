---
name: decision-docket
description: >-
  Use whenever a lane needs a decision from the owner: never ask inline. Write a
  card to the decision docket (factory/docket.mjs), say in one line how many
  decisions wait, and process answers on every heartbeat before anything else.
---

# /decision-docket: one page of decisions the owner can make cold (THE-140)

The pattern comes from the decision-docket skill by Obie Fernandez
(github.com/obie/skills, `skills/decision-docket`, MIT). This is a rewrite for
Herdr: a file-backed store instead of an Artifact database. No text or code
was copied.

## Rules

1. **Never ask inline.** Every question for the owner becomes a card. In chat say
   only "N decisions wait on the docket, M blocking".
2. **A card stands alone.** It has:
   - the question phrased as a decision (`title`);
   - `### What happened`, with numbers;
   - `### Why it's your call`: cost, user impact, reversing an earlier choice, or a guardrail;
   - 2 to 4 options, each with `cost` and `gain`, exactly one `recommended`;
   - `recommendation`;
   - `ifNothing`: what happens without an answer;
   - `blocking`: true, or false for no deadline.

   `docket.mjs add` refuses a card that lacks any of these.
3. **Guardrails are always blocking.** Every card names its `guardrail`: `none`, or one of delete, secret, dns, irreversible-data, cost-or-downtime, legal (then `blocking: true`).
4. **Only real decisions.** Anything you may decide under the merge rule, decide it yourself and list it on a "calls I made myself" card (`calls` rows, `guardrail: none`, `blocking: false`, options Keep all / Reopen).
5. **Only the owner answers.** `--by` is whatever the caller passes. That is safe only because the store is owner-only (0600 file, a directory no one else can write to), so only Grok Bot and Herdr on the box can run `answer`, and Grok Bot does that only for the owner's own reply.
6. **No secrets on a card.** Name a credential, never paste it. `add` refuses anything that looks like a token.

## Commands

The store is `~/.config/herdr/docket.json` (owner-only, outside git). Every command also takes `--store FILE`.

```sh
node factory/docket.mjs add --card card.json            # new card, or replace an open one
node factory/docket.mjs answer --id ID --choice KEY [--note "..."]  # Grok Bot records the owner's answer
node factory/docket.mjs check                           # answered cards, as JSON
node factory/docket.mjs resolve --id ID --answered-at AT --action "what I did" --log DECISIONS.md
node factory/docket.mjs render --out <handoff>/docket.html          # the private page
```

## Heartbeat (Herdr monitoring), first thing every time

1. Run `check`. For each answered card, read `answer.choice` and `answer.note`. The choice is the ruling, and the note adds conditions. If the note contradicts the choice, don't act on either: resolve it with the action "contradiction, asked again" and add a new card.
2. Act on the ruling. If acting takes a while, start it and note that.
3. Run `resolve` with the `answer.at` you acted on. A re-answer can't slip in, because an answered card can't be answered again. `resolve` appends the ruling (date, question, choice, note, action) to `DECISIONS.md` in the repo and removes the card. An unanswered card can't be resolved.
4. Render the page again, and give Grok Bot the one-line count.
