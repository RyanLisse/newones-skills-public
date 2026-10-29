---
name: improve-claude-md
description: "Audit a repo's CLAUDE.md and propose a shorter, accurate version as a diff for the user to approve. Checks every command against package.json, Makefile and CI config, drops stale or generic lines, and moves detail into linked docs. Use when CLAUDE.md is long, out of date, or Claude keeps ignoring it, or after /init. Never rewrites the file without approval."
argument-hint: "[path to CLAUDE.md]"
---

<!-- Copied from https://github.com/RyanLisse/claude-code-skills-pack/tree/867fcb1626f321dbc21a854fce0dd39be2f8aaa4/skills/improve-claude-md (Ryan Lisse, MIT). Upstream: humanlayer/skills `improve-claude-md` @ 653b641 (MIT, Copyright (c) 2026 HumanLayer; licence text: LICENSE.humanlayer). -->

# Improve CLAUDE.md

> Adapted from HumanLayer's `improve-claude-md` skill (MIT) and modified for this pack: command checks against the repo, progressive disclosure into linked docs, and a propose-then-approve flow. See [ATTRIBUTION.md](https://github.com/RyanLisse/claude-code-skills-pack/blob/main/ATTRIBUTION.md) and [NOTICE](https://github.com/RyanLisse/claude-code-skills-pack/blob/main/NOTICE).

Claude Code loads `CLAUDE.md` into every session. Every line costs context, and a wrong command costs a failed run. Make it short, true and current, then **propose** the change. Never rewrite the file silently.

Target: $ARGUMENTS

With a path, audit and diff only that file. Without one, audit `./CLAUDE.md` and list any other `CLAUDE.md` files you find so the user can ask for them next.

## Why it matters

Lines that do not apply to the task at hand still take attention. The more of the file that is irrelevant, the more likely Claude is to skim past the parts that matter.

## Rules

- **Propose, never silently rewrite.** Nothing is written until the user approves the diff.
- **Every command must be real.** Keep every command you can find a definition for. Fix or remove the ones you cannot.
- **Leave `CLAUDE.local.md` and `~/.claude/CLAUDE.md` alone** unless the user names them. They are personal.
- Local tools only: Read, Grep, Glob and Bash. Works on a Claude Code subscription; no MCP servers or API keys.

## Principles

1. **Foundational context stays at the top.** Project identity, project map and tech stack apply to almost every task. Keep them short and plain.
2. **Less is more.** Models follow a limited number of instructions reliably, and Claude Code's own system prompt already uses many of them.
   - Cut rules a linter, formatter or pre-commit hook enforces. Suggest the hook instead.
   - Cut rules the agent can learn from existing code. It follows consistent patterns after a few searches.
   - Cut code snippets. They go stale. Point to a file instead: "see `src/utils/example.ts`".
   - Cut vague advice ("follow best practices", "write clean code").
3. **Progressive disclosure for task-specific detail.** Deploy runbooks, migration steps, long testing or API guides go into `docs/agents/<topic>.md` (or an existing doc), referenced with one line that says when to read it. Use a plain path, not an `@` import: imports load at session start and defeat the point.
4. **Conditional blocks for short inline rules (optional).** A rule that matters only for one kind of work and is too short for its own doc can go in an `<important if="<specific condition>">` block. One narrow condition per block; never wrap the project map or identity. See `references/example.md`.

## Workflow

### 1. Find the files

- The target file (see above). Without an argument, also note `.claude/CLAUDE.md` and nested `CLAUDE.md` files, but do not audit them unless asked.
- Files the target pulls in with `@path` imports; they count toward its size.
- Docs it links to. Note links to missing files.

### 2. Collect the facts

- **Package manager:** from the lockfile (`pnpm-lock.yaml`, `bun.lock`, `yarn.lock`, `package-lock.json`, `uv.lock`, `poetry.lock`, `Cargo.lock`, `go.sum`).
- **Commands:** `package.json` scripts, `Makefile`/`justfile`/`Taskfile.yml` targets, `pyproject.toml`, `Cargo.toml`, CI workflow steps.
- **Layout:** top-level directories and what lives in them.
- **Enforced style:** linter, formatter and type-checker configs.

### 3. Audit each line

| Verdict | When |
|---|---|
| Keep | True, specific to this repo, needed in most sessions |
| Fix | Right idea, wrong detail (renamed script, wrong package manager, moved path) |
| Move | True but only needed for some tasks |
| Cut | Stale, duplicated, tool-enforced, discoverable from code, or vague |

For each command, record where it is defined (`package.json` → `scripts.test`). Running a command is optional and only for ones without side effects (lint, typecheck, unit tests). Never run deploy, migrate, publish or anything that writes outside the repo.

### 4. Draft

Aim for under 100 lines, in this order, dropping empty sections:

1. One line on what the repo is and what it is built with.
2. Project map: key directories, one line each.
3. Commands: every verified command, exact strings, with a short purpose.
4. Rules Claude would get wrong without being told.
5. Pointers to moved docs, one line each with "read when".

Keep the user's tone and headings where they work. Add nothing you did not verify.

### 5. Propose

Show, in this order:

1. **Summary:** line count before → after; counts of kept, fixed, moved and cut items.
2. **Findings table:** each changed line, its verdict and the reason (`npm test` → `pnpm test`: repo has `pnpm-lock.yaml`).
3. **Unified diff** of the target file.
4. **New files** with full contents, if anything moved.
5. **Unsure items:** lines you could not verify. Ask instead of guessing.

Then ask: apply all, apply some, or change something. Wait.

### 6. Apply (only after approval)

Write exactly the approved changes. Re-check that every path and command in the new file exists. Report the files written. Do not commit unless asked.

## Done when

- [ ] Every command in the proposed `CLAUDE.md` has a recorded source
- [ ] Stale, generic and tool-enforced lines are gone or justified
- [ ] Task-specific detail lives in referenced docs, not inline
- [ ] The user saw the diff and approved it before anything was written
