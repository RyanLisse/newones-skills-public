# newones-skills

Agent-skills die The New Ones gebruikt om software te bouwen met coding agents (Claude Code, Codex). Skills van derden staan als manifest in [`third-party/`](third-party/README.md), niet als kopie.

## Inhoud

| Map | Skill | Waarvoor |
|-----|-------|----------|
| `skills/company-os` | blocks | Testoutput inkorten, eerste fout vinden, JSON inspecteren via de repo-scripts |
| | company-os-visual-evidence | Visueel PR-bewijs van zichtbare UI-wijzigingen |
| | formal-verification | TLA+-specs schrijven en model-checken voor state machines |
| | verify-frontend-change | Een wijziging aan een admin-UI verifiëren of reviewen |
| | visual-evidence | Before/after-screenshots, diff, trace en walkthrough als PR-bewijs |
| | visual-pr | Visual PR-flow, alleen bij expliciete aanroep |
| `skills/job-intelligence` | crabbox | Validatie op een exe.dev-shadowlane met Crabbox |
| | ji-source-wave | Een golf bronwerk end-to-end: census, lanes, gates, clean-room, bookkeeping |
| `skills/software-factory` | decision-docket, implement, new-project-defaults, plan, pr, research, show-me, verify-claim-lock | De skills van onze software factory |
| `skills/shared` | issue-wave | Algemene wave-workflow voor elke repo: census, lanes in worktrees, eigen review, seriële push, clean-room, bookkeeping. `ji-source-wave` is een projectadapter erop |
| | requirements-ste100-linear | Spraaknotitie, transcript, PDF of losse notities omzetten naar toetsbare requirements in ASD-STE100 (Simplified Technical English) en daarna naar Linear-issues |
| | domain-modeling-linear | Begrippen scherp krijgen: `GLOSSARY.md` en ADR's bijhouden, en Linear-issues in die taal laten schrijven |
| | to-tickets-linear | Een plan of spec opknippen in verticale Linear-issues met echte blocking-relaties, klaar voor agents |
| | triage-linear | Linear-issues en externe PR's triëren: categorie, verificatie, state en label voor agent-dispatch |
| | linear-done-evidence | Een Linear-issue pas op Done zetten met live screenshot of video als bewijs |
| | handoff-packet | Werk overdragen tussen agents (of agent en mens) via een bestand in plaats van chat |
| | engineering-playbook | Vaste principes voor werk uitbesteden aan coding agents en hun PR's tot merge begeleiden |
| `skills/dev-workflow` | deslop | AI-slop uit de branch-diff halen zonder gedrag te veranderen (`/deslop`) |
| | verify-this | Een bewering bewijzen of weerleggen met vers lokaal bewijs |
| | fix-ci | Falende PR-checks vinden, logs lezen en gericht fixen tot groen (`gh` nodig) |
| | get-pr-comments | Reviewcommentaar op de PR samenvatten als actielijst (`gh` nodig) |
| | make-pr-easy-to-review | Een PR reviewbaar maken: beschrijving, reviewer-hints, history alleen als afgesproken (`gh` nodig) |
| | new-branch-and-pr | Verse branch vanaf main, werk afmaken, committen, pushen, PR openen (`gh` nodig) |
| | review-and-ship | Branch reviewen op bugs, tests draaien of toevoegen, committen, PR openen of bijwerken (`gh` nodig) |
| | cli-for-agents | CLI's ontwerpen of reviewen zodat agents ze headless kunnen draaien |
| | handoff | Een kant-en-klare prompt schrijven waarmee een andere agent de taak oppakt |
| | grilling | Een plan of besluit ronde voor ronde laten doorvragen tot niets meer stil wordt aangenomen |
| | improve-claude-md | `CLAUDE.md` toetsen aan de repo en een kortere, kloppende versie voorstellen als diff |
| | visual-plan | Plan, planreview, diff-review of recap als één offline HTML-pagina |
| | diagram | Architectuur-, sequence-, flow- en state-diagrammen uit echte code (Mermaid of HTML met inline SVG) |
| | eli5 | Code, diffs, fouten en afwegingen simpel uitleggen zonder het mechanisme weg te laten |
| `humanlayer/commands` | research_codebase, create_plan, iterate_plan, implement_plan, validate_plan, create_handoff, resume_handoff, describe_pr, commit | HumanLayer's Claude Code-commands voor research → plan → implement → validate, plus handoff, PR-beschrijving en commit. Ze schrijven naar `thoughts/shared/...` in je repo |
| `humanlayer/agents` | codebase-locator, codebase-analyzer, codebase-pattern-finder, thoughts-locator, thoughts-analyzer, web-search-researcher | De subagents die de commands hierboven aanroepen |

`skills/software-factory` heeft ook `research`, `plan` en `implement`: dat is onze eigen, kortere versie van dezelfde flow (gekoppeld aan Linear-ids en `.agents/artifacts/`). De HumanLayer-commands zijn de originele, uitgebreidere variant. Kies er per repo één.

## Kanttekeningen

- De skills in `company-os`, `job-intelligence` en `software-factory` zijn geschreven voor onze eigen repo's. Ze verwijzen naar scripts, paden en documenten in die repo's (zoals `RISK_POLICY.md` of `defaults/project-start-defaults.md`) die hier niet bij zitten. Lees ze als patroon en pas de paden aan.
- Issue-ID's als `THE-123` of `CTP-505` verwijzen naar onze eigen tracker.
- `<org>` en `<user>` zijn placeholders voor je eigen GitHub-org en branch-prefix.
- `skills/shared`, `skills/dev-workflow` en `humanlayer/` zijn algemeen: die werken in elke repo.

## Installeren

Elke skill is een map met een `SKILL.md`. Die map werkt in Claude Code, Codex en Cursor; alleen de plek verschilt.

| Tool | Persoonlijk (alle repo's) | Per project |
|------|---------------------------|-------------|
| Claude Code | `~/.claude/skills/<naam>/` | `.claude/skills/<naam>/` |
| Codex | `~/.agents/skills/<naam>/` (`~/.codex/skills` is legacy) | `.agents/skills/<naam>/` |
| Cursor | `~/.cursor/skills/` of `~/.agents/skills/`; leest ook `~/.claude/skills/` | `.cursor/skills/` of `.agents/skills/`; leest ook `.claude/skills/` |

### Alles in één keer

```bash
git clone https://github.com/RyanLisse/newones-skills-public.git ~/src/newones-skills-public
cd ~/src/newones-skills-public

scripts/install.sh --dry-run                 # laat zien wat er gebeurt, verandert niets
scripts/install.sh                           # symlinks in ~/.claude/skills (Claude Code, en Cursor leest mee)
scripts/install.sh --target agents           # symlinks in ~/.agents/skills (Codex en Cursor)
scripts/install.sh --target all --with-humanlayer   # beide, plus HumanLayer-commands en -agents in ~/.claude/
```

Opties: `--project <repo>` installeert in die repo in plaats van in je home, `--copy` kopieert in plaats van symlinkt, `--groups "shared dev-workflow"` neemt alleen die groepen, `--force` overschrijft een bestaande skill met dezelfde naam. Met symlinks is bijwerken gewoon `git pull`.

Gebruik je zowel `~/.claude/skills` als `~/.agents/skills`, dan ziet Cursor elke skill twee keer. Kies dan voor Cursor één van de twee.

### Eén skill met de hand

```bash
cp -R skills/shared/requirements-ste100-linear ~/.claude/skills/     # Claude Code
cp -R skills/shared/requirements-ste100-linear ~/.agents/skills/     # Codex / Cursor
```

In een repo: kopieer de map naar `.agents/skills/<naam>` en symlink `.claude/skills/<naam>` ernaar, dan lezen alle drie de tools dezelfde map.

### HumanLayer-commands en -agents (Claude Code)

```bash
mkdir -p ~/.claude/commands ~/.claude/agents
cp humanlayer/commands/*.md ~/.claude/commands/
cp humanlayer/agents/*.md ~/.claude/agents/
```

Daarna: `/research_codebase`, `/create_plan`, `/implement_plan`, `/validate_plan` enzovoort. Ze schrijven research, plannen en handoffs naar `thoughts/shared/` in je repo; maak die map aan of zet hem in `.gitignore`, wat je wilt. Gebruik je de HumanLayer CLI niet, dan sla je de stap `humanlayer thoughts sync` over (de commands zeggen dat nu zelf). In Cursor kun je de commands ook in `~/.cursor/commands/` zetten; de agents zijn voor Claude Code geschreven (`model: sonnet`/`opus` in de frontmatter).

### Wat je nog nodig hebt

- [GitHub CLI](https://cli.github.com/) (`gh auth login`) voor de PR- en CI-skills.
- Een Linear-koppeling (MCP of CLI) voor de `*-linear`-skills. Zonder Linear werken ze tot het moment dat er issues aangemaakt worden.
- Skills die naar `interrogate`, `poteto-mode` of `ce-doc-review` verwijzen: installeer pstack en de compound-engineering-plugin vanuit hun bron (zie [`third-party/`](third-party/README.md)), of doe die stap met de hand. `grilling` kan `interrogate` vervangen.

## Herkomst en licenties

Eigen werk van Ryan Lisse valt onder de MIT-licentie, zie [`LICENSE`](LICENSE) (© 2026 Ryan Lisse). Overgenomen mappen houden hun eigen licentie, zie de tabel; `humanlayer/` valt onder Apache-2.0. Elk overgenomen bestand begint met een kopregel met bron, commit en licentie; de volledige licentietekst staat in dezelfde map.

| Wat | Bron | Licentie | Licentietekst |
|-----|------|----------|---------------|
| `humanlayer/commands/*`, `humanlayer/agents/*` | [humanlayer/humanlayer](https://github.com/humanlayer/humanlayer) `.claude/` @ [`99abe67`](https://github.com/humanlayer/humanlayer/tree/99abe673498cf8bdcd5f989aebe9406a27185b3b/.claude), aangepast | Apache-2.0, © 2024 humanlayer Authors | `humanlayer/LICENSE`, `humanlayer/NOTICE` |
| `to-tickets-linear`, `triage-linear`, `domain-modeling-linear` | [mattpocock/skills](https://github.com/mattpocock/skills) @ `49dd158`, aangepast voor Linear | MIT, © 2026 Matt Pocock | `LICENSE.mattpocock` |
| `dev-workflow/grilling` | mattpocock/skills `skills/productivity/grilling`, ongewijzigd | MIT, © 2026 Matt Pocock | `LICENSE.mattpocock` |
| `dev-workflow/deslop`, `verify-this`, `fix-ci`, `get-pr-comments`, `make-pr-easy-to-review`, `new-branch-and-pr`, `review-and-ship`, `cli-for-agents` | Claude Code-ports van [cursor/plugins](https://github.com/cursor/plugins) (`cursor-team-kit`, `cli-for-agent`) | MIT, © 2026 Cursor | `LICENSE.cursor` |
| `dev-workflow/improve-claude-md` | [humanlayer/skills](https://github.com/humanlayer/skills) @ `653b641`, aangepast | MIT, © 2026 HumanLayer | `LICENSE.humanlayer` |
| `dev-workflow/visual-plan`, `dev-workflow/diagram` | display-dev/visualize, humanlayer/skills `show-me`, Cocoon-AI/architecture-diagram-generator, aangepast | MIT | `LICENSE.*` in de map |
| `software-factory/plan`, `implement`, `research`, `company-os/visual-pr` | humanlayer/skills `rpi`, herschreven | MIT, © 2026 HumanLayer | `LICENSE.humanlayer` |
| Eigen skills van Ryan Lisse (o.a. `shared/*` behalve de mattpocock-afgeleiden, `company-os`, `job-intelligence`, `software-factory` behalve de HumanLayer-afgeleiden) | deze repo | MIT, © 2026 Ryan Lisse | `LICENSE` |
| `dev-workflow/eli5`, `dev-workflow/handoff` | eigen werk, eerder gepubliceerd in [claude-code-skills-pack](https://github.com/RyanLisse/claude-code-skills-pack) | MIT, © 2026 Ryan Lisse | |

Alle `dev-workflow`-skills komen uit [RyanLisse/claude-code-skills-pack](https://github.com/RyanLisse/claude-code-skills-pack) @ `867fcb1`; daar staan ook `ATTRIBUTION.md` en `NOTICE` met de details per bestand. Niet overgenomen uit dat pack: `java-lts-migration` (Java, niet onze stack), `archify` (heeft de externe Archify-engine nodig) en `rpi` (overlapt met de HumanLayer-commands en `software-factory`). pstack wordt alleen gerefereerd, zie `third-party/`.
