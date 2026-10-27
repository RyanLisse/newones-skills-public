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

## Kanttekeningen

- Deze skills zijn geschreven voor onze eigen repo's. Ze verwijzen naar scripts, paden en documenten in die repo's (zoals `RISK_POLICY.md` of `defaults/project-start-defaults.md`) die hier niet bij zitten. Lees ze als patroon en pas de paden aan.
- Issue-ID's als `THE-123` of `CTP-505` verwijzen naar onze eigen tracker.
- `<org>` en `<user>` zijn placeholders voor je eigen GitHub-org en branch-prefix.

## Gebruiken

Kopieer een skillmap naar `.agents/skills/<naam>` in je repo en symlink `.claude/skills/<naam>` ernaar.
