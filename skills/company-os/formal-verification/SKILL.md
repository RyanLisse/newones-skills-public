---
name: formal-verification
description: Writes and model-checks TLA+ specs for Company OS state machines (settlement, approval-hold, meter outcomes) with TLC. Use when changing a state machine, its SQL transition function or trigger, its TS reducer, or the guard/lock order around it; when adding a new state machine; or when a concurrency bug is suspected. Runs `bun scripts/tlc.mjs`.
---

# Formal verification (TLA+ / TLC)

Specs live in `specs/tla/`, and `bun scripts/tlc.mjs` checks every model there.
The script needs Java 11 or newer. It downloads tla2tools.jar, checks it
against a pinned sha256 and caches it in `~/.cache/tla`. CI runs it as the
`tla` job behind `ci-gate`.

## When a state machine changes

1. Model the writer that really exists (the SQL function that inserts or
   updates, its locks and its checks), not the reducer alone. Keep the
   spec's state sets equal to the TS constants; `scripts/tlc.test.ts`
   checks that.
2. Write the rule as an invariant (state predicate) or an action property
   (`[][...]_vars`) in the spec, and list it in the `.cfg`.
3. Add a must-fail model for every guard the invariant depends on: a copy
   of the `.cfg` that switches the guard off (a boolean CONSTANT) and an
   entry in `MODELS` in `scripts/tlc.mjs` naming the invariant that must be
   violated, and that cfg lists only that invariant. That proves the
   invariant is not vacuous. A known gap gets a must-fail model too, until
   the fix lands (then flip it to "pass").
4. Keep models small: 2 operations, 2 workers and time 0..3.
   TLC is exhaustive, so small bounds already cover every interleaving.

## Modelling rules

- One atomic TLA+ step per database statement that holds a row lock; split
  read and write into two steps when the code reads first and writes later.
- Model the BEFORE trigger as a guard on the write step, checked against
  the current row, not against what the worker read.
- Time is a variable `now` with a `Tick` action. Compare a deadline at the
  step that uses it.
- Specs describe behaviour only. They contain no production data and no
  secrets.

## Reading a failure

TLC prints the violated invariant and a trace (`State 1 ... State n`). Each
state lists every variable; the last step is the bug. Reproduce it as a
db test before fixing.
