---
name: visual-evidence
description: Maak lokaal visueel PR-bewijs (before/after screenshots, diff, trace, optionele walkthrough) met de clean-room route `bun run evidence`. Voor Codex Luna, Claude, GLM en Devin.
---

# Visueel bewijs met `bun run evidence`

Lees `tools/evidence/README.md` voor het manifestcontract en de foutcodes. Gebruik uitsluitend synthetische fixturedata en loopback-URL's.

1. Draai `bun run evidence doctor`. Chromium, ffmpeg en ffprobe moeten `ok` zijn (exit 0).
2. Start de app op fixturedata. Draai de PR-head op één poort (after) en `main` in een aparte worktree op een andere poort (before). Verandert de PR geen bestaand gedrag, dan is alleen after genoeg (retest).
3. Commit eerst, want capture weigert een vuile werkboom (`--allow-dirty` schrijft `dirty: true`). Draai daarna:
   `bun run evidence capture --base-url http://127.0.0.1:<after> --before-url http://127.0.0.1:<before> --routes <bestand|csv> --pr <n> --lane <codex-luna|claude|glm|devin|human>`
   Voeg voor admin-routes `--storage-state <pad>` toe (zie README). De optie `--video <spec.json>` is optioneel.
4. Draai `bun run evidence diff artifacts/evidence/<sha>/manifest.json`. Dat vult `diff` en `diffPct`.
5. Bekijk de PNG's werkelijk (Read-tool op after, before en diff, desktop én mobile). Controleer de claim, leesbaarheid en dat er geen echte data in beeld staat. Capture opnieuw bij twijfel.
6. Voeg per zichtbare claim een regel toe aan `claims` in het manifest (id, title, start, action, result, mode, clips). Is geen beeld mogelijk, vul dan `notCaptured` met `reason` en `reviewerCheck`.
7. Draai `bun run evidence manifest inspect <manifest> --claim <id> --file <relatief pad>` voor elk bestand dat je bekeken hebt.
8. Draai `bun run evidence validate <manifest>`. Exit 0 is vereist, 1 betekent geweigerd (lees `errors[].code`) en 2 is een gebruiksfout.
9. Vul in de PR-beschrijving de sectie "Before / after" onder Evidence (zie `.github/pull_request_template.md`) met wat je zag: claim, route, viewport, `diffPct`, en wat niet is vastgelegd.

Regels:

- Commit proof-assets (`artifacts/evidence/`) nooit; Git negeert de map.
- Uploaden gebeurt alleen via THE-72b, na expliciete toestemming voor de geïnspecteerde bestanden.
- Een geldige `validate` bewijst de bestandsintegriteit, niet de visuele claim; dat doet jouw inspectie.
- Een storage-state bevat sessies: bewaar hem buiten Git, in `/tmp`, en toon of log hem niet.
- `trace.zip` is gevoelig (`traceSensitive: true`): een trace kan DOM-snapshots, netwerkdata, headers, cookies en sessies bevatten. Deel of upload hem nooit zonder hem eerst zelf te bekijken.
