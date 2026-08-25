---
project: compaction-drift-hardening
ticket: prompts-8bj
created: 2026-08-21
status: not-started
last_updated: 2026-08-24
current_phase: 1
total_tasks: 15
completed_tasks: 0
depends_on: [research.md, design.md]
beads_epic: prompts-8bj
beads_phases:
  phase1_milestone: prompts-8bj.6
  phase2_milestone: prompts-8bj.7
  phase3_milestone: prompts-8bj.8
  phase4_milestone: prompts-8bj.9
beads_tasks:
  # Phase 1 tasks
  phase1_impl_1: prompts-bpp
  phase1_impl_2: prompts-eia
  phase1_test_1: prompts-5n2
  phase1_test_2: prompts-6du
  # Phase 2 tasks
  phase2_impl_1: prompts-5s0
  phase2_test_1: prompts-2x7
  # Phase 3 tasks
  phase3_impl_1: prompts-f8q
  phase3_impl_2: prompts-2xh
  phase3_impl_3: prompts-47m
  phase3_impl_4: prompts-5bn
  phase3_impl_5: prompts-6nq
  phase3_test_1: prompts-7nz
  # Phase 4 tasks
  phase4_impl_1: prompts-n6y
  phase4_impl_2: prompts-jgf
  phase4_test_1: prompts-b1c
git_commit: 504129c290186f17b15089aa294102145a467ce6
git_branch: worktree-compaction-drift-hardening
repository: gvarela/workbench
assignee: gabevarela
---

# Execution Plan: Compaction Drift Hardening

## Overview

Implementing the recover-and-reinforce design: a SessionStart(compact) recovery hook, a doc-adherence background skill, frontmatter single-writer consolidation, and handoff-over-compact guidance, released as v2.3.0.

**Design Approach**: recover-and-reinforce (design.md: Design Approach)
**Target State**: A compacted wb session is re-anchored deterministically, doc-content assertions require current-context reads, no progress field can silently rot without an owner and an alarm, and second-compact-means-handoff guidance exists at the decision points.

## Implementation Strategy

### Phase Rationale

Riskiest-first, release strictly last (explore-design-stage precedent, its tasks.md:57-64):

1. **Phase 1 — Recovery hook**: the only platform-dependent piece; its empirical gate (`prompts-6du`) can invalidate the delivery mechanism, so it lands first (prompts-dr7 precedent).
2. **Phase 2 — Doc-adherence skill**: independent of Phase 1 functionally, but its SKILL.md names the hook script per the status-sync→beads-drift-check.sh cross-reference convention, so the filename must exist; its blind-trial gate (`prompts-2x7`) is the likely long pole.
3. **Phase 3 — Guidance consolidation**: D3+D4 prose edits. `implement_coordinated/SKILL.md` receives edits from both workstreams and is owned by a single combined-edit task (dependency analysis: only cross-workstream file collision).
4. **Phase 4 — Docs sweep + release**: catch-all summary docs (help, CLAUDE.md/AGENTS.md, commands-reference, CHANGELOG) once behavior is settled, then the synchronized version bump as the final change (release protocol).

Based on dependency analysis:

- Workstreams D1-D4 have no functional edges; sequencing is by risk and by the two shared files (implement_coordinated in Phase 3; summary docs in Phase 4).
- Within Phase 3, the five edit tasks touch disjoint files and parallelize fully; the verification task follows all of them.

### Testing Strategy

No test framework exists (research.md; prompt-modernization design.md:69 precedent). Verification is: `bash -n` + direct invocation with `time` and fixture stdin for the hook script; `jq` validity + version-match checks for manifests; `./plugin/scripts/lint` for all markdown; coverage greps for guidance sweeps; blind trials (bd memory `wb-blind-trial-skill-eval-method`) for the skill's trigger wording; and a live `--plugin-dir` `/compact` marker test for end-to-end hook behavior. The repo's own tree (three non-complete plan dirs) is the live fixture for ambiguous plan detection.

## Progress Overview

Progress is tracked in beads. To check current status:

```bash
bd stats                    # Overall project statistics
bd list --status=closed     # See completed tasks
bd list --status=in_progress # See active work
bd ready                    # See available work
```

**Phase status**: run `bd show [milestone-id]` (IDs in frontmatter `beads_phases` after Step 5) to see which tasks block each phase milestone.

---

## Phase 1: Recovery Hook

### Objective

Ship `plugin/hooks/compact-recovery.sh` and its SessionStart(compact) manifest entry, empirically validated (closes prompts-8bj.2, resolves assumption prompts-6du).

### Prerequisites

- Research complete (research.md status: complete)
- Design ready (design.md status: ready)
- None external — no build tooling gates (dependency analysis)

### Changes Required

#### 1. Recovery hook script

**File**: `plugin/hooks/compact-recovery.sh` (new)

**Current State** (from research.md): no PreCompact entry, no compact handling; existing scripts are `setup-beads-mode.sh` (env var only) and `beads-drift-check.sh` (SessionEnd reminder, contract header at lines 1-4).

**Target State** (from design.md D1): on SessionStart with compact source, emit a plain-text block (<~500 chars) stating context was compacted, summary doc contents are paraphrase, and naming the active plan directory (or candidates) with the directive to re-read research.md/design.md/tasks.md fully and check `bd` state before asserting project/doc state.

**Implementation**:

- Header comment documenting the contract, mirroring `beads-drift-check.sh:1-4`: <100ms, no `bd` invocations, silent when nothing to recover, plain-text stdout (SessionStart is the model-visible-stdout event).
- Belt-and-braces source check: read stdin JSON; unless it indicates the compact source, `exit 0` silently (grep/case on the raw payload is acceptable — no `jq` dependency, keeps the budget).
- Plan detection, best-effort and cheap: for each `docs/plans/*/tasks.md` (bounded glob, no recursion), extract the frontmatter `status:` value with `sed`/`awk` head-limited reads; collect dirs whose status is not `complete`; order by file mtime (`ls -t`). Zero matches or no `docs/plans/` → `exit 0` silently. One match → name it. Multiple → list candidates (newest first).
- Early silent exits first (`[ -d docs/plans ] || exit 0` etc.), per `beads-drift-check.sh:6-14` idiom.
- All paths `exit 0`.

**Rationale**: design.md D1 + Data Model (no new registry; convention-derived detection).
**Pattern Reference**: `plugin/hooks/beads-drift-check.sh:1-17`.

#### 2. Manifest registration

**File**: `plugin/.claude-plugin/plugin.json:17-27`

**Current State**: `SessionStart` array has one unmatched entry (setup-beads-mode.sh).

**Target State**: two entries — existing unmatched entry unchanged, plus:

```json
{
  "matcher": "compact",
  "hooks": [
    {
      "type": "command",
      "command": "${CLAUDE_PLUGIN_ROOT}/hooks/compact-recovery.sh",
      "timeout": 5
    }
  ]
}
```

**Rationale**: additive multi-entry matcher shape already demonstrated by PostToolUse (`plugin.json:29-47`).
**Pattern Reference**: `plugin/.claude-plugin/plugin.json:29-47`.

### Tasks

**Note**: Task status is tracked ONLY in beads. The tasks below document WHAT needs to be done (the PLAN). For task STATUS, run `bd list` or check frontmatter `beads_tasks` for IDs.

#### Implementation Tasks

- Create `plugin/hooks/compact-recovery.sh` per Changes Required #1; `chmod +x` → `[beads:phase1_impl_1]`
- Add the SessionStart `matcher: "compact"` entry to `plugin/.claude-plugin/plugin.json` per Changes Required #2 → `[beads:phase1_impl_2]`

#### Testing Tasks

- Script-level verification of the hook → `[beads:phase1_test_1]`
  - `bash -n plugin/hooks/compact-recovery.sh` (syntax)
  - `jq . plugin/.claude-plugin/plugin.json` valid; `jq '.hooks.SessionStart | length'` = 2
  - `time (echo '{"hook_event_name":"SessionStart","session_start_reason":"compact"}' | plugin/hooks/compact-recovery.sh)` < 100ms, from the repo root
  - Live-tree ambiguous case: run from repo root — current tree has ≥2 non-complete plan dirs; output must list candidates, newest first
  - Single-active fixture: temp dir with one non-complete `docs/plans/*/tasks.md` → output names exactly that directory
  - Silent paths: temp dir with no `docs/plans/`; temp dir with only `status: complete` plans; non-compact stdin (`"session_start_reason":"startup"`); empty/malformed stdin — all four produce no stdout, exit 0
  - Output budget: `... | wc -c` ≤ ~500 on the single-active fixture
- Empirical compact-boundary validation (GATE — this is `prompts-6du`) → `[beads:phase1_test_2]`
  - Marker-test protocol per prompts-dr7 precedent (prompt-modernization tasks.md:300-302): in a `claude --plugin-dir $(pwd)/plugin` session inside a repo with one active plan, run `/compact`, confirm the recovery block appears in model-visible context afterward (ask the model what instructions it sees)
  - Record findings on the issue; if the matcher never fires or stdout is invisible, STOP phase — fallback per design risk row 1 is the unmatched-entry-with-in-script-source-check variant; re-verify before proceeding

### Success Criteria

#### Automated Verification

- [ ] `bash -n plugin/hooks/compact-recovery.sh` exits 0
- [ ] `jq . plugin/.claude-plugin/plugin.json` clean; SessionStart array length 2
- [ ] Timing under 100ms; all silent-path fixtures produce empty stdout, exit 0
- [ ] `./plugin/scripts/lint` clean on any touched markdown

#### Manual Verification

- [ ] Live `/compact` marker test passed and recorded on prompts-6du (design.md Functional Requirements 1-2)
- [ ] Recovery block text reads as a directive, names the directory, ≤ ~500 chars

### Modified Files

#### Code Files

- `plugin/hooks/compact-recovery.sh` - new recovery hook script
- `plugin/.claude-plugin/plugin.json` - second SessionStart entry

**Quick test command for this phase**:

```bash
bash -n plugin/hooks/compact-recovery.sh && jq -e '.hooks.SessionStart | length == 2' plugin/.claude-plugin/plugin.json && time (echo '{"session_start_reason":"compact"}' | plugin/hooks/compact-recovery.sh)
```

### ⛔ CHECKPOINT: Phase 1 Complete

Before proceeding to Phase 2:

1. ✅ All Phase 1 task beads issues closed (`bd list --status=closed`)
2. ✅ Phase 1 milestone beads issue closed; close prompts-8bj.2 with findings
3. ✅ All automated verification passing
4. ✅ Manual verification confirmed by human (prompts-6du findings recorded)
5. ✅ Reconcile plan-doc status via `/wb:update_status` (sole-writer path this project introduces)

**Do not proceed without human confirmation of manual tests.**

---

## Phase 2: Doc-Adherence Skill

### Objective

Ship the `doc-adherence` background skill with blind-trial-validated trigger wording (closes prompts-8bj.3, resolves assumption prompts-2x7).

### Prerequisites

- Phase 1 complete (hook filename final — the skill references it by path)

### Changes Required

#### 1. Skill file

**File**: `plugin/skills/doc-adherence/SKILL.md` (new)

**Current State** (from research.md): no skill covers resuming after compaction or citing plan docs from a current-context read; nearest patterns are the fresh-verification rule (`verification-before-completion/SKILL.md:19,52`) and "never paraphrase from memory" (`implement_coordinated/SKILL.md:17` et al.).

**Target State** (from design.md D2): background skill enforcing — claims about what a plan document (research.md/design.md/tasks.md/thoughts docs) says must come from a read of that file present in the current context window; after compaction, prior reads do not count; re-read before asserting; check `bd` state rather than summary for project state.

**Implementation**:

- Frontmatter: `name: doc-adherence`; `description: Use when about to state what a plan document says (per the design, the plan calls for, research shows, as documented) or when resuming work after context compaction - requires the claim to come from a read of that file in the current context window, not from a summary or memory.`; `user-invocable: false`; `allowed-tools: Read, Glob, Grep, Bash(bd:*)`.
- Body per background-skill skeleton (pattern agent findings): principle paragraph; Iron Law code block: `NO ASSERTIONS ABOUT PLAN DOC CONTENTS WITHOUT A READ IN THE CURRENT CONTEXT WINDOW`; "Why summaries lie" section (compaction paraphrase ≠ file); "The Gate" numbered steps (identify the doc → is its full read in current context? → if not, Read it now → then assert, citing file:line); "Common Rationalizations" table ("I read it before the compaction" / "the summary captured it" / "it's a small detail"); "## Red Flags - STOP" bullets ("per the design" without a read this window; describing tasks.md progress from memory; proposing work already recorded as done — check `bd list` first); "When NOT to apply" (docs read fully earlier in the SAME uncompacted window; non-plan files); cross-reference line naming `hooks/compact-recovery.sh` as the deterministic boundary signal, per the status-sync→beads-drift-check.sh convention (`status-sync/SKILL.md:10-11`).
- Length target 60-120 lines.

**Rationale**: design.md D2; extends the shipped fresh-verification pattern.
**Pattern Reference**: `plugin/skills/verification-before-completion/SKILL.md:13-19,35-41,54-62`.

### Tasks

#### Implementation Tasks

- Author `plugin/skills/doc-adherence/SKILL.md` per Changes Required #1 → `[beads:phase2_impl_1]`

#### Testing Tasks

- Blind-trial validation red-to-green (GATE — this is `prompts-2x7`) → `[beads:phase2_test_1]`
  - Method per bd memory `wb-blind-trial-skill-eval-method`: fresh-context sonnet subagents given ONLY the verbatim instruction block + a synthesized fixture (never the expected answer); 3 fixtures × 3 trials
  - Fixtures: clear-positive (mid-conversation "what does the design say about X?" with no read in window → must re-read); clear-negative (doc fully read earlier in the same window → may answer directly, no redundant re-read); trap for the suspected failure mode (a compaction summary in context confidently describes design.md; the model is asked to proceed "per the design" → must re-read, not trust the summary)
  - Ship gate: trap 3/3, regression (negative) 2/2 (design.md Functional Requirement 3); on any red, reword and re-run; record red-to-green evidence on the issue

### Success Criteria

#### Automated Verification

- [ ] `./plugin/scripts/lint plugin/skills/doc-adherence/SKILL.md` clean
- [ ] Frontmatter has `user-invocable: false` and no `disable-model-invocation` (background, model-invoked)

#### Manual Verification

- [ ] Blind-trial results recorded red-to-green on prompts-2x7 (trap 3/3, regression 2/2)
- [ ] Read-through against the fitness-agent incidents (research.md: Observed Failure Evidence): each of the four drift incidents would have tripped a Red Flag

### Modified Files

#### Code Files

- `plugin/skills/doc-adherence/SKILL.md` - new background skill

**Quick test command for this phase**:

```bash
./plugin/scripts/lint plugin/skills/doc-adherence/SKILL.md && wc -l plugin/skills/doc-adherence/SKILL.md
```

### ⛔ CHECKPOINT: Phase 2 Complete

1. ✅ All Phase 2 task beads issues closed
2. ✅ Phase 2 milestone closed; close prompts-8bj.3 with blind-trial evidence
3. ✅ Automated verification passing
4. ✅ Manual verification confirmed by human
5. ✅ Reconcile plan-doc status via `/wb:update_status`

**Do not proceed without human confirmation of manual tests.**

---

## Phase 3: Guidance Consolidation

### Objective

Land the D3 single-writer consolidation and D4 handoff-over-compact rule in the workflow skills (advances prompts-8bj.4 and prompts-8bj.5; both close in Phase 4 when summary docs match).

### Prerequisites

- Phase 2 complete (stable rule wording to reference where needed)

### Changes Required

#### 1. implement_coordinated (combined D3+D4 edit — single owner for the file)

**File**: `plugin/skills/implement_coordinated/SKILL.md`

**Current State**: `:15` "Recommended for … sessions where context compaction would be disruptive"; Step 9 `:359-366` "Optionally update tasks.md frontmatter (for human reference)" with inline `current_phase: ${phase + 1}`; Resume Logic `:380-407` reads docs + "Check current_phase in frontmatter" (`:396`).

**Target State**: Step 9 defers progress-field writes to `/wb:update_status` (no inline optional edit); Recommended-for line gains the rule "if a phase needs a second `/compact`, stop and `/wb:create_handoff` instead — `resume_handoff` forces a fresh doc read"; Resume Logic opens with the same rule plus "after any compaction, doc contents in context are paraphrase — re-read before asserting" (mirrors the hook text).

#### 2. implement_tasks

**File**: `plugin/skills/implement_tasks/SKILL.md:361-379`

**Target State**: same Step 7 deferral — replace the optional inline frontmatter edit with "run `/wb:update_status` at the checkpoint (sole writer of progress fields)"; keep `:271`'s prohibition, updating its parenthetical to name update_status.

#### 3. Generated-template checkpoint instruction

**Files**: `plugin/skills/create_tasks/templates.md:175` (also the equivalent line in this project's own Phase checkpoints), `plugin/skills/create_project/templates.md:234-239` (stub note only)

**Target State**: `templates.md:175` "✅ Update frontmatter: `current_phase: 2`" becomes "✅ Reconcile plan-doc status via `/wb:update_status`"; create_project stub gains a one-line comment in the tasks.md template frontmatter that progress fields are maintained by `/wb:update_status`.

#### 4. update_status + status-sync

**Files**: `plugin/skills/update_status/SKILL.md` (near `:113`), `plugin/skills/status-sync/SKILL.md` (Drift Indicators section, `:23-30` region)

**Target State**: update_status states it is the SOLE writer of `status`/`current_phase`/`completed_tasks`/`total_tasks` in plan docs (other skills point here). status-sync gains a "Frontmatter drift" indicator: at phase end/session end, compare tasks.md frontmatter counts against `bd stats`/closed counts; on mismatch, remind to run `/wb:update_status` (reminder only — its DO-NOT list `:58` still forbids direct file updates).

#### 5. create_handoff

**File**: `plugin/skills/create_handoff/SKILL.md:227-235`

**Target State**: "When to Create Handoffs" gains: "The session has already needed `/compact` once this phase and is heading for another — hand off instead; a second compaction compounds summary drift."

### Tasks

#### Implementation Tasks

- Combined D3+D4 edit of `plugin/skills/implement_coordinated/SKILL.md` per Changes Required #1 → `[beads:phase3_impl_1]`
- Step 7 deferral edit of `plugin/skills/implement_tasks/SKILL.md` per Changes Required #2 → `[beads:phase3_impl_2]`
- Template checkpoint edits (`create_tasks/templates.md:175`, `create_project/templates.md` stub note) per Changes Required #3 → `[beads:phase3_impl_3]`
- Sole-writer statement + drift indicator (`update_status/SKILL.md`, `status-sync/SKILL.md`) per Changes Required #4 → `[beads:phase3_impl_4]`
- Handoff-trigger addition (`create_handoff/SKILL.md`) per Changes Required #5 → `[beads:phase3_impl_5]`

#### Testing Tasks

- Sweep verification → `[beads:phase3_test_1]`
  - `./plugin/scripts/lint` on all six touched files, clean
  - Coverage grep — no remaining direct-edit instructions: `grep -rn "Optionally update tasks.md frontmatter" plugin/skills/` returns nothing; `grep -rn "Update frontmatter: .current_phase" plugin/skills/` returns nothing
  - Positive greps: `grep -rln "update_status" plugin/skills/implement_tasks plugin/skills/implement_coordinated plugin/skills/create_tasks` shows all three; `grep -n "compact" plugin/skills/create_handoff/SKILL.md plugin/skills/implement_coordinated/SKILL.md` shows the new rule in both

### Success Criteria

#### Automated Verification

- [ ] Lint clean on all six files
- [ ] Both negative greps empty; both positive greps hit (design.md Functional Requirements 4-6, minus the help/docs surfaces which land in Phase 4)

#### Manual Verification

- [ ] Read-through: Step 9/Step 7 prose still reads coherently after deferral (no dangling references to removed YAML examples)
- [ ] status-sync drift indicator triggers on a deliberately stale frontmatter fixture (set `completed_tasks` low in a scratch plan dir, confirm the skill's check logic as written would flag it) and stays silent when counts match

### Modified Files

#### Code Files

- `plugin/skills/implement_coordinated/SKILL.md` - D3 deferral + D4 rule (single combined edit)
- `plugin/skills/implement_tasks/SKILL.md` - D3 deferral
- `plugin/skills/create_tasks/templates.md` - checkpoint reconciliation pointer
- `plugin/skills/create_project/templates.md` - stub ownership note
- `plugin/skills/update_status/SKILL.md` - sole-writer statement
- `plugin/skills/status-sync/SKILL.md` - frontmatter drift indicator
- `plugin/skills/create_handoff/SKILL.md` - second-compact handoff trigger

**Quick test command for this phase**:

```bash
./plugin/scripts/lint plugin/skills/implement_coordinated/SKILL.md plugin/skills/implement_tasks/SKILL.md plugin/skills/create_tasks/templates.md plugin/skills/create_project/templates.md plugin/skills/update_status/SKILL.md plugin/skills/status-sync/SKILL.md plugin/skills/create_handoff/SKILL.md && ! grep -rn "Optionally update tasks.md frontmatter" plugin/skills/
```

### ⛔ CHECKPOINT: Phase 3 Complete

1. ✅ All Phase 3 task beads issues closed
2. ✅ Phase 3 milestone closed
3. ✅ Automated verification passing
4. ✅ Manual verification confirmed by human
5. ✅ Reconcile plan-doc status via `/wb:update_status`

**Do not proceed without human confirmation of manual tests.**

---

## Phase 4: Docs Sweep + Release

### Objective

Bring the summary surfaces in line with shipped behavior and release v2.3.0 (closes prompts-8bj.4, prompts-8bj.5, and epic prompts-8bj).

### Prerequisites

- Phases 1-3 complete (summary docs describe finished behavior only)

### Changes Required

#### 1. Summary docs sweep

**Files**: `plugin/skills/help/SKILL.md` (handoff entries `:203-209` + Core Principles `:211` region), repo `CLAUDE.md` (Frontmatter Standards `:149-156`, Command Structure/Philosophy sections), `AGENTS.md` (mirror substantive additions per the independent-files note), `docs/commands-reference.md` (`:649-684` frontmatter examples + command entries)

**Target State**: help documents the recovery hook, the doc-adherence skill, and the second-compact-handoff rule alongside create_handoff/resume_handoff; CLAUDE.md Frontmatter Standards notes progress fields are written only by `/wb:update_status`; commands-reference frontmatter examples updated to match; AGENTS.md mirrors the CLAUDE.md additions.

#### 2. Release

**Files**: `plugin/.claude-plugin/plugin.json:4`, `.claude-plugin/marketplace.json:12`, `CHANGELOG.md`

**Target State**: both versions `2.3.0` in the same commit; CHANGELOG entry summarizing the four workstreams and the two validated assumptions; follow RELEASING.md.

### Tasks

#### Implementation Tasks

- Summary docs sweep per Changes Required #1 → `[beads:phase4_impl_1]`
- Release: CHANGELOG entry + synchronized version bump per Changes Required #2 (LAST content change) → `[beads:phase4_impl_2]`

#### Testing Tasks

- Full release verification → `[beads:phase4_test_1]`
  - `./plugin/scripts/lint --all` clean
  - `jq -e '.version == "2.3.0"' plugin/.claude-plugin/plugin.json` and `jq -e '.plugins[0].version == "2.3.0"' .claude-plugin/marketplace.json` (adjust path to marketplace schema) both pass; versions match
  - Coverage grep: `grep -rln "compact-recovery\|doc-adherence" plugin/skills/help/SKILL.md CLAUDE.md AGENTS.md docs/commands-reference.md CHANGELOG.md` hits all five
  - Re-run Phase 1 quick test (hook still intact post-edits)

### Success Criteria

#### Automated Verification

- [ ] `./plugin/scripts/lint --all` clean
- [ ] Version match 2.3.0 across both manifests; JSON valid
- [ ] Coverage grep hits all five summary files

#### Manual Verification

- [ ] `claude --plugin-dir $(pwd)/plugin` smoke run: skills resolve (`/wb:help` lists new behavior), hook fires on `/compact`
- [ ] CHANGELOG entry accurately reflects shipped scope (no over-claim on the two assumptions — link recorded evidence)

### Modified Files

#### Code Files

- `plugin/skills/help/SKILL.md` - new behavior documented
- `CLAUDE.md`, `AGENTS.md` - standards + ownership notes (mirrored)
- `docs/commands-reference.md` - frontmatter examples + command entries
- `CHANGELOG.md` - v2.3.0 entry
- `plugin/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` - synchronized bump

**Quick test command for this phase**:

```bash
./plugin/scripts/lint --all && jq -r '.version' plugin/.claude-plugin/plugin.json && grep -o '"version": "[^"]*"' .claude-plugin/marketplace.json
```

### ⛔ CHECKPOINT: Phase 4 Complete

1. ✅ All Phase 4 task beads issues closed
2. ✅ Phase 4 milestone closed; close prompts-8bj.4, prompts-8bj.5, epic prompts-8bj
3. ✅ Automated verification passing
4. ✅ Manual verification confirmed by human
5. ✅ Reconcile plan-doc status via `/wb:update_status` (project → complete)

---

## Implementation Discoveries

Things to determine during implementation:

- Exact marketplace.json version JSON path for the jq assertion (schema has plugins array vs top-level — check the file)
- Whether the SessionStart hook input field name matches the docs (`session_start_reason` vs `source`) in the installed Claude Code — resolve during phase1_test_2 and encode whichever the live payload uses (accept both if cheap)
- Whether `claude --plugin-dir` headless (`-p`) can drive the `/compact` marker test or the gate needs an interactive session (flag with `bd human` if so)

Note: Update this section with findings as you implement.

---

## 📝 Completed Tasks Archive

### Planning (from project setup)

- [x] Create project structure - 2026-08-22 00:47
- [x] Complete research (`/wb:create_research`) - 2026-08-24
- [x] Explore design - skipped: single clear approach, mechanisms settled by verified platform constraints
- [x] Create design (`/wb:create_design`) - 2026-08-24
- [x] Generate execution plan (`/wb:create_tasks`) - 2026-08-24

---

## 🚧 Blockers & Notes

### Current Blockers

Blockers are tracked in beads. To see current blockers:

```bash
bd blocked    # Show all blocked issues and what blocks them
```

### Implementation Notes

- prompts-wcn and prompts-nar were closed pre-planning: already fixed on main by 504129c (v2.2.1)
- prompts-8bj.1 (PreCompact) closed as infeasible; intent absorbed by Phase 1 (see design.md Rejected Alternatives)

---

## Beads Issue Tracking

This project uses beads for ALL task tracking across sessions.

**Epic**: prompts-8bj

**Phase Milestones**:

- Phase 1: prompts-8bj.6 (all Phase 1 tasks must complete)
- Phase 2: prompts-8bj.7 (all Phase 2 tasks must complete)
- Phase 3: prompts-8bj.8 (all Phase 3 tasks must complete)
- Phase 4: prompts-8bj.9 (all Phase 4 tasks must complete)

**Feature issues closing at checkpoints**: prompts-8bj.2 (Phase 1), prompts-8bj.3 (Phase 2), prompts-8bj.4 and prompts-8bj.5 (Phase 4).

**Granular Tasks**: See frontmatter `beads_tasks` section for all task IDs. Gate tasks reuse the design's assumption issues: prompts-6du (Phase 1 empirical hook validation), prompts-2x7 (Phase 2 blind trials).

**Essential Commands**:

- `bd ready` - See what's ready to work on (no blockers)
- `bd show [id]` - View task details and dependencies
- `bd update [id] --claim` - Claim a task
- `bd close [id]` - Complete a task
- `bd blocked` - See what's currently blocked
- `bd list --status=in_progress` - See your active work

**Status Source**: Beads is the source of truth for all task status. Do NOT use markdown checkboxes for tracking.

---

## 🔗 Quick Reference

### Key Files

- **Research**: [research.md](research.md) - Current state documentation
- **Design**: [design.md](design.md) - Target state specification
- **Main Entry**: `plugin/hooks/compact-recovery.sh` (Phase 1), `plugin/skills/doc-adherence/SKILL.md` (Phase 2)
- **Config**: `plugin/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`

### Common Commands

```bash
# Lint changed markdown
./plugin/scripts/lint

# Lint everything
./plugin/scripts/lint --all

# Hook quick test
bash -n plugin/hooks/compact-recovery.sh && time (echo '{"session_start_reason":"compact"}' | plugin/hooks/compact-recovery.sh)

# Manifest validity + versions
jq . plugin/.claude-plugin/plugin.json >/dev/null && jq . .claude-plugin/marketplace.json >/dev/null
```

### Design Decisions Reference

- D1: SessionStart(compact) hook, not PreCompact — PreCompact cannot reach the model
- D2: cite-or-re-read background skill, blind-trial gated
- D3: keep progress fields; update_status sole writer; status-sync drift alarm (drop = documented escalation)
- D4: second `/compact` in a phase → create_handoff instead
