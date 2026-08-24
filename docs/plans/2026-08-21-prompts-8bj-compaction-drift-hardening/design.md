---
project: compaction-drift-hardening
ticket: prompts-8bj
created: 2026-08-21
status: ready
last_updated: 2026-08-24
depends_on: research.md
design_approach: recover-and-reinforce
---

# Design: Compaction Drift Hardening

## Problem Statement

A compaction boundary silently invalidates the two things wb workflows depend on: the skill instructions loaded at invocation time (every ⛔ BARRIER and read-FULLY directive) and the session's grounding in the plan documents. After compaction the session holds a paraphrase of research.md/design.md/tasks.md but nothing marks it as a paraphrase, so the session asserts doc and project state from its own summary. The fitness-agent session (dfc788d7) demonstrated the full failure: stale-state proposals corrected only by user pushback, a barrier skip that left design.md unread for 16 days, and tasks.md frontmatter 12 tasks stale. The plugin currently has zero machinery on either side of the boundary (research.md: Hook Infrastructure).

### Success Metrics

- A session compacted mid-wb-workflow receives, in its first post-compaction context, an instruction to re-read the active plan docs and treat summarized doc contents as unverified.
- The plugin carries an always-on rule that assertions about plan-doc contents require a read in the current context window, validated to trigger reliably by blind trials.
- No frontmatter field in generated plan docs can silently diverge from beads without a designated reconciliation path and an activation moment that invokes it.
- Guidance exists at the moments the fitness-agent session went wrong: choosing `/compact` again mid-phase instead of a handoff.

## Design Approach

**Recover-and-reinforce**: a deterministic recovery injection at the compaction boundary (hook), plus an always-on adherence discipline between boundaries (background skill), plus removal of the conditions that made drift invisible (single-writer frontmatter reconciliation and handoff-over-compact guidance). No attempt to shape the compaction summary itself — that channel does not exist on the platform.

### Why This Approach

- Hooks are the only mechanism that survives compaction deterministically; skill text does not (research.md: fitness-agent evidence). The skills guide's own decision table assigns deterministic event-driven behavior to hooks and judgment-bearing discipline to `user-invocable: false` skills (docs/claude-code-skills-guide.md:287-302) — this design uses one of each, matching the status-sync / beads-drift-check.sh division of labor already shipped.
- SessionStart is the one hook event whose plain-text stdout is added to model-visible context, and it supports a `compact` matcher (research.md: Platform Hook Semantics, verified 2026-08-24). PreCompact cannot inject anything into the summary, which is why prompts-8bj.1 was closed as infeasible and folded into this design.
- The `bd prime` pattern ("run after compaction, clear, or new session") is the in-repo precedent proving hook-driven context recovery works; wb lacks only its own equivalent.
- The dominant observed failure was asserting doc contents from summary, which is the same shape as the already-shipped fresh-verification rule ("if you haven't run the verification command in this response, you cannot claim it passes") — the new skill extends a proven pattern rather than inventing one.

## Technical Decisions

### Architecture

- **D1 — Post-compaction recovery hook**: a second `SessionStart` entry in the plugin manifest with matcher `compact`, running a new `plugin/hooks/` script.
  - Rationale: additive to the existing unmatched SessionStart entry; PostToolUse already demonstrates the multi-entry matcher shape, so no schema conflict (research follow-up: integration analysis).
  - The script emits a short plain-text block (model-visible) stating that context was just compacted, that doc contents in the summary are paraphrase, and that the active plan docs must be re-read fully and beads state checked before asserting project or doc state.
  - Belt-and-braces: the script also inspects the hook input JSON for the compact source and exits silently otherwise, so behavior stays correct even if matcher filtering differs across Claude Code versions. Tracked as assumption `prompts-6du`.
  - Trade-off: SessionStart cannot block, so recovery is advisory context, not a hard gate — accepted; the skill (D2) covers the judgment side.
  - Pattern reference: `plugin/hooks/beads-drift-check.sh:1-17` contract (early silent exits, <100ms, no `bd` invocations, output only when there is something to say).

- **D2 — Doc-adherence background skill**: a new `user-invocable: false` skill whose rule is: claims about what research.md/design.md/tasks.md (or any plan doc) say must come from a read of that file present in the current context window; otherwise re-read first.
  - Rationale: covers the between-boundaries gap hooks cannot (drift incidents occurred mid-session, not only at the boundary), and covers compactions the hook might miss.
  - Structure follows the established background-skill skeleton: "Use when …" trigger description, Iron Law code block, operational sections, Red Flags (research.md: Auto-Activated Skill Conventions).
  - Trigger wording is validated by blind trials before ship (assumption `prompts-2x7`; method: bd memory `wb-blind-trial-skill-eval-method`).
  - Trade-off: skill activation depends on model attention — accepted as the second layer, not the only layer.

- **D3 — Frontmatter progress fields: keep, consolidate to a single reconciliation path** (`update_status`), rather than dropping `current_phase`/`total_tasks`/`completed_tasks`.
  - WHAT: `update_status` becomes the sole sanctioned writer of the progress fields; the "optionally update frontmatter" instructions in the implementation skills and the inline `current_phase: 2` bump baked into generated tasks.md defer to it; `status-sync` gains a frontmatter-vs-beads drift indicator at its existing activation moments (phase end, session end) so staleness is surfaced instead of trusted.
  - Rationale: the observed harm was *trusting* stale values, and the fields rotted because phase checkpoints made updating them optional with no owner. Consolidation has roughly half the blast radius of dropping the fields (~6 sites vs ~12+, per the integration analysis), keeps `validate_project/reference.md:27` intact, and preserves the at-a-glance human reference the docs were designed for.
  - Trade-off: the duplication remains by design ("beads for STATUS" purists would drop the fields) — accepted because a designated writer plus a drift alarm addresses the failure mode with far less churn.

- **D4 — Handoff-over-compact guidance**: the compaction threshold rule "if a phase needs a second `/compact`, create a handoff and resume fresh instead" is added where the decision actually gets made: `implement_coordinated`'s recommendation/resume text, `create_handoff`'s "When to Create Handoffs" list, and the help skill's handoff entries.
  - Rationale: `resume_handoff` already forces a full doc re-read on resume (research.md: Handoff Machinery); no skill text today ever chooses between handoff, same-session continuation, and `/compact` — the fitness-agent session compacted six times because nothing said otherwise.

### Data Model

- Recovery-hook plan detection: the active plan directory is derived best-effort from the existing convention only — `docs/plans/<YYYY-MM-DD>-<project>/tasks.md` frontmatter whose `status` is not `complete`, most recently modified first. No new registry, frontmatter field, or env var is introduced; when detection is ambiguous the hook names the candidates, and when it finds nothing it stays generic. Rationale: research confirmed no discovery mechanism exists to reuse, and inventing durable state for it would create a second thing that can go stale.
- No changes to the beads data model or to plan-doc frontmatter schemas (D3 changes ownership and prose, not fields).

### Integration Points

- `plugin/.claude-plugin/plugin.json` hooks block: one added SessionStart entry (matcher `compact`); existing entries untouched. `setup-beads-mode.sh` continues to run unmatched on all sources, including compact — no ordering dependency between the two scripts (neither reads the other's output).
- New skill directory under `plugin/skills/` — no registry wiring exists or is needed beyond the directory itself.
- Guidance edits touch: `implement_coordinated/SKILL.md`, `implement_tasks/SKILL.md`, `create_tasks/templates.md`, `create_project/templates.md` (stub note only if needed), `update_status/SKILL.md` (sole-writer statement), `status-sync/SKILL.md` (drift indicator), `create_handoff/SKILL.md`, `help/SKILL.md`, repo `CLAUDE.md` (+ mirror to `AGENTS.md` per the independent-files note), `docs/commands-reference.md`.
- Release: version 2.2.1 → 2.3.0 in BOTH `plugin/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`, same commit (release protocol; explore-design-stage precedent).

## Scope Definition

### In Scope

- The compact-matched SessionStart recovery hook script and its manifest registration (prompts-8bj.2, absorbing prompts-8bj.1's intent).
- The doc-adherence background skill, including blind-trial validation of its trigger wording (prompts-8bj.3).
- Progress-field ownership consolidation and the status-sync drift indicator (prompts-8bj.4, resolved as consolidate-not-drop).
- Handoff-over-compact guidance in the four surfaces listed above (prompts-8bj.5).
- CLAUDE.md/AGENTS.md and commands-reference updates reflecting the above; version bump to 2.3.0.

### Out of Scope

- Any PreCompact hook (platform cannot deliver the intent; prompts-8bj.1 closed).
- Dropping the progress frontmatter fields (rejected alternative below).
- A persistent active-plan registry (env var, state file, or new frontmatter field).
- Changes to the beads plugin, `bd prime`, or the repo-level beads hooks.
- Retrofitting existing plan directories under `docs/plans/` to new guidance.
- Worker/subagent-side recovery (subagents are ephemeral; the ceiling work in v2.2.1 already covers their failure modes).

## Success Criteria

### Functional Requirements

- [ ] After a `/compact` (manual or auto) in a repo containing an active plan directory, the next model context contains the recovery block naming that directory (or candidates when ambiguous).
- [ ] In repos with no `docs/plans/` or no active plan, the hook is silent and adds nothing.
- [ ] The doc-adherence skill ships with blind-trial results recorded red-to-green (trap fixture 3/3, regression 2/2) per `prompts-2x7`.
- [ ] `update_status` is documented as the sole writer of progress fields; no skill instructs a direct optional frontmatter edit of them.
- [ ] `status-sync` surfaces a frontmatter-vs-beads mismatch at phase end/session end when one exists.
- [ ] The second-compact-means-handoff rule appears in implement_coordinated, create_handoff, and help.

### Non-Functional Requirements

- [ ] Performance: recovery hook completes in <100ms, no `bd` invocations, silent-exit paths cost near zero (beads-drift-check.sh contract).
- [ ] Reliability: hook degrades gracefully — wrong/old Claude Code matcher semantics produce silence, never noise in non-compact sessions (in-script source check).
- [ ] Output budget: recovery block stays under ~500 characters so it survives in context and reads as a directive, not a document.

## Risk Analysis

### Technical Risks

| Risk | Impact | Likelihood | Mitigation |
| ------ | -------- | ------------ | ------------ |
| SessionStart `compact` matcher or stdout visibility differs from docs in the installed Claude Code version | High | Low | In-script source check + empirical validation task `prompts-6du` before release (prompts-dr7 precedent) |
| Doc-adherence skill under- or over-triggers | Med | Med | Blind-trial validation `prompts-2x7`; reword and re-run red-to-green before ship |
| Multiple plans in-flight make detection ambiguous | Low | Med | Hook lists candidate directories instead of guessing one |
| Consolidated ownership still rots if update_status is never run | Med | Med | status-sync drift indicator fires at its existing phase-end/session-end activation moments |
| Recovery block trains habituation (ignored boilerplate) | Med | Low | Keep it short, specific (names the directory), and absent when there is nothing to recover |

### Assumptions

Based on knowledge gaps from research - track in beads to ensure validation:

| Assumption | Beads ID | Validated? |
|------------|----------|------------|
| SessionStart(compact) fires post-compaction and its plain-text stdout reaches model context | `prompts-6du` | Pending |
| Doc-adherence trigger wording discriminates reliably | `prompts-2x7` | Pending |

## Rejected Alternatives

### Option: PreCompact summary-shaping hook

- **Approach**: Inject preservation instructions (active plan path, "doc contents are paraphrase") into the compaction summarizer via a PreCompact hook.
- **Rejected because**: Verified platform behavior — PreCompact stdout is not surfaced to the model and no instruction-injection field is honored; only permission decision/systemMessage/continue are read. The channel does not exist.
- **Trade-offs**: Would have been the cleanest fix (correct summary beats corrected summary); nothing is lost that was achievable.

### Option: Drop the progress frontmatter fields entirely

- **Approach**: Remove `current_phase`/`total_tasks`/`completed_tasks` from templates, validator, update blocks, and standards docs — pure "Beads for STATUS".
- **Rejected because**: Twice the change surface (~12+ sites including `validate_project/reference.md:27`'s required-fields spec), destroys the at-a-glance human reference in generated docs, and the observed harm is fully addressed by single-writer + drift alarm + cite-or-re-read.
- **Trade-offs**: Keeps a by-design duplication that must stay policed; if drift recurs despite D3, dropping the fields is the documented escalation.

### Option: Auto-sync frontmatter via a PostToolUse or SessionEnd hook

- **Approach**: A hook recomputes progress fields from beads and rewrites tasks.md automatically.
- **Rejected because**: Violates the established hook budget contract (`bd` invocations are explicitly excluded per beads-drift-check.sh), makes a hook a silent writer of tracked files, and hides the reconciliation the user is meant to confirm (update_status's BARRIER 2 exists deliberately).
- **Trade-offs**: Gives up zero-effort freshness for auditability and hook cheapness.

### Option: Skill-only enforcement (no hook)

- **Approach**: Rely on the doc-adherence skill alone to catch post-compaction drift.
- **Rejected because**: Skill activation depends on model attention, which is precisely what compaction degrades — the fitness-agent evidence shows barrier discipline eroding non-monotonically after boundaries. Deterministic injection must come from the harness side.
- **Trade-offs**: None — the skill is still shipped as the second layer.

## Pending Decisions

Design decisions that need stakeholder input - track in beads:

| Decision Needed | Beads ID | Blocks |
|-----------------|----------|--------|
| None — both open questions are tracked as validation assumptions above | — | — |

Note: Decisions blocking execution should be resolved before `/create_tasks`. The two assumptions gate release, not planning.

## References

- Research: [research.md](research.md)
- Related designs: docs/plans/2026-06-09-prompt-modernization/design.md (hook contract + prompts-dr7 visibility-validation precedent), docs/plans/2026-07-10-explore-design-stage/design.md (release/version-sync precedent)
- External docs: Claude Code hooks reference (code.claude.com/docs/en/hooks.md, verified 2026-08-24)
