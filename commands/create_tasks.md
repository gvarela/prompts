# Generate Task List

Breaks down the implementation plan into concrete, actionable tasks organized by phase with clear completion tracking and verification barriers.

## CRITICAL: Task Extraction Philosophy

- ONLY extract tasks directly from the plan - DO NOT add new scope
- Every task must be traceable to the implementation plan
- Maintain separation between automated and manual verification
- Include explicit checkpoints between phases
- Track both implementation and verification tasks

## Initial Setup

When this command is invoked, respond with:

```
I'll help you break down the implementation plan into actionable tasks. Please provide:
1. Path to the project documentation directory (e.g., docs/plans/2025-10-07-my-project/)

I'll read the plan.md file and extract all tasks with proper tracking structure.
```

Then wait for the user's input.

## Steps to Execute

### Step 1: Validate and Read Context (CRITICAL)

- Check that the specified directory exists
- Verify tasks.md file exists (created by `/create_project`)
- **Read plan.md FULLY** - Use Read tool WITHOUT limit/offset
- **CRITICAL**: Extract EVERY task mentioned in the plan
- Identify all phases, changes, success criteria, and verification steps

**⛔ BARRIER 1**: Do not proceed until plan.md is fully read and understood

### Step 2: Extract Tasks from Plan

**think deeply**

Analyze the plan and extract ALL tasks:

1. **Setup Tasks**:
   - Environment setup
   - Dependency installation
   - Initial scaffolding
   - Pre-work research/review

2. **Implementation Tasks**:
   - From every "Changes Required" section
   - Each code modification as a separate task
   - Configuration changes
   - Database migrations

3. **Testing Tasks**:
   - Unit test creation
   - Integration test creation
   - Test execution commands

4. **Verification Tasks**:
   - Automated checks (from "Automated Verification")
   - Manual tests (from "Manual Verification")
   - Performance validation
   - Regression testing

5. **Documentation Tasks**:
   - Any documentation updates mentioned
   - README updates
   - API documentation

### Step 3: Generate Structured Task List

Create a comprehensive task list with proper tracking:

```markdown
---
project: [from existing frontmatter]
ticket: [from existing frontmatter]
created: [from existing frontmatter]
status: not-started
last_updated: [YYYY-MM-DD]
current_phase: 1
total_tasks: [count]
completed_tasks: 0
---

# Tasks: [Project Name]

**Created**: [original date]
**Last Updated**: [YYYY-MM-DD]
**Ticket**: [ticket-reference or N/A]
**Current Phase**: Phase 1 of [total phases]

## Progress Overview

| Phase | Status | Tasks | Progress |
|-------|--------|-------|----------|
| Phase 1: [Name] | 🔄 In Progress | [X]/[Y] | [percentage]% |
| Phase 2: [Name] | ⏸️ Not Started | 0/[Y] | 0% |
| Phase 3: [Name] | ⏸️ Not Started | 0/[Y] | 0% |

**Overall Progress**: [completed]/[total] tasks ([percentage]%)

---

## Phase 1: [Descriptive Name from Plan]

**Status**: 🔄 In Progress
**Objective**: [What this phase accomplishes from plan]

### 📋 Setup & Prerequisites
- [ ] Review research document at `research.md`
- [ ] Review implementation plan at `plan.md`
- [ ] Set up development environment
- [ ] Install dependencies: `[specific command from plan]`
- [ ] Verify existing code at `[file:line from plan]`

### 🔨 Implementation Tasks

#### [Component 1 from Plan]
**File**: `path/to/file.ext`

- [ ] Task from plan "Changes Required" section
  - Details: [specific change needed]
  - Reference: [plan.md section reference]
- [ ] Another specific task
  - Details: [what to implement]
  - Code location: `file.ext:123`

#### [Component 2 from Plan]
**File**: `path/to/another/file.ext`

- [ ] Specific modification task
- [ ] Another implementation task

### 🧪 Testing Tasks
- [ ] Write unit test for [specific function/component]
  - Test file: `path/to/test.spec.ts`
  - Coverage: [what it should test]
- [ ] Write integration test for [scenario from plan]
  - Test file: `path/to/integration.test.ts`
- [ ] Ensure all existing tests still pass

### ✅ Verification Tasks

#### Automated Verification (CI/CD)
**MUST ALL PASS before manual verification:**
- [ ] Unit tests pass: `[exact command from plan]`
- [ ] Integration tests pass: `[exact command from plan]`
- [ ] Linting passes: `[exact command from plan]`
- [ ] Type checking passes: `[exact command from plan]`
- [ ] Build succeeds: `[exact command from plan]`

#### Manual Verification (Human Testing)
**Required before moving to Phase 2:**
- [ ] [Specific manual test from plan]
  - Steps: [how to test]
  - Expected: [what should happen]
- [ ] [Another manual verification]
  - Steps: [testing procedure]
  - Expected: [success criteria]
- [ ] No regressions in [related feature]

### ⛔ CHECKPOINT: Phase 1 Complete
```

Before proceeding to Phase 2:

1. ✅ All implementation tasks complete
2. ✅ All automated checks passing
3. ✅ Manual verification confirmed by human
4. ✅ Update status in frontmatter

```

---

## Phase 2: [Descriptive Name from Plan]

**Status**: ⏸️ Not Started (Blocked: Waiting for Phase 1)
**Objective**: [What this phase accomplishes from plan]

### 🔒 Prerequisites
- [ ] Phase 1 marked complete in frontmatter
- [ ] Phase 1 manual verification confirmed
- [ ] Review Phase 1 implementation

### 🔨 Implementation Tasks

[Extract all tasks from Phase 2 of plan, following same structure]

### 🧪 Testing Tasks

[Extract all test tasks from Phase 2]

### ✅ Verification Tasks

[Extract all verification tasks from Phase 2]

### ⛔ CHECKPOINT: Phase 2 Complete
[Same structure as Phase 1]

---

## Phase 3: [Additional Phases as Needed]

[Continue pattern for all phases in plan]

---

## 📝 Completed Tasks Archive

Move completed tasks here weekly to keep active list focused.

### Week of [YYYY-MM-DD]
- [x] Task description (completed YYYY-MM-DD HH:MM)
- [x] Another task (completed YYYY-MM-DD HH:MM)

---

## 🚧 Blockers & Notes

### Current Blockers
| Blocker | Impact | Action | Owner | Due Date |
|---------|--------|--------|-------|----------|
| None | - | - | - | - |

### Decision Log
| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| YYYY-MM-DD | [Decision made] | [Why] | [What changed] |

### Implementation Notes
- [Important discovery or context from implementation]
- [Deviation from plan and why]

---

## 🔗 Quick Reference

### Key Files
- **Research**: [`research.md`](research.md)
- **Plan**: [`plan.md`](plan.md)
- **Main Entry Point**: `[from plan]`
- **Config**: `[from plan]`
- **Tests**: `[test directory from plan]`

### Common Commands
```bash
# Development
[command from plan]

# Testing
[test command from plan]

# Linting
[lint command from plan]

# Build
[build command from plan]

# Run locally
[run command from plan]
```

### File:Line References

Quick jump to key code locations:

- `path/to/file1.ext:123` - [What's there]
- `path/to/file2.ext:456` - [What's there]

```

### Step 4: Update Tasks File

- Write the complete task list to tasks.md
- Preserve YAML frontmatter structure
- Set initial values:
  - `status: not-started`
  - `current_phase: 1`
  - `total_tasks: [actual count]`
  - `completed_tasks: 0`
- Update `last_updated` to today's date

**⛔ BARRIER 2**: Verify all tasks from plan are captured before writing

### Step 5: Present Task Summary

```

✅ Task list generated at: [path]/tasks.md

Task Breakdown by Phase:
━━━━━━━━━━━━━━━━━━━━━
Phase 1: [Name]
  Setup: [X] tasks
  Implementation: [Y] tasks
  Testing: [Z] tasks
  Verification: [W] tasks
  Subtotal: [total] tasks

Phase 2: [Name]
  [Similar breakdown]
  Subtotal: [total] tasks

Phase 3: [Name]
  [Similar breakdown]
  Subtotal: [total] tasks

━━━━━━━━━━━━━━━━━━━━━
TOTAL: [grand total] tasks

Key Features:
✓ Automated vs manual verification separated
✓ Checkpoints between phases
✓ Progress tracking in frontmatter
✓ All commands from plan included
✓ File:line references preserved

Next Steps:

1. Review the generated task list
2. Start with Phase 1 setup tasks
3. Update task status as you progress
4. Use frontmatter for overall tracking

```

## Task Management Protocol

### Task Granularity Rules
Tasks MUST be:
- **Specific**: Exact file, function, or feature to modify
- **Actionable**: Clear implementation path
- **Verifiable**: Has clear completion criteria
- **Sized**: Completable in 1-4 hours (break down if larger)
- **Traceable**: Links back to plan.md section

### Task Status Lifecycle
```

[ ] Not started
[>] In progress (optional, for current task)
[x] Complete (with timestamp)
[!] Blocked (move to blockers section)

```

### Frontmatter Updates
Update these fields as work progresses:
```yaml
status: in-progress  # not-started → in-progress → complete
current_phase: 2     # increment when phase complete
completed_tasks: 15  # increment as tasks complete
last_updated: YYYY-MM-DD
```

### Daily Workflow

1. **Morning**: Review current phase tasks
2. **During work**: Check off completed tasks with timestamps
3. **End of day**: Update frontmatter counts
4. **Weekly**: Archive completed tasks

### Blocker Management

When blocked:

```markdown
### Current Blockers
| Blocker | Impact | Action | Owner | Due Date |
|---------|--------|--------|-------|----------|
| API not ready | Can't test Phase 2 integration | Mock API responses | @teammate | 2025-01-15 |
```

## Important Guidelines

### CRITICAL Rules

- **NEVER add tasks not in the plan** - that's scope creep
- **ALWAYS include verification steps** - both automated and manual
- **MAINTAIN checkpoints** - enforce phase boundaries
- **EXTRACT everything** - miss nothing from the plan
- **PRESERVE references** - keep all file:line citations

### Task Extraction Checklist

- [ ] Every "Changes Required" item becomes a task
- [ ] Every "Success Criteria" item becomes a verification task
- [ ] Every test mentioned becomes a testing task
- [ ] Every command mentioned is preserved exactly
- [ ] Every file:line reference is maintained
- [ ] Phase boundaries are clearly marked
- [ ] Checkpoints prevent skipping ahead

### Progress Tracking

- Use frontmatter for high-level metrics
- Use checkboxes for individual task status
- Add timestamps when completing tasks
- Archive weekly to maintain focus
- Track blockers with action items

## Synchronization Points

1. ⛔ **BARRIER 1**: After reading plan - ensure full understanding
2. ⛔ **BARRIER 2**: Before writing - verify complete extraction
3. ⛔ **CHECKPOINT**: Between phases - require human verification

## Configuration

The command accepts the directory path as a parameter:

```
/create_tasks docs/plans/2025-10-07-my-project
```

Or prompts for it if not provided.
