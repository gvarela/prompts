---
project: implement-rename-3.0
ticket: prompts-h7c
created: 2026-09-05
created_timestamp: 2026-09-06T00:23:23Z
status: not-started
last_updated: 2026-09-06
assignee: gabe@vare.la
# progress fields below are maintained by /wb:update_status — do not hand-edit
current_phase: 1
total_tasks: 17
completed_tasks: 0
git_commit: 447a1c618f330ec439547f4c564a7bce364be90b
git_branch: worktree-implement-rename-3.0
repository: gvarela/workbench
tags: [tasks, tracking, implement-rename-3.0]
depends_on: [research.md, design.md]
beads_epic: prompts-tq7
beads_phases:
  phase1_milestone: prompts-1ng
  phase2_milestone: prompts-h1y
beads_tasks:
  # Phase 1 tasks
  phase1_impl_1: prompts-33l
  phase1_impl_2: prompts-ds5
  phase1_impl_3: prompts-4ni
  phase1_impl_4: prompts-fr8
  phase1_impl_5: prompts-nqw
  phase1_impl_6: prompts-97q
  phase1_test_1: prompts-32z
  phase1_integration_1: prompts-f00
  # Phase 2 tasks
  phase2_impl_1: prompts-q4fm
  phase2_impl_2: prompts-on4
  phase2_impl_3: prompts-oxe
  phase2_impl_4: prompts-mcvf
  phase2_impl_5: prompts-8d5t
  phase2_impl_6: prompts-o5q4
  phase2_impl_7: prompts-irau
  phase2_test_1: prompts-84lh
  phase2_integration_1: prompts-30s1
---

# Execution Plan: implement-rename-3.0

## Overview

Implementing the rename of `implement_coordinated` to `implement` and `implement_tasks` to `implement_inline` with deprecated aliases, the removal of the `create_execution` alias, three ride-along corrections, and the RELEASING.md bundling rule, shipped as 3.0.0 as specified in design.md.

**Design Approach**: alias-rename-bundled-major (design.md "Design Approach")
**Target State**: the new commands resolve and the old names redirect with a notice; `create_execution` is gone; every live rendering names `implement` as the default; beads-mode.md is the single persistence statement; lint's exit code reflects findings; one tier-rule statement; RELEASING.md carries the bundling rule; 3.0.0 cut and tagged (design.md "Success Metrics")

## Implementation Strategy

### Phase Rationale

Design D9 sets the order: non-breaking phases merge to main unbumped under an Unreleased heading, and the breaking phase goes last and carries the bump in its own PR. Phase 1 is therefore every correction that does not rename or remove a command (D6, D7, D8, D9), landed on the current paths. Phase 2 is the rename, the aliases, the alias removal, the doc sweep, and the 3.0.0 cut, in one PR, because RELEASING.md fact 2 forbids a state on main where `create_execution` is gone and the version is still 2.x.

Based on dependency analysis:

- Phase 1 edits `implement_tasks/SKILL.md` and `implement_coordinated/SKILL.md` (auto-flush lines) and `implement_coordinated/reference.md` (tier paragraph); Phase 2 moves those files. Doing the corrections first on the old paths keeps git's rename detection intact when the directories move (the v2.2.0 rename was detected at R097 to R099 similarity; a move combined with in-file edits risks falling below the threshold).
- Nothing in `plugin/` resolves either skill by path; every in-directory link is same-directory or `../../docs/reference/`, so the directory move needs no link rewrites beyond the alias stubs.
- The 67 name occurrences across 26 files split into current-state mentions (renamed) and dated narrative in maintainer docs (kept); the per-task lists below make that call line by line.
- Design assumption prompts-7mo (a single-word `implement` directory resolves) is validated by task 2.1's dry run before the two sweep tasks start, as the design's risk table requires.
- Inside each phase the graph branches: Phase 1 has three independent roots (lint, beads-mode.md, reference.md); Phase 2 has two (the move, the deletion).

### Testing Strategy

No test framework (research.md §12). Four mechanisms:

- **Grep audits**: each task states the grep and its expected result.
- **Lint fixture**: two files under `/Users/gabevarela/.claude/jobs/ab08d664/tmp/` (one malformed, one clean) exercise the exit code in each mode after task 1.1. `lint --all` is expected to exit 1 on the pre-existing backlog of about 58 files after the fix; it is not a gate.
- **Per-file lint delta**: for every touched file, `git show HEAD:<file> > $CLAUDE_JOB_DIR/tmp/baseline.md; ./plugin/scripts/lint $CLAUDE_JOB_DIR/tmp/baseline.md` versus `./plugin/scripts/lint <file>`; "clean" means no new `⚠ Issues found in:` line and no new error lines relative to baseline.
- **Headless `--plugin-dir` runs**: `claude --plugin-dir plugin --model sonnet -p "<prompt>" --output-format stream-json --verbose --max-turns 3`, grepping the stream for `"skill":"wb:<name>"` events and notice text. Runs stop at the first permission prompt; macOS has no `timeout`, so use `--max-turns` or the tool timeout.

Suggested worker models (design.md model map; Gabe's 2026-09-06 preference for lower models): sonnet at `effort: xhigh` for every task below, haiku for none (each sweep needs the current-versus-historical judgment), fable only on a verified failure per the escalation rule.

## Progress Overview

Progress is tracked in beads. To check current status:

```bash
bd stats                    # Overall project statistics
bd list --status=closed     # See completed tasks
bd list --status=in_progress # See active work
bd ready                    # See available work
```

**Phase status**:

- Phase 1: See beads milestone `[beads:phase1_milestone]` - depends on 8 tasks
- Phase 2: See beads milestone `[beads:phase2_milestone]` - depends on 9 tasks

Use `bd show [milestone-id]` to see which tasks block each phase milestone.

---

## Phase 1: Non-Breaking Corrections

### Phase 1 Objective

Land the lint exit code fix, the beads persistence correction, the reference.md pointer, and the RELEASING.md bundling rule on the current paths, merged to main with no version bump under a CHANGELOG Unreleased heading.

### Phase 1 Prerequisites

- [ ] Research complete (research.md `status: complete`)
- [ ] Design approved (design.md `status: approved`)
- [ ] Working branch `worktree-implement-rename-3.0` at or after 447a1c6 (origin/main 70c50bd plus the plan commits); every `file:line` below re-read before editing
- [ ] `markdownlint`, `jq`, and `gh` on PATH (confirmed 2026-09-06)

### Phase 1 Changes Required

#### 1. Lint exit code

**File**: `plugin/scripts/lint`

**Current State** (research.md §8): `ISSUES_FOUND=false` at line 181; the markdownlint loop at lines 184-200 is `echo "$FILES" | while read -r file; do … done`, so the `ISSUES_FOUND=true` at line 193 is set in a pipeline subshell; line 209 reads the parent's value and exits 0 at line 215; the `--fix`-with-findings branch (lines 216-221) has no `exit`.

**Target State** (design.md D7): exit 1 when any file had a markdownlint error, in named-file, changed-files, and `--all` modes; a defined exit on the `--fix` path; `plugin/scripts/lint-hook` unchanged and still exiting 0.

**Implementation**:

```bash
# lines 184 and 200: replace the pipeline with a here-string so the loop runs in the current shell
while read -r file; do
    …
done <<< "$FILES"

# lines 216-221: give the --fix branch an exit
else
    if [ -z "$AUTO_FIX" ]; then
        echo -e "${YELLOW}⚠️  Markdown linting issues found${NC}"
        echo "Run '$0 --fix' to auto-fix issues"
    else
        echo -e "${YELLOW}⚠️  Some issues could not be auto-fixed — see the lines above${NC}"
    fi
    exit 1
fi
```

The display-only listing loop at lines 148-150 may stay as a pipeline. `lint-hook` line 23 tests the grep pipeline, not lint's exit code, and lines 24 and 27 both `exit 0`; no change.

#### 2. Beads persistence text

**File**: `plugin/docs/reference/beads-mode.md` lines 17-35

**Current State** (research.md §7): line 19 states beads "auto-flushes `.beads/issues.jsonl` after changes. There is no manual export step."; lines 26-33 tell git mode to `git add .beads/` at session end.

**Target State** (design.md D6): the single statement of persistence mechanics; `issues.jsonl` is written only with `export.auto` on or an explicit `bd export`; git mode needs one of those before committing.

**Implementation** (replace lines 17-22):

```markdown
## Persistence Mechanics (bd 1.0.2+)

- Beads auto-commits mutations to its embedded Dolt database under `.beads/`. The database is the source of truth in both modes.
- `.beads/issues.jsonl` is an export, not a mirror. bd writes it only when `export.auto` is on (`bd config set export.auto true`, default off) or when you run `bd export > .beads/issues.jsonl`. Without one of those the file goes stale while the database moves on (observed 2026-09-05: five weeks stale, 92 of 156 issues).
- Git mode therefore needs `export.auto` on once per clone before `.beads/` is committed. After `git pull` updates `issues.jsonl`, beads imports the changes.
- Remote *database* sync (separate from git) is `bd dolt push` / `bd dolt pull`, only when a Dolt remote is configured.
```

And in the git-mode block (lines 26-33), add one line before the snippet: `Prerequisite:`export.auto`on (see above); otherwise the commit carries a stale export.`

#### 3. Auto-flush claim sweep, plugin skills

**Files and lines** (research.md §7): `plugin/skills/implement_tasks/SKILL.md:399, 402, 530, 566`; `plugin/skills/implement_coordinated/SKILL.md:373, 376`; `plugin/skills/create_handoff/SKILL.md:124, 128, 148`; `plugin/skills/resume_handoff/SKILL.md:70, 87, 96`; `plugin/skills/status-sync/SKILL.md:30, 48`; `plugin/skills/update_status/SKILL.md:235, 238, 251, 252`; `plugin/skills/help/SKILL.md:104, 152-153`.

**Target State** (design.md D6): each site drops the auto-flush claim or points at beads-mode.md. Lines that only say "commit `.beads/` in git mode" keep that instruction.

**Implementation rule**, with two worked examples:

- `implement_tasks/SKILL.md:399` `5. **Persist beads state** (beads auto-flushes`.beads/issues.jsonl`after mutations):` → `5. **Persist beads state** (git mode needs`export.auto`on; see [docs/reference/beads-mode.md](../../docs/reference/beads-mode.md)):`
- `help/SKILL.md:104` `# beads auto-flushes .beads/issues.jsonl; commit .beads/ in git mode` → `# git mode: export.auto on, then commit .beads/ (see plugin/docs/reference/beads-mode.md)`
- Every other listed line: delete the words `auto-flush`, `auto-flushes`, `auto-flushed`, and `nothing to run` claims; where the sentence would lose its point, replace with the pointer. `beads-drift-check.sh` and `beads-not-initialized.md:13` make no auto-flush claim and are untouched.

#### 4. Auto-flush claim sweep, docs

**Files and lines** (research.md §7): `docs/commands-reference.md:75-76`; `docs/workbench-workflow-guide.md:429, 432, 437, 495, 497, 520, 522, 844`; `docs/beads-integration-learnings.md:258`.

**Implementation**: same rule as item 3. `beads-integration-learnings.md:258` is a learnings entry stated as current fact; rewrite it to the export condition and date the correction (2026-09-05, prompts-vwo).

#### 5. Worker Model Selection pointer

**File**: `plugin/skills/implement_coordinated/reference.md:58-60`

**Current State** (research.md §9): the paragraph restates the tiers with "opus (bugs/refactors/architecture; default when unsure)".

**Target State** (design.md D8): a pointer, no tier restatement.

**Implementation** (replace line 60):

```markdown
The `determineModel()` keyword-regex spec was retired in favor of coordinator judgment (2026-06, prompts-0my). The tier rule lives in one place, SKILL.md Step 5 item 4 ("Determine model"), and is not restated here; the choice is passed as a per-spawn model override on the `task-worker` agent.
```

#### 6. RELEASING.md bundling rule and CHANGELOG Unreleased

**Files**: `RELEASING.md:25-31` (Process), `CHANGELOG.md:5` (insert before the 2.6.0 heading)

**Current State** (research.md §10): five Process items; item 1 permits unbumped non-breaking merges; item 3 names `lint --all`; item 4 is the canary; no cut timing, no tagging, no Unreleased section in CHANGELOG.

**Target State** (design.md D9; D7 trade-off): six items, as below; CHANGELOG gains `## [Unreleased]` carrying the Phase 1 entries.

**Implementation** (replace the Process list):

```markdown
1. **One concern per branch/PR**, phase-sized. Non-breaking phases merge to main with no version bump and are listed under `## [Unreleased]` in CHANGELOG.md (fact 2 above still holds: main stays releasable).
2. **When to cut**: when the plan completes, or earlier only when wb sessions in other repositories need a shipped phase — this repository's own sessions run `--plugin-dir` and never wait. A breaking phase is the last phase of its plan and carries the bump in its own PR. If the breaking piece must land early, the whole plan lives on a release branch, dogfooded through `--plugin-dir`, and merges with the bump.
3. **Cutting a release**: move Unreleased → version + date in CHANGELOG.md (write Migration notes if anything breaks), bump both manifests, merge, push, then tag the commit main carries the bump on: `git tag vX.Y.Z <sha> && git push origin vX.Y.Z`. Every cut is tagged; the tag is the rollback anchor.
4. **Verification before any bump**: `./plugin/scripts/lint <file>` on every touched file with a zero delta against HEAD (`lint --all` exits 1 on the pre-existing backlog until that backlog is cleared, so it is not the gate), the grep audits, and a `--plugin-dir` smoke session (`/wb:` menu correct, `/wb:help` renders, one workflow skill's intake flow works). As the eval harness lands, this becomes: Tier 0 on every PR, Tier 2 golden runs before any bump, Tier 3 before anything behavior-shaping.
5. **Canary for majors**: the maintainer runs at least three real sessions on the release branch through `--plugin-dir` before the bump; one volunteer installer updates first; announce to the rest after a quiet interval.
6. **Announce**: tell installers the version, the one-line summary, and any migration steps (link the changelog entry). Updates are pull-based — the changelog is their entire decision input.
```

CHANGELOG insert after line 3:

```markdown
## [Unreleased]

### Changed

- `RELEASING.md` Process: non-breaking phases merge unbumped under Unreleased; a cut happens when a plan completes; the breaking phase goes last and carries the bump; every cut is tagged; majors get a three-session canary on the release branch.
- Beads persistence: `plugin/docs/reference/beads-mode.md` is the single statement. `issues.jsonl` is written only with `export.auto` on or an explicit `bd export`; the auto-flush claim is removed from ten skill and doc sites (prompts-vwo).
- `implement_coordinated/reference.md` "Worker Model Selection" points at the SKILL.md Step 5 tier list instead of restating it with opus as the default when unsure.

### Fixed

- `plugin/scripts/lint` exits 1 when markdownlint reports an error, in named-file, changed-files, and `--all` modes, and exits 1 from `--fix` when findings remain; it had always exited 0 (prompts-3ke). The PostToolUse hook still exits 0.
```

### Phase 1 Tasks

**Note**: Task status is tracked ONLY in beads. The tasks below document WHAT needs to be done. For STATUS, run `bd list` or check frontmatter `beads_tasks` for IDs.

#### Phase 1 Implementation Tasks

- Fix the lint exit code in `plugin/scripts/lint` (here-string loop, `--fix` exit) → `[beads:phase1_impl_1]`
  - Verify: write `$CLAUDE_JOB_DIR/tmp/bad.md` (`#Bad Heading` and mixed `*`/`+` list markers) and `$CLAUDE_JOB_DIR/tmp/clean.md`; `./plugin/scripts/lint $CLAUDE_JOB_DIR/tmp/bad.md; echo $?` → 1; same on clean.md → 0; `./plugin/scripts/lint --fix $CLAUDE_JOB_DIR/tmp/clean.md; echo $?` → 0; copy bad.md under `docs/` untracked, `./plugin/scripts/lint; echo $?` → 1, then remove it; `echo '{"tool_input":{"file_path":"'$CLAUDE_JOB_DIR'/tmp/bad.md"}}' | ./plugin/scripts/lint-hook; echo $?` → 0
- Rewrite Persistence Mechanics in `plugin/docs/reference/beads-mode.md` → `[beads:phase1_impl_2]`
  - Verify: `grep -c "export.auto" plugin/docs/reference/beads-mode.md` → 2 or more; `grep -c "auto-flush" plugin/docs/reference/beads-mode.md` → 0
- Remove the auto-flush claim from seven skills (implement_tasks, implement_coordinated, create_handoff, resume_handoff, status-sync, update_status, help) → `[beads:phase1_impl_3]`
  - Consumes 1.2's wording for the pointers; verify: `grep -rn "auto-flush" plugin/skills` → none
- Remove the auto-flush claim from `docs/commands-reference.md`, `docs/workbench-workflow-guide.md`, `docs/beads-integration-learnings.md` → `[beads:phase1_impl_4]`
  - Consumes 1.2's wording; verify: `grep -rln "auto-flush" --include=*.md . | grep -v "^./CHANGELOG.md" | grep -v "^./docs/plans/"` → none
- Replace the tier paragraph in `plugin/skills/implement_coordinated/reference.md:60` with the pointer → `[beads:phase1_impl_5]`
  - Verify: `grep -n "default when unsure" plugin/skills/implement_coordinated/reference.md` → none; `grep -c "Step 5 item 4" plugin/skills/implement_coordinated/reference.md` → 1
- Amend the RELEASING.md Process list and add the CHANGELOG Unreleased section → `[beads:phase1_impl_6]`
  - Verify: `sed -n '27,32p' RELEASING.md | grep -c "^[0-9]\. \*\*"` → 6 (the whole-file count is 8: lines 14-15 are the two numbered facts under The channel model); `grep -n "Every cut is tagged\|three real sessions\|not the gate" RELEASING.md` → 3 lines; `grep -n "^## \[Unreleased\]" CHANGELOG.md` → line 5

#### Phase 1 Testing Tasks

- Phase 1 verification → `[beads:phase1_test_1]`
  - After 1.1 through 1.6; every grep above returns its stated result; per-file lint delta against HEAD is zero on all eleven touched files (list in Modified Files); `./plugin/scripts/lint --all; echo $?` → 1 with only pre-existing findings (record the count); headless `claude --plugin-dir plugin --model sonnet -p "run /wb:help" --output-format stream-json --verbose --max-turns 2` shows `"skill":"wb:help"`

#### Phase 1 Integration Tasks

- Open the Phase 1 PR against main, no version bump → `[beads:phase1_integration_1]`
  - After 1.7; title `Non-breaking corrections ahead of 3.0.0: lint exit code, beads persistence text, release bundling rule`; body lists the three closed issues (prompts-vwo, prompts-3ke closed by this PR; prompts-h7c stays open) and the Unreleased entries; draft PR; merge is the checkpoint

### Phase 1 Success Criteria

#### Phase 1 Automated Verification

- [ ] Every grep in 1.1 through 1.6 returns the stated result
- [ ] Lint fixture: bad.md → 1, clean.md → 0, hook → 0
- [ ] Per-file lint delta zero on every touched file

#### Phase 1 Manual Verification

- [ ] PR merged to main with no version bump (merge stands as human confirmation per the merge-as-checkpoint convention)
- [ ] `bd close prompts-vwo prompts-3ke` on merge

### Phase 1 Modified Files

- `plugin/scripts/lint` — loop and `--fix` exit
- `plugin/docs/reference/beads-mode.md` — Persistence Mechanics
- `plugin/skills/implement_tasks/SKILL.md`, `plugin/skills/implement_coordinated/SKILL.md`, `plugin/skills/create_handoff/SKILL.md`, `plugin/skills/resume_handoff/SKILL.md`, `plugin/skills/status-sync/SKILL.md`, `plugin/skills/update_status/SKILL.md`, `plugin/skills/help/SKILL.md` — auto-flush lines
- `docs/commands-reference.md`, `docs/workbench-workflow-guide.md`, `docs/beads-integration-learnings.md` — auto-flush lines
- `plugin/skills/implement_coordinated/reference.md` — tier pointer
- `RELEASING.md`, `CHANGELOG.md` — Process list, Unreleased

**Quick check command for this phase**:

```bash
grep -rn "auto-flush" plugin docs --include=*.md | grep -v docs/plans; ./plugin/scripts/lint $CLAUDE_JOB_DIR/tmp/bad.md; echo "exit=$?"
```

### ⛔ CHECKPOINT: Phase 1 Complete

Before proceeding to Phase 2:

1. ✅ All Phase 1 task beads issues closed (`bd list --status=closed`)
2. ✅ Phase 1 milestone beads issue closed
3. ✅ All automated verification passing
4. ✅ PR merged (human confirmation); prompts-vwo and prompts-3ke closed
5. ✅ Reconcile plan-doc status via `/wb:update_status` (sole writer of the progress fields)

**Verification**: Run `bd show [beads:phase1_milestone]` to confirm all blocking tasks are closed.

**Do not proceed without human confirmation of manual tests.**

---

## Phase 2: Rename, Aliases, Removal, and the 3.0.0 Cut

### Phase 2 Objective

Move the two skill directories to their new names, leave alias stubs with pointer files, delete `create_execution`, sweep every live rendering to the new default, and cut 3.0.0 in the same PR, tagged on the merge.

### Phase 2 Prerequisites

- [ ] Phase 1 merged (milestone `[beads:phase1_milestone]` closed); branch rebased onto that main
- [ ] Fable or Opus available for escalation only; workers on sonnet

### Phase 2 Changes Required

#### 1. Directory move and in-file naming

**Files**: `plugin/skills/implement_coordinated/` (5 files) → `plugin/skills/implement/`; `plugin/skills/implement_tasks/` (2 files) → `plugin/skills/implement_inline/`

**Current State** (research.md §3; dependency inventory): `name:` at `implement_coordinated/SKILL.md:2` and `implement_tasks/SKILL.md:2`; example invocations at `implement_coordinated/SKILL.md:27` (`/implement_coordinated docs/plans/… 1`) and `implement_tasks/SKILL.md:18`; "original `implement_tasks`" mentions at `implement_coordinated/SKILL.md:52, 281, 424, 428`; H1 titles naming the skill at `implement_coordinated/README.md:1`, `reference.md:1`, `sub-agent-prompts.md:1`, `templates.md:1`, `implement_tasks/templates.md:1`. Every internal link is same-directory or `../../docs/reference/`, so none change.

**Target State** (design.md D1): directory and `name:` renamed together; in-file self-references in the new names; descriptions carry the discrimination (`implement` is the default; `implement_inline` runs on the session model).

**Implementation**:

```bash
git mv plugin/skills/implement_coordinated plugin/skills/implement
git mv plugin/skills/implement_tasks plugin/skills/implement_inline
```

Then, in the moved files: `name: implement` / `name: implement_inline`; example lines to `/implement docs/plans/2025-01-08-my-project/ 1` and `/implement_inline …`; the four "original `implement_tasks`" phrases to "`implement_inline`"; each H1 to `# implement — …` / `# implement_inline — Output Templates`. Descriptions:

- `implement/SKILL.md:3`: `Implement a project's tasks.md by coordinating fresh-context worker agents (one per task, model chosen per task), verifying each with a task-verifier, and escalating verified failures. The default execution path: use when the user asks to implement, build, or execute a planned phase, asks for workers or coordination, or wants the main context kept clean. Takes the project directory and a phase number or continue.`
- `implement_inline/SKILL.md:3`: `Implement a project's tasks.md in this session with TDD (red, green, refactor), beads claim and close per task, and a human checkpoint at each phase boundary. Use only when the user asks for the work done inline, in this session, or on the session model rather than by workers (for example a full-Fable run). Takes the project directory and a phase number or continue.`

**Dry run** (design assumption prompts-7mo, before 2.5 and 2.6 start): `claude --plugin-dir plugin --model sonnet -p "run /wb:implement" --output-format stream-json --verbose --max-turns 2` → stream contains `"skill":"wb:implement"`; same for `implement_inline`. Record the proof lines in Implementation Notes and close prompts-7mo.

#### 2. Alias stubs and pointer files

**Files**: `plugin/skills/implement_coordinated/{SKILL,README,reference,sub-agent-prompts,templates}.md` (new), `plugin/skills/implement_tasks/{SKILL,templates}.md` (new)

**Pattern Reference**: `plugin/skills/create_execution/SKILL.md:1-24`, `examples.md:1-5` (research.md §4). Four pointer files for `implement` (its four supporting files), one for `implement_inline`; design.md D2's "five" counted SKILL.md.

**Implementation** (`implement_coordinated/SKILL.md`; the `implement_tasks` stub is the same with `implement_inline`, `argument-hint` unchanged, and "the in-session path" wording):

```markdown
---
name: implement_coordinated
description: Deprecated alias of implement — use /wb:implement (removed at 4.0.0)
argument-hint: [project-directory] [phase-number|continue]
disable-model-invocation: true
allowed-tools: Read
---

# Implement Coordinated (Deprecated Alias)

This command was renamed to `/wb:implement`: coordinated execution is the recommended path, so it takes the plain verb; the in-session path is `/wb:implement_inline`. The alias remains through 3.x and is removed at 4.0.0.

## Behavior

1. **Tell the user once, up front**:

   ```

   Note: /wb:implement_coordinated is now /wb:implement — same skill, new name.
   This alias works through 3.x and will be removed at 4.0.0.

   ```

2. **Then run the canonical skill**: Read [../implement/SKILL.md](../implement/SKILL.md) NOW and follow it exactly, passing through any arguments unchanged. Its supporting files (sub-agent-prompts.md, templates.md, reference.md, README.md) live in `../implement/` — resolve every "read X NOW" directive there.

Do not duplicate any behavior here; the canonical skill is the single source of truth.
```

Pointer file shape (one per supporting file, target path substituted):

```markdown
# Moved

This skill was renamed to `implement`. This pointer file exists so sessions holding a stale pre-rename skill body still resolve their reads instead of erroring.

Read [../implement/reference.md](../implement/reference.md) and use it as directed.
```

#### 3. Remove `create_execution`

**Files**: `plugin/skills/create_execution/` (4 files, deleted)

**Implementation**: `git rm -r plugin/skills/create_execution`. The three live sentences that describe it (`CLAUDE.md:13`, `docs/claude-code-skills-guide.md:310`, `plugin/skills/help/SKILL.md:185`) are rewritten by the sweep tasks that own those files (2.5 owns help; 2.6 owns CLAUDE.md and the skills guide), to say the two implement aliases are the user-only skills.

#### 4. Canonical skill prose in the new names

**File**: `plugin/skills/implement/README.md` (whole file, 55 lines)

**Current State**: "Evolution from implement_tasks" (line 5), "Sequential (`implement_tasks`)" / "Coordinated (`implement_coordinated`)" (20, 27), "Migration from implement_tasks" (49-55) with step 3 "Use `/wb:implement_coordinated` instead of `/wb:implement_tasks`".

**Target State** (design.md D5): the same rationale in the new names, with the relationship stated the new way round: `implement` is the default, `implement_inline` is the in-session path; the Migration section becomes "Choosing implement_inline" (when the session model should do the coding itself, for example a full-Fable phase) and the comparison headings read **Inline** (`implement_inline`) and **Coordinated** (`implement`).

#### 5. Rendering sweep, plugin side

**Files and lines** (dependency inventory): `plugin/skills/help/SKILL.md:41, 185, 187`; `plugin/skills/create_project/templates.md:31, 50`; `plugin/skills/create_project/SKILL.md:138`; `plugin/skills/create_tasks/SKILL.md:304`; `plugin/skills/create_handoff/SKILL.md:252`; `plugin/skills/resume_handoff/SKILL.md:345, 353`; `plugin/skills/validate_execution/SKILL.md:211`; `plugin/skills/validate_project/templates.md:113`; `plugin/agents/task-worker.md:3`; `plugin/docs/reference/beads-not-initialized.md:3`.

**Target State** (design.md D4, D5): every `/wb:implement_tasks` "continue" or sequence line becomes `/wb:implement`; the help diagram line 41 reads `/wb:implement          → Execute with workers (verify, escalate)` and gains a line under it `/wb:implement_inline   → Same plan, coded by this session (TDD)`; help line 185 drops the create_execution parenthetical; help line 187 heading becomes `###`/wb:implement [directory] [phase|continue]`` with an `implement_inline` heading added in the same shape; task-worker.md:3 ends `Spawned by /wb:implement with a per-task model override.`; beads-not-initialized.md:3 lists `implement`, `implement_inline`, `create_tasks`.

#### 6. Rendering sweep, root and docs

**Files and lines** (dependency inventory): `README.md:57, 79, 80`; `CLAUDE.md:13, 86`; `docs/commands-reference.md:24, 62, 385, 392, 636, 737`; `docs/workbench-workflow-guide.md:56, 73, 74, 285, 483`; `docs/claude-code-skills-guide.md:310, 314`; `docs/subagent-tool-call-ceiling.md:6, 66, 69, 89, 133`; `docs/beads-integration-learnings.md:202, 203`.

**Kept as dated narrative** (not renamed): `docs/subagent-tool-call-ceiling.md:4` ("Found: 2026-08-19, during a long `/wb:implement_coordinated` run") and `:126` (`create_execution` in an August note); `docs/beads-integration-learnings.md:45, 90, 248` (task histories naming the commands of the day); `docs/claude-code-skills-guide.md:310`'s quoted history stays, its last sentence becomes "Only the deprecated `implement_coordinated` and `implement_tasks` aliases keep `disable-model-invocation: true`, so the model never picks them over `implement` and `implement_inline`."

**Target State** (design.md D4, D5): sequences end in `/wb:implement`; README.md:79-80 become `/wb:implement` (default, workers) and `/wb:implement_inline` (this session); the workflow-guide model-map rows keep their model text under the new names; `CLAUDE.md:13` names the two aliases as the user-only skills; `docs/commands-reference.md:385-392` section heading and usage in the new name with an `implement_inline` subsection added after it; `:737` lists `implement/SKILL.md` and `implement_inline/SKILL.md`.

#### 7. CHANGELOG 3.0.0 and manifests

**Files**: `CHANGELOG.md` (Unreleased → `## [3.0.0] — <date>`), `plugin/.claude-plugin/plugin.json:3`, `.claude-plugin/marketplace.json:12`

**Pattern Reference**: `CHANGELOG.md:96-140` (2.0.0: Breaking, Changed, Fixed, Added, Migration); `CHANGELOG.md:70, 82` (2.2.0 rename bullets).

**Implementation** (entry skeleton; the Changed and Fixed bullets are the Unreleased ones from task 1.6):

```markdown
## [3.0.0] — YYYY-MM-DD

The rename release. `implement` is the default execution path, `implement_inline` the in-session one, and the alias promised for removal at 3.0.0 is gone. Plan: `docs/plans/2026-09-05-prompts-h7c-implement-rename-3.0/`.

### ⚠️ Breaking / Requirements

- **`/wb:create_execution` removed** (deprecated since 2.2.0). Use `/wb:create_tasks`.
- **Renamed**: `/wb:implement_coordinated` → `/wb:implement`, `/wb:implement_tasks` → `/wb:implement_inline`. The old names keep working as deprecated aliases through 3.x (removed at 4.0.0): each prints a one-line notice and runs the canonical skill unchanged. **Gotcha**: a session started before this release may hold a cached pre-rename skill body — restart the session (or `/reload-skills`) after updating; the alias directories keep pointer files for their old supporting files so stale references degrade gracefully.

### Changed

- (Unreleased bullets from Phase 1, plus:) `implement` is the default in every workflow rendering, the generated project README, the help diagram, and the model map; `implement_inline` is documented beside it as the session-model path. `task-worker` names `/wb:implement` as its spawner.

### Fixed

- (Unreleased lint bullet.)

### Migration

1. `claude plugin update wb@gvarela-workbench` from your shell, then restart Claude (or `/reload-plugins`).
2. Optionally switch to the new names; the old ones print a notice until 4.0.0. Replace any `/wb:create_execution` with `/wb:create_tasks`.
3. Git-mode beads users: run `bd config set export.auto true` once per clone before committing `.beads/` (the docs had claimed this was automatic).
```

Both manifests: `"version": "3.0.0"`.

### Phase 2 Tasks

#### Phase 2 Implementation Tasks

- Move the two skill directories and rename every in-file self-reference; rewrite the two descriptions; run the resolution dry run → `[beads:phase2_impl_1]`
  - Verify: `ls plugin/skills/implement plugin/skills/implement_inline` → 5 and 2 files; `grep -n "^name:" plugin/skills/implement/SKILL.md plugin/skills/implement_inline/SKILL.md` → `implement`, `implement_inline`; `grep -rn "implement_coordinated\|implement_tasks" plugin/skills/implement plugin/skills/implement_inline` → none; dry-run proof lines recorded; `bd close prompts-7mo`
- Create the alias stubs and pointer files at the old directory names → `[beads:phase2_impl_2]`
  - After 2.1 (the target files must exist); verify: `ls plugin/skills/implement_coordinated plugin/skills/implement_tasks` → 5 and 2 files; `grep -c "removed at 4.0.0" plugin/skills/implement_coordinated/SKILL.md plugin/skills/implement_tasks/SKILL.md` → 2 each (description and body) plus the notice line; for every pointer file, the `../implement/…` or `../implement_inline/…` target passes `test -f`; headless `-p "run /wb:implement_coordinated"` stream shows `"skill":"wb:implement_coordinated"` and the notice text
- Delete `plugin/skills/create_execution/` → `[beads:phase2_impl_3]`
  - Verify: `test -d plugin/skills/create_execution; echo $?` → 1; `git status --short plugin/skills/create_execution` shows four `D` entries
- Rewrite `plugin/skills/implement/README.md` in the new names and relationship → `[beads:phase2_impl_4]`
  - After 2.1 (file moved); verify: `grep -c "implement_inline" plugin/skills/implement/README.md` → 3 or more; `grep -n "implement_tasks\|implement_coordinated" plugin/skills/implement/README.md` → none
- Sweep the plugin-side renderings (help, create_project templates and SKILL, create_tasks, create_handoff, resume_handoff, validate_execution, validate_project templates, task-worker, beads-not-initialized) → `[beads:phase2_impl_5]`
  - After 2.1 (names validated by the dry run); verify: `grep -rn "implement_tasks\|implement_coordinated\|create_execution" plugin --include=*.md | grep -v "^plugin/skills/implement_coordinated/\|^plugin/skills/implement_tasks/"` → none; `grep -c "/wb:implement_inline" plugin/skills/help/SKILL.md` → 2 or more; `grep -n "Spawned by /wb:implement " plugin/agents/task-worker.md` → 1
- Sweep the root and docs renderings (README.md, CLAUDE.md, commands-reference, workflow guide, skills guide, subagent-tool-call-ceiling, beads-integration-learnings) → `[beads:phase2_impl_6]`
  - After 2.1; verify: `grep -rn "implement_tasks\|implement_coordinated\|create_execution" README.md CLAUDE.md docs --include=*.md | grep -v "^docs/plans/"` → exactly the six kept-narrative lines (`subagent-tool-call-ceiling.md:4, 126`; `beads-integration-learnings.md:45, 90, 248`; `claude-code-skills-guide.md:310`'s history clause) and `CLAUDE.md:13`'s alias mention; `grep -c "/wb:implement\b" CLAUDE.md README.md docs/commands-reference.md docs/workbench-workflow-guide.md` → 1 or more each
- Write the CHANGELOG 3.0.0 entry and bump both manifests → `[beads:phase2_impl_7]`
  - After 2.2 and 2.3 (the two breaking artifacts it announces); verify: `grep -n "^## \[3.0.0\]\|^### ⚠️ Breaking\|^### Migration" CHANGELOG.md` → 3 lines; `grep -c "^## \[Unreleased\]" CHANGELOG.md` → 0; `jq -r .version plugin/.claude-plugin/plugin.json` = `jq -r '.plugins[0].version' .claude-plugin/marketplace.json` = `3.0.0`

#### Phase 2 Testing Tasks

- Phase 2 verification → `[beads:phase2_test_1]`
  - After 2.1 through 2.7. Sweep-miss check: `grep -rl "implement_coordinated\|implement_tasks\|create_execution" --include=*.md . | grep -v "^./plugin/skills/implement_coordinated/\|^./plugin/skills/implement_tasks/\|^./CHANGELOG.md\|^./docs/plans/"` → only the kept-narrative files from 2.6. Per-file lint delta zero on every touched file. Headless: `-p "run /wb:help"` output names `implement` and `implement_inline`; `-p "implement phase 2 of the plan"` stream shows `"skill":"wb:implement"`; `-p "implement this phase inline in this session, no workers"` shows `"skill":"wb:implement_inline"`; `-p "what does implement_inline do"` shows no `wb:implement` skill event; record the three outcomes and close prompts-zmy (or reopen the description question if routing fails, per design.md risk table)
  - Three real `--plugin-dir` sessions on the branch before the bump PR merges (RELEASING.md item 5 as amended); note each in Implementation Notes

#### Phase 2 Integration Tasks

- Open the 3.0.0 PR, merge, tag, update the installed plugin, close out → `[beads:phase2_integration_1]`
  - After 2.7 and 2.8; draft PR titled `Rename implement_coordinated → implement and implement_tasks → implement_inline; remove create_execution (v3.0.0)`; body carries the Breaking and Migration sections; merge is the checkpoint; then `git tag v3.0.0 <merge-sha> && git push origin v3.0.0`; `claude plugin update wb@gvarela-workbench` and a fresh session shows 3.0.0 in `claude plugin list`; `bd close prompts-h7c`; run `/wb:update_status docs/plans/2026-09-05-prompts-h7c-implement-rename-3.0`

### Phase 2 Success Criteria

#### Phase 2 Automated Verification

- [ ] Every grep in 2.1 through 2.7 returns the stated result
- [ ] Sweep-miss grep returns only the kept-narrative files
- [ ] Manifests match at 3.0.0; `git tag --points-at <merge-sha>` shows `v3.0.0`

#### Phase 2 Manual Verification

- [ ] Dry run proves `/wb:implement` and `/wb:implement_inline` resolve (prompts-7mo closed)
- [ ] Routing test recorded (prompts-zmy closed or reopened)
- [ ] Three canary sessions noted
- [ ] PR merged; installed plugin at 3.0.0 in a fresh session

### Phase 2 Modified Files

- `plugin/skills/implement/` (moved from implement_coordinated; SKILL.md, README.md edited), `plugin/skills/implement_inline/` (moved from implement_tasks; SKILL.md edited)
- `plugin/skills/implement_coordinated/` (5 new alias files), `plugin/skills/implement_tasks/` (2 new alias files)
- `plugin/skills/create_execution/` (deleted)
- `plugin/skills/help/SKILL.md`, `plugin/skills/create_project/{SKILL,templates}.md`, `plugin/skills/create_tasks/SKILL.md`, `plugin/skills/create_handoff/SKILL.md`, `plugin/skills/resume_handoff/SKILL.md`, `plugin/skills/validate_execution/SKILL.md`, `plugin/skills/validate_project/templates.md`, `plugin/agents/task-worker.md`, `plugin/docs/reference/beads-not-initialized.md`
- `README.md`, `CLAUDE.md`, `docs/commands-reference.md`, `docs/workbench-workflow-guide.md`, `docs/claude-code-skills-guide.md`, `docs/subagent-tool-call-ceiling.md`, `docs/beads-integration-learnings.md`
- `CHANGELOG.md`, `plugin/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`

**Quick check command for this phase**:

```bash
grep -rl "implement_coordinated\|implement_tasks\|create_execution" --include=*.md . | grep -v "^./plugin/skills/implement_coordinated/\|^./plugin/skills/implement_tasks/\|^./CHANGELOG.md\|^./docs/plans/"; jq -r .version plugin/.claude-plugin/plugin.json .claude-plugin/marketplace.json 2>/dev/null; jq -r '.plugins[0].version' .claude-plugin/marketplace.json
```

### ⛔ CHECKPOINT: Phase 2 Complete

1. ✅ All Phase 2 task beads issues closed
2. ✅ Phase 2 milestone closed
3. ✅ PR merged, `v3.0.0` tagged, installed plugin at 3.0.0 (human confirmation)
4. ✅ Reconcile plan-doc status via `/wb:update_status`

---

## Implementation Discoveries

Things to determine during implementation:

- Whether git detects the directory moves as renames after Phase 1's in-file edits (check `git show --stat -M` on the 2.1 commit; if not, nothing breaks, but the history is a delete plus add)
- Whether the alias stub's Skill event names the alias or the canonical skill in stream-json (the test agent expects the alias name, since the stub keeps its own `name:`)
- The exact count of pre-existing `lint --all` findings after 1.1 (record it; RELEASING.md item 4 refers to the backlog)
- Whether `implement`'s broadened description over-triggers on questions about implementation (the negative routing case in 2.8)

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

- 2026-09-06: Plan written from research.md and design.md with three analysis agents (dependency inventory, verification recipes, before-text). Corrections folded in: `implement` has four supporting files, so the alias carries four pointer files (design.md D2 said five, counting SKILL.md); CLAUDE.md has two name occurrences (lines 13, 86), not the 104 research §4 cited; the 67-line inventory separates dated narrative from current mentions per file.

---

## 🔗 Quick Reference

### Key Files

- **Research**: [research.md](research.md) - inventory (§5), auto-flush sites (§7), lint mechanics (§8), tier-rule copies (§9), release facts (§10)
- **Design**: [design.md](design.md) - D1 through D10
- **Alias precedent**: `plugin/skills/create_execution/` (until task 2.3 deletes it; quoted in full in Phase 2 item 2)
- **Release process**: `RELEASING.md`

### Common Commands

```bash
# Old-name occurrences outside aliases, changelog, and plan history
grep -rn "implement_coordinated\|implement_tasks\|create_execution" --include=*.md . | grep -v "^./plugin/skills/implement_coordinated/\|^./plugin/skills/implement_tasks/\|^./CHANGELOG.md\|^./docs/plans/"

# Auto-flush claims
grep -rn "auto-flush" plugin docs --include=*.md | grep -v docs/plans

# Lint fixture
./plugin/scripts/lint $CLAUDE_JOB_DIR/tmp/bad.md; echo "exit=$?"

# Headless skill event check
claude --plugin-dir plugin --model sonnet -p "run /wb:implement" --output-format stream-json --verbose --max-turns 2 | grep -o '"skill":"wb:[a-z_]*"'

# Dev session against the working tree
claude --plugin-dir "$(pwd)/plugin"
```

### Design Decisions Reference

- D1: names `implement` and `implement_inline`, underscores kept
- D2: alias stubs plus pointer files, user-only
- D3: aliases through 3.x, removed at 4.0.0
- D4: `create_execution` deleted; three sentences rewritten
- D5: `implement` is the default in every rendering
- D6: beads-mode.md is the single persistence statement
- D7: lint exit code real; hook stays 0
- D8: reference.md points at the SKILL.md tier list
- D9: RELEASING.md bundling rule, tags, three-session canary
- D10: 3.0.0 with Breaking and Migration sections, tagged on the merge

## Beads Issue Tracking

This project uses beads for ALL task tracking across sessions.

**Epic**: prompts-tq7

**Phase Milestones**:

- Phase 1: prompts-1ng (all Phase 1 tasks must complete)
- Phase 2: prompts-h1y (all Phase 2 tasks must complete; depends on prompts-1ng)

**Granular Tasks**: See frontmatter `beads_tasks` section for all task IDs.

**Essential Commands**:

- `bd ready` - See what's ready to work on (no blockers)
- `bd show [id]` - View task details and dependencies
- `bd update [id] --claim` - Claim a task
- `bd close [id]` - Complete a task
- `bd blocked` - See what's currently blocked
- `bd list --status=in_progress` - See your active work

**Status Source**: Beads is the source of truth for all task status. Do NOT use markdown checkboxes for tracking.
