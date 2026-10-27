# Measurement

Representative input: `test/fixtures/bun-unhandled-errors.txt`, a real Bun test run from `packages/api` without a database environment. It contains six passes, three unhandled errors, and Bun's `3 errors` summary.

The measurement uses character count divided by four as an approximate token count. Reductions are relative to the full fixture. Both commands read the same fixture; `test-summary` intentionally exits with status 1 because the fixture contains failures. The measurement still captured its output.

| Stage | Characters | Approx. tokens (`characters / 4`) | Reduction |
|---|---:|---:|---:|
| Full fixture output before reduction | 1,438 | 359.5 | none (baseline) |
| `.agents/skills/blocks/test-summary` output | 219 | 54.8 | 84.8% |
| `.agents/skills/blocks/first-error` output | 192 | 48.0 | 86.6% |

Commands used:

```sh
.agents/skills/blocks/test-summary .agents/skills/blocks/test/fixtures/bun-unhandled-errors.txt
.agents/skills/blocks/first-error .agents/skills/blocks/test/fixtures/bun-unhandled-errors.txt
```

The summary reduced the full run by 1,219 characters, approximately 304.8 tokens (84.8%). `first-error` reduced it by 1,246 characters, approximately 311.5 tokens (86.6%).
