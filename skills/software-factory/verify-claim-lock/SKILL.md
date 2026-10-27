---
name: verify-claim-lock
description: >-
  Use when a change touches factory/claim-lock.mjs, factory/claim-store-github.mjs,
  lanes/templates/lane-claim.sh
  or the review claim in factory/review-rounds.mjs, or when someone asks whether
  two lanes, two reviews or three sandboxes can run at once. Runs the TLA+ model
  in docs/verification/claim-lock with TLC and says whether the lock still keeps
  one lane per issue, one review per PR and at most 2 exe sandboxes.
---

# /verify-claim-lock: model-check the claim lock

The claim lock promises one live lane per issue, one review per PR, at most 2 exe sandboxes, and that a `release` by a lane that does not own a claim never frees it. A test runs one interleaving. The TLA+ model in [docs/verification/claim-lock](../../../docs/verification/claim-lock/README.md) runs all of them for 2 to 4 processes, mostly one filesystem call per step (the README lists the merged steps).

## Coverage and sync commit

The sync commit is `daacbe0d` (THE-186: a same-owner acquire refreshes only the same host and PID, or two PID-less claims on one host; `--takeover` for a handover; `SameHolder` in the model, and `lane_same_owner_nopid` keeps the PID-less limit visible). Before that `c20dcd48` (THE-184 GitHub ref store for lane and review keys: review claim freed when `plan` cannot save its round, `verdict` releases under the state lock, also when the round-3 escalation fails, and skips the delete when that lock may have gone stale; the model is unchanged since `ac3e7646`. Before that `39e92fe3`, THE-185 claim renewal; `224d5c7d`, factory #34, THE-160). The model was last confirmed against the code at this commit.

THE-186 fix round 1 (PR #70) adds an immutable acquisition id to dir and GitHub claims and to the review round state, so a displaced `--takeover` holder cannot release the new claim and PID-less same-owner review reruns stay busy. The model has five new configs for it (`review_same_owner_nopid`, `review_same_owner_nopid_gh`, `lane_takeover_release`, `lane_takeover_release_gh`, `lane_same_owner_nopid`). Their TLC results are not confirmed yet, so `SYNC_COMMIT` and the sync commit above stay at `daacbe0d` until a TLC run matches `expected.txt` (step 5 below).

| Code | Function or line | Model |
| --- | --- | --- |
| `factory/claim-lock.mjs` | `tryKey`: `mkdirSync`, `writeClaim`, the 3-attempt loop | `Mkdir`, `WriteOrRefresh`, `Continue` |
| `factory/claim-lock.mjs` | `tryKey`: same-owner refresh (`found.claim?.owner === owner`) | `Read`, then `refresh` |
| `factory/claim-lock.mjs` | `readClaim`, `staleOf`, `staleReason`, `HALF_MADE_MS` | `Read`, `StaleOn`, `AgeHalf` |
| `factory/claim-lock.mjs` | `remove`: rename aside, compare, `rmSync` or rename back | `RmMove`, `RmCheck`, `Same` |
| `factory/claim-lock.mjs` | `acquire --counter`: own-slot scan, slots 1..max | `Own`, `GoBusy`, `Slots` |
| `factory/claim-lock.mjs` | `release`: owner check, `--counter` skips other owners | `RelRead`, `RelNext` |
| `factory/claim-lock.mjs` | `main`: default TTL 120, `--pid none`, exits 0/75/65 | `HasPid`, `Outlive`, final states `busy`/`err`/`done` |
| `factory/claim-lock.mjs` | `renew`: strict for `--key`, lenient for the owner's other claims; `--every` loop, ppid check, SIGTERM on loss | `RenewRead`, `RenewWrite`, `rn`, `RenewStall`, `OrphanWrite` |
| `factory/claim-lock.mjs` | `claimStore`: lane and review keys use the GitHub store unless `--dir` or `FACTORY_CLAIMS_STORE=dir`; counters always use the dir store | constant `KeyStore`, `IsGitHubKey` |
| `factory/claim-store-github.mjs` | `acquire`: read ref + server `Date`, `updateRefs` create (`beforeOid` zero) or replace (stale or same owner, `beforeOid` = read oid), re-read after an error | `ReadRef`, `CASCreate`, `CASReplace`, `ResolveAfterError` |
| `factory/claim-store-github.mjs` | `release`: owner check, `beforeWrite` (may stop before the delete; no ref change, so it is the crash-before-release case), `updateRefs` delete with the read oid | `ReleaseReadRef`, `CASDelete` |
| `factory/claim-store-github.mjs` | `renew`/`renewOwned`: read, server-time staleness and margin, `updateRefs` replace with the read oid; a CAS failure is lost or skipped | `RenewReadRef`, `CASRenew` |
| `lanes/templates/lane-claim.sh` | `lane_claim` (TTL 240, `--pid $$`, starts the renewer), `lane_counter_acquire` (`--ttl-min $LANE_TTL_MIN`), `lane_claim_exit` (stops the renewer, then releases) | roles `lane` and `sandbox`, `Finish`, `MayExpire` |
| `factory/review-rounds.mjs` | `planLocked` (`pid: null`, `REVIEW_CLAIM_TTL_MIN`), `verdict` release | role `review`, `Finish` |

## Steps

1. Does the change touch the covered code? `git diff <sync commit> -- factory/claim-lock.mjs factory/claim-store-github.mjs lanes/templates/lane-claim.sh factory/review-rounds.mjs`. In `review-rounds.mjs` only `claimFor`, `ownerOf`, `planLocked` and the `verdict` release count; the round logic is not modelled.
2. Run `docs/verification/claim-lock/run.sh`. It exits 3 while the covered code differs from the sync commit. When it does, do step 3 before you trust any result.
3. Map each changed line to a row of the coverage table and change the model to match. Use one TLA+ action per filesystem call and keep the names from the code. A change that adds a new filesystem call needs a new step, never a merge into an existing one. To check a result before you edit the model, run it with `SKIP_SYNC_CHECK=1`.
4. Run `run.sh` again and read the table:
   - If every row matches, the change keeps the properties within the bounds. Say so in the PR and paste the table.
   - If an `*_envelope` row now says `violates:`, it is probably a real bug. Open `out/<config>.log`, read the trace bottom-up, and retell it as code steps (see the README's findings table for the style). Then check the trace against the code once more: if a step in it cannot happen in the code, the model is wrong, fix the model. Otherwise it is a bug: report it and do not weaken the property.
   - If a findings row now says `pass`, the change fixed that finding. Check in `out/<config>.log` that the property was in the checked list, then set the row to `pass` in `expected.txt` and move the finding to fixed in the README.
   - If a row says `error(see out/...)`, your model edit has a TLA+ parse or type error. Fix the model.
5. When the model matches the code again and `run.sh` gives the expected rows with `SKIP_SYNC_CHECK=1`, move `SYNC_COMMIT` in `run.sh` and the sync commit above to the new commit, in the same PR. Never move it without doing step 3.

## Telling a bug from a modelling error

A violation is real when every step of the trace maps to a line of code, in that order, with nothing in between that the code would do. It is a modelling error when the trace needs a step the code cannot take, such as a `Read` that sees state between two writes the code does atomically, or an environment action outside its constant (for example `TTLEnd` on a working holder while `Outlive` is empty). The README lists every simplification under "What the model treats as one step".

## Open findings at the sync commit

F1 TTL ends while the holder works: fixed by THE-185 renewal; residual risk `lane_renew_stall` (renewer stopped for a whole TTL). F2 claims do not cross hosts: fixed by THE-184 for lane and review keys (GitHub ref store, `lane_cross_host` and `lane_shared_skew` pass); still true for `--dir` mode and for sandbox counters, which stay per host. F3, F4 and F6 exist only in the dir store (`_gh` twins pass). F3 `remove()` can delete a live claim in its rename-aside gap. F4 `remove(..., "half-made")` matches any dir whose `claim.json` is missing, unreadable or invalid. F5 same-owner refresh let a rerun share the claim: fixed by THE-186 for runs with a PID (`lane_same_owner` and `lane_same_owner_gh` pass); two PID-less runs of one owner on one host still share (`lane_same_owner_nopid`). F6 a lane killed between its renewer's read and write gets one orphan renewal write, which can land in the `remove()` gap (`lane_orphan_renew`). Details and traces: the README's results table.

## Changing the bounds

To add a config, copy an `MC_*.tla` and `.cfg` pair, change the processes or constants, and add one line to `expected.txt`. Keep a full `run.sh` under about 5 minutes on one core; `lane_reclaim_race` (four lanes) is the largest config that stays there.
