# Create Execution Plan

Transforms design decisions into a detailed, phased execution plan with embedded tasks. Focuses on HOW to implement what was designed.

## Initial Setup

**Check if user provided parameters below before asking:**

If the user filled in the "User Input Section" at the bottom of this prompt, use those parameters and proceed directly to creating the execution plan.

If parameters are NOT provided, respond with:

```
I'll help you create an execution plan from the approved design. Please provide:
1. Path to the project documentation directory (e.g., docs/plans/2025-10-07-my-project/)

I'll read the research and design documents to create a detailed implementation plan with tasks.
```

Then wait for the user's input.

## Prerequisites

- **MUST** have research.md (validated)
- **MUST** have design.md (approved)
- Both documents should be in the specified project directory

## Process Steps

### Step 1: Read Foundation Documents

**⛔ BARRIER 1**: Read BOTH documents FULLY before proceeding

1. **Read research.md completely**:
   - Current implementation details
   - File locations and patterns
   - Constraints to respect
   - Knowledge gaps identified

2. **Read design.md completely**:
   - Design decisions made
   - Success criteria defined
   - Scope boundaries set
   - Technical specifications

3. **Read existing tasks.md if present**:
   - Check current status
   - Note any existing progress

**think deeply**

Synthesize research (current state) and design (target state) to determine the implementation path.

### Step 2: Determine Implementation Strategy

Based on the gap between current and target state:

1. **Identify dependencies**:
   - What must be built first?
   - What can be done in parallel?
   - What requires prerequisites?

2. **Assess risk**:
   - What changes are highest risk?
   - What needs extra testing?
   - Where might we need rollback?

3. **Plan phases**:
   - Group related changes
   - Minimize risk per phase
   - Enable incremental validation

### Step 3: Generate Execution Plan

Update or create tasks.md with the following structure:

```markdown
---
project: [from existing frontmatter]
ticket: [from existing frontmatter]
created: [from existing frontmatter]
status: not-started
last_updated: [YYYY-MM-DD]
current_phase: 1
total_tasks: [calculated count]
completed_tasks: 0
depends_on: [research.md, design.md]
---

# Execution Plan: [Feature Name]

## Overview

Implementing [brief summary] as specified in design.md

**Design Approach**: [from design.md]
**Target State**: [from design.md success criteria]

## Implementation Strategy

### Phase Rationale
[Explain why phases are ordered this way - dependencies, risk mitigation, etc.]

### Testing Strategy
[Overall approach to testing throughout implementation]

## Progress Overview

| Phase | Status | Tasks | Progress |
|-------|--------|-------|----------|
| Phase 1: [Name] | 🔄 In Progress | 0/[Y] | 0% |
| Phase 2: [Name] | ⏸️ Not Started | 0/[Y] | 0% |
| Phase 3: [Name] | ⏸️ Not Started | 0/[Y] | 0% |

**Overall Progress**: 0/[total] tasks (0%)

---

## Phase 1: [Descriptive Name]

### Objective
[Single clear goal for this phase]

### Prerequisites
- [ ] Research validated
- [ ] Design approved
- [ ] Development environment ready

### Changes Required

#### 1. [Component/Module Name]

**File**: `path/to/file.ext`

**Current State** (from research.md):
- [How it works now]
- [Key function at line X]

**Target State** (from design.md):
- [How it should work]
- [New capability needed]

**Implementation**:
```language
// At line [X], replace:
[old code]

// With:
[new code]
```

**Rationale**: [Why this specific implementation]

#### 2. [Another Component]

[Similar structure...]

### Tasks

#### Setup Tasks
- [ ] Create new directory structure at `path/to/new/`
- [ ] Install dependencies: `npm install [package]`
- [ ] Set up configuration in `config/feature.json`

#### Implementation Tasks
- [ ] Create [Component] class at `src/component.ts`
  - Implement constructor with dependency injection
  - Add [method1] for [purpose]
  - Add [method2] for [purpose]
- [ ] Modify [ExistingComponent] at `src/existing.ts:45`
  - Add integration with new component
  - Update error handling
- [ ] Write unit tests for [Component] at `tests/component.test.ts`
  - Test [scenario 1]
  - Test error cases
  - Test edge condition [X]

#### Integration Tasks
- [ ] Connect [Component] to [ExistingSystem]
- [ ] Update API endpoint at `api/routes.ts:78`
- [ ] Add database migration for new table

### Success Criteria

#### Automated Verification
- [ ] Unit tests pass: `npm test src/component.test.ts`
- [ ] Integration tests pass: `npm test:integration`
- [ ] Linting clean: `npm run lint`
- [ ] Type checking passes: `npm run typecheck`
- [ ] Build succeeds: `npm run build`

#### Manual Verification
- [ ] [Specific user action] works correctly
- [ ] Performance meets target: [metric]
- [ ] Error messages are clear and helpful
- [ ] No regression in [related feature]

### Modified Files

Track all files changed in this phase:

#### Code Files
- `src/component.ts` - New component implementation
- `src/existing.ts` - Integration point modified
- `config/feature.json` - Configuration added

#### Test Files
- `tests/component.test.ts` - Unit tests for new component
- `tests/integration/feature.test.ts` - Integration tests

**Quick test command for this phase**:
```bash
npm test src/component.test.ts tests/integration/feature.test.ts
```

### ⛔ CHECKPOINT: Phase 1 Complete

Before proceeding to Phase 2:
1. ✅ All tasks checked off
2. ✅ All automated verification passing
3. ✅ Manual verification confirmed by human
4. ✅ Update frontmatter: `current_phase: 2`

**Do not proceed without human confirmation of manual tests.**

---

## Phase 2: [Descriptive Name]

### Objective
[Clear goal for phase 2]

### Prerequisites
- [ ] Phase 1 complete and verified
- [ ] Phase 1 manual testing confirmed

[Continue with similar structure...]

---

## Implementation Discoveries

Things to determine during implementation:
- [Technical detail that needs investigation]
- [Configuration that needs testing]
- [Performance tuning needed]

Note: Update this section with findings as you implement.

---

## Rollback Plan

If implementation needs to be reverted:

### Phase 3 Rollback
1. [Specific step to undo phase 3]
2. [Command to run]

### Phase 2 Rollback
1. [Specific step to undo phase 2]
2. [Command to run]

### Phase 1 Rollback
1. [Specific step to undo phase 1]
2. [Command to run]

---

## 📝 Completed Tasks Archive

Move completed tasks here weekly to keep active list focused.

### Week of [YYYY-MM-DD]
- [x] Task description (completed YYYY-MM-DD HH:MM)

---

## 🚧 Blockers & Notes

### Current Blockers
| Blocker | Impact | Action | Owner | Due Date |
|---------|--------|--------|-------|----------|
| None | - | - | - | - |

### Implementation Notes
- [Important discovery during implementation]
- [Deviation from plan and why]

---

## 🔗 Quick Reference

### Key Files
- **Research**: [research.md](research.md) - Current state documentation
- **Design**: [design.md](design.md) - Target state specification
- **Main Entry**: `[from design]`
- **Config**: `[from design]`

### Common Commands
```bash
# Run all tests
npm test

# Run phase-specific tests
[phase test command]

# Build
npm run build

# Lint
npm run lint
```

### Design Decisions Reference
Quick lookup of key design decisions:
- [Decision 1]: [Brief reminder]
- [Decision 2]: [Brief reminder]
```

### Step 4: Validate Completeness

**⛔ BARRIER 2**: Ensure everything from design is captured

Verify:
1. **All success criteria** from design.md have corresponding tasks
2. **All scope items** from design.md are addressed
3. **Knowledge gaps** from research.md are handled
4. **Risk mitigations** from design.md are incorporated
5. **Every task is specific and executable**

### Step 5: Present the Plan

```
✅ Execution plan created at: [path]/tasks.md

Implementation structure:
- Phase 1: [Name] - [X] tasks
- Phase 2: [Name] - [Y] tasks
- Phase 3: [Name] - [Z] tasks

Total tasks: [total count]

Key features of the plan:
- Clear implementation sequence based on dependencies
- Specific code changes with before/after context
- Automated and manual verification per phase
- Rollback procedures for each phase
- Quick test commands to avoid running full suite

Next steps:
1. Review the execution plan
2. Run `/implement_tasks` to begin implementation with TDD
3. Update progress using checkboxes as you work
```

## Important Guidelines

### Execution Planning Principles

1. **Bridge Current to Target**:
   - Start from research (current state)
   - End at design (target state)
   - Plan the transformation path

2. **Phase by Risk and Dependencies**:
   - Riskiest changes early (fail fast)
   - Dependencies before dependents
   - Infrastructure before features

3. **Make Tasks Executable**:
   - Specific file and line references
   - Exact code to add/change
   - Clear test scenarios
   - Runnable commands

4. **Enable Incremental Progress**:
   - Each phase independently valuable
   - Checkpoints prevent cascading issues
   - Rollback possible at each phase

### What Belongs in Execution vs Design

**Execution (THIS document)**:
- ✅ Phase sequencing and dependencies
- ✅ Specific code changes
- ✅ File modifications with line numbers
- ✅ Test writing tasks
- ✅ Command sequences
- ✅ Rollback procedures

**Design (design.md)**:
- ❌ Architecture decisions (already made)
- ❌ Success criteria (reference them)
- ❌ Scope decisions (already defined)
- ❌ Technical approach (already chosen)

### Handling Implementation Discoveries

Some things can only be determined during coding:

1. **Document in "Implementation Discoveries"**:
   - Note what needs investigation
   - Update with findings as discovered
   - Adjust tasks if needed

2. **Don't Block on Unknowns**:
   - Make reasonable assumptions
   - Plan to test and adjust
   - Document the uncertainty

3. **Update During Implementation**:
   - Add discovered constraints
   - Note performance findings
   - Record configuration needs

## Task Granularity

Tasks should be:
- **Specific**: "Create PaymentRetry class at src/retry/PaymentRetry.ts"
- **Sized**: 1-4 hours of work typically
- **Testable**: Clear completion criteria
- **Independent**: Minimal blocking between tasks

## Synchronization Points

1. **⛔ BARRIER 1**: After reading documents - ensure full context
2. **⛔ BARRIER 2**: After generating plan - verify completeness
3. **⛔ CHECKPOINT**: Between phases - require human verification

## Configuration

This command creates an execution plan from approved research and design documents. See the User Input Section at the bottom to provide parameters directly, or submit without parameters for interactive mode.

---

## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

```
- Project directory: docs/plans/2025-10-08-payment-integration
```

**Parameters:**

- Project directory: