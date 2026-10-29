---
name: handoff-packet
description: >-
  Use when handing work between agents or between an agent and a human, so
  the context lives in a file and not in chat.
---
# Handoff packet

Use this when work moves between assistants (or from a coordinator to a specialist).

## When
- A coordinator is routing a job instead of doing it
- A specialist is returning a deliverable
- A run is partial or blocked and someone else must continue

## Steps
1. Write a markdown file (not a chat dump) with: Task, From, To, Status (`complete` / `partial` / `blocked`), Output (path or URL), Sources, Next owner, Do-not-assume, Forbidden.
2. Tag each source VERIFIED, INFERRED, or UNKNOWN.
3. Point at files under a shared working folder. Do not paste secrets, tokens, or one-time codes.
4. Tell the next owner the file path. Re-open that file before acting; do not trust memory of a number or ticket state.
5. Irreversible actions (send, publish, post, spend, delete, sign) stay listed as parked until the human approves.

## Done when
The next owner can continue without rereading the chat.
