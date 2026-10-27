---
name: verify-frontend-change
description: Verify or review a change to the Company OS admin UI in apps/admin.
---

# Verify an admin-UI change

Use this for every visible or behavioral change under `apps/admin`, both while implementing it and while reviewing its PR. Keep all work on fixture/test data.

1. Start the admin dev server:

   ```sh
   bun install --frozen-lockfile
   NEXT_PUBLIC_SERVER_URL=http://localhost:3000 bun run dev:admin
   ```

   Keep that process running, then wait in another shell until this succeeds:

   ```sh
   curl -sf -o /dev/null http://localhost:3001/login
   ```

   `bun run dev:admin` runs `next dev --port 3001`. `NEXT_PUBLIC_SERVER_URL` is the only admin setting required here; it is a public URL, not a secret (see `apps/admin/.env.schema`). Repeat the `curl` until it succeeds. If the page needs data or a session, start fixture/test services first with `bun run db:start` and `bun run dev:server` (port 3000). For a logged-in route, create a Playwright storage state from a fixture account and keep it in `/tmp`; see [the evidence README](../../../tools/evidence/README.md), section “Ingelogde routes”. Never use production data, real credentials, or PII.

2. Name the route to verify explicitly before you start. List the changed files:

   ```sh
   git diff --name-only origin/main...HEAD -- apps/admin
   ```

   A changed `apps/admin/src/app/<path>/page.tsx` is route `/<path>`. A dynamic segment such as `[operationId]`, `[channelId]` or `[entryId]` is not a usable URL: replace it with the ID of a record that exists in the fixture/test data you started (for example a Hub entry created by `bun run db:seed:hub`, read from its list page in the admin). If the fixture/test data has no such record, stop and ask; never invent an ID or use one from production. A change elsewhere (a component, hook, or style) has no page in that list: follow its imports up to every `page.tsx` that renders it and use those routes; if a shared component appears on several routes, verify each one, or name the routes you skip and why. If you cannot name at least one route that shows the change, stop and ask; never verify without one. Use those routes in the verification below.

3. Click the new control. Choose one stable selector from the diff—a role, visible text, or `data-testid`—rather than generated CSS or a changing label.

4. Capture before/after screenshots. Write the console-check script below to `artifacts/evidence/verify-frontend-change/console-check.mjs` (Git ignores this directory; keeping it in the repo lets `playwright-core` resolve), then run:

   ```sh
   [STORAGE_STATE=/tmp/<file>.json] bun artifacts/evidence/verify-frontend-change/console-check.mjs <url> <selector> <out-dir> [<after-selector>]
   ```

   Its `before.png` is the page before the click and `after.png` is the page after it. Pass `<after-selector>` (an element that appears only once the click's work is done) whenever the click does not navigate. The script waits for it, then for a 2-second quiet window with no new console messages, page errors or network requests (at most 15 seconds), before the screenshot and the error count. Set `STORAGE_STATE` for a logged-in route. For a main-versus-PR comparison of a page that needs no session or API data, also run the repo evidence flow against `origin/main` served on a second port. Start it in a separate plain clone of `origin/main` (never push from it), because `bun run dev:admin` is fixed to port 3001:

   ```sh
   cd apps/admin && NEXT_PUBLIC_SERVER_URL=http://localhost:3000 bunx next dev --port 3002
   ```

   The API server allows only one CORS origin, read from its runtime `CORS_ORIGIN` setting (`apps/server/.env.schema`; start `bun run dev:server` with `CORS_ORIGIN=http://localhost:3001`), so do not use port 3002 for logged-in or data pages; compare those serially on port 3001 as in step 5. Use `localhost`, not `127.0.0.1`, in every URL: the API server's CORS origin must be `http://localhost:3001`, and the browser origin must match it exactly. Then, from the PR checkout:

   ```sh
   bun run evidence doctor
   bun run evidence capture --base-url http://localhost:3001 --before-url http://localhost:3002 --routes <route> --pr <n> --lane <lane> [--storage-state /tmp/<file>.json] [--video <spec.json>]
   bun run evidence diff <manifest>
   bun run evidence validate <manifest>
   ```

   Read [tools/evidence/README.md](../../../tools/evidence/README.md) and [.agents/skills/visual-evidence/SKILL.md](../../../.agents/skills/visual-evidence/SKILL.md) for capture, claims, diffs, and validation; do not repeat their content here.

5. Require zero new console errors. The console-check script records `console` errors and `pageerror` messages during load and click: `errors: 0` passes. If it reports errors, get the main baseline.

   Run the same script, with the same arguments, against `origin/main`: either the port-3002 server from step 4 (pages without a session or API data only), or stop the PR-head server and run `NEXT_PUBLIC_SERVER_URL=http://localhost:3000 bun run dev:admin` (port 3001, same fixture/test data) in the plain `origin/main` clone. Logged-in or data pages always use the port-3001 route, because the API server trusts only that origin. Never push from that clone. Fail only on errors that the main baseline doesn't have, and copy those errors into the evidence with tokens, emails, IDs and other PII redacted.

6. Attach evidence to the PR. In the PR body's “Before / after” section, between the `<!-- evidence:start -->` and `<!-- evidence:end -->` markers, record the route, selector, console result (`errors: 0` or the new errors), and screenshots. Upload image files only after explicit permission (repo rule THE-72b); otherwise list local paths and write “upload pending permission”. Never commit artifacts.

## Console-check script

```js
import { mkdirSync, writeFileSync } from "node:fs";
import { chromium } from "playwright-core";

const [url, selector, outDir, afterSelector] = process.argv.slice(2);
if (!url || !selector || !outDir) throw new Error("usage: console-check.mjs <url> <selector> <out-dir> [<after-selector>]");
mkdirSync(outDir, { recursive: true });
const errors = [];
let lastActivity = Date.now();
const touch = () => {
  lastActivity = Date.now();
};
const settle = async (quietMs = 2_000, maxMs = 15_000) => {
  const start = Date.now();
  while (Date.now() - lastActivity < quietMs && Date.now() - start < maxMs) await page.waitForTimeout(250);
};
const browser = await chromium.launch({ headless: true });
const storageState = process.env.STORAGE_STATE || undefined;
const context = await browser.newContext({ viewport: { width: 1440, height: 900 }, storageState });
const page = await context.newPage();
page.on("console", (message) => {
  touch();
  if (message.type() === "error") errors.push(message.text());
});
page.on("pageerror", (error) => {
  touch();
  errors.push(error.message);
});
page.on("request", touch);
page.on("requestfinished", touch);
await page.goto(url, { waitUntil: "networkidle" });
await settle();
await page.screenshot({ path: `${outDir}/before.png`, fullPage: true });
await page.click(selector);
if (afterSelector) await page.waitForSelector(afterSelector, { timeout: 15_000 });
touch();
await settle();
await page.screenshot({ path: `${outDir}/after.png`, fullPage: true });
// console.json holds raw error text: keep it local and redact it before it reaches the PR (step 5).
writeFileSync(`${outDir}/console.json`, JSON.stringify({ url, selector, errors }, null, 2));
console.log(JSON.stringify({ errors: errors.length }));
await browser.close();
if (errors.length > 0) process.exitCode = 1;
```

## Rules

- Use fixture/test data only; never production data, real credentials, or PII.
- Storage states and `trace.zip` are sensitive: keep them in `/tmp`, never print them, and never upload them unreviewed.
- Stop the admin and server dev servers when verification is complete.
