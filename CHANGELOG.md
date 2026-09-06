# Changelog

All notable changes to the wb plugin. Versions are release cuts — installers receive a version only when it's bumped here AND they run `claude plugin update wb@gvarela-workbench`. See [RELEASING.md](RELEASING.md) for the process.

## [Unreleased]

### Changed

- `RELEASING.md` Process: non-breaking phases merge unbumped under Unreleased; a cut happens when a plan completes; the breaking phase goes last and carries the bump; every cut is tagged; majors get a three-session canary on the release branch.
- Beads persistence: `plugin/docs/reference/beads-mode.md` is the single statement. `issues.jsonl` is written only with `export.auto` on or an explicit `bd export`; the auto-flush claim is removed from ten skill and doc sites (prompts-vwo).
- `implement_coordinated/reference.md` "Worker Model Selection" points at the SKILL.md Step 5 tier list instead of restating it with opus as the default when unsure.

### Fixed

- `plugin/scripts/lint` exits 1 when markdownlint reports an error, in named-file, changed-files, and `--all` modes, and exits 1 from `--fix` when findings remain; it had always exited 0 (prompts-3ke). The PostToolUse hook still exits 0.

## [2.6.0] — 2026-09-05

Every wb workflow skill is now model-invocable. A prose request to plan, research, design, break down, implement, validate, sync status, or hand off is honored without a typed `/wb:` command; the slash commands still work as before.

### Changed

- `disable-model-invocation` removed from all workflow skills except the deprecated `create_execution` alias. Descriptions rewritten as trigger text (what the skill does, when to use it, what it takes) since the model now loads them. Each skill's Initial Response still gates on its arguments, and checkpoints still stop for a human.
- `update_status` had been the sole writer of tasks.md progress frontmatter since v2.3.0 while user-only, so no phase could reconcile its own status; that is now possible.
- `CLAUDE.md` and `docs/claude-code-skills-guide.md` record the decision.

## [2.5.0] — 2026-09-05

Fable 5.1 re-baseline, phase 2: the CLAUDE.md command root rewritten, the budget-keyword directives converted, and the two deferred prompt-modernization trims decided on blind-trial evidence. Plan: `docs/plans/2026-09-01-fable-5-1-rebaseline/` (trials in `trials/2026-09-05-blind-trials.md`).

### Changed

- `CLAUDE.md` "Working with Commands": one marker per real synchronization point with its reason stated; name what a decision is about instead of instructing thinking depth; spawn in parallel and synthesize only after every agent returns. The Command Structure Patterns example carries a reason per marker.
- R1 (prompt-modernization): the 21 `think deeply` / `ultrathink` directives across the stage skills become the directive they introduced (Decide…, Document…, Identify…, Work out…); the two bare ones (create_project, update_status) are deleted. Thinking depth is the session's effort setting, not prompt text.

### Skipped on evidence

- R3 barrier normalization (triple ⛔ → single ⛔ with reason): on a trap fixture with two of three agent reports back and the third streaming a near-complete partial, Sonnet synthesized anyway under both wordings (WAIT 0/3 baseline, 1/3 trimmed). Volume is not what holds the barrier; no barrier text changed.
- R4 scope-block softening (CRITICAL/NEVER → Scope/Do not): both wordings left a trap bug in the edited function untouched 3/3; the trimmed wording surfaced it 2/3 against 3/3 baseline. No scope block changed. The documentarian-placement half of R4 was already at target since the v2.0.0 relocations.

## [2.4.0] — 2026-09-05

Fable 5.1 re-baseline, phase 1: guardrails and uplifts the new model needs in implementation contexts, plus Fable routed into the two places it pays for itself — escalation after a verified failure and the create_tasks decomposition stage. Nothing removed. Plan: `docs/plans/2026-09-01-fable-5-1-rebaseline/`.

### Added

- `task-worker` agent: FOLLOW-UPS, NOT FIXES and SURGICAL EDITS constraints (pre-existing bugs are reported, not fixed; targeted edits over whole-file rewrites), and an Operating Mode section for autonomous runs that explicitly excludes phase checkpoints and plan-defect halts.
- `implement_tasks`: "Extras and edits" rules after the scope block; "Record durable learnings" step (`bd remember` with a qualification rule) at phase completion.
- `implement_coordinated`: autonomy paragraph at the top of the task loop; "Record durable learnings" step at phase completion; `why:` field leading the worker context package, rendered first in the Worker Prompt Template.
- `create_tasks`: Model Self-Check (Fable recommended at high effort, Opus the comfortable minimum; warns below Opus, never blocks) — same shape as explore_design's.
- `create_handoff`: Critical Discoveries reviews the session's `bd remember` entries.

### Changed

- `implement_coordinated`: verified failures escalate once to a `fable` fix worker at `effort: high` (opus fallback when fable is unavailable); no second retry — the task goes to the checkpoint's blocking list. Opus tier is architectural/cross-cutting work; Fable is never a first spawn.
- Model map: `docs/workbench-workflow-guide.md` rows for create_tasks (Fable, Opus fallback), implement_tasks (Fable for cross-cutting phases), implement_coordinated (escalation workers Fable at high); `CLAUDE.md` tier list gives `fable` decomposition and escalation, and the rule that Fable spawns use `effort: high`, never `xhigh`.

### Removed

- `AGENTS.md`: duplicated CLAUDE.md's session protocol with a stale pre-1.0.2 step; references repointed.

## [2.3.0] — 2026-08-26

Compaction and drift hardening: a recovery hook for compacted sessions, a background skill that keeps plan-doc claims grounded in the current context, and a single authoritative writer for plan-doc progress frontmatter.

### Added

- `hooks/compact-recovery.sh` (SessionStart, `compact` trigger): re-anchors a compacted session on the active plan directory. Empirically validated with a live `/compact` marker test — the model quoted the recovery block verbatim (evidence on `prompts-6du`).
- `doc-adherence` background skill: plan-doc claims require a read in the current context window before they can be asserted. Blind-trial validated 9/9 on first run (evidence on `prompts-2x7`).

### Changed

- Plan-doc progress frontmatter consolidated to a single writer, `/wb:update_status`; `implement_tasks`, `implement_coordinated`, and their templates now defer to it instead of writing frontmatter themselves. `status-sync` gains a frontmatter-drift indicator.
- Handoff-over-compact guidance: a phase that would need a second `/compact` now hands off instead (`implement_coordinated`, `create_handoff`, `help`).

## [2.2.0] — 2026-07-31

The create_tasks rename, plus the model-strategy recalibration.

### Added

- `skills/create_tasks`: canonical name for the execution-planning skill (the `create_*` family names its artifact — this one writes `tasks.md` — and it pairs with `implement_tasks`). Identical behavior; all docs and cross-references updated.

### Changed

- `implement_coordinated` worker tiers recalibrated: sonnet (at `effort: xhigh`) is the default when unsure, including bugs and refactors; haiku is mechanical-only; opus is reserved for architectural, cross-cutting, or previously-failed tasks. Fix workers stay opus.
- `implement_coordinated` verification FAILs now distinguish implementation defects (fix-worker retries) from plan defects — a new Plan-Defect Deviation Protocol files a design-revision issue, blocks dependents, and halts the phase instead of burning retries on tasks that are wrong as specified.
- `create_mockup` research agents moved from haiku to sonnet at `effort: low`; analyzer/verifier agents carry explicit `effort` annotations.
- `create_tasks` gains a must-NOT-contain list (no new scope, no re-deciding design, no invented requirements).
- Per-stage session-model guidance added to the workflow guide (Fable for explore_design, Opus for decomposition/coordination, Sonnet elsewhere).

### Deprecated

- `/wb:create_execution` — now a stub that redirects to `/wb:create_tasks`. Removed at 3.0.0. **Gotcha**: a session started before this rename may hold a cached pre-rename skill body and reference supporting files by their old paths — restart the session (or `/reload-skills`) after updating; the stub directory keeps pointer files for its old supporting files so stale references degrade gracefully instead of erroring.

## [2.1.0] — 2026-07-31

The explore_design release. Adds an optional architecture-discussion stage between research and design, with durable decision records the rest of the pipeline consumes.

### Added

- `skills/explore_design`: optional, user-only facilitated architecture discussion (frame → diverge → discuss → converge → record). Produces an elastic exploration record under `thoughts/` and a fixed-shape decision record as a closed `Decide:` beads issue. Recommended model: Fable (Opus fallback); the skill self-checks and surfaces lighter models without blocking.
- `create_design` cold-start consumption: BARRIER 1 checks `bd list -n 0 --status=closed | grep "Decide:"` and reads referenced thoughts docs; Step 4 formalizes the recorded decision on confirmation instead of generating options. With no record, behavior is byte-identical to 2.0.0 (verified against a pre-edit parity baseline).
- `create_research` and `create_product_research` completion summaries conditionally suggest `/wb:explore_design` — only when findings show multiple viable approaches.
- `validate_project` orphan detection exempts planning-prefix issues (`Q:`, `Decide:`, `Validate:`, `UI Q:`) — planning-phase records are intentionally not anchored in tasks.md frontmatter.
- Documentation sweep: the optional stage appears in every workflow rendering (help, CLAUDE.md, README, commands reference, workflow guide, generated project templates); help additionally documents `Decide:` lifecycle semantics (open = pending, closed = decided, rationale in close reason).

## [2.0.0] — 2026-07-31

The modernization release. One coordinated breaking change covering the Claude Code skills unification, the beads 1.0.2 CLI migration, and a repository restructure.

### ⚠️ Breaking / Requirements

- **Requires beads ≥ 1.0.2** (embedded-Dolt backend). The prompts now use `bd info`, `bd update --claim`, and auto-flush semantics; `bd sync` and `bd doctor` are gone from all guidance. **Update beads before updating the plugin** — old beads + new prompts will produce failing commands.
- **Repository layout changed**: the runtime plugin now lives in `plugin/`; installs cache only that subtree. If you reference repo paths directly (scripts, `--plugin-dir`), point at `plugin/`. All `/wb:*` command names are unchanged.
- **Workflow commands no longer auto-trigger**: the 13 `/wb:create_*`/`implement_*`/`validate_*`/`*_handoff`/`update_status` skills carry `disable-model-invocation` — you invoke them; Claude won't fire them spontaneously. Background discipline skills (tdd-discipline, verification-before-completion, status-sync, project-structure) are now Claude-only (hidden from the `/` menu).

### Changed

- All 14 workflow commands migrated from `commands/*.md` to canonical `skills/<name>/SKILL.md` form (skills/commands unification).
- Skill cores restructured for context economy: 8,439 → ~5,275 lines loaded at invocation (−37.5%); templates, sub-agent prompts, and reference material moved to on-demand supporting files with verified output parity (structural dry-run comparison + independent content-conservation audit).
- `implement_coordinated` workers are now a defined `task-worker` agent with the tdd-discipline skill preloaded; model selection moved from keyword regex to coordinator judgment with per-spawn overrides.
- Agents carry explicit `model:` selections (haiku for search, sonnet for analysis/verification) and `maxTurns` caps on search agents.
- Verification skills (`validate_execution`, `research-validation`) pinned to `model: sonnet` + `effort: high`.
- `status-sync` skill re-scoped to interactive deep-checks; the deterministic session-end reminder moved to a SessionEnd hook.

### Fixed

- `bd list` decision pipelines no longer silently truncate at 50 issues (`-n 0` added at 8 gating sites).
- Task claiming is atomic (`bd update --claim`) — closes the double-claim window in coordinated execution (14 sites).
- `validate_project` mode checks now use the same `git check-ignore` predicate as the SessionStart hook (the old tracked-file check false-warned before first commit).
- Phase-completion checks use the milestone's `blockedBy` (authoritative) instead of fragile title greps.
- Phantom barrier references removed from three sync summaries; two real pre-report gates added to the validation skills (validate_execution BARRIER 3, validate_project BARRIER 2).
- PostToolUse lint hook reads hook input from stdin JSON — it had been silently no-opping since Claude Code stopped setting `CLAUDE_TOOL_ARGS`.

- Workflow skills carry `allowed-tools: Read` — pre-approves file reads while the skill is active, so the on-demand supporting files (templates, sub-agent prompts, reference) load without permission prompts when your session is in a different project. Found in release testing; reads outside the active skill still follow your normal permission settings once the skill completes.

### Added

- `hooks/beads-drift-check.sh` (SessionEnd): one-line reminder when `.beads/` has uncommitted changes; silent when clean.
- `agents/task-worker.md`: focused single-task TDD worker for coordinated execution.
- `plugin/docs/reference/`: shared runtime docs (beads modes, documentarian philosophy, beads-not-initialized playbook) referenced by skills instead of duplicated in them.
- `displayName: Workbench` in the plugin manifest.

### Migration

1. Update beads first: `brew upgrade bd` (or equivalent) to ≥ 1.0.2, then in each beads project let it migrate (`bd info` to confirm; if it errors, `bd export` then `bd init --force --prefix <prefix>` then `bd import`).
2. `claude plugin update wb@gvarela-workbench` from your shell, then restart Claude (or `/reload-plugins`).
3. Nothing else changes day-to-day: same `/wb:*` names, same workflow sequence.

## [1.1.0] — 2026

- Added product-manager research flow: `/wb:create_product_research`, `product-behavior-analyzer` and `research-validator` agents, `research-validation` skill, portable Claude Desktop prompt.

## [1.0.0]

- Initial plugin release: wb workflow commands, agents, skills, hooks, beads integration.
