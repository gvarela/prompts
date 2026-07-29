# Changelog

All notable changes to the wb plugin. Versions are release cuts — installers receive a version only when it's bumped here AND they run `claude plugin update wb@gvarela-workbench`. See [RELEASING.md](RELEASING.md) for the process.

## [2.1.0] — Unreleased

The explore_design release. Adds an optional architecture-discussion stage between research and design, with durable decision records the rest of the pipeline consumes.

### Added

- `skills/explore_design`: optional, user-only facilitated architecture discussion (frame → diverge → discuss → converge → record). Produces an elastic exploration record under `thoughts/` and a fixed-shape decision record as a closed `Decide:` beads issue. Recommended model: Fable (Opus fallback); the skill self-checks and surfaces lighter models without blocking.
- `create_design` cold-start consumption: BARRIER 1 checks `bd list -n 0 --status=closed | grep "Decide:"` and reads referenced thoughts docs; Step 4 formalizes the recorded decision on confirmation instead of generating options. With no record, behavior is byte-identical to 2.0.0 (verified against a pre-edit parity baseline).
- `create_research` and `create_product_research` completion summaries conditionally suggest `/wb:explore_design` — only when findings show multiple viable approaches.
- `validate_project` orphan detection exempts planning-prefix issues (`Q:`, `Decide:`, `Validate:`, `UI Q:`) — planning-phase records are intentionally not anchored in tasks.md frontmatter.
- Documentation sweep: the optional stage appears in every workflow rendering (help, CLAUDE.md, README, commands reference, workflow guide, generated project templates); help additionally documents `Decide:` lifecycle semantics (open = pending, closed = decided, rationale in close reason).

## [2.0.0] — Unreleased

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
