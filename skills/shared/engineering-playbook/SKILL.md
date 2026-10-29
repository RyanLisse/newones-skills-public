---
name: engineering-playbook
description: >-
  Standing principles for delegating code to coding agents (local or cloud)
  and supervising their pull requests to merge. Use when planning, delegating
  or reviewing agent-written changes.
---
# Engineering playbook

> Written by Ryan Lisse. Generic version: the board, watcher and chat rules of the original are left out.

Standing principles for anyone who ships code through coding agents.

## Mindset
1. Design first, before any code. Make the agent write a short plan and approve it before it writes a line: what existing table, RPC, module or primitive already does this? What is the smallest possible diff? Why is any net-new schema, migration or primitive truly unavoidable?
2. Subtract first, add last. Lead every prompt with reuse-and-delete. The first questions are what should not exist, what can be deleted, and what existing thing replaces this.
3. Judge a PR by diff size and net-new surface, not by how cleanly it cleared review-bot rounds. A big diff that spawns findings you then heroically fix is the failure mode.
4. Repeated findings in one subsystem mean the design is wrong. Stop and rethink. Still triage every finding with judgment: fix at the root, rethink the surface, or dismiss with a written rationale. Never silently ignore, never blindly action.
5. Default hard to mirroring the existing or reference path. A deviation needs a stated reason.

## Execution
- Delegate code to agents. Supervise the approach, not just pass/fail.
- Split ballooning PRs.
- Feed agents the review finding bodies and the exact CI errors; they often cannot read CI themselves.
- Prefer replying to the agent that already owns a PR over launching a new one. One agent per PR stream; a fresh agent only for a new task or an intentional rewrite.
- Demand real proof (see Proof). Never merge without explicit approval from the owner.

## Rebase
- Being behind the default branch is never on its own a reason to rebase.
- Rebase only on real conflicts, or when CI failures inherited from the default branch are now fixed there.
- Always rebase onto the default branch. Never merge the default branch into the working branch. Never force-push a shared branch without agreement.
- Confirm mergeability again after the rebase.

## Proof
- Put hosted artifacts (screenshots, short videos) in the PR body. Never commit media into the branch.
- Use image markdown for stills. A video must be a playable video file, not a poster frame.
- Open each artifact yourself before you mark the PR ready.

## PR states
- Drafts are not ready. Undraft only when leftover findings are 0, CI is green, no rebase is needed and the agent is idle.
- Merged means done; closed without merge means cancelled. Check this before any other status logic.
