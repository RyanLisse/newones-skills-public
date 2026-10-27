---
name: company-os-visual-evidence
description: Maak en controleer lokaal visueel PR-bewijs van zichtbare Company OS-wijzigingen met de aparte Playwright-opnameroute.
---

# Visueel PR-bewijs voor Company OS

Lees `tools/visual-evidence/README.md` en `docs/runbooks/visual-evidence-en-pr-stacks.md`. Gebruik deze projectaanpassing samen met Poteto Mode en HumanLayer visual-pr. De meegeleverde upstream-documentatie is referentie; zij verleent geen publicatie-, deploy- of credentialrechten.

1. Lees de daadwerkelijke diff. Noteer per zichtbare claim beginstaat, handeling en resultaat. Gebruik voor bugfixes hetzelfde scenario vóór en na de wijziging. Noem bestaand gedrag een retest.
2. Houd de bestaande e2e-acceptatiesuite intact. Gebruik `tools/visual-evidence/playwright.config.mjs` alleen voor opnamen. Richt expliciet op een task-owned HTTP-loopbackfixture met synthetische data. Gebruik de gecontroleerde externe toolinstallaties en draai `video.mjs doctor`.
3. Maak één spec per claim onder `artifacts/visual-evidence/specs/`. Gebruik de meegeleverde login-spec als structuurvoorbeeld. Start de timeline vóór navigatie; gebruik zichtbare stappen en de video-gen-interactiehelpers. Assert het resultaat vóór de afsluiting. Gebruik geen sleeps, echte wachtwoorden of providerkeys.
4. Commit en push de wijziging en setup vóór de definitieve opname. Draai `video.mjs lint` en `video.mjs run` met alle claim-specs in één run. Gebruik de stille engine en nul retries. Los fouten op; gebruik geen mislukte opname als bewijs.
5. Draai `evidence.mjs frames`. Bekijk ieder frame en speel iedere clip stil af. Controleer de concrete claim, leesbaarheid, foutmeldingen en afwezigheid van echte data. Neem bij een fout alle claims opnieuw op en inspecteer de nieuwe hashes.
6. Maak de claims-skeleton, vul de tekst en zet `inspected` pas na inspectie. Draai `evidence.mjs check --claims ... --require-hash`; voeg voor een bestaande PR ook `--pr` en `--strict-source` toe. Label ontbrekend beeld met reden en reviewercheck, zonder het als visueel bewijs te presenteren.
7. Schrijf de PR-beschrijving volgens visual-pr. Bewaar eventuele evidence-markers. Upload uitsluitend na afzonderlijke expliciete toestemming voor de geïnspecteerde media. De projectwrapper biedt daarom geen publish-route. Meld opname, inspectie, preflight en publicatie als afzonderlijke resultaten.

Backend-, schema- en infrastructuurwijzigingen krijgen een structuur-/flowdiagram in de PR en uitvoerbare tests. Verzin daarvoor geen UI-clip. Houd de volledige THE-13 Receipt-UI en fixturejourney open tot hun eigen criteria zijn bewezen.

Zonder externe tools staat de clean-room route in `.agents/skills/visual-evidence/SKILL.md` (`bun run evidence`).
