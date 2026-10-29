---
name: linear-done-evidence
description: >-
  Use when closing a Linear issue or posting Done proof on it: only live
  end-to-end screenshot or video evidence; refuse speculative or mass
  backfill comments.
---
# Linear Done evidence

When closing a Linear issue, marking Done, or posting implementation proof on a ticket:

## Rule

Attach a Linear comment with a live screenshot or short video **only** when the feature is actually implemented, running, and end-to-end verified. Otherwise post nothing.

## Refuse

- Text-only “done” narratives
- Mass backfill comments across today’s closed tickets
- Speculative proof (“should work”, “agent said done”)
- Screenshots of tickets, plans, or CI green alone without a live product path

## Do

1. Confirm the change is on the target environment (or the agreed preview).
2. Exercise the user-visible path end-to-end once.
3. Capture one screenshot or short video of that live result.
4. Comment on the matching Linear issue with that proof and a one-line what-was-verified.
5. Only then mark Done (if that is your job).

If you cannot prove it live, leave the issue open / In Review and say what blocks proof. Do not invent evidence.
