# Third-party skills

Deze skills gebruiken we, maar we schrijven ze niet zelf. Ze staan hier niet als kopie: installeer ze vanuit de bron, zodat je de actuele versie en de licentie van de maker krijgt.

## pstack (Claude Code-plugin)

Werkstijl- en workflowskills (`poteto-mode`, `tdd`, `architect`, `interrogate`, `swarm`, `how`/`why` en meer, 54 skills). MIT-licentie, bron [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude). In gebruik: versie 0.9.30, commit `0986f344496c9c8468003465261711f6bb2c5ec1`.

```text
/plugin marketplace add michael-denyer/pstack-claude
/plugin install pstack@pstack-claude
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
