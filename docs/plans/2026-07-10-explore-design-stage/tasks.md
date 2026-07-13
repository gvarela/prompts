---
project: explore-design-stage
ticket: null
created: 2026-07-10
created_timestamp: 2026-07-10T22:13:38Z
status: not-started
last_updated: 2026-07-10
assignee: gabevarela
current_phase: 1
total_tasks: 16
completed_tasks: 0
git_commit: 0c1250840dbce9ab373a6d718a2600e4489539f9
git_branch: modernize-2.0
repository: gvarela/workbench
tags: [tasks, tracking, explore-design-stage]
depends_on: [research.md, design.md]
beads_epic: prompts-247
beads_phases:
  phase1_milestone: prompts-kk5
  phase2_milestone: prompts-zxe
  phase3_milestone: prompts-2k4
  phase4_milestone: prompts-ebp
beads_tasks:
  # Phase 1 tasks
  phase1_setup_1: prompts-9zw
  phase1_impl_1: prompts-390
  phase1_impl_2: prompts-349
  phase1_test_1: prompts-6ju
  # Phase 2 tasks
  phase2_setup_1: prompts-0wl
  phase2_impl_1: prompts-hxi
  phase2_impl_2: prompts-k3d
  phase2_impl_3: prompts-np3
  phase2_test_1: prompts-64j
  # Phase 3 tasks
  phase3_impl_1: prompts-y1s
  phase3_impl_2: prompts-z1h
  phase3_impl_3: prompts-a05
  phase3_test_1: prompts-g7t
  # Phase 4 tasks
  phase4_impl_1: prompts-cox
  phase4_impl_2: prompts-4p4
  phase4_test_1: prompts-9on
---

# Execution Plan: explore_design Stage

## Overview

Implementing the optional `explore_design` workflow stage (architecture discussion between research and design) as specified in design.md.

**Design Approach**: Adaptive thought partner — separate user-only skill; thoughts/ capture + closed `Decide:` hand-off; create_design as formalizer.
**Target State**: Cold-start test passes (fresh create_design session consumes the decision record); fast path pays zero cost; exploration is durable.

## Implementation Strategy

### Phase Rationale

Riskiest-first with a parity gate, per dependency analysis:

- Phase 1 authors the new skill — the origin of the output contract (`Decide:` close-reason shape, thoughts-doc frontmatter) everything else consumes.
- Phase 2 makes the consumer-contract changes and gates them on the pilot-parity method (baseline before edit; fast-path branch byte-identical; cold-start dry-run against this project's own worked example). Dependency finding: create_design edits can be *authored* in parallel with Phase 1 (contract pinned in design.md) but only *verified* after the skill exists — hence verification is the phase gate, not the authoring.
- Phase 3 is the fully parallel, cosmetic documentation sweep (nine sequence-rendering locations; only the skill *name* is a dependency).
- Phase 4 is strictly last: RELEASING.md requires verification before the synchronized version bump, and main must stay releasable.

### Testing Strategy

No test framework exists for skill behavior (eval-harness fixtures are out of scope per design.md). Verification is: automated structural checks (lint, `wc -l`, pointer-resolution and coverage greps, manifest version-match assertion) plus manual dry-runs using **this project as the fixture** — its closed `Decide:` issue (`prompts-ar9`), thoughts docs, and hand-authored design.md are the cold-start input and expected output. Fast-path no-op is verified by textual parity diff against a pre-edit baseline (prompt-modernization parity-gate method). The one mechanically executable integration check — `bd list -n 0 --status=closed | grep "Decide:"` — is run as a real command.

## Progress Overview

Progress is tracked in beads. To check current status:

```bash
bd stats                    # Overall project statistics
bd list --status=closed     # See completed tasks
bd list --status=in_progress # See active work
bd ready                    # See available work
```

**Phase status**:

- Phase 1: See beads milestone `prompts-kk5` - depends on 4 tasks
- Phase 2: See beads milestone `prompts-zxe` - depends on 5 tasks
- Phase 3: See beads milestone `prompts-2k4` - depends on 4 tasks
- Phase 4: See beads milestone `prompts-ebp` - depends on 3 tasks

Use `bd show [milestone-id]` to see which tasks block each phase milestone.

---

## Phase 1: Author the explore_design Skill

### Objective

Create `plugin/skills/explore_design/` — the complete, self-contained stage skill — fixing the literal shape of both durable outputs (closed `Decide:` record, thoughts/ doc).

### Prerequisites

- [ ] Research validated (research.md status: complete)
- [ ] Design approved (design.md status: ready)
- [ ] Worked example available: [thoughts/2026-07-10-innovate-session-stage-architecture.md](thoughts/2026-07-10-innovate-session-stage-architecture.md)

### Changes Required

#### 1. New skill directory

**Files**: `plugin/skills/explore_design/SKILL.md` (new), `plugin/skills/explore_design/templates.md` (new)

**Current State** (from research.md): 21 skills exist; no explore_design; scaffolding models are `create_handoff/SKILL.md` (~256 lines) and `create_project/SKILL.md` (~177 lines).

**Target State** (from design.md): stage-skill frontmatter (`disable-model-invocation: true`, `allowed-tools: Read`, `effort: high`, `argument-hint: [project-directory]`); process flow frame → diverge → discuss → converge → record; Innovate contamination list and model self-check in the skill core (compaction lesson: constraints must not sit in the tail); convergence ⛔ CHECKPOINT using the `create_design/SKILL.md:166` approval language; templates.md carrying the thoughts-doc frontmatter template (with required Synthesis section) and the `Decide:` create/close command shapes (description = options + trade-offs; close reason = chosen direction + rationale + thoughts-doc paths).

**Rationale**: The skill is the origin of the consumption contract; everything downstream parses what it emits.
**Pattern Reference**: `create_product_research/SKILL.md:61-67` (Workflow Position dual-mode section), `create_handoff/SKILL.md` structure, `create_mockup/SKILL.md:98` (hard-wait interview wording).

### Tasks

**Note**: Task status is tracked ONLY in beads. The tasks below document WHAT needs to be done (the PLAN). For task STATUS, run `bd list` or check frontmatter `beads_tasks` for IDs.

#### Setup Tasks

- Scaffold `plugin/skills/explore_design/` with SKILL.md frontmatter + section skeleton (Initial Response / Process Steps / Important Notes / Error Handling per stage-skill convention) → `[beads:phase1_setup_1]`

#### Implementation Tasks

- Author SKILL.md core → `[beads:phase1_impl_1]`
  - Model self-check at open (surface to user when session below Opus; recommend Fable)
  - Step 1 entry gate: research.md exists + `status: complete`, else refuse with guidance; read research + existing thoughts/ fully (⛔ BARRIER 1)
  - CRITICAL contamination block: possibilities not commitments; no implementation detail; no task lists; no chosen answer unless user chose it
  - Frame → diverge (elastic: session drafts by default, fan-out only when scope warrants) → discuss (hard waits) → ⛔ CHECKPOINT convergence on explicit user signal → record
  - Completion summary with next-step pointer to `/wb:create_design`
  - Workflow Position section (pipeline + standalone modes, invocation criteria AND non-triggers)
- Author templates.md → `[beads:phase1_impl_2]`
  - Thoughts-doc template: frontmatter (project, created, status: exploration, topic, tags) + required Synthesis section
  - `Decide:` record shapes: `bd create "Decide: …" --type=task --priority=1 -d "[options + trade-offs]"` and `bd close [id] --reason "[chosen direction + rationale + thoughts path(s)]"`

#### Testing Tasks

- Verify Phase 1 structurally → `[beads:phase1_test_1]`
  - `./plugin/scripts/lint plugin/skills/explore_design/*.md` clean
  - `wc -l plugin/skills/explore_design/SKILL.md` ≤ ~500
  - Supporting-file pointers resolve (grep `](templates.md)` targets vs `ls`)
  - Structural read-through against the worked example: the skill's steps must reproduce the shape of the 2026-07-10 ad-hoc session (frame/diverge/discuss/converge/record)
  - Contamination list + CHECKPOINT confirmed in core (not tail); self-check present at open

### Success Criteria

#### Automated Verification

- [ ] Lint clean: `./plugin/scripts/lint plugin/skills/explore_design/SKILL.md plugin/skills/explore_design/templates.md`
- [ ] Core size: `wc -l plugin/skills/explore_design/SKILL.md` ≤ ~500
- [ ] Pointer resolution: every `Read … NOW` target exists

#### Manual Verification

- [ ] Read-through matches worked-example flow (frame → diverge → discuss → converge → record)
- [ ] Contamination rules and convergence CHECKPOINT sit in the skill core
- [ ] Model self-check wording surfaces below-Opus sessions without blocking them

### Modified Files

#### New Files

- `plugin/skills/explore_design/SKILL.md` - stage skill core
- `plugin/skills/explore_design/templates.md` - thoughts-doc + Decide: record templates

**Quick test command for this phase**:

```bash
./plugin/scripts/lint plugin/skills/explore_design/SKILL.md plugin/skills/explore_design/templates.md && wc -l plugin/skills/explore_design/SKILL.md
```

### ⛔ CHECKPOINT: Phase 1 Complete

Before proceeding to Phase 2:

1. ✅ All Phase 1 task beads issues closed (`bd list --status=closed`)
2. ✅ Phase 1 milestone beads issue closed
3. ✅ All automated verification passing
4. ✅ Manual verification confirmed by human
5. ✅ Update frontmatter: `current_phase: 2`

**Verification**: Run `bd show prompts-kk5` to confirm all blocking tasks are closed.

**Do not proceed without human confirmation of manual tests.**

---

## Phase 2: Consumer Contracts + Parity Gate

### Objective

Wire the three consumers (create_design, create_research, validate_project) to the new stage and pass the cold-start + fast-path gate.

### Prerequisites

- [ ] Phase 1 complete and verified (the skill's output shapes are fixed)
- [ ] Parity baseline captured BEFORE any create_design edit (setup task below)

### Changes Required

#### 1. create_design consumption branch

**File**: `plugin/skills/create_design/SKILL.md`

**Current State** (from research.md): BARRIER 1 reads research.md + design.md only (`:68-76`); Step 4 always generates 2–3 options (`:133-166`); sync list has five gates (`:296-302`).

**Target State** (from design.md): BARRIER 1 read set adds closed `Decide:` issues (`bd list -n 0 --status=closed | grep "Decide:"`) + thoughts docs referenced in their close reasons; Step 4 gains conditional: record present → present recorded decision for confirmation; absent → current text **verbatim**; sync list gains the conditional entry.

**Rationale**: Formalizer contract; fast-path must be byte-identical.
**Pattern Reference**: conditional-branch wording styles at `create_product_research/SKILL.md:61-67`; open-status grep convention at `create_design/SKILL.md:59`.

#### 2. create_research exit nudge

**Files**: `plugin/skills/create_research/SKILL.md:176-203` (the `Next:` line at `:201`), `plugin/skills/create_research/templates.md:121-129`

**Target State**: conditional suggestion of `/wb:explore_design` only when findings show multiple viable approaches; both files use matching wording (duplication noted as review point).

#### 3. validate_project prefix exemption

**File**: `plugin/skills/validate_project/reference.md:78-99`

**Target State**: orphan-detection logic exempts issues whose titles match `Q:`, `Decide:`, `Validate:`, `UI Q:`; non-prefixed orphans still warn (`reference.md:169-175` message unchanged).

### Tasks

#### Setup Tasks

- Capture parity baseline: save pre-edit `create_design/SKILL.md` Step 4 text (git ref) + record a no-record dry-run structure per the pilot-parity method (`docs/plans/2026-06-09-prompt-modernization/tasks.md:218-256`) → `[beads:phase2_setup_1]`

#### Implementation Tasks

- Edit create_design: BARRIER 1 read set + Step 4 conditional branch + Synchronization Points entry → `[beads:phase2_impl_1]`
- Edit create_research: Step 8 conditional nudge + templates.md Next Steps (matching wording) → `[beads:phase2_impl_2]`
- Edit validate_project: planning-prefix exemption in orphan detection → `[beads:phase2_impl_3]`

#### Testing Tasks

- Phase 2 gate verification → `[beads:phase2_test_1]`
  - Fast-path parity: diff no-record branch against baseline — byte-identical
  - Cold-start dry-run: fresh `claude --plugin-dir plugin` session, `/wb:create_design docs/plans/2026-07-10-explore-design-stage` (with existing design.md set aside for the test); confirm detection of `prompts-ar9`, confirmation flow, output consistent with the hand-authored design.md
  - Run `bd list -n 0 --status=closed | grep "Decide:"` as a real command → returns `prompts-ar9`
  - Nudge discrimination: dry-run completion summary against one single-approach and one multi-approach research outcome (assumption `prompts-01d`)
  - Orphan exemption walk-through: all four prefixes exempt; synthetic non-prefixed orphan still flagged
  - `./plugin/scripts/lint` on all touched files

### Success Criteria

#### Automated Verification

- [ ] Lint clean on create_design, create_research, validate_project files
- [ ] `bd list -n 0 --status=closed | grep "Decide:"` returns the fixture record
- [ ] `git diff` of Step 4 no-record branch vs baseline shows zero semantic change

#### Manual Verification

- [ ] Cold-start dry-run produces a design consistent with the recorded decision (⛔ this is the project's headline acceptance test)
- [ ] Fast-path dry-run indistinguishable from pre-change behavior
- [ ] Nudge fires only on the multi-approach fixture

### Modified Files

#### Code Files

- `plugin/skills/create_design/SKILL.md` - BARRIER 1 read set, Step 4 conditional, sync list
- `plugin/skills/create_research/SKILL.md` - Step 8 conditional nudge
- `plugin/skills/create_research/templates.md` - Next Steps conditional line
- `plugin/skills/validate_project/reference.md` - orphan-detection prefix exemption

**Quick test command for this phase**:

```bash
bd list -n 0 --status=closed | grep "Decide:" && ./plugin/scripts/lint plugin/skills/create_design/SKILL.md plugin/skills/create_research/SKILL.md plugin/skills/create_research/templates.md plugin/skills/validate_project/reference.md
```

### ⛔ CHECKPOINT: Phase 2 Complete

Before proceeding to Phase 3:

1. ✅ All Phase 2 task beads issues closed
2. ✅ Phase 2 milestone beads issue closed
3. ✅ Cold-start and fast-path gates PASSED (human-confirmed)
4. ✅ Update frontmatter: `current_phase: 3`

**Verification**: Run `bd show prompts-zxe`.

**Do not proceed without human confirmation of manual tests.**

---

## Phase 3: Documentation Sweep

### Objective

Add explore_design with "(optional)" notation to every workflow-sequence rendering; document the closed-`Decide:` semantics.

### Prerequisites

- [ ] Phase 2 complete (contract wording final, so docs describe shipped behavior)

### Changes Required

#### 1. Sequence renderings (nine locations from design.md Integration Points)

**Files**: `plugin/skills/help/SKILL.md:28-42, :153-169`; `CLAUDE.md:86`; `README.md:47-72`; `docs/commands-reference.md:24, :581-626, :719-722`; `docs/workbench-workflow-guide.md:24-57, :162-166`; `plugin/skills/create_project/templates.md:24-50, :260-301`; `plugin/skills/create_mockup/SKILL.md:278-288`; `plugin/skills/create_product_research/SKILL.md:277` + `templates.md:135`

**Target State**: explore_design listed between research and design with the exact "(optional)" notation create_mockup uses in each location; help additionally documents invocation criteria, non-triggers, and closed-`Decide:` record semantics alongside the existing prefix table (`help/SKILL.md:66-77`).

### Tasks

#### Implementation Tasks

- Update help skill: workflow diagram, command-details entry with invocation criteria/non-triggers, closed-`Decide:` semantics in beads conventions → `[beads:phase3_impl_1]`
- Update repo docs: CLAUDE.md, README.md, docs/commands-reference.md, docs/workbench-workflow-guide.md → `[beads:phase3_impl_2]`
- Update generated templates + cross-refs: create_project/templates.md (README workflow + Quick Commands + tasks planning checklist + Next Action), create_mockup relationship section, create_product_research next-steps lines → `[beads:phase3_impl_3]`

#### Testing Tasks

- Verify docs sweep → `[beads:phase3_test_1]`
  - Coverage grep: `grep -rn "explore_design" CLAUDE.md README.md docs/ plugin/skills/` hits match the design.md location list exactly
  - Notation consistency vs create_mockup's "(optional)" strings per file
  - `./plugin/scripts/lint` on all touched files

### Success Criteria

#### Automated Verification

- [ ] Coverage grep matches the nine-location list (no misses, no strays)
- [ ] Lint clean on all touched files

#### Manual Verification

- [ ] help output reads coherently with the new stage (dry-run `/wb:help`)
- [ ] Generated project README template shows the optional stage correctly

### Modified Files

#### Documentation Files

- `plugin/skills/help/SKILL.md`, `CLAUDE.md`, `README.md`, `docs/commands-reference.md`, `docs/workbench-workflow-guide.md`, `plugin/skills/create_project/templates.md`, `plugin/skills/create_mockup/SKILL.md`, `plugin/skills/create_product_research/SKILL.md`, `plugin/skills/create_product_research/templates.md`

**Quick test command for this phase**:

```bash
grep -rln "explore_design" CLAUDE.md README.md docs/ plugin/skills/ | sort && ./plugin/scripts/lint
```

### ⛔ CHECKPOINT: Phase 3 Complete

1. ✅ All Phase 3 task beads issues closed
2. ✅ Phase 3 milestone beads issue closed
3. ✅ Coverage grep + lint passing; help dry-run confirmed by human
4. ✅ Update frontmatter: `current_phase: 4`

**Do not proceed without human confirmation of manual tests.**

---

## Phase 4: Release

### Objective

Ship v2.1.0: CHANGELOG entry, synchronized manifest bump, pre-release verification.

### Prerequisites

- [ ] Phases 1–3 complete; working tree lint-clean

### Changes Required

#### 1. Release metadata

**Files**: `CHANGELOG.md`, `plugin/.claude-plugin/plugin.json:4`, `.claude-plugin/marketplace.json:12`

**Current State**: both manifests `"2.0.0"`.

**Target State**: `[2.1.0]` CHANGELOG section (`### Added`: new stage skill; create_design cold-start consumption; create_research nudge; validate_project prefix exemption); both manifests `"2.1.0"` (minor bump: additive feature per RELEASING.md semver).

### Tasks

#### Implementation Tasks

- Write CHANGELOG.md [2.1.0] entry → `[beads:phase4_impl_1]`
- Bump version to 2.1.0 in both manifests → `[beads:phase4_impl_2]`

#### Testing Tasks

- Release verification → `[beads:phase4_test_1]`
  - Version-match assertion: `diff <(grep -oE '"version": "[^"]+"' plugin/.claude-plugin/plugin.json) <(grep -oE '"version": "[^"]+"' .claude-plugin/marketplace.json)` exits 0
  - `./plugin/scripts/lint --all` clean
  - `--plugin-dir` smoke session: `/wb:` menu lists explore_design; `/wb:help` renders the updated workflow
  - RELEASING.md process checklist walked (CHANGELOG before bump; main releasable)

### Success Criteria

#### Automated Verification

- [ ] Version-match assertion exits 0; both manifests read 2.1.0
- [ ] `./plugin/scripts/lint --all` clean

#### Manual Verification

- [ ] Smoke session confirms skill loads and help renders
- [ ] RELEASING.md checklist complete

### Modified Files

#### Release Files

- `CHANGELOG.md`, `plugin/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`

**Quick test command for this phase**:

```bash
diff <(grep -oE '"version": "[^"]+"' plugin/.claude-plugin/plugin.json) <(grep -oE '"version": "[^"]+"' .claude-plugin/marketplace.json) && ./plugin/scripts/lint --all
```

### ⛔ CHECKPOINT: Phase 4 Complete

1. ✅ All Phase 4 task beads issues closed
2. ✅ Phase 4 milestone + epic closed
3. ✅ Release verification passing; human confirms ship

---

## Implementation Discoveries

Things to determine during implementation:

- Exact conditional-branch wording for create_design Step 4 (four existing styles catalogued; pick during authoring)
- Whether the nudge trigger condition needs example phrasings to discriminate reliably (`prompts-01d`)

Note: Update this section with findings as you implement.

---

## 📝 Completed Tasks Archive

### Planning Phase (pre-execution)

- [x] Create project structure - 2026-07-10 22:13
- [x] Complete research (research.md status: complete) - 2026-07-10 22:31
- [x] Ad-hoc innovate session + decision record `prompts-ar9` - 2026-07-10
- [x] Create design document (design.md status: ready) - 2026-07-10

---

## 🚧 Blockers & Notes

### Current Blockers

Blockers are tracked in beads. To see current blockers:

```bash
bd blocked    # Show all blocked issues and what blocks them
```

### Implementation Notes

- [2026-07-10] Phase 1 authored: SKILL.md landed at 293 lines (well under the ~500 ceiling). Two additions beyond the letter of the plan, both defensive and within the designed contract: Step 1 adopts a pre-existing *open* `Decide:` issue instead of duplicating it (closed at Step 6), and Step 5 defines the no-convergence exit (thoughts doc finalized, no `Decide:` created, stage re-runnable)
- This project's own artifacts are the test fixture: closed `prompts-ar9`, thoughts docs, and the hand-authored design.md (expected output for the cold-start grade)
- Assumption under validation: `prompts-01d` (nudge trigger reliability)
- Related but out-of-scope work already tracked: `prompts-4q0`, `prompts-vv8` (RIPER retrofits); `prompts-v4e`, `prompts-bbt`, `prompts-hls`, `prompts-f9r`, `prompts-0ar`, `prompts-1sr` (model recalibration)

---

## 🔗 Quick Reference

### Key Files

- **Research**: [research.md](research.md) - Current state documentation
- **Design**: [design.md](design.md) - Target state specification
- **Worked example**: [thoughts/2026-07-10-innovate-session-stage-architecture.md](thoughts/2026-07-10-innovate-session-stage-architecture.md)
- **Scaffolding models**: `plugin/skills/create_handoff/SKILL.md`, `plugin/skills/create_project/SKILL.md`

### Common Commands

```bash
# Lint (changed files / all)
./plugin/scripts/lint
./plugin/scripts/lint --all

# Dev-mode session (required for testing working-tree skills)
claude --plugin-dir plugin

# The novel consumption query
bd list -n 0 --status=closed | grep "Decide:"
```

### Design Decisions Reference

- Adaptive thought partner: separate skill, thoughts/ + closed `Decide:` hand-off, create_design formalizer
- Model: guidance + tripwire (`effort: high`, no pin)
- Nudge: create_research exit, conditional on multiple viable approaches
- Orphan fix: exempt the four planning prefixes in validate_project

## Beads Issue Tracking

This project uses beads for ALL task tracking across sessions.

**Epic**: prompts-247

**Phase Milestones**:

- Phase 1: prompts-kk5 (all Phase 1 tasks must complete)
- Phase 2: prompts-zxe (all Phase 2 tasks must complete)
- Phase 3: prompts-2k4 (all Phase 3 tasks must complete)
- Phase 4: prompts-ebp (all Phase 4 tasks must complete)

**Granular Tasks**: See frontmatter `beads_tasks` section for all task IDs.

**Essential Commands**:

- `bd ready` - See what's ready to work on (no blockers)
- `bd show [id]` - View task details and dependencies
- `bd update [id] --claim` - Claim a task
- `bd close [id]` - Complete a task
- `bd blocked` - See what's currently blocked
- `bd list --status=in_progress` - See your active work

**Status Source**: Beads is the source of truth for all task status. Do NOT use markdown checkboxes for tracking.
