# Third-party skills

Deze skills gebruiken we, maar we schrijven ze niet zelf. Ze staan hier niet als kopie: installeer ze vanuit de bron, zodat je de actuele versie en de licentie van de maker krijgt.

## pstack (Claude Code-plugin)

Werkstijl- en workflowskills (`poteto-mode`, `tdd`, `architect`, `interrogate`, `swarm`, `how`/`why` en meer, 54 skills). MIT-licentie, bron [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude). In gebruik: versie 0.9.30, commit `0986f344496c9c8468003465261711f6bb2c5ec1`.

```text
/plugin marketplace add michael-denyer/pstack-claude
/plugin install pstack@pstack-claude
```

## fable-advisor (Claude Code-plugin)

Architect-als-orchestrator: Fable 5.1 plant en reviewt, routinewerk gaat naar een GPT-5.6 Luna-lane via Codex, lastige one-offs naar Sol. Levert de `orchestration`-skill en de agents `fable-advisor`, `codex-implementer` en `sol-implementer`. MIT, bron [DannyMac180/fable-advisor](https://github.com/DannyMac180/fable-advisor). In gebruik: versie 5.0.0, commit `4d6cc62164619a279b076439e1af5439892b958a`.

```text
/plugin marketplace add DannyMac180/fable-advisor
/plugin install fable-advisor@fable-advisor
```

## astra-advisor (Codex-plugin)

De Codex-tegenhanger van fable-advisor, met `gpt-6-astra` als adviseur. MIT, bron [DannyMac180/astra-advisor](https://github.com/DannyMac180/astra-advisor). In gebruik: marketplace-revisie `c72d3280551f118eba51a5884e3971a0c0058aa6`. In `~/.codex/config.toml`:

```toml
[marketplaces.astra-advisor]
source_type = "git"
source = "https://github.com/DannyMac180/astra-advisor.git"
ref = "main"

[plugins."astra-advisor@astra-advisor"]
enabled = true
```

## exe-dev

VM-beheer op exe.dev (VM's, HTTP-proxy, delen, custom domains). Auteur: Benjamin Jesuiter, automatisch gegenereerd uit de exe.dev-docs en volgens de auteur nog niet getest.

## Company OS (via `skills-lock.json`)

`company-os.skills-lock.json` is een kopie van de lockfile in `newones-company-os`. Daarin staan bron, pad en hash van:

| Skill | Bron |
|-------|------|
| analyze-logs, build-audit-logs, review-logging-patterns | evlog.dev |
| better-auth-best-practices, better-auth-security-best-practices, email-and-password-best-practices | better-auth/skills |
| hono | honojs/skills |
| next-cache-components-adoption, next-cache-components-optimizer, next-dev-loop, next-partial-prefetching-adoption | vercel/next.js |
| shadcn | shadcn/ui |
| ultracite | haydenbleasel/ultracite |
| vercel-composition-patterns, vercel-react-best-practices, web-design-guidelines | vercel-labs/agent-skills |

## Niet in een lockfile

| Skill | Repo | Bron |
|-------|------|------|
| e2e | newones-company-os | e2e.dev, de agentic test runner (toegevoegd in commit `3ab0b830`) |
| trigger-authoring-chat-agent, trigger-authoring-tasks, trigger-chat-agent-advanced, trigger-cost-savings, trigger-getting-started, trigger-realtime-and-frontend | newones-job-intelligence | Trigger.dev agent skills, `library_version` 4.5.13 (toegevoegd in commit `ae30b353`) |

Deze staan nog als vendored kopie in de productrepo's. Komt er een lockfile voor, dan hoort die hier ook bij.

## compound-engineering (Claude Code-plugin)

Levert onder meer `ce-doc-review`, `ce-plan`, `ce-code-review` en `ce-commit-push-pr`. `requirements-ste100-linear` gebruikt `ce-doc-review` voor de reviewstap. MIT, bron [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin). Installeer vanuit de bron volgens hun README.

## Gebruikt, maar niet opgenomen (licentie onduidelijk)

Deze skills gebruiken we wel, maar de licentie is niet vast te stellen of ze komen via een site zonder licentietekst. Ze staan daarom niet in deze repo. Installeer ze alleen vanuit de bron als de licentie daar klopt.

| Skill | Bron | Waarom niet |
|-------|------|-------------|
| design-review | Superfuture via ui-skills.com | Geen licentietekst gevonden |
| web-accessibility-audit | addyosmani "accessibility" via ui-skills.com | Geen licentietekst bij de bron die we gebruikten |
| beautiful-shadows | MengTo via ui-skills.com | Geen licentietekst gevonden |

## Ook bruikbaar, installeer vanuit de bron (MIT)

| Skill | Bron |
|-------|------|
| break-ui, mobile-native, apple-design | [emilkowalski/skills](https://github.com/emilkowalski/skills) |
| state-machine | [jakubkrehel/skills](https://github.com/jakubkrehel/skills) |
| show-me (origineel) | [humanlayer/skills](https://github.com/humanlayer/skills) `plugins/show-me` |
