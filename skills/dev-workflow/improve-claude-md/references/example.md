<!--
Adapted from the example in HumanLayer's improve-claude-md skill,
`plugins/improve-claude-md/skills/improve-claude-md/SKILL.md` in https://github.com/humanlayer/skills
at commit 653b6411c1f70c275a18e37673b042ff99f67ceb. Copyright (c) 2026 HumanLayer. MIT License (see LICENSES/MIT-HumanLayer.txt in the pack repo).
Modified for this pack: commands checked against package.json (one fixed, one removed); deploy runbook moved to a
linked doc; output shown as a proposal with a findings table; shortened.
-->

# Example audit

## Input `CLAUDE.md` (excerpt)

```markdown
# CLAUDE.md

This is an Express API with a React frontend in a Turborepo monorepo.

## Commands

| Command | Description |
|---|---|
| `turbo build` | Build all packages |
| `turbo test` | Run all tests |
| `turbo lint` | Lint all packages |
| `turbo dev` | Start dev server |
| `turbo db:generate` | Generate Prisma client |
| `turbo db:migrate` | Run database migrations |
| `turbo analyze` | Bundle analyzer |

## Project Structure

- `apps/api/` - Express REST API
- `apps/web/` - React SPA
- `packages/db/` - Prisma schema and client
- `packages/ui/` - Shared component library

## Coding Standards

- Use named exports
- Use camelCase for variables, PascalCase for components
- Prefer `const` over `let`
- Always use strict equality (`===`)

## API Development

- All routes go in `apps/api/src/routes/`
- Use Zod for request validation
- Error responses follow RFC 7807 format

## Deploying

[80 lines of release steps]
```

Facts found: `turbo.json` defines `build`, `test`, `lint`, `dev`, `db:generate`, `db:migrate:dev` (not `db:migrate`); there is no `analyze` task. ESLint config enforces `prefer-const` and `eqeqeq`.

## Proposal

**Summary:** 118 → 38 lines. 6 commands kept, 1 fixed, 1 removed; 1 section moved; 3 rules cut.

| Line | Verdict | Reason |
|---|---|---|
| `turbo db:migrate` | Fix → `turbo db:migrate:dev` | `turbo.json` has no `db:migrate` task |
| `turbo analyze` | Cut | No `analyze` task in `turbo.json` or any `package.json` |
| camelCase / `const` / `===` | Cut | Enforced by `.eslintrc` (`prefer-const`, `eqeqeq`) or visible in code |
| Deploying (80 lines) | Move → `docs/agents/deploy.md` | Needed only for releases |

Proposed file:

```markdown
# CLAUDE.md

Express API + React frontend in a Turborepo monorepo.

## Project map

- `apps/api/` - Express REST API
- `apps/web/` - React SPA
- `packages/db/` - Prisma schema and client
- `packages/ui/` - Shared component library

## Commands

Run with `turbo` from the repo root.

| Command | What it does |
|---|---|
| `turbo build` | Build all packages |
| `turbo test` | Run all tests |
| `turbo lint` | Lint all packages |
| `turbo dev` | Start dev server |
| `turbo db:generate` | Regenerate Prisma client after schema changes |
| `turbo db:migrate:dev` | Run database migrations locally |

<important if="you are adding or modifying imports or exports">
- Use named exports (no default exports)
</important>

<important if="you are adding or modifying API routes">
- Routes go in `apps/api/src/routes/`
- Validate requests with Zod
- Error responses follow RFC 7807
</important>

## More docs

- Releasing or deploying: read `docs/agents/deploy.md` first.
```

The diff and the full `docs/agents/deploy.md` follow, then: apply all, apply some, or change something?
