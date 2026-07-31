# Pre-research: eval harness design discussion (2026-06-10 session)

Exploration captured from the session that proposed this project. Not validated research — `/wb:create_research` should verify the factual claims (especially plugin packaging mechanics and Faraday codebase details) before design hardens them into decisions.

## Proposed tier architecture (sketch)

- **Tier 0 — static invariants** (`scripts/check`, every commit): pointer integrity (targets exist + quoted section names match headings), gate manifest (`evals/gates.yaml` expected ⛔ inventory per skill), bd CLI contract check (every `bd` invocation in skills validated against `bd --help` — the "next bd 1.0.2" detector), forbidden-pattern regressions (`bd list` without `-n 0` in decision pipelines, `--status in_progress` at claim sites, bare `docs/reference/` paths in bash comments), frontmatter schema + invocation-flag matrix.
- **Tier 1 — refactor conservation** (`scripts/conserve <old-ref>`, on restructures): line-multiset + order-preserving sequence checks of moved blocks against git blobs, allowlist for intentional deletions. Proven 2026-06-09: caught a worker stripping Task() wrappers (subagent_type/model loss) that the worker's own report claimed was verbatim.
- **Tier 2 — structural golden runs** (headless `claude --plugin-dir -p`, per release): canonical structural-dry-run prompt per workflow skill, blessed output in `evals/golden/`, compared by key-element checklist (gates/fields/sections), not byte-diff.
- **Tier 3 — behavioral pressure suites** (on behavior-shaping changes + model upgrades): superpowers `testing-skills-with-subagents` pattern — pressure scenarios (deadline, sunk cost, "just this once") for discipline skills; editorializing-bait fixture for research skills; gate-adherence transcript checks for workflow skills; judge agents return structured PASS/FAIL (research-validator pattern generalized). Keep RED-state evidence (agents failing WITHOUT the skill) to prove tests discriminate.

## Fixture decision (tentative)

- **Faraday, pinned at a v1.10.x SHA on a fork** (gvarela fork TBD). Rationale: maintainer familiarity (grading requires smelling wrong answers); v1.x keeps the retry middleware in-tree as research precedent (2.x extracted it to faraday-retry); middleware/adapter architecture gives crisp locator/analyzer/pattern ground truth; built-in test adapter = deterministic failures, no network.
- Considered: Liquid (best layering, but implement-shaped benchmark candidates and less maintainer familiarity), Rack, Sinatra (single-file core — weak locator bait), Thor, tinydb/dayjs (wrong stack).
- **Benchmark feature: circuit-breaker middleware.** Real design space (state scope per-host/global, storage abstraction, half-open probes, failure classification, retry interaction); phased decomposition (state machine → middleware → config → instrumentation); deterministic via test adapter + injected clock. Difficulty tiers: config option on existing middleware (haiku) → logging-with-redaction middleware (sonnet) → circuit breaker (opus).
- **Consistency mechanism**: freeze three artifacts — the SHA, a feature spec fixing only the public contract (middleware name, options, error class; internals stay open as design space), and an acceptance suite written once against that contract (SWE-bench move: our tests grade their implementation). Each run: scratch copy → `bd init --stealth` → run workflow stage → grade vs frozen spec/tests/rubrics → discard.
- Ground truth file per fixture (`evals/fixtures/<name>.truth.yaml`): where features live, conventions, known warts (documentarian bait). Built from one human-verified create_research pass.
- Scenario branches on the fork (e.g., planted-deviation implementation for validate_execution evals).
- Mockup evals: out of scope; would need a second UI-bearing fixture (tiny Sinatra+ERB app) — later decision.

## Packaging constraints (verify in research)

- Marketplace install clones the whole repo; version cache copies the whole plugin source dir; no exclude field. Loading is manifest/demand-driven, so evals never pollute context — the cost is disk/download only.
- Plugin has multiple installers (coworkers) — `docs/plans/` and `.beads/issues.jsonl` are tracked and currently ship; `tmp/` is gitignored and never shipped (corrected claim from session).
- Planned fix (tracked as prompts-89d in prompt-modernization): `plugin/` subdirectory layout with `marketplace.json` `source: "./plugin"`; `docs/reference/` must move inside plugin/ (runtime-referenced by skills via relative links). Evals live at repo root, co-versioned but never cached.
- Fixture as git submodule: non-recursive clones (marketplace add, cache copy) materialize only the pointer — installs stay light. Runner preflight does `git submodule update --init` with a clear error if missing. VERIFY submodule behavior empirically.

## SOTA context (from 2026-06-09 research; cite-check during research phase)

- Anthropic official: evals before documentation; multi-model testing (Haiku/Sonnet/Opus); real-usage validation; no official refactor-validation framework exists.
- Practitioner standard: subagent pressure-testing (obra/superpowers `testing-skills-with-subagents` — RED/GREEN/REFACTOR for skills).
- Tooling: promptfoo-style assertion evals; Claude Code built-ins limited to `/reload-skills`, `claude plugin validate`, `/context` — no native regression harness; behavioral testing is the plugin author's responsibility.
- Tier 1 conservation checking appears ahead of published practice (no documented equivalent found).

## Cross-project dependency

- prompt-modernization Phase 4 (`prompts-41c` parity protocol) should be re-scoped to consume this harness's Tier 3 against the Faraday fixture instead of building a throwaway protocol against the prompts repo. Phase 4 trims stay blocked until then (by design: trims land last-or-never).

## Open questions for research phase

1. Verify Faraday v1.10.x actually has retry in-tree and which middlewares exist at the candidate SHA; pick the SHA.
2. Empirically verify submodule behavior under `claude plugin marketplace add` and cache copy.
3. What's the realistic per-run cost (tokens/time) of a Tier 3 scenario, and what budget tiering keeps the suite runnable?
4. Judge reliability: can a haiku judge grade discipline-violation transcripts, or do rubric verdicts need sonnet+?
5. How do Tier 2 golden comparisons stay stable across model upgrades (key-element checklist design)?
