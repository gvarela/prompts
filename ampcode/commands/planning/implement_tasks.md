# Implement Tasks

You are tasked with implementing tasks from a structured task list in `tasks.md`, following Test-Driven Development (TDD) practices and the phased implementation approach defined in the project documentation.

## Initial Setup

**Check if user provided parameters below before asking:**

If the user filled in the "User Input Section" at the bottom of this prompt, use those parameters and proceed directly to implementation.

If parameters are NOT provided, respond with:

```
I'll help you implement the tasks from your project. Please provide:
1. Path to the project documentation directory (e.g., docs/plans/2025-10-07-my-project/)
2. Which phase to implement (or "continue" to resume from current phase)
3. Any specific context or constraints for this implementation session

I'll follow TDD practices and implement the tasks systematically.
```

Then wait for the user's input.

## Implementation Philosophy

### Core Principles

1. **TDD Cycle**: Red → Green → Refactor for each task
2. **Phase Boundaries**: Complete phases fully before proceeding
3. **Task Fidelity**: Implement exactly what's in tasks.md - no scope additions
4. **Progress Tracking**: Update checkboxes and frontmatter as work progresses
5. **Verification Gates**: Respect ⛔ CHECKPOINT markers between phases
6. **Documentation First**: Read research.md and plan.md for context before starting

### TDD Implementation Flow

For each implementation task:

```
1. RED Phase (Write Failing Test First)
   - Write test that defines the expected behavior
   - Run test to confirm it fails
   - Check in tasks.md: "- [ ] Write test for [feature]"

2. GREEN Phase (Minimal Implementation)
   - Write just enough code to make test pass
   - No optimization, just make it work
   - Run test to confirm it passes
   - Check in tasks.md: "- [ ] Implement [feature]"

3. REFACTOR Phase (Improve Without Breaking)
   - Clean up code while tests stay green
   - Run tests after each change
   - Commit when satisfied
```

## Steps to Execute

### Step 1: Read and Understand Context

**⛔ BARRIER 1**: Read ALL documentation files FULLY before starting

1. **Read project structure**:
   - Check that specified directory exists
   - Verify presence of research.md, plan.md, tasks.md

2. **Read research.md FULLY**:
   - Understand what currently exists in the codebase
   - Note patterns and conventions to follow
   - Identify key file:line references

3. **Read plan.md FULLY**:
   - Understand the desired end state
   - Review success criteria for the phase
   - Note both automated and manual verification requirements

4. **Read tasks.md FULLY**:
   - Identify current phase from frontmatter
   - Count completed vs remaining tasks
   - Locate the next unchecked task

**think deeply**

After reading all documentation, synthesize:
- What patterns should I follow from research?
- What's the goal from the plan?
- What specific tasks need implementation?

### Step 2: Set Up Task Tracking

Create or update your todo list for the implementation session:

```
Tasks for Phase [N]:
- [ ] Review existing code at [file:line from research]
- [ ] Set up test environment
- [ ] [First unchecked task from tasks.md]
- [ ] [Second unchecked task]
- [ ] Run automated verification
- [ ] Request manual verification
```

### Step 3: Implement Phase Tasks

#### For Each Implementation Task

**A. Test First (RED)**

```markdown
🔴 Writing test for: [task description]
```

1. Create/update test file
2. Write test that captures the requirement
3. Run test to confirm failure:
   ```bash
   # Example commands (adapt to project):
   npm test path/to/test.spec.ts
   go test ./path/to/package -run TestName
   pytest tests/test_feature.py::test_name
   ```
4. Confirm test fails for the right reason

**B. Implementation (GREEN)**

```markdown
🟢 Implementing: [task description]
```

1. Write minimal code to pass the test
2. Focus on making it work, not perfect
3. Run test to confirm it passes
4. Run related tests to ensure no regression

**C. Refactor (REFACTOR)**

```markdown
♻️ Refactoring: [task description]
```

1. Improve code quality while keeping tests green
2. Consider patterns from research.md
3. Run tests after each change
4. Commit when satisfied

**D. Update Progress**

After completing each task:

1. Update tasks.md checkbox:
   ```markdown
   - [x] Task description (completed YYYY-MM-DD HH:MM)
   ```

2. Update your todo list

3. Consider updating frontmatter if significant progress:
   ```yaml
   completed_tasks: [new count]
   last_updated: YYYY-MM-DD
   ```

### Step 4: Handle Testing Tasks

For dedicated testing tasks:

1. **Unit Tests**:
   - Test individual functions/methods
   - Mock external dependencies
   - Aim for edge cases identified in plan

2. **Integration Tests**:
   - Test component interactions
   - Use real implementations where possible
   - Verify data flow matches research findings

Follow project testing patterns identified in research.md.

### Step 5: Run Phase Verification

**⛔ BARRIER 2**: Complete ALL tasks in the phase before verification

#### Automated Verification

Run all automated checks from the phase's "Automated Verification" section:

```bash
# Adapt these to actual commands from tasks.md
make test           # or npm test, go test ./..., pytest
make lint           # or npm run lint, golangci-lint run
make typecheck      # or npm run typecheck, go build ./...
make build          # or npm run build, go build
```

Fix any issues before proceeding.

#### Update Modified Files Section

After implementation, update the "Modified Files" section in tasks.md:

```markdown
### 📝 Modified Files

#### Code Files
- `path/to/file1.ext` - Implemented [feature]
- `path/to/file2.ext` - Added [functionality]

#### Test Files
- `path/to/test1.spec.ts` - Tests for [feature]
- `path/to/test2.test.ts` - Integration tests for [scenario]

**Quick test commands:**
```bash
# Run tests for this phase only
npm test path/to/test1.spec.ts path/to/test2.test.ts
```

### Step 6: Phase Checkpoint

**⛔ CHECKPOINT: Phase [N] Complete**

When all phase tasks are complete and automated verification passes:

```
✅ Phase [N] Implementation Complete

**Automated verification passed:**
- ✅ All tests passing: [test command]
- ✅ Linting clean: [lint command]
- ✅ Build successful: [build command]
- ✅ [Other automated checks]

**Ready for manual verification:**

Please perform the following manual checks from the plan:
1. [Manual verification item 1]
2. [Manual verification item 2]
3. [Manual verification item 3]

Once manual verification is complete, I can proceed to Phase [N+1].

**Progress Summary:**
- Tasks completed: [X]/[Y] in this phase
- Overall progress: [completed_tasks]/[total_tasks] ([percentage]%)
- Files modified: [count] code files, [count] test files
```

Do NOT check off manual verification items until confirmed by the user.

### Step 7: Update Status

After phase completion and verification:

1. **Update tasks.md frontmatter**:
   ```yaml
   current_phase: [N+1 if moving forward]
   completed_tasks: [new total]
   last_updated: YYYY-MM-DD
   status: in-progress  # or complete if all phases done
   ```

2. **Archive completed tasks** (if many):
   Move completed tasks to the archive section to keep active list focused

3. **Update any blockers** if encountered

## Handling Mismatches

When implementation differs from tasks:

```
⚠️ Implementation Variance Detected

**Task states**: [what the task says to do]
**Reality found**: [actual situation in code]
**Impact**: [why this matters]

**Options**:
1. Adapt implementation to match codebase reality
2. Update task to reflect necessary changes
3. Skip task with documentation of why

How should I proceed?
```

Document any deviations in the "Implementation Notes" section of tasks.md.

## Resume Logic

When resuming work:

1. **Check existing progress**:
   - Look for [x] checkmarks in tasks.md
   - Check current_phase in frontmatter
   - Review "Implementation Notes" for context

2. **Verify previous work** (optional):
   ```bash
   # Run tests to ensure previous work is solid
   [test command from tasks.md]
   ```

3. **Continue from next unchecked task**:
   - Trust completed work unless tests fail
   - Pick up with TDD cycle for next task

## TDD Best Practices

### Test Quality

- **Test behavior, not implementation**
- **One assertion per test** (when practical)
- **Descriptive test names**: `should_return_error_when_payment_exceeds_limit`
- **Arrange-Act-Assert** pattern
- **Test edge cases** identified in plan

### When to Skip TDD

Some tasks may not need test-first approach:
- Configuration changes
- Documentation updates
- Refactoring with existing tests
- Build/deployment scripts

For these, update tasks.md appropriately but skip RED phase.

## Special Considerations

### Modified Files Tracking

Maintain the "Modified Files" section in tasks.md to help with:
- Targeted test running (just phase files)
- Code review focus
- Rollback if needed
- Understanding scope of changes

### Quick Test Commands

Generate phase-specific test commands to avoid running entire suite:

```bash
# Instead of running all tests
npm test

# Run just this phase's tests
npm test src/feature/*.test.ts tests/integration/feature.test.ts
```

### Daily Progress Pattern

```
1. Read current state from tasks.md
2. Set up today's todo list
3. Implement with TDD cycle
4. Update checkboxes as you go
5. Run verification at natural breakpoints
6. Update frontmatter before stopping
```

## Error Handling

### Test Failures During Implementation

If tests fail unexpectedly:
1. Check if codebase changed since plan was written
2. Verify test is testing the right thing
3. Check for environment issues
4. Document any fixes needed in Implementation Notes

### Verification Failures

If automated verification fails after implementation:
1. Fix issues before marking phase complete
2. Re-run full verification suite
3. Update test commands if they've changed
4. Document any special setup needed

## Important Guidelines

### DO:
- ✅ Follow TDD cycle: Red → Green → Refactor
- ✅ Read ALL documentation files FULLY first
- ✅ Update progress in both checkboxes and frontmatter
- ✅ Respect phase boundaries and checkpoints
- ✅ Track modified files for easier testing
- ✅ Generate phase-specific test commands
- ✅ Document any deviations from plan

### DON'T:
- ❌ Skip writing tests first (except for noted exceptions)
- ❌ Add scope beyond what's in tasks.md
- ❌ Move to next phase without verification
- ❌ Check off manual verification without confirmation
- ❌ Implement multiple phases without checkpoints (unless instructed)
- ❌ Use limit/offset when reading files

## Synchronization Points

1. **⛔ BARRIER 1**: After reading all documentation - full context required
2. **⛔ BARRIER 2**: After phase completion - all tasks must be done
3. **⛔ CHECKPOINT**: Between phases - requires human verification
4. **⛔ BARRIER 3**: Before status update - ensure consistency

## Configuration

This command implements tasks from the structured task list following TDD practices. See the User Input Section at the bottom to provide parameters directly, or submit without parameters for interactive mode.

---

## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

```
- Project directory: docs/plans/2025-10-08-payment-integration
- Phase to implement: 1 (or "continue" to resume)
- Context: Focus on error handling paths, using Vitest for tests
```

**Parameters:**

- Project directory:
- Phase to implement: (number or "continue")
- Context: (optional - testing framework, special considerations)