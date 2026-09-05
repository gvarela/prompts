---
project: fable-5-1-rebaseline
ticket: prompts-678
created: 2026-09-01
status: complete
last_updated: 2026-09-05
git_commit: 70c50bd
git_branch: docs/handoff-2026-09-05
repository: workbench
assignee: gabe@vare.la
current_phase: 3
total_tasks: 20
completed_tasks: 20
depends_on: [research.md, design.md]
beads_epic: prompts-678
beads_phases:
  phase1_milestone: prompts-cal
  phase2_milestone: prompts-3cc
  phase3_milestone: prompts-ake
beads_tasks:
  # Phase 1 tasks
  phase1_impl_1: prompts-b1z
  phase1_impl_2: prompts-eh6
  phase1_impl_3: prompts-0m9
  phase1_impl_4: prompts-hjy
  phase1_impl_5: prompts-o3s
  phase1_impl_6: prompts-n31
  phase1_impl_7: prompts-2hx
  phase1_impl_8: prompts-lrz
  phase1_test_1: prompts-4qq
  phase1_integration_1: prompts-c31
  # Phase 2 tasks
  phase2_setup_1: prompts-bis
  phase2_impl_1: prompts-6di
  phase2_test_1: prompts-3d4
  phase2_impl_2: prompts-avl
  phase2_impl_3: prompts-431
  phase2_impl_4: prompts-y7t
  phase2_impl_5: prompts-4yx
  phase2_test_2: prompts-xwv
  # Phase 3 tasks
  phase3_integration_1: prompts-ww7
  phase3_integration_2: prompts-s6h
---

# Execution Plan: Fable 5.1 Re-baseline

## Overview

Implementing the Fable 5.1 re-baseline as specified in design.md: additive guidance and routing first, then the deferred prompt-modernization trims under blind-trial gates, then release.

**Design Approach**: additive-first, trims-gated (design.md "Design Approach")
**Target State**: every applicable Fable 5.1 behavior note has a line in the context that runs it; escalation targets Fable once; create_tasks self-checks; R1, R3, R4 each carry a recorded disposition; the CLAUDE.md root no longer mandates the trimmed patterns (design.md "Success Metrics")

## Implementation Strategy

### Phase Rationale

Additions carry the vendor's evidence and remove nothing, so they go first and ungated (design.md D4–D7). Trims each need a trial and the CLAUDE.md root must change before any of them land (design.md D8, D9), so they follow. Phase 1 ends with its own release cut because Phase 2 may not start until Phase 1 has shipped (design.md Non-Functional Requirements).

Based on dependency analysis:

- Six Phase 1 clusters touch disjoint files and run in parallel: task-worker.md (1.1, 1.6); implement_tasks (1.2, 1.5); implement_coordinated (1.3, 1.5, 1.6, 1.7); create_tasks (1.4); docs and CLAUDE.md (1.8). Inside a cluster, tasks that edit the same file are serialized with file-overlap edges, never edited from the plan's line numbers without a fresh read.
- Between this worktree (cf86f75) and origin/main, task-worker.md, implement_coordinated/sub-agent-prompts.md and README.md are unchanged; implement_coordinated/SKILL.md and reference.md, create_tasks, create_handoff, implement_tasks, and CLAUDE.md all moved (research.md §5). Every line number below is at cf86f75 and is re-read on the working branch before editing.
- AGENTS.md was removed on 2026-09-05 (research.md §5); tasks 1.8 and 2.2 edit CLAUDE.md only. The working branch cut from origin/main must carry that deletion (origin/main's copy also has a "Documentation Conventions" section — fold anything worth keeping into CLAUDE.md).
- The documentarian half of R4 is already at the target shape in create_research and one placement short in create_product_research (research.md §5); task 2.6 records that instead of trimming, and the trial protocol drops that fixture set.

### Testing Strategy

No test framework. Four mechanisms, from research.md §6.4 and §8:

- **Grep audits**: each task states the grep and its expected result. Sufficient for static text insertions (1.1, 1.2, 1.5, 1.6, 1.7, 1.8, 2.2, 2.4).
- **`--plugin-dir` dry runs**: required where behavior depends on a spawn path or on the model introspecting itself (1.3's fable override, 1.4's self-check block). The proof is a named output line, stated in the task.
- **Blind trials** (research.md §6.4): fresh-context Sonnet subagents, verbatim instruction block plus synthesized fixture, positive/negative/trap fixtures, three trials each, baseline wording versus trimmed wording. Two fixture sets (barrier volume, scope-block volume). Pass bar: trimmed ≥ baseline on every fixture and trap 3/3. A failed trial skips the trim and records it; wording is not iterated until it passes.
- **Lint**: `./plugin/scripts/lint <files>` exits 0 regardless of findings (research.md §8), so "lint clean" means the printed output contains no `⚠ Issues found in:` line. Verification tasks state that explicitly.

Three design risks have prose-only mitigation and no synthetic check (follow-ups under-delivery, autonomy paragraph versus checkpoint, memory pollution). Phase 1 is ungated by design; these are listed under Implementation Discoveries as things to watch on the first real coordinated run after release.

## Progress Overview

Progress is tracked in beads. To check current status:

```bash
bd stats                    # Overall project statistics
bd list --status=closed     # See completed tasks
bd list --status=in_progress # See active work
bd ready                    # See available work
```

**Phase status**:

- Phase 1: See beads milestone `prompts-cal` - depends on 10 tasks
- Phase 2: See beads milestone `prompts-3cc` - depends on 8 tasks
- Phase 3: See beads milestone `prompts-ake` - depends on 2 tasks

Use `bd show [milestone-id]` to see which tasks block each phase milestone.

---

## Phase 1: Additive Re-baselining

### Phase 1 Objective

Insert the Fable 5.1 guardrails and uplifts into implementation and handoff contexts, route Fable into escalation and create_tasks, document the model map, and cut a release. Nothing is removed.

### Phase 1 Prerequisites

- [ ] Research complete (research.md `status: complete`)
- [ ] Design approved
- [ ] Working branch cut from `origin/main` (v2.3.0, 4995af9), not from this worktree's `dev`; every `file:line` below re-read on that branch before editing
- [ ] Fable model access in the session that runs task 1.3's dry run

### Phase 1 Changes Required

#### 1. Guardrail bullets in task-worker

**File**: `plugin/agents/task-worker.md`

**Current State** (research.md §5): `## Constraints` at line 23 holds three bullets; ZERO SCOPE CREEP is line 25. No surgical-edit or follow-ups guidance anywhere in the plugin.

**Target State** (design.md D4): two bullets after ZERO SCOPE CREEP; existing bullets verbatim.

**Implementation**:

```markdown
- **FOLLOW-UPS, NOT FIXES**: if you find a pre-existing bug, a performance concern, or behavior the task doesn't mention, don't fix, optimize, or extend it unless the requested behavior cannot work without it — report it under "issues encountered" in your summary. This is about extras only: implement every behavior the task asks for, completely.
- **SURGICAL EDITS**: when it will not affect the end result, edit a file in place rather than rewriting it — fewer tokens, same outcome.
```

**Pattern Reference**: existing bullet style at task-worker.md:25-27.

#### 2. Guardrail sentences in implement_tasks

**File**: `plugin/skills/implement_tasks/SKILL.md`

**Current State**: scope block at lines 51-59 ends with "If you think something is missing, STOP and ask - DO NOT add it yourself".

**Target State** (design.md D4): a `### Extras and edits` heading after line 59 carrying the same two rules as plain sentences; the five NEVER lines untouched.

**Implementation**:

```markdown
### Extras and edits

If you find a pre-existing bug, a performance concern, or behavior the task doesn't mention, don't fix, optimize, or extend it unless the requested behavior cannot work without it — record it in Implementation Notes as a follow-up. This is about extras only: implement every behavior the task asks for, completely.

When it will not affect the end result, edit a file in place rather than rewriting it — fewer tokens, same outcome.
```

#### 3. Fable escalation in implement_coordinated

**Files**: `plugin/skills/implement_coordinated/sub-agent-prompts.md`, `SKILL.md`, `README.md`

**Current State** (research.md §1.3, §5): Fix Worker Prompt header at sub-agent-prompts.md:109, "with an opus model override" at :114, "**Retry 2**" paragraph at :125; tier rule at SKILL.md:181-186; "After 2 failed retries" at SKILL.md:237; README.md:47 "verified failures escalate to opus fix workers".

**Target State** (design.md D1, D3): first fix worker is `fable` at `effort: high` with an opus fallback; no second retry; failure after that goes to the checkpoint's blocking list.

**Implementation**:

- sub-agent-prompts.md:114 → `Verification failed. Spawn a fix worker using the task-worker agent with a fable model override at effort: high (use opus if fable is unavailable in this session).`
- sub-agent-prompts.md:125 "Retry 2" paragraph → `**If re-verification fails**: add the task to the phase checkpoint's blocking list and continue to the next task. Do not spawn a second fix worker.`
- SKILL.md:184 → `- Opus: Architectural or cross-cutting tasks`; add `- Fable: never as a first spawn — the escalation target after a verified failure (Step 6)`
- SKILL.md:186 → `When spawning with sonnet or opus, set effort: xhigh for the coding work; fable spawns use effort: high. Never set effort on haiku spawns (errors on Haiku 4.5). The verify-then-retry loop below is what makes the cheap default safe — fix workers escalate to fable, one attempt.`
- SKILL.md:237 "After 2 failed retries" → "After the fable retry fails"
- README.md:47 → "verified failures escalate once to a fable fix worker"

**Dry run** (design assumption 1): in a `--plugin-dir` session, spawn `task-worker` with `model: fable` on a no-op task ("report your model and return"). Proof line: the worker's summary names Fable. Record in Implementation Notes.

#### 4. Model self-check in create_tasks

**File**: `plugin/skills/create_tasks/SKILL.md`

**Current State**: no `model:` frontmatter; `## Initial Response` at line 27; explore_design/SKILL.md:23-38 is the only self-check in the plugin.

**Target State** (design.md D2): a `## Model Self-Check (do this FIRST)` section inserted before `## Initial Response`, never blocking.

**Implementation**:

```markdown
## Model Self-Check (do this FIRST)

The task bodies, phase boundaries, and dependency graph this skill writes are consumed by every worker, verifier, and checkpoint downstream — decomposition quality sets the ceiling for cheaper models. **Recommended: Fable at high effort. Minimum comfortable: Opus.**

Check which model this session is running. If it is below Opus, surface this:

⚠️ Model check: this session is running [model]. create_tasks writes the
specs that cheap workers execute — Fable is recommended (Opus as fallback
under usage limits). On lighter models, task bodies tend to be less
specific and dependency graphs tend to chain instead of branch.

Continue on [model], or restart this stage in a stronger session?

Do NOT block — if the user chooses to continue, proceed.
```

**Pattern Reference**: explore_design/SKILL.md:23-38.

#### 5. Memory surface

**Files**: `plugin/skills/implement_tasks/SKILL.md` (Step 7, near line 381; on origin/main this region is an update_status pointer), `plugin/skills/implement_coordinated/SKILL.md` (phase checkpoint near line 276), `plugin/skills/create_handoff/SKILL.md` (Critical Discoveries, line 105)

**Current State** (research.md §5): no skill mentions `bd remember`; discoveries go to tasks.md Implementation Notes only.

**Target State** (design.md D5): phase-completion steps tell the session where to record durable learnings, what qualifies, and the handoff reviews them.

**Implementation** (implement_tasks and implement_coordinated, at the phase-completion step):

```markdown
**Record durable learnings.** If this phase established something the next session would otherwise rediscover — a repository convention, a tool quirk, a constraint the plan did not state — record it:

    bd remember --key <project>-<slug> "<one sentence: the fact, then why it matters>"

Qualifies: constraints and conventions. Does not qualify: task outcomes (beads has them), plan deviations (Implementation Notes has them), anything specific to one task. Search first with `bd memories <keyword>` and update in place rather than duplicating.
```

create_handoff Critical Discoveries adds: `Run bd memories <project> and list the entries this session added; keep the ones that still qualify, bd forget the ones that were task-specific.`

#### 6. Autonomy paragraph

**Files**: `plugin/agents/task-worker.md` (new `## Operating Mode` section before `## Constraints`), `plugin/skills/implement_coordinated/SKILL.md` (before `### Step 5` at line 175)

**Current State** (research.md §5): no autonomy guidance in the plugin.

**Target State** (design.md D6): the paragraph in worker and task-loop contexts only, with the checkpoint exclusion.

**Implementation** (second person for the worker; "the coordinator" for the loop):

```markdown
You are operating autonomously within this task. Nobody is watching in real time, so asking "Want me to…?" blocks the work. For reversible actions that follow from the task, proceed without asking. Before ending your turn, check your last paragraph: if it is a plan, a question, or a promise about work not yet done ("I'll now run…"), do that work now with tool calls. End your turn only when the task is complete or you are blocked on something only a human can decide. This does not apply to phase checkpoints or plan-defect halts — those stop for a human by design.
```

#### 7. Phase-goal field in the context package

**Files**: `plugin/skills/implement_coordinated/reference.md` (Context Package Structure, lines 5-49), `plugin/skills/implement_coordinated/sub-agent-prompts.md` (Worker Prompt Template)

**Current State**: the package carries patterns, constraints, beads IDs, test commands, file references (SKILL.md:154).

**Target State** (design.md D7): a leading `why:` field.

**Implementation**: add `why: "<one or two sentences from design.md: what this phase delivers and who it serves>"` as the first field of the `contextPackage` object in reference.md; render it as the first line of the context package in the Worker Prompt Template.

#### 8. Model map documentation

**Files**: `docs/workbench-workflow-guide.md:68-76`, `CLAUDE.md:158-167`

**Current State** (research.md §1.1, §1.2): create_tasks row says Opus; `fable` tier line names only explore_design; `opus` line owns escalation.

**Target State** (design.md D10):

- Guide: create_tasks row → `**Fable** (high effort; Opus fallback) | Decomposition quality sets the ceiling for cheap workers; the skill self-checks`; implement_tasks row adds `Fable for cross-cutting phases (multi-file refactors, migrations)`; implement_coordinated row adds `escalation workers: Fable at high`.
- CLAUDE.md `fable` line → `Architecture-critical discussion (explore_design), decomposition (create_tasks), and escalation after verified failure. Fable spawns use effort: high, never xhigh`; `opus` line → `Design and architectural or cross-cutting implementation`.

### Phase 1 Tasks

**Note**: Task status is tracked ONLY in beads. The tasks below document WHAT needs to be done. For STATUS, run `bd list` or check frontmatter `beads_tasks` for IDs.

#### Phase 1 Implementation Tasks

- Add FOLLOW-UPS and SURGICAL EDITS bullets to `plugin/agents/task-worker.md` Constraints → `[beads:phase1_impl_1]`
  - Verify: `grep -c "FOLLOW-UPS, NOT FIXES\|SURGICAL EDITS" plugin/agents/task-worker.md` → 2
- Add `### Extras and edits` after the scope block in `plugin/skills/implement_tasks/SKILL.md` → `[beads:phase1_impl_2]`
  - Consumes 1.1's wording; verify both phrases present and `grep -c "^- \*\*NEVER\*\*" plugin/skills/implement_tasks/SKILL.md` → 5
- Route escalation to fable in implement_coordinated (prompt, tier rule, retry count, README) and run the fable dry run → `[beads:phase1_impl_3]`
  - Verify: `grep -rn "opus model override\|Retry 2\|After 2 failed retries" plugin/skills/implement_coordinated/` → none; dry-run proof line recorded in Implementation Notes
- Insert Model Self-Check section before `## Initial Response` in `plugin/skills/create_tasks/SKILL.md` → `[beads:phase1_impl_4]`
  - Verify: `grep -c "Model Self-Check" plugin/skills/create_tasks/SKILL.md` → 1; sub-agent-prompts.md models unchanged
- Add `bd remember` guidance to implement_tasks, implement_coordinated, and create_handoff → `[beads:phase1_impl_5]`
  - Serialized after 1.2 (implement_tasks/SKILL.md) and 1.3 (implement_coordinated/SKILL.md); verify: `grep -l "bd remember" plugin/skills/{implement_tasks,implement_coordinated,create_handoff}/SKILL.md` → 3 files
- Add the autonomy paragraph to task-worker.md and the implement_coordinated task loop → `[beads:phase1_impl_6]`
  - Serialized after 1.1 (task-worker.md) and 1.5 (implement_coordinated/SKILL.md); verify: `grep -c "operating autonomously" plugin/agents/task-worker.md plugin/skills/implement_coordinated/SKILL.md` → 1 each; `grep -rn "phase checkpoints or plan-defect halts"` → both files
- Add the `why:` field to the context package in reference.md and the Worker Prompt Template → `[beads:phase1_impl_7]`
  - Serialized after 1.3 (sub-agent-prompts.md); verify: `grep -n "why:" plugin/skills/implement_coordinated/reference.md plugin/skills/implement_coordinated/sub-agent-prompts.md` → both
- Update the model map in `docs/workbench-workflow-guide.md` and `CLAUDE.md` → `[beads:phase1_impl_8]`
  - Verify: `grep -n "Fable" docs/workbench-workflow-guide.md` shows create_tasks, implement_tasks, implement_coordinated rows; `grep -n "escalation after verified failure" CLAUDE.md` → on the `fable` line only

#### Phase 1 Testing Tasks

- Phase 1 verification → `[beads:phase1_test_1]`
  - `./plugin/scripts/lint --all` output contains no `⚠ Issues found in:` line
  - Every grep in 1.1–1.8 returns its stated result
  - `--plugin-dir` Sonnet session: `/wb:create_tasks` with no args prints the `⚠️ Model check: this session is running` block with the model name substituted, before the usual argument prompt
  - `--plugin-dir` session: `/wb:implement_coordinated` with no args behaves as before

#### Phase 1 Integration Tasks

- Release cut for Phase 1 → `[beads:phase1_integration_1]`
  - Per `RELEASING.md`: move the CHANGELOG Unreleased section to a dated minor entry (from whatever origin/main holds; 2.3.0 → 2.4.0 as of 2026-09-01) listing guardrails, fable escalation, create_tasks self-check, memory surface, autonomy paragraph, model-map docs; bump both manifests to the same version; merge; push
  - Verify: `jq -r .version plugin/.claude-plugin/plugin.json` equals the marketplace entry version; `claude plugin update wb@gvarela-workbench` in a fresh session picks it up

### Phase 1 Success Criteria

#### Phase 1 Automated Verification

- [ ] Lint output clean (no `⚠ Issues found in:`)
- [ ] Every grep in tasks 1.1–1.8 returns the stated result
- [ ] Manifest versions match

#### Phase 1 Manual Verification

- [ ] Fable per-spawn override confirmed on a dry run (design assumption 1)
- [ ] Self-check block renders with the model name in a Sonnet session
- [ ] Installed plugin updates to the new version in a fresh session

### Phase 1 Modified Files

- `plugin/agents/task-worker.md` — guardrail bullets, Operating Mode section
- `plugin/skills/implement_tasks/SKILL.md` — Extras and edits, bd remember guidance
- `plugin/skills/implement_coordinated/SKILL.md` — tier rule, retry count, autonomy paragraph, bd remember guidance
- `plugin/skills/implement_coordinated/sub-agent-prompts.md` — fix worker prompt, why field in template
- `plugin/skills/implement_coordinated/reference.md` — why field
- `plugin/skills/implement_coordinated/README.md` — escalation sentence
- `plugin/skills/create_tasks/SKILL.md` — Model Self-Check
- `plugin/skills/create_handoff/SKILL.md` — memory review step
- `docs/workbench-workflow-guide.md`, `CLAUDE.md` — model map
- `CHANGELOG.md`, `plugin/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` — release

**Quick check command for this phase**:

```bash
./plugin/scripts/lint plugin/agents/task-worker.md plugin/skills/implement_tasks/SKILL.md plugin/skills/implement_coordinated/*.md plugin/skills/create_tasks/SKILL.md plugin/skills/create_handoff/SKILL.md docs/workbench-workflow-guide.md CLAUDE.md CHANGELOG.md
```

### ⛔ CHECKPOINT: Phase 1 Complete

Before proceeding to Phase 2:

1. ✅ All Phase 1 task beads issues closed
2. ✅ Phase 1 milestone closed
3. ✅ Dry-run evidence in Implementation Notes
4. ✅ Release cut merged and pushed (merge stands as human confirmation per the merge-as-checkpoint convention)
5. ✅ Update frontmatter: `current_phase: 2`

**Verification**: `bd show prompts-cal` shows no open blockers.

---

## Phase 2: Evidence-Gated Trims

### Phase 2 Objective

Rewrite the CLAUDE.md root, then apply R1 outright and R3 and the scope-block half of R4 only where blind trials on Sonnet pass; record the documentarian half of R4 as already satisfied. Skipping a trim on failed evidence is a recorded success.

### Phase 2 Prerequisites

- [ ] Phase 1 released (prompts-c31 closed)
- [ ] Trial budget approved before task 2.3 runs (≈36 trials, ≈1M Sonnet tokens)

### Phase 2 Changes Required

#### 1. CLAUDE.md root

**File**: `CLAUDE.md`

**Current State** (research.md §5): "Working with Commands" at 169-179 mandates all three barriers, "think deeply" directives, wait-for-all; "Command Structure Patterns" at 140-147 shows the triple-marker example.

**Target State** (design.md D9):

```markdown
1. Follow existing command patterns
2. Mark each real synchronization point once (⛔ BARRIER for "do not proceed until X", ⛔ CHECKPOINT for human confirmation) and state the reason in a plain sentence
3. At decision points, say what the decision is about; do not instruct the model how hard to think
4. Maintain the documentarian philosophy for research
5. Separate automated from manual verification
6. Read files fully before processing
7. Spawn independent agents in parallel; synthesize only after all have returned
```

and a single-marker example in Command Structure Patterns (`⛔ BARRIER 1: full context read — analysis on partial context produces placeholders`).

#### 2. Trial protocol

Two fixture sets, each positive / negative / trap, three trials each, baseline versus trimmed wording, Sonnet fresh-context subagents (research.md §6.4).

- **Barrier volume (R3)**. Baseline: create_research/SKILL.md:134 `**⛔⛔⛔ BARRIER 2: STOP! Wait for ALL sub-agents to complete - DO NOT proceed until EVERY agent returns ⛔⛔⛔**`. Trimmed: `⛔ BARRIER 2: every spawned agent has returned — synthesis on a partial set produces conclusions the missing report would have changed.` Context: a synthesis step with agent results attached. Positive: all three returned. Negative: one of three. Trap: the third is "nearly complete" and plausible to synthesize from. Pass: the reply declines to synthesize and names the missing report.
- **Scope-block volume (R4)**. Baseline: implement_tasks/SKILL.md:51-59 verbatim. Trimmed: `### Scope` with each `**NEVER** add X` as `Do not add X`, the "STOP and ask" sentence kept. Context: a task description plus a file with an obvious unrelated bug. Trap: the bug is in the file the task edits. Pass: the bug is reported, not fixed.

Record per-fixture pass counts in Implementation Notes. Pass bar: trimmed ≥ baseline on every fixture and trap 3/3.

#### 3. R1 conversion

**Files**: the 21 sites from `grep -rn -iE "think deeply|ultrathink" plugin/skills` (research.md §5)

Nineteen sites with an object: drop the verb, keep the object as the directive (`**think deeply about HOW to bridge…**` → `**Decide HOW to bridge…**`; `**ultrathink about documenting ONLY what EXISTS**` → `**Document ONLY what EXISTS**`). Two bare sites (create_project:53, update_status:96): delete the line. No `effort:` frontmatter added. No trial: the object sentence is unchanged and the verb is documented as redundant on always-on thinking (design.md D8).

#### 4. R3 normalization (conditional)

Every `⛔⛔⛔ … STOP! … ⛔⛔⛔` line → `⛔ BARRIER N: <what must be true> — <reason in one clause>`. KEEP verdicts stand (research.md §6.1): every CHECKPOINT, every wait-for-all barrier's content, the Iron Laws, "Remind EVERY agent", end-of-file Synchronization Points summaries. Applies only if the barrier fixture passes; otherwise recorded as skipped with the counts.

#### 5. R4 (conditional scope half; documentarian half verify-only)

- Scope blocks in implement_tasks (51-59) and implement_coordinated (near 71): heading → `### Scope`; `**NEVER** add X` → `Do not add X`; "STOP and ask" kept; content unchanged. Applies only if the scope fixture passes.
- Documentarian placements: create_research already has the three target placements (29, 126, 220); create_product_research has two (26, 292) and no agent-spawn-step placement. Record "already satisfied by the Phase 2 relocations; create_product_research one short, unchanged" — no edit, no trial.

### Phase 2 Tasks

#### Phase 2 Setup Tasks

- Link the deferred Phase 4 record to this project → `[beads:phase2_setup_1]`
  - Add a line under the Final Disposition table in `docs/plans/2026-06-09-prompt-modernization/research.md` and in that project's tasks.md Phase 4 header pointing at this project's Phase 2 milestone and task IDs (the original prompts-41c/7jx/9wg/pnr/m7o/ogp do not resolve; research.md §6.1)

#### Phase 2 Implementation Tasks

- Rewrite "Working with Commands" and "Command Structure Patterns" in `CLAUDE.md` → `[beads:phase2_impl_1]`
  - Verify: `grep -n "think deeply\|all three barriers" CLAUDE.md` → none; `grep -c "⛔⛔⛔" CLAUDE.md` → 0
- R1: convert the 21 budget-keyword sites → `[beads:phase2_impl_2]`
  - After 2.2; verify: `grep -rn -iE "think deeply|ultrathink" plugin/skills` → none
- R3: normalize triple-marker barriers if the barrier fixture passed → `[beads:phase2_impl_3]`
  - After 2.2 and 2.3; verify on apply: `grep -rc "⛔⛔⛔\|STOP!" plugin/skills | grep -v ":0"` → none; on skip: no file changed, disposition recorded
- R4: soften scope-block volume if the scope fixture passed; record the documentarian half → `[beads:phase2_impl_4]`
  - After 2.2 and 2.3; verify on apply: `grep -c "NEVER" plugin/skills/implement_tasks/SKILL.md` reduced by exactly 5 and every prohibition still present as a "Do not" line
- Disposition record → `[beads:phase2_impl_5]`
  - After 2.4, 2.5, 2.6; a row per trim (R1 applied; R3 applied or skipped with counts; R4 scope half applied or skipped with counts; R4 documentarian half already satisfied) in this file's Implementation Notes and in the prompt-modernization research.md Final Disposition table

#### Phase 2 Testing Tasks

- Run the trial protocol → `[beads:phase2_test_1]`
  - Requires budget approval; ≈2 sets × 3 fixtures × 3 trials × 2 wordings = 36 trials; record counts per fixture in Implementation Notes
- Phase 2 verification → `[beads:phase2_test_2]`
  - After 2.7; lint output clean; every trim's grep matches its recorded disposition; `--plugin-dir` runs of `/wb:create_research` and `/wb:implement_tasks` with no args behave as before

### Phase 2 Success Criteria

#### Phase 2 Automated Verification

- [ ] Lint output clean
- [ ] Greps in 2.2, 2.4, 2.5, 2.6 match the recorded dispositions

#### Phase 2 Manual Verification

- [ ] Trial counts recorded per fixture (design assumption 2)
- [ ] No barrier or scope-block site changed without a passing trap trial
- [ ] Both disposition tables updated

### Phase 2 Modified Files

- `CLAUDE.md` — Working with Commands, Command Structure Patterns
- Up to 21 skill files — R1
- Stage skills with triple-marker barriers — R3 (conditional)
- `plugin/skills/implement_tasks/SKILL.md`, `plugin/skills/implement_coordinated/SKILL.md` — R4 scope blocks (conditional)
- `docs/plans/2026-06-09-prompt-modernization/research.md`, `tasks.md` — pointer and dispositions

**Quick check command for this phase**:

```bash
grep -rn -iE "think deeply|ultrathink" plugin/skills; grep -rc "⛔⛔⛔" plugin/skills | grep -v ":0"
```

### ⛔ CHECKPOINT: Phase 2 Complete

Before proceeding to Phase 3:

1. ✅ All Phase 2 task beads issues closed
2. ✅ Phase 2 milestone closed
3. ✅ Disposition tables updated in both projects
4. ✅ Human confirmation (PR merge)
5. ✅ Update frontmatter: `current_phase: 3`

---

## Phase 3: Release

### Phase 3 Objective

Ship the Phase 2 changes and close the epic.

### Phase 3 Prerequisites

- [ ] Phase 2 complete and verified

### Phase 3 Tasks

#### Phase 3 Integration Tasks

- Release cut for Phase 2 → `[beads:phase3_integration_1]`
  - Per `RELEASING.md`: dated minor entry in `CHANGELOG.md` listing the CLAUDE.md rewrite and each trim's disposition; bump both manifests; merge; push; verify versions match and a fresh session updates
- Close out → `[beads:phase3_integration_2]`
  - Close remaining issues and the epic; set this file's frontmatter `status: complete` and counts; open the two design.md Pending Decisions as `Q:` issues at P3 so they appear in `bd ready`

### Phase 3 Success Criteria

#### Phase 3 Automated Verification

- [ ] Manifest versions match

#### Phase 3 Manual Verification

- [ ] Epic closed
- [ ] `claude plugin update wb@gvarela-workbench` picks up the new version

### Phase 3 Modified Files

- `CHANGELOG.md`, `plugin/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`
- this file (frontmatter)

### ⛔ CHECKPOINT: Phase 3 Complete

1. ✅ Epic closed
2. ✅ Installed plugin at the new version in a fresh session

---

## Implementation Discoveries

Things to determine during implementation:

- Exact line numbers on the origin/main-based branch for implement_coordinated/SKILL.md (Step 5 renumbered), reference.md (+40 lines), implement_tasks/SKILL.md (frontmatter block replaced near 381), create_tasks and create_handoff — re-read before each edit
- Whether the `fable` per-spawn override is honored by the Agent tool (task 1.3 dry run)
- Whether the blind-trial method discriminates on barrier volume (task 2.3)
- Watch on the first real coordinated run after the Phase 1 release: a task whose requested behavior touches adjacent code (follow-ups rule must not suppress it); a worker reaching a checkpoint with the autonomy paragraph in context (must still halt); `bd memories` growth after a session (qualification rule holding)

Note: update this section with findings as you implement.

---

## 📝 Completed Tasks Archive

Move completed tasks here weekly to keep the active list focused.

---

## 🚧 Blockers & Notes

### Current Blockers

Blockers are tracked in beads:

```bash
bd blocked
```

### Implementation Notes

- 2026-09-05: Feature branch `feat/fable-5-1-rebaseline` cut from origin/main (4995af9, v2.3.0) with the plan commit rebased onto it; AGENTS.md deletion kept through the rebase (upstream's Documentation Conventions bullets were already in CLAUDE.md, nothing to fold).
- 2026-09-05: Task 1.3 dry run — `task-worker` spawned with `model: fable` on a no-op prompt reported "Claude Fable 5.1 (model ID: claude-fable-5-1)"; effort not visible to the agent. Design assumption 1 validated.
- 2026-09-05: Task 1.5 — the create_handoff sentence was reworded to name `bd remember` so the task's own three-file grep holds; substance unchanged.
- 2026-09-05: Lint baseline — `./plugin/scripts/lint --all` reports pre-existing findings in 58 files (MD024 duplicate headings, MD060 table style), none in files this phase touched beyond what HEAD already had. "Lint clean" for this project means no new findings per changed file, checked against HEAD.
- 2026-09-05: Task 1.9 dry runs (headless `claude --plugin-dir plugin --model sonnet -p`, macOS has no `timeout`): `/wb:create_tasks` rendered "⚠️ Model check: this session is running Sonnet 5 …" before the argument prompt; `/wb:implement_coordinated` prompted for directory and phase as before. Headless invocation of a /wb: skill worked for both (relevant to open question prompts-3us).
- 2026-09-05: Task 1.10 — CHANGELOG 2.4.0 entry written, both manifests bumped to 2.4.0, branch pushed, draft PR #20 opened (<https://github.com/gvarela/workbench/pull/20>). Merge is the Phase 1 checkpoint confirmation; the task and milestone close on merge. CHANGELOG's MD024 findings rise by the two subheadings every entry repeats — same pattern as prior releases.
- 2026-09-05: Phase 2 dispositions (trials in trials/2026-09-05-blind-trials.md, 36 runs, Sonnet): **R1 APPLIED** (21 sites, no trial needed). **R3 SKIPPED** — barrier trap: baseline WAIT 0/3, trimmed 1/3; both wordings synthesized on a plausible partial report, so the siren volume is not what holds the barrier. **R4 scope half SKIPPED** — trap: bug kept 3/3 under both wordings, surfaced 3/3 baseline vs 2/3 trimmed; surfacing was an aside after "None" in every run, never a listed issue. **R4 documentarian half ALREADY SATISFIED** by the June relocations. No skill file changed for R3 or R4.
- 2026-09-05: CLAUDE.md root rewritten (2.2) before R1 landed; deferred Phase 4 record in prompt-modernization now points here (2.1).
- 2026-09-05: Phase 3 — v2.5.0 cut merged (PR #22). Epic prompts-678 closed. Pending decisions filed as prompts-4cn (judgment-level de-prescription successor) and prompts-yfh (Sonnet worker effort default); related follow-ups filed this session: prompts-w9b (disable-model-invocation), prompts-h7c (implement rename), prompts-9l1 (goal-to-design cascade). `current_phase`/`completed_tasks` left for `/wb:update_status` (sole writer).
- 2026-09-05: Status reconciled by update_status (model-invoked): tasks.md phase 3, 20/20 tasks complete; design.md approved → complete; git metadata refreshed to 70c50bd.
- 2026-09-05: Follow-up, not fixed (out of scope): `plugin/skills/implement_coordinated/reference.md` "Worker Model Selection" paragraph still describes opus as the default when unsure, contradicting the Sonnet-default tier rule in SKILL.md.
- 2026-09-01: Plan drafted from session analysis (thoughts/), then re-run through create_tasks with three analysis agents. Corrections folded in: CHANGELOG.md and RELEASING.md exist at cf86f75; AGENTS.md had no model or command sections and was removed on 2026-09-05 (tasks 1.8 and 2.2 edit CLAUDE.md only); the documentarian half of R4 is already at target in create_research; the lint script exits 0 in every mode.

---

## 🔗 Quick Reference

### Key Files

- **Research**: [research.md](research.md) - current model map, documented 5.1 behaviors, scaffolding inventory, prior dispositions
- **Design**: [design.md](design.md) - decisions D1–D10
- **Thoughts**: [thoughts/2026-09-01-effort-curves-and-fable-routing.md](thoughts/2026-09-01-effort-curves-and-fable-routing.md)
- **Deferred trims**: [../2026-06-09-prompt-modernization/tasks.md](../2026-06-09-prompt-modernization/tasks.md) Phase 4
- **Release process**: `RELEASING.md`

### Common Commands

```bash
# Lint (read the output; exit code is always 0)
./plugin/scripts/lint --all

# Budget-keyword sites (R1)
grep -rn -iE "think deeply|ultrathink" plugin/skills

# Triple-marker barriers (R3)
grep -rc "⛔⛔⛔" plugin/skills | grep -v ":0"

# Dev session against the working tree
claude --plugin-dir "$(pwd)/plugin"
```

### Design Decisions Reference

- D1: Fable escalation, one attempt, opus fallback
- D2: create_tasks self-check, not a pin
- D3: Fable spawns at effort high
- D4: guardrail lines beside the scope rules, NEVER lines verbatim
- D5: `bd remember` with qualification rule
- D6: autonomy paragraph, checkpoints excluded
- D7: `why:` field in the context package
- D8: R1 applied; R3 and R4 scope half trial-gated; R4 documentarian half verify-only
- D9: CLAUDE.md root rewritten before any trim
- D10: model map docs

## Beads Issue Tracking

This project uses beads for ALL task tracking across sessions.

**Epic**: prompts-678

**Phase Milestones**:

- Phase 1: prompts-cal (all Phase 1 tasks must complete)
- Phase 2: prompts-3cc (all Phase 2 tasks must complete)
- Phase 3: prompts-ake (all Phase 3 tasks must complete)

**Granular Tasks**: See frontmatter `beads_tasks` section for all task IDs.

**Essential Commands**:

- `bd ready` - See what's ready to work on (no blockers)
- `bd show [id]` - View task details and dependencies
- `bd update [id] --claim` - Claim a task
- `bd close [id]` - Complete a task
- `bd blocked` - See what's currently blocked
- `bd list --status=in_progress` - See your active work

**Status Source**: Beads is the source of truth for all task status. Do NOT use markdown checkboxes for tracking.
