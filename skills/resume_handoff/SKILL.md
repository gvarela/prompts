---
name: resume_handoff
description: Resume work from a handoff document created in a previous session
argument-hint: [handoff-file-path]
disable-model-invocation: true
---

# Resume Handoff

Resumes work from a handoff document, restoring context and continuing implementation where the previous session left off.

Supporting files in this directory (read each when its step directs you to — never paraphrase from memory):

- [templates.md](templates.md) — output templates for resumption reports
- [reference.md](reference.md) — error handling catalog

## Purpose

This command:

- Restores full context from handoff document
- Reads all referenced project files
- Understands problems solved and blockers
- Continues work without repeating discoveries
- Maintains consistency with previous decisions

## Initial Response

When invoked, check for arguments:

1. **If handoff path provided** (e.g., `/resume_handoff docs/plans/2025-01-08-auth/handoff-2025-01-08-14-30.md`):
   - Use `$1` as handoff file path
   - Begin resumption process immediately

2. **If no arguments**:

   ```
   I'll resume work from a handoff document. Please provide:
   1. Path to the handoff document (e.g., docs/plans/project/handoff-YYYY-MM-DD-HH-MM.md)

   I'll restore the context and continue where the previous session left off.
   ```

## Process Steps

### Step 1: Read and Validate Handoff

**⛔⛔⛔ BARRIER 1: STOP! Read handoff document COMPLETELY - every section matters ⛔⛔⛔**

```javascript
const handoffPath = $1 || /* prompt for it */;
```

1. **Read handoff document fully** to understand:
   - Current state and progress
   - Critical learnings and discoveries
   - Problems already solved
   - Active blockers
   - Next steps planned

2. **Extract key information**:
   - Project directory path
   - Current phase and task
   - Git commit reference
   - Uncommitted changes status

3. **Pull latest from remote**:

   ```bash
   git pull    # Get latest commits (and beads state if in git mode)
   ```

4. **Validate handoff currency**:

   ```bash
   # Check if we're on the right commit
   git rev-parse HEAD

   # Compare with handoff's git_commit
   # Warn if different - work may have progressed
   ```

5. **Sync and check beads state**:

   ```bash
   # Mode semantics: see docs/reference/beads-mode.md ($BEADS_MODE set by
   # SessionStart hook). Git mode: beads auto-imports issues.jsonl after git pull.

   # Check beads state regardless of mode
   bd stats                        # Current beads statistics
   bd list --status=in_progress    # Check active work
   bd ready                        # See what's available
   ```

   Compare with handoff's `beads_in_progress`:
   - **Git mode**: Should match if no work done since handoff
   - **Stealth mode**: May differ (beads is local, handoff is document-based)

**think deeply about the context and discoveries documented**

### Step 2: Read Project Documentation

Based on handoff references, read the project files:

```javascript
// Extract project directory from handoff
const projectDir = /* extracted from handoff */;

// Read all project documentation
const researchFile = `${projectDir}/research.md`;
const designFile = `${projectDir}/design.md`;
const tasksFile = `${projectDir}/tasks.md`;
```

1. **Read research.md** to understand:
   - Original codebase state
   - Patterns to follow
   - Integration points

2. **Read design.md** to understand:
   - What we're building
   - Design decisions made
   - Success criteria

3. **Read tasks.md** to understand:
   - Current phase details
   - Specific tasks to complete
   - Success verification steps

### Step 3: Restore Working Context

**Restore beads tracking state:**

```bash
# If handoff shows an in_progress phase, verify it's still claimed
bd show [phase-id-from-handoff]

# If phase was released (no longer in_progress), reclaim it
bd update [phase-id] --claim

# If phase was completed by another session, find next work
bd ready
```

**Review beads issues for next steps:**

The handoff document may reference specific beads issue IDs. Check them:

```bash
# Review next tasks mentioned in handoff
bd show [issue-id-from-handoff]

# See what's ready to work on
bd ready

# Claim the next task
bd update [task-id] --claim
```

**Check for uncommitted changes** mentioned in handoff:

```bash
# Check current git status
git status

# If uncommitted changes exist, understand their purpose from handoff
git diff
```

### Step 4: Apply Learnings from Handoff

Before starting work, internalize the critical learnings:

1. **Patterns and Conventions**:
   - Note any discovered patterns mentioned
   - Remember consistency requirements
   - Apply same approaches used previously

2. **Problems Already Solved**:
   - Don't re-solve issues documented in handoff
   - Use the solutions already found
   - Apply workarounds mentioned

3. **Decisions Made**:
   - Maintain consistency with prior decisions
   - Don't revisit settled trade-offs
   - Follow the chosen approach

4. **Known Gotchas**:
   - Be aware of performance issues found
   - Watch for edge cases discovered
   - Avoid pitfalls documented

### Step 5: Address Active Blockers

If handoff documents active blockers:

1. **Review attempted solutions**:
   - Don't repeat failed attempts
   - Understand why previous approaches failed

2. **Try suggested solutions**:
   - Start with potential solutions from handoff
   - Apply insights from previous attempts

3. **Escalate if still blocked**:
   - Document additional attempts
   - Consider if different expertise needed
   - Create new handoff if switching approach

### Step 6: Continue Implementation

**Resume from exact point indicated in handoff:**

```
Resuming work from handoff dated [YYYY-MM-DD HH:MM]

Current Status:
- Phase: [N] of [Total]
- Last Completed: [task description]
- Now Working On: [next task]

Applying learnings:
- [Key learning 1 from handoff]
- [Key learning 2 from handoff]

Continuing implementation...
```

Follow the "Next Steps" section from handoff:

1. Complete the immediate next task specified
2. Apply recommended approach documented
3. Watch for gotchas mentioned
4. Verify work as indicated

### Step 7: Maintain Continuity

As you work:

1. **Stay consistent** with patterns discovered in handoff
2. **Reference solutions** to problems already solved
3. **Update tasks.md** checkboxes as you complete work
4. **Document new discoveries** for potential future handoff
5. **Run verification** commands from handoff

## Validation Steps

After resuming, verify continuity:

1. **Code State Verification**:

   ```bash
   # Run tests to ensure starting state is good
   npm test  # or appropriate test command

   # Check build still works
   npm run build
   ```

2. **Progress Verification**:
   - Confirm phase matches handoff
   - Check task completion matches
   - Verify no work was lost

3. **Context Verification**:
   - Apply a learning from handoff
   - Reference a solved problem
   - Use a discovered pattern

## Output Format

When successfully resumed, read [templates.md](templates.md) and use the "Resumption Report Template" to format the output.

## Handling Stale Handoffs

If the handoff seems outdated:

1. **Check git history**:

   ```bash
   # See if work progressed since handoff
   git log --oneline -10
   ```

2. **Compare with tasks.md**:
   - More tasks checked than handoff indicates?
   - Different phase than handoff shows?

3. **If stale, analyze the delta**:
   - Determine what changed since handoff
   - Decide if handoff learnings still apply
   - Consider creating fresh handoff from current state

Alert user if handoff is stale:

```
⚠️ Warning: Handoff may be stale

Handoff created: [date]
Current date: [date]
Git commits since handoff: [count]

The handoff learnings may still be valuable, but verify current state.
Consider running /validate_execution to assess current progress.
```

## Important Guidelines

### Resume Best Practices

1. **Trust the Handoff**: Previous session did the discovery work
2. **Don't Repeat**: Avoid re-solving problems documented
3. **Stay Consistent**: Follow patterns and decisions made
4. **Build on Learnings**: Apply insights discovered
5. **Continue Momentum**: Pick up where left off, don't restart

### When Handoff Conflicts with Code

If handoff says one thing but code shows another:

1. **Trust the code** for current state
2. **Trust the handoff** for learnings and context
3. **Document the discrepancy**
4. **Proceed with caution**
5. **Consider validation** via `/validate_execution`

### Quality Indicators

A successful resume shows:

- Immediate understanding of context
- No repeated discovery work
- Consistent approach with previous session
- Forward progress from exact stopping point
- Application of documented learnings

## Relationship to Other Commands

Common workflows:

**Simple Resume**:

1. **`/resume_handoff`** - Load context
2. `/implement_tasks` - Continue implementation
3. `/validate_execution` - Verify when phase complete

**Complex Resume with Validation**:

1. **`/resume_handoff`** - Load context
2. `/validate_execution` - Check actual state
3. Resolve any discrepancies
4. `/implement_tasks` - Continue work

**Chain of Handoffs**:

1. **`/resume_handoff`** - Session 2 resumes from Session 1
2. Work on implementation
3. `/create_handoff` - Session 2 creates new handoff
4. [New session]
5. **`/resume_handoff`** - Session 3 continues chain

## Error Handling

Read [reference.md](reference.md) and use the "Error Handling Catalog" for the appropriate error block (Handoff File Not Found / Invalid Handoff Format / Git State Mismatch).
