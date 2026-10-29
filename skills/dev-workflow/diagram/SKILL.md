---
name: diagram
description: "Draw an architecture, sequence, flow, state or hierarchy diagram from real code or a described system: Mermaid in chat by default, or a self-contained HTML file with inline SVG when the user wants a file to share. Use when the user asks to diagram, draw, map or visualize how components connect, who calls whom in what order, or how a process branches. No install needed; for a validated interactive system map use /archify."
argument-hint: "[architecture | sequence | flow | state | hierarchy] [path, system, or question]"
---

<!-- Copied from https://github.com/RyanLisse/claude-code-skills-pack/tree/867fcb1626f321dbc21a854fce0dd39be2f8aaa4/skills/diagram (Ryan Lisse, MIT). Upstream: humanlayer/skills `show-me` (MIT, Copyright (c) 2026 HumanLayer), Cocoon-AI/architecture-diagram-generator (MIT, Copyright (c) 2025 Cocoon AI) and display-dev/visualize (MIT, Copyright (c) 2026 display.dev); licence texts: LICENSE.humanlayer, LICENSE.cocoon-ai, LICENSE.display-dev. -->

# Diagram: Mermaid first, inline SVG when it must be a file

> Adapted from HumanLayer's `show-me` (MIT, Copyright (c) 2026 HumanLayer), Cocoon AI's `architecture-diagram` (MIT, Copyright (c) 2025 Cocoon AI) and display-dev/visualize's diagram references (MIT, Copyright (c) 2026 display.dev). Modified for this pack; see [ATTRIBUTION.md](https://github.com/RyanLisse/claude-code-skills-pack/blob/main/ATTRIBUTION.md) and [NOTICE](https://github.com/RyanLisse/claude-code-skills-pack/blob/main/NOTICE).

Request: $ARGUMENTS

## Files in this skill

- [`assets/diagram.html`](assets/diagram.html): offline HTML + inline SVG starter (light/dark, arrow marker, boundary, nodes, legend). Copy it for the HTML route.

## 1. Pick the type from the reader's question

| Reader question | Type | Mermaid |
|---|---|---|
| What exists, where are the boundaries, how do parts connect? | architecture / system | `flowchart LR` with `subgraph` per boundary |
| Who talks to whom, in what order? | sequence | `sequenceDiagram` |
| What happens next, where does it branch? | flow | `flowchart TD` |
| How does one thing move between states? | state | `stateDiagram-v2` |
| What contains or owns what? | hierarchy | `flowchart TD` or a text tree |

Use one type per figure. If two questions both matter, draw two figures.

If a diagram is overkill, use the smallest text view instead: a call tree, a file tree, a component tree, pseudocode, or a `diff` block of one of those when the point is what changed.

## 2. Evidence before boxes

- Read the code or the description first. Every node, edge, label and boundary must come from what you read: imports, HTTP/queue calls, config, docker-compose, Terraform, routes. Name the files you used.
- Unknown links stay visible as a dashed edge labelled `?` (Mermaid: `api -.->|?| billing`), or you ask one focused question. Never complete a graph by guessing.
- Label edges with the actual call, event or data (`POST /orders`, `order.created`). Boundaries label what they mean (trust zone, VPC, process, team), not just a pretty box.

## 3. Stay inside the budget

| Type | Budget per figure |
|---|---|
| architecture | ≤ 9 components, ≤ 12 edges, ≤ 3 top-level boundaries |
| sequence | ≤ 5 participants, ≤ 12 messages, 1 `alt`/`opt`/`loop` block |
| flow | ≤ 9 steps, ≤ 3 exits per decision, every exit labelled |
| state | ≤ 9 states, ≤ 18 transitions (fewer if labels crowd), every transition labelled with its event |
| hierarchy | ≤ 4 visible levels, ≤ 5 children per parent, ≤ 12 nodes; split by branch beyond that |

Over budget: draw an overview, then one detail figure per area or per path (happy path first, failure/retry separate).

## 4a. Mermaid route (default)

- Put the diagram in a ```` ```mermaid ```` block next to two or three sentences that say what to notice.
- Quote labels that contain spaces, parentheses or slashes: `api["Orders API (Go)"]`. Use short IDs.
- Sequence: solid arrows for calls (`->>`), dashed for returns (`-->>`); time runs downward only.
- To check that it parses, save it as `d.mmd` and run `mmdc -i d.mmd -o d.svg` if `mmdc` is installed, otherwise `npx -y @mermaid-js/mermaid-cli -i d.mmd -o d.svg` (downloads once; needs network). If neither works, say the diagram was not validated.

## 4b. HTML + inline SVG route (when asked for a file, or Mermaid can't show it)

- Copy `assets/diagram.html` to `docs/diagrams/<slug>.html` (or the user's path). Do not overwrite without asking.
- Get geometry either from Mermaid or by hand on a 20px grid. From Mermaid: write `{"flowchart":{"htmlLabels":false}}` to `m.json`, run `mmdc -i d.mmd -o d.svg -c m.json`, inline the SVG, then delete its `<style>` block, `<foreignObject>` elements and generator attributes and restyle with the file's tokens. `mmdc` downloads Chromium and can fail in sandboxes or as root; if it does, draw by hand. Never ship Mermaid source or a Mermaid runtime; no CDN scripts or web fonts.
- Layout rules:
  - Draw edges first so they sit behind nodes. Translucent node fills get an opaque rect underneath, so edges don't show through.
  - Keep ≥ 40px between stacked nodes; put small connectors (a queue, a bus) inside that gap, not overlapping a node.
  - Edges attach to nodes, never to a boundary label. Route around unrelated nodes; avoid crossings.
  - Legend sits outside every boundary; grow the `viewBox` instead of squeezing it in.
- Color by role only when the source shows the role: client/frontend, service, data store, external, async/queue, security boundary. Same role, same color. Color never carries meaning alone: keep text labels.
- Accessibility: `<svg role="img" aria-labelledby="t d">` with `<title id="t">` and a `<desc id="d">` that states the main parts, direction and boundaries in one or two sentences.
- Narrow screens: the SVG scales with `viewBox`. If labels become unreadable around 390px wide, add a top-to-bottom variant or split the figure; do not collapse it into unconnected cards.

## 5. Verify, then deliver

- Every edge has a real source and target, arrowheads match the evidence, every decision exit is labelled.
- HTML route: `grep -nEi "(src|srcset|href|poster|action|data)[[:space:]]*=[[:space:]]*[\"']?(https?:)?//|@import|url\([[:space:]]*[\"']?(https?:)?//" <file>` may only match plain `<a href>` links (any `src`, stylesheet, `@import` or `url(...)` hit is a network dependency to remove); if a browser tool is available, screenshot desktop and phone width and check labels don't overlap or clip. Otherwise say it was not rendered.
- Deliver the diagram (or file path plus how to open it), the files it was derived from, and any `?` edges that still need an answer.
