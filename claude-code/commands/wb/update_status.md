---
description: Update status across all project documentation files based on progress
argument-hint: [project-directory]
---

# Update Project Status

Intelligently updates status across all project documentation files (research.md, design.md, tasks.md) based on actual progress, ensuring consistency and proper state transitions.

## CRITICAL: Status Update Philosophy

- **READ BEFORE WRITE**: Always read ALL documentation files FULLY before making any updates
- **VERIFY STATE**: Confirm current state matches actual progress before transitioning
- **CASCADING UPDATES**: Status changes may trigger updates across multiple files
- **MAINTAIN CONSISTENCY**: Ensure all files reflect the same project reality
- **NO REGRESSION**: Never move status backward without explicit user confirmation
- **ATOMIC UPDATES**: Update all affected files together, not one at a time

## Initial Response

When invoked, check for arguments:

1. **If directory provided** (e.g., `/wb:update_status docs/plans/2025-01-08-auth/`):
   - Use `$1` as the project directory
   - Read all documentation files immediately
   - Analyze and propose status updates

2. **If no arguments**:

   ```
   I'll help you update the project status. Please provide:
   1. Path to the project documentation directory

   Example: /wb:update_status docs/plans/2025-01-08-auth/
   ```

## Steps to Execute

### Step 1: Read Current State (CRITICAL)

**⛔ BARRIER 1**: Read ALL files FULLY before proceeding

Read all documentation files to understand current state:

1. **Read research.md FULLY** - Check status, completion, findings
2. **Read design.md FULLY** - Check status, phase progress, implementation state
3. **Read tasks.md FULLY** - Check current_phase, completed_tasks, total_tasks, task checkboxes

**IMPORTANT**: Use Read tool WITHOUT limit/offset parameters

Record current state:

- Research status: [draft/in-progress/complete]
- Design status: [draft/ready/implementing/complete]
- Tasks status: [not-started/in-progress/complete]
- Current phase: [number]
- Completed tasks: [count]
- Total tasks: [count]

### Step 2: Analyze Actual Progress

**think deeply**

Examine the files to determine actual state:

1. **Research Analysis**:
   - Are all required sections populated with real content?
   - Does it have detailed findings with file:line references?
   - Are there still placeholder sections like "[To be added]"?
   - Determine: draft | in-progress | complete

2. **Design Analysis**:
   - Are design decisions documented with rationale?
   - Are success criteria measurable and complete?
   - Is implementation started (check tasks.md)?
   - Are all design aspects complete?
   - Determine: draft | ready | implementing | complete

3. **Tasks Analysis**:
   - Count checked vs unchecked tasks
   - Identify current phase based on which phase has active work
   - Check if phase checkpoints were met
   - Are all tasks complete?
   - Determine: not-started | in-progress | complete

4. **Progress Calculation**:
   - Calculate actual completion percentage
   - Identify which phase is currently active
   - Check if blocked (are there blockers listed?)

### Step 3: Determine Status Transitions

Based on analysis, determine appropriate status for each file:

**Status Progression Rules**:

1. **research.md**:
   - `draft` → Has frontmatter but minimal/placeholder content
   - `in-progress` → Has some findings but incomplete sections
   - `complete` → All sections populated with real findings, no placeholders

2. **design.md**:
   - `draft` → Template structure, no real design decisions made
   - `ready` → All design decisions documented, ready for execution planning
   - `implementing` → Tasks have started (tasks.md shows progress)
   - `complete` → All design implemented and verified

3. **tasks.md**:
   - `not-started` → No tasks checked off, current_phase: 0
   - `in-progress` → Some tasks checked, actively working
   - `complete` → All tasks checked, all phases verified

**Validation Rules**:

- Cannot mark design as `ready` if research is still `draft`
- Cannot mark tasks as `in-progress` if design is still `draft`
- Cannot mark design as `complete` if tasks is not `complete`
- `implementing` requires at least one checked task in tasks.md

### Step 4: Present Status Update Plan

Show user what will change:

```
📊 Current Status Analysis:

**research.md**
- Current: [current-status]
- Proposed: [new-status]
- Reason: [why this transition is appropriate]

**design.md**
- Current: [current-status]
- Proposed: [new-status]
- Reason: [why this transition is appropriate]

**tasks.md**
- Current: [current-status]
- Current Phase: [phase-number]
- Completed: [X]/[Y] tasks ([percentage]%)
- Proposed: [new-status]
- Proposed Phase: [phase-number]
- Reason: [why this transition is appropriate]

**Git Metadata Update**:
- New git_commit: [current commit hash]
- New git_branch: [current branch]

Do you want to proceed with these updates? (yes/no)
```

### Step 5: Apply Updates

**⛔ BARRIER 2**: Wait for user confirmation before proceeding

After user confirms, update all files:

#### Update research.md

Update frontmatter:

```yaml
status: [new-status]
last_updated: [YYYY-MM-DD]
git_commit: [current-commit]
git_branch: [current-branch]
```

#### Update design.md

Update frontmatter:

```yaml
status: [new-status]
last_updated: [YYYY-MM-DD]
git_commit: [current-commit]
git_branch: [current-branch]
```

If transitioning to `implementing`, add implementation notes:

```markdown
## Implementation Notes

Started: [YYYY-MM-DD]
- Implementation began on phase [N]
- [Any relevant context about starting implementation]
```

#### Update tasks.md

Update frontmatter:

```yaml
status: [new-status]
last_updated: [YYYY-MM-DD]
current_phase: [calculated-phase-number]
completed_tasks: [actual-count]
git_commit: [current-commit]
git_branch: [current-branch]
```

Update Progress Overview table to reflect actual counts.

Add implementation notes if status changes:

```markdown
### Implementation Notes
- Status updated to [new-status] on [YYYY-MM-DD]
- [Reason for status change]
```

### Step 6: Verify Consistency

**⛔ BARRIER 3**: Verify all updates were applied correctly

After all updates:

1. **Read each file back** to verify changes were applied
2. **Check consistency**:
   - All files have same `last_updated` date
   - All files have same git metadata
   - Status transitions are valid across all files
3. **Validate no regressions**:
   - Status didn't move backward unexpectedly
   - Task counts are accurate
   - Phase numbers make sense

### Step 7: Confirm Completion

Present summary:

```
✅ Status updated successfully!

📁 Project: [project-name]
📊 Updates Applied:

**research.md**: [old] → [new]
**design.md**: [old] → [new]
**tasks.md**: [old] → [new]
  - Phase: [number]
  - Progress: [X]/[Y] tasks ([percentage]%)

**Metadata Updated**:
- Last updated: [YYYY-MM-DD]
- Git commit: [commit-hash]
- Git branch: [branch-name]

**Next Steps**:
[Contextual suggestions based on new status]
```

## Status Transition Logic

### Research Status Transitions

```
draft → in-progress
  Trigger: User starts researching, some sections have content

in-progress → complete
  Trigger: All sections populated with real findings
  Requires: No placeholder text like "[To be added]"
```

### Plan Status Transitions

```
draft → ready
  Trigger: All phases defined with success criteria
  Requires: research.md is complete

ready → implementing
  Trigger: First task checked in tasks.md
  Requires: tasks.md status is in-progress

implementing → complete
  Trigger: All tasks complete and verified
  Requires: tasks.md status is complete
```

### Tasks Status Transitions

```
not-started → in-progress
  Trigger: First task checked off
  Updates: current_phase to active phase number

in-progress → complete
  Trigger: All tasks checked, all phase checkpoints passed
  Requires: All phases verified
```

## Smart Status Detection

The command should intelligently detect status based on actual content:

### Research Detection

- Count sections with real content vs placeholders
- Check for file:line references (indicates real research)
- Look for code snippets and detailed findings
- If >80% complete → suggest "complete"
- If >20% complete → suggest "in-progress"
- Otherwise → keep as "draft"

### Plan Detection

- Check if all phases have detailed "Changes Required"
- Verify success criteria are specific (not "[To be defined]")
- Cross-check with tasks.md for implementation progress
- If tasks have progress → suggest "implementing"
- If fully defined but no tasks started → suggest "ready"
- Otherwise → keep as "draft"

### Tasks Detection

- Count checked vs total tasks
- Identify which phase has unchecked tasks
- If all checked → suggest "complete"
- If any checked → suggest "in-progress" and update current_phase
- Calculate accurate percentage

## Error Handling

### Invalid Transitions

If user requests invalid transition:

```
⚠️ Invalid Status Transition

Cannot transition design.md from 'draft' to 'implementing' because:
- research.md is still in 'draft' status
- No tasks have been checked in tasks.md

Valid next steps:
1. Complete research first (/create_research)
2. Move plan to 'ready' status once research is complete
3. Start checking off tasks to begin implementing
```

### Missing Files

If files don't exist:

```
❌ Missing Documentation Files

Expected files in [directory]:
- research.md [✓/✗]
- design.md [✓/✗]
- tasks.md [✓/✗]

Run /create_project first to initialize the documentation structure.
```

### Inconsistent State

If files have conflicting status:

```
⚠️ Inconsistent Status Detected

Current state:
- design.md: implementing
- tasks.md: not-started (0 tasks completed)

This is inconsistent. Suggesting correction:
- Set design.md back to 'ready' OR
- Start checking off tasks in tasks.md

Which would you prefer?
```

## Important Notes

### Read-Only Analysis

- **NEVER modify files** without explicit user confirmation
- **ALWAYS present the update plan** before applying changes
- **VERIFY actual progress** by reading file contents, not just frontmatter

### Atomic Updates

- Update all files in the same operation
- Don't leave files in inconsistent states
- If any update fails, report error and don't partial-update

### Git Metadata

- Capture current git state when updating
- This provides audit trail of when status changed
- Update timestamp reflects when status was updated, not when work was done

### Backward Transitions

- Only allow with explicit confirmation
- Warn user about regression
- Require reason for moving backward

### Phase Progression

- Automatically detect current phase from tasks.md
- Update current_phase based on which phase has active work
- Don't skip phases - must complete in order

## Configuration

The command accepts the directory path as a parameter:

```
/update_status docs/plans/2025-10-07-my-project
```

Or prompts for it if not provided.
