---
project: prompt-modernization
ticket: prompts-fkz
created: 2026-06-09
status: not-started
last_updated: 2026-06-09
git_commit: db40dea
git_branch: modernize-2.0
repository: workbench
assignee: gabe@vare.la
current_phase: 1
total_tasks: 28
completed_tasks: 0
depends_on: [research.md, design.md]
beads_epic: prompts-y2a
beads_phases:
  phase1_milestone: prompts-9qy
  phase2_milestone: prompts-sgm
  phase3_milestone: prompts-au4
  phase4_milestone: prompts-6o3
beads_tasks:
  phase1_impl_1: prompts-dzy
  phase1_impl_2: prompts-xou
  phase1_impl_3: prompts-dwl
  phase1_impl_4: prompts-gz8
  phase1_impl_5: prompts-wyz
  phase1_impl_6: prompts-gja
  phase1_impl_7: prompts-skb
  phase1_test_1: prompts-c9o
  phase2_setup_1: prompts-e14
  phase2_impl_1: prompts-8dv
  phase2_test_1: prompts-yuf
  phase2_impl_2: prompts-c1l
  phase2_impl_3: prompts-zk4
  phase2_impl_4: prompts-ah0
  phase2_impl_5: prompts-6m4
  phase2_test_2: prompts-due
  phase3_setup_1: prompts-twp
  phase3_impl_1: prompts-1gt
  phase3_impl_2: prompts-0my
  phase3_setup_2: prompts-y2o
  phase3_impl_3: prompts-eav
  phase3_test_1: prompts-34n
  phase4_setup_1: prompts-41c
  phase4_impl_1: prompts-7jx
  phase4_impl_2: prompts-9wg
  phase4_test_1: prompts-pnr
  phase4_impl_3: prompts-m7o
  phase4_test_2: prompts-ogp
---

# Execution Plan: wb Prompt Modernization

## Overview

Implementing the mechanism-first, trims-last modernization of all wb prompt files as specified in [design.md](design.md).

**Design Approach**: evidence-strength ordering — correctness → restructure → capability → evidence-gated trims
**Target State**: zero verified defects; implementation-skill cores ~40% leaner with verified output parity; worker TDD discipline mechanically injected; session-end persistence deterministic; trims applied only with behavioral evidence.

## Implementation Strategy

### Phase Rationale

Phases descend by evidential confidence (design.md "Staging strategy"). Phase 1 fixes are verified against actual `bd` CLI behavior — no judgment calls. Phase 2 relocations preserve semantics by construction, gated by one pilot (implement_coordinated) before rollout. Phase 3 capabilities each carry a validation task for their design assumption (`prompts-70p`, `prompts-dr7`) with designed fallbacks. Phase 4 trims consume the behavioral evidence the earlier pilots generate; skipping them entirely is an acceptable terminal state. Each phase is an independent abort point.

### Testing Strategy

No test framework — verification is: `./scripts/lint --all` (markdownlint), grep audits against known-bad patterns, live `claude --plugin-dir /Users/gabe/Development/SaraGabriel/prompts` smoke runs (skills resolve, pointers load, workflows execute), and the Phase 4 behavioral parity protocol (baseline-vs-trimmed runs of create_research and an implement phase, compared for editorializing / skipped gates / placeholder output).

## Progress Overview

Progress is tracked in beads:

```bash
bd stats                      # Overall statistics
bd ready                      # Available work (no blockers)
bd list --status=in_progress -n 0  # Active work
```

**Phase status**:
- Phase 1: milestone `prompts-9qy` — 8 tasks
- Phase 2: milestone `prompts-sgm` — 8 tasks (depends on Phase 1)
- Phase 3: milestone `prompts-au4` — 6 tasks (depends on Phase 2)
- Phase 4: milestone `prompts-6o3` — 6 tasks (depends on Phase 3)

Use `bd show [milestone-id]` to see which tasks block each milestone.

---

## Phase 1: Correctness Fixes

### Objective

Eliminate every verified defect from research.md Batch 2 plus the proven-dead content, leaving behavior-shaping scaffolding untouched.

### Prerequisites

- [ ] design.md approved (done — this plan exists)
- [ ] Branch `modernize-2.0` checked out; dev session via `claude --plugin-dir`

### Changes Required

#### 1. bd list truncation (5 sites) → `prompts-dzy`

**Files/lines**: `skills/help/SKILL.md:73`, `skills/create_research/SKILL.md:318`, `skills/create_design/SKILL.md:312`, `skills/validate_project/SKILL.md:166`, `skills/mockup-iteration/SKILL.md:235`
**Current**: `bd list --status=open | grep ...` (default `--limit 50`, open-only at validate_project:166 where "all" is intended)
**Target**: `bd list -n 0 --status=open | grep ...`; validate_project additionally `--all` where the comment says "Get all beads issues"
**Rationale**: decision-gating pipelines must see complete result sets.

#### 2. Atomic claiming (6 sites) → `prompts-xou`

**Files/lines**: `skills/implement_tasks/SKILL.md` (~211, 222, 228, 611), `skills/implement_coordinated/SKILL.md` (~319, 344)
**Current**: `bd update [id] --status in_progress` at claim intent
**Target**: `bd update [id] --claim`
**Rationale**: atomic status+assignee; closes the double-claim window in coordinated mode. Leave `--status` forms where intent is a non-claiming status change.

#### 3. validate_project git-mode check → `prompts-dwl`

**File/line**: `skills/validate_project/SKILL.md:153`
**Current**: `git ls-files .beads/issues.jsonl` (tests *tracked*, false-negative before first commit)
**Target**: `git check-ignore -q .beads/` branch logic (mirrors the SessionStart hook's own detection)

#### 4. implement_coordinated phase-completion check → `prompts-gz8`

**File/line**: `skills/implement_coordinated/SKILL.md:~532`
**Current**: `bd list --status=closed | grep "phase${phase}"` (matches milestone titles only, truncates at 50)
**Target**: `bd show ${phaseMilestoneId}` blocker check (blockedBy empty ⇒ phase complete)

#### 5. Phantom barrier references → `prompts-wyz`

**Files/lines**: `skills/implement_tasks/SKILL.md:670-675`, `skills/validate_execution/SKILL.md:422-425`, `skills/validate_project/SKILL.md:510-514`
**Current**: sync summaries cite "BARRIER 3" / "BARRIER 2/3" absent from the step bodies
**Target**: summaries reference only barriers that exist (summaries themselves stay — recency anchors per research Rev 2)

#### 6. Configuration boilerplate → `prompts-gja`

**Files**: ~12 workflow skills, closing "## Configuration" paragraphs restating frontmatter `description`
**Target**: deleted; verify per-file nothing unique rides along (R5)

#### 7. Model-hint intent review → `prompts-skb` (includes human decision)

**Sites**: `skills/create_mockup/SKILL.md` 59, 75, 92, 126 (codebase-analyzer@haiku); `skills/validate_execution/SKILL.md` 97 (@haiku), 149 (pattern-finder@sonnet)
**Action**: decide intent per site with maintainer (per-spawn hints override frontmatter by design); record decisions in this file's Implementation Notes. Hints on `general-purpose` spawns stay untouched.

### Tasks

**Note**: Status is tracked ONLY in beads. Run `bd ready` for available work.

#### Implementation Tasks
- Fix bd list truncation in 5 decision pipelines → `prompts-dzy`
- Standardize atomic claiming with `--claim` (6 sites) → `prompts-xou`
- Fix validate_project git-mode check → `prompts-dwl`
- Fix implement_coordinated phase-completion check → `prompts-gz8`
- Fix phantom barrier references (3 files) → `prompts-wyz`
- Remove Configuration boilerplate (~12 skills) → `prompts-gja`
- Review model-hint intent with maintainer (6 sites) → `prompts-skb`

#### Testing Tasks
- Phase 1 verification → `prompts-c9o`

### Success Criteria

#### Automated Verification
- [ ] `./scripts/lint --all` clean
- [ ] `grep -rn 'bd list --status' skills/ | grep -v '\-n 0'` → no decision-pipeline hits
- [ ] `grep -rn 'status in_progress' skills/implement_tasks skills/implement_coordinated` → only non-claim sites remain
- [ ] `grep -rn 'BARRIER 3' skills/implement_tasks skills/validate_execution skills/validate_project` → no phantom refs
- [ ] `grep -rn '^## Configuration' skills/` → zero

#### Manual Verification
- [ ] `/wb:validate_project docs/plans/2026-06-09-prompt-modernization/` runs in a `--plugin-dir` session without false mode-config errors
- [ ] Model-hint decisions recorded in Implementation Notes

### Modified Files

- `skills/help/SKILL.md`, `skills/create_research/SKILL.md`, `skills/create_design/SKILL.md`, `skills/validate_project/SKILL.md`, `skills/mockup-iteration/SKILL.md` — bd list fixes
- `skills/implement_tasks/SKILL.md`, `skills/implement_coordinated/SKILL.md` — claiming, phase check, phantom refs
- `skills/validate_execution/SKILL.md` — phantom refs, possible model-hint change
- ~12 workflow skills — Configuration paragraph removal
- `skills/create_mockup/SKILL.md` — possible model-hint changes

**Quick check for this phase**: `./scripts/lint --all && grep -rn "bd list --status" skills/ | grep -v "\-n 0"`

### ⛔ CHECKPOINT: Phase 1 Complete

1. ✅ All 8 Phase 1 beads issues closed (`bd show prompts-9qy` → no open blockers)
2. ✅ Automated verification passing
3. ✅ Manual verification confirmed by human
4. ✅ Close milestone `prompts-9qy`; update frontmatter `current_phase: 2`

**Do not proceed without human confirmation.**

---

## Phase 2: Restructure with Verified Parity

### Objective

Move on-demand content (templates, agent prompts, reference material) out of SKILL.md cores per research Appendix B, piloted on implement_coordinated before rollout; extract shared explanatory content to `docs/reference/`.

### Prerequisites

- [ ] Phase 1 complete and verified (milestone `prompts-9qy` closed)

### Changes Required

#### 1. Shared reference files → `prompts-e14`

**Create**: `docs/reference/beads-mode.md` (stealth/git semantics), `docs/reference/documentarian-philosophy.md`, `docs/reference/beads-not-initialized.md` — content lifted from the duplicated blocks inventoried in research Appendix C. Explanatory only; operative snippets stay inline.

#### 2. Pilot split: implement_coordinated → `prompts-8dv`

**From**: `skills/implement_coordinated/SKILL.md` (808 lines)
**To**: core SKILL.md (~475) + `sub-agent-prompts.md` (worker prompt 287-372, verification 395-409, retry 429-449) + `templates.md` (aggregation 499-511, phase report 590-612, notes 638-654) + `reference.md` (context package 191-232, failure playbook 462-484; determineModel 657-700 unless already retired) + `README.md` (Evolution 14-30, Advantages 732-770 — human-facing, R6)
**Every extraction point gets an imperative pointer**: "Read [sub-agent-prompts.md](sub-agent-prompts.md) NOW for the worker prompt template."

#### 3. Pilot parity gate → `prompts-yuf` (GATE for all further splits)

Baseline before split: capture current behavior notes on a sample coordination dry-run. After split, in a `--plugin-dir` session: skill loads, every pointer resolves, dry-run produces structurally identical coordination flow (worker prompt fields, verification gates, report format). **No rollout until pass.**

#### 4-5. Rollout splits → `prompts-c1l`, `prompts-zk4`, `prompts-ah0`

Per research Appendix B tables: implement_tasks (4 templates out); create_execution/create_handoff/create_project (the three biggest template extractions: 257-line tasks skeleton, 256-line handoff template, ~300 lines of init templates); then the remaining nine workflow skills, including validate_project's pseudo-code → `reference.md` (R7 relocation, not deletion).

#### 6. Dedup pass → `prompts-6m4`

Replace the duplicated BEADS_MODE/documentarian/not-initialized explanations in skills with pointers to `docs/reference/`; keep the 4-line git-commit conditional inline; agents stay fully self-contained.

### Tasks

#### Setup Tasks
- Create docs/reference shared files → `prompts-e14`

#### Implementation Tasks
- Pilot split: implement_coordinated → `prompts-8dv`
- Split implement_tasks → `prompts-c1l`
- Split create_execution, create_handoff, create_project → `prompts-zk4`
- Split remaining workflow skills → `prompts-ah0`
- Dedup pass to docs/reference → `prompts-6m4`

#### Testing Tasks
- Pilot parity verification (GATE) → `prompts-yuf`
- Phase 2 verification → `prompts-due`

### Success Criteria

#### Automated Verification
- [ ] `./scripts/lint --all` clean
- [ ] `wc -l skills/implement_coordinated/SKILL.md` ≤ ~500
- [ ] Every supporting-file link target exists: `grep -rhoE '\]\((templates|sub-agent-prompts|reference|examples)\.md\)' skills/ | sort -u` cross-checked against `ls skills/*/`

#### Manual Verification
- [ ] Pilot dry-run output structurally identical to baseline (the `prompts-yuf` gate)
- [ ] `/wb:help` and `/wb:create_research` (no args) behave normally in `--plugin-dir` session
- [ ] All 21 skills appear correctly in the `/wb:` menu after `/reload-skills`

### Modified Files

- `skills/implement_coordinated/` — SKILL.md + 4 new files + README.md
- `skills/implement_tasks/`, `skills/create_execution/`, `skills/create_handoff/`, `skills/create_project/`, `skills/create_mockup/`, `skills/create_product_research/`, `skills/validate_project/`, `skills/create_design/`, `skills/create_research/`, `skills/validate_execution/`, `skills/update_status/`, `skills/resume_handoff/`, `skills/mockup-iteration/` — splits per Appendix B
- `docs/reference/` — 3 new shared files

### ⛔ CHECKPOINT: Phase 2 Complete

1. ✅ All 8 Phase 2 beads issues closed (`bd show prompts-sgm`)
2. ✅ Automated + manual verification passing
3. ✅ Close milestone `prompts-sgm`; update frontmatter `current_phase: 3`

**Do not proceed without human confirmation.**

---

## Phase 3: Capability Adoption

### Objective

Convert prose-requested discipline into mechanism: preloaded worker skill, deterministic session-end drift check, pinned verification budgets. Each capability validates its design assumption first and has a designed fallback.

### Prerequisites

- [ ] Phase 2 complete (milestone `prompts-sgm` closed)

### Changes Required

#### 1. Validate skills-preload assumption → `prompts-twp` (resolves `prompts-70p`)

Minimal throwaway agent with `skills: [tdd-discipline]` (try `wb:tdd-discipline` form too) in a `--plugin-dir` session; spawn it; confirm Iron Law content present in its context. **Fallback if unresolved**: inline the TDD rules in task-worker's system prompt.

#### 2. Verification pins → `prompts-1gt`

**Files**: `skills/validate_execution/SKILL.md`, `skills/research-validation/SKILL.md` frontmatter
**Add**: `model: sonnet`, `effort: high`

#### 3. task-worker agent → `prompts-0my` (depends on #1)

**Create**: `agents/task-worker.md` — tools: full edit/test set; `skills: [tdd-discipline]` (or inline fallback); no fixed `model:` (coordinator passes per-spawn override).
**Modify**: `skills/implement_coordinated/SKILL.md` — workers spawn as `task-worker`; replace `determineModel()` with a short coordinator-judgment note (haiku: mechanical config/docs; sonnet: standard implementation; opus: bugs/refactors/architecture — coordinator decides from task content, not regex).

#### 4. Validate SessionEnd visibility → `prompts-y2o` (resolves `prompts-dr7`)

Stub hook printing a marker; verify it displays at session end. **Fallback**: Stop event, or keep skill-only reminding.

#### 5. Drift-check hook → `prompts-eav` (depends on #4)

**Create**: `hooks/beads-drift-check.sh` — exits 0 silently when clean; prints one-line reminder when `.beads/` has uncommitted changes (git mode) or in_progress issues linger; guards: non-git safe, <100ms, no daemon spawns.
**Modify**: `.claude-plugin/plugin.json` (register SessionEnd hook), `skills/status-sync/SKILL.md` (slims to interactive deep-check role).

### Tasks

#### Setup Tasks
- Validate skills-preload resolution → `prompts-twp`
- Validate SessionEnd hook visibility → `prompts-y2o`

#### Implementation Tasks
- Add model/effort pins to verification skills → `prompts-1gt`
- Create task-worker agent; retire determineModel → `prompts-0my`
- Add beads-drift-check hook; slim status-sync → `prompts-eav`

#### Testing Tasks
- Pilot task-worker + hook behavior → `prompts-34n`

### Success Criteria

#### Automated Verification
- [ ] `./scripts/lint --all` clean; `jq . .claude-plugin/plugin.json` valid
- [ ] `time (echo '{}' | hooks/beads-drift-check.sh)` < 100ms, empty output on clean tree

#### Manual Verification
- [ ] One coordinated phase piloted on a sample project: worker demonstrably operates under TDD rules; task-verifier gate works; per-spawn model override observed
- [ ] Drift reminder appears at session end with uncommitted `.beads/` changes, and ONLY then
- [ ] Assumptions `prompts-70p` and `prompts-dr7` closed with findings

### Modified Files

- `agents/task-worker.md` (new), `hooks/beads-drift-check.sh` (new)
- `skills/implement_coordinated/SKILL.md` + its `reference.md`, `skills/validate_execution/SKILL.md`, `skills/research-validation/SKILL.md`, `skills/status-sync/SKILL.md`
- `.claude-plugin/plugin.json`

### ⛔ CHECKPOINT: Phase 3 Complete

1. ✅ All 6 Phase 3 beads issues closed (`bd show prompts-au4`)
2. ✅ Pilot evidence recorded in Implementation Notes (feeds Phase 4)
3. ✅ Close milestone `prompts-au4`; update frontmatter `current_phase: 4`

**Do not proceed without human confirmation.**

---

## Phase 4: Evidence-Gated Trims

### Objective

Apply the Rev 2-revised R1-R4 trims only where behavioral parity is demonstrated; skipping any trim is an acceptable outcome and gets recorded, not retried.

### Prerequisites

- [ ] Phase 3 complete (milestone `prompts-au4` closed)
- [ ] Behavioral observations from Phase 2/3 pilots available

### Changes Required

#### 1. Parity protocol + baselines → `prompts-41c` (resolves `prompts-409`)

Define: one representative research question against this repo + one sample implement phase; capture BASELINE transcripts with current prompts; pass criteria: zero editorializing in research output, zero skipped gates, zero placeholder content.

#### 2. Budget-keyword conversion → `prompts-7jx`

Per R1 Rev 2: `effort:` frontmatter where a skill is uniformly hard; retain inline `ultrathink` at decision-critical steps otherwise; delete only the 2 bare no-object directives (`create_project:50`, `update_status:95`).

#### 3. Strategic-placement repetition → `prompts-9wg`

Per R4 Rev 2: documentarian rule at exactly 3 placements (top-of-file, agent-spawn step, synthesis/write step) in create_research and create_product_research; "Remind EVERY agent" stays (untyped spawns); CAPS scope blocks soften to plain sentences.

#### 4. Parity comparison → `prompts-pnr` (GATE)

Re-run the protocol on trimmed prompts; compare to baselines. **Regression ⇒ revert the trim commit and record the evidence in research.md** — that is a successful outcome of this phase, not a failure.

#### 5. Barrier formatting decision → `prompts-m7o`

R3 (downgraded): apply single-⛔ normalization only if parity runs showed no formatting sensitivity; otherwise record "skipped — insufficient evidence of benefit."

#### 6. Final verification + release → `prompts-ogp`

Re-run the full Phase 1 (v2.0.0) verification checklist; bump version if shipping after PR #2 merges; update research.md with the applied/skipped record; close epic `prompts-y2a`.

### Tasks

#### Setup Tasks
- Construct parity protocol + baselines → `prompts-41c`

#### Implementation Tasks
- Convert thinking-budget keywords → `prompts-7jx`
- Strategic-placement repetition reduction → `prompts-9wg`
- Barrier-formatting decision on evidence → `prompts-m7o`

#### Testing Tasks
- Before/after parity comparison (GATE) → `prompts-pnr`
- Final verification and release → `prompts-ogp`

### Success Criteria

#### Automated Verification
- [ ] `./scripts/lint --all` clean
- [ ] Full v2.0.0 verification checklist green (skill flags, agent models, bd audit greps, manifest version match)

#### Manual Verification
- [ ] Parity comparison verdict recorded per trim (applied / reverted-with-evidence / skipped)
- [ ] research.md updated with final disposition of every R-recommendation
- [ ] Epic `prompts-y2a` closed

### Modified Files

- `skills/create_research/SKILL.md`, `skills/create_product_research/SKILL.md`, `skills/create_project/SKILL.md`, `skills/update_status/SKILL.md`, possibly others per parity evidence
- `docs/plans/2026-06-09-prompt-modernization/research.md` (final disposition record)

### ⛔ CHECKPOINT: Phase 4 Complete

1. ✅ All 6 Phase 4 beads issues closed (`bd show prompts-6o3`)
2. ✅ Final verification green; release decision made
3. ✅ Close milestone `prompts-6o3` and epic `prompts-y2a`; update frontmatter `status: complete`

---

## Implementation Discoveries

Things to determine during implementation:
- Whether `skills:` preload resolves plugin-namespaced skill names (`prompts-70p` — Phase 3 setup)
- SessionEnd hook display behavior in current Claude Code (`prompts-dr7` — Phase 3 setup)
- How discriminative the parity protocol is in practice (`prompts-409` — Phase 4 setup)
- R15/R16 inclusion decision (`prompts-s6c` — open; nothing blocks on it)

Update this section with findings as you implement.

---

## 🚧 Blockers & Notes

### Current Blockers

```bash
bd blocked    # live view
```

### Implementation Notes

- [2026-06-09] prompts-dzy variance: research listed 5 truncation sites; implementation found and fixed 3 more of the same decision-gating class (update_status counting pipelines ×2, implement_tasks phase-verification grep). Display-only listings deliberately untouched.
- [2026-06-09] prompts-xou variance: claim-intent sites totaled 14, not 6 — implement_tasks ×5, implement_coordinated ×2, resume_handoff ×2, create_execution ×2 (incl. generated-template text), help ×1, update_status ×1, plus CLAUDE.md and AGENTS.md quick references. All standardized to `--claim`.
- [2026-06-09] prompts-gz8 variance: the same fragile title-grep existed in implement_tasks Step 6; fixed both. Authoritative check is milestone `blockedBy`.
- [2026-06-09] prompts-gja: implement_coordinated's unique "Recommended for" guidance relocated to its intro before section deletion.
- [2026-06-09] prompts-skb decisions (maintainer): create_mockup ×4 codebase-analyzer@haiku KEPT (deliberate cost choice for lightweight UI documentation); validate_execution:97 haiku hint REMOVED (diff verification defers to frontmatter sonnet); validate_execution:149 pattern-finder@sonnet KEPT (quality judgment is heavier than pattern location). Per-spawn overrides remain a sanctioned mechanism.
- [2026-06-09] prompts-wyz follow-up (maintainer decision): validate_execution's phantom BARRIER 3 promoted to a REAL gate at Step 5 (no report until automated checks run and recorded) — restores the create_* skills' barrier-before-writing symmetry; the dangling summary line was likely a remnant of intended structure. The implement_tasks analog stays deleted (post-CHECKPOINT bookkeeping, already human-gated).
- [2026-06-09] prompts-wyz follow-up 2 (maintainer decision): validate_project gets a real pre-report BARRIER 2 (all checklist categories executed, incl. per-ID bd show, before writing the report) — covers the gate semantics of its deleted phantom "BARRIER 2: verify all IDs exist". The deleted "BARRIER 3: organize findings by severity" stays dead: formatting instruction, not a gate; the report template already enforces severity structure.

---

## 🔗 Quick Reference

### Key Files
- **Research**: [research.md](research.md) — Rev 2 evaluation with reviewer appendices (line-level specifics)
- **Design**: [design.md](design.md) — staging strategy and decisions
- **Plugin manifest**: `.claude-plugin/plugin.json`

### Common Commands
```bash
./scripts/lint --all                                   # lint everything
claude --plugin-dir /Users/gabe/Development/SaraGabriel/prompts   # test session from branch
bd ready                                               # next available work
git worktree add ../workbench-test modernize-2.0       # optional isolated test checkout
```

### Design Decisions Reference
- Evidence-strength ordering: correctness → restructure → capability → trims
- Four-name supporting-file convention; imperative pointers; agents self-contained
- Scaffolding presumed load-bearing; trims gated on `prompts-pnr` parity verdict
- Skipped trims are recorded outcomes, not failures

## Beads Issue Tracking

This project uses beads for ALL task tracking across sessions.

**Epic**: `prompts-y2a`

**Phase Milestones**:
- Phase 1: `prompts-9qy` (8 tasks)
- Phase 2: `prompts-sgm` (8 tasks)
- Phase 3: `prompts-au4` (6 tasks)
- Phase 4: `prompts-6o3` (6 tasks)

**Granular Tasks**: see frontmatter `beads_tasks`.

**Essential Commands**: `bd ready` · `bd show [id]` · `bd update [id] --claim` · `bd close [id]` · `bd blocked`

**Status Source**: Beads is the source of truth. Markdown checkboxes here document the PLAN only.
