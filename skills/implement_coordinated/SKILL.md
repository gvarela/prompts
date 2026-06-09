---
name: implement_coordinated
description: Coordinate task implementation using sequential worker agents with fresh context
argument-hint: [project-directory] [phase-number|continue]
disable-model-invocation: true
---

# Implement Tasks (Coordinated)

**Next-generation task implementation using coordinator + worker agent pattern.**

You coordinate task implementation from `tasks.md` by spawning worker agents sequentially, each with focused context and fresh context window. This prevents main session context bloat.

**Recommended for**: Long phases with many tasks, sessions where context compaction would be disruptive, or when you want the main window available for monitoring/debugging.

Supporting files in this directory (read each when its step directs you to — never paraphrase from memory):

- [sub-agent-prompts.md](sub-agent-prompts.md) — verbatim worker/verifier/fix-worker prompts
- [templates.md](templates.md) — output templates for aggregation, reports, notes
- [reference.md](reference.md) — context-package spec, model selection, failure playbook
- [README.md](README.md) — design rationale (for humans; not needed at runtime)

## Initial Response

When invoked, check for arguments:

1. **If directory and phase provided** (e.g., `/implement_coordinated docs/plans/2025-01-08-my-project/ 1`):
   - Use `$1` as project directory
   - Use `$2` as phase number (or "continue" to resume)
   - Read all documentation immediately
   - Begin coordination

2. **If partial arguments**:
   - Use provided arguments
   - Prompt only for missing ones

3. **If no arguments**:

   ```
   I'll coordinate task implementation using worker agents with fresh context. Please provide:
   1. Path to the project documentation directory (e.g., docs/plans/2025-01-08-my-project/)
   2. Which phase to implement (number or "continue" to resume from current phase)
   3. Any specific context or constraints for this implementation session (optional)

   I'll spawn worker agents sequentially to keep the main session context clean.
   ```

## Implementation Philosophy

### Core Principles

All principles from `implement_tasks` PLUS:

1. **Coordination Over Direct Implementation**: Main agent orchestrates, doesn't code
2. **Context Extraction**: Build minimal context packages for workers
3. **Sequential Execution**: Simple, predictable, one task at a time
4. **Worker Isolation**: Each worker operates in fresh context
5. **Model Selection**: Right model for task complexity (haiku/sonnet/opus)
6. **Main Session Stays Clean**: No context accumulation in coordinator

### CRITICAL: NO SCOPE ADDITIONS - NONE

Same zero-tolerance policy as original:

- **NEVER** add features not in tasks.md
- **NEVER** refactor beyond what's specified
- **NEVER** make "improvements" not explicitly asked for
- **NEVER** add extra error handling, validation, or edge cases
- **ONLY** implement what is EXPLICITLY written in tasks.md
- If something seems missing, STOP and ask - DO NOT add it

## Process Steps

### Step 1: Read and Understand Context

**⛔⛔⛔ BARRIER 1: STOP! Read ALL documentation files FULLY - NO SHORTCUTS ⛔⛔⛔**

```javascript
const projectDir = $1 || /* prompt for it */;
const phase = $2 || /* prompt for it */;

// Read all project files FULLY
const researchFile = `${projectDir}/research.md`;
const designFile = `${projectDir}/design.md`;
const tasksFile = `${projectDir}/tasks.md`;
```

1. **Read project structure**:
   - Check that specified directory exists
   - Verify presence of research.md, design.md, tasks.md

2. **Read research.md FULLY**:
   - Understand what currently exists in the codebase
   - Note patterns and conventions to follow
   - Identify key file:line references
   - Extract testing framework, file structure, naming conventions

3. **Read design.md FULLY**:
   - Understand the desired end state
   - Review success criteria for the phase
   - Note automated and manual verification requirements
   - Identify architectural constraints

4. **Read tasks.md FULLY**:
   - Identify current phase from frontmatter
   - Count completed vs remaining tasks
   - Read beads tracking configuration
   - Understand task structure and dependencies

**think deeply about:**

- What patterns should workers follow from research?
- What's the goal from the design?
- What EXACT tasks are specified in tasks.md?
- What minimal context does each worker need?

After reading all documentation, prepare to spawn workers sequentially.

### Step 2: Verify Beads Configuration

**CRITICAL**: Use beads for ALL task tracking (phases AND granular tasks).

#### Verify Beads is Initialized

```bash
bd info    # Check beads is initialized
```

**If beads is not initialized or has errors**:

```
⚠️ Beads Not Initialized

Beads is required for task tracking in the wb workflow.

To initialize beads for this project:
```bash
cd [project-root]
bd init
```

Then run `/wb:create_execution` to set up beads issues for all tasks.

```

Stop and wait for user to initialize beads before proceeding.

#### Detect Beads Mode

```bash
# Check mode (set by SessionStart hook)
if [ "$BEADS_MODE" = "stealth" ]; then
  echo "📍 Stealth mode: Beads state is local-only"
else
  echo "📍 Git mode: Beads state tracked in git"
fi
```

#### Verify Beads Tracking Configuration

Check that tasks.md frontmatter has beads tracking:

```yaml
beads_epic: [epic-id]
beads_phases:
  phase1_milestone: [milestone-id]
beads_tasks:
  phase1_setup_1: [task-id]
  phase1_impl_1: [task-id]
  # ... all tasks
```

**If frontmatter is missing**: Tell user "Run `/wb:create_execution` to configure beads tracking."

### Step 3: Extract Context Package

**Build a minimal context package for workers** from the documentation you've read — only what workers actually need to implement tasks: patterns from research.md, this phase's goal/criteria/constraints from design.md, beads IDs from tasks.md frontmatter, test commands, and the file references relevant to this phase.

**Read [reference.md](reference.md) NOW** — its "Context Package Structure" section is the exact structure to build. Do not improvise the shape.

### Step 4: Find Available Work

**⛔ BARRIER 2: Get ready tasks from beads**

Query beads to find what's ready to work on:

```bash
# Get ready tasks (no blockers)
bd ready

# This shows tasks that:
# - Have no dependencies, OR
# - All dependencies are closed
```

**Start with the first ready task**. After each worker completes, `bd ready` will show newly unblocked tasks.

### Step 5: Spawn Worker Agents Sequentially

**For each ready task in the phase**, spawn a focused worker agent:

1. **Get next task**: Run `bd ready` to find available work
2. **Check task details**: Run `bd show [task-id]` for requirements
3. **Determine model**:
   - Haiku: Simple tasks (config, docs, renames)
   - Sonnet: Standard implementation (tests, new functions, integrations)
   - Opus: Everything else (bugs, refactoring, architecture) - DEFAULT
   - The precise selection spec is the `determineModel()` function in [reference.md](reference.md) — consult it when the tier isn't obvious.
4. **Spawn worker agent** as `general-purpose` with the chosen model. **Read [sub-agent-prompts.md](sub-agent-prompts.md) NOW** and build the worker prompt from its "Worker Prompt Template" — task ID/title/description, the context package, beads commands (`bd update [id] --claim`, `bd close [id]`), the TDD cycle, and the expected-output contract. Use the template verbatim with values filled in.
5. **Collect worker output** when complete
6. **Proceed to verification** (Step 6)

**Loop**: Spawn → Wait → Verify → Next task

### Step 6: After Each Worker Completes

**⛔ BARRIER 3: Collect output and verify before next task**

After each worker completes:

1. **Verify task was closed**:

   ```bash
   bd show ${taskId}  # Should show status: closed
   ```

2. **Collect worker output**:
   - Files created/modified
   - Tests added/modified
   - Test commands to verify
   - Any issues encountered

3. **Verify task completion**:

   Spawn the task-verifier agent using the "Verification Agent Prompt" in [sub-agent-prompts.md](sub-agent-prompts.md) — read it before spawning. The agent runs tests, checks scope adherence, and returns a structured markdown report with Status: PASS or FAIL.

4. **Parse verification result autonomously**:

   Extract pass/fail from agent's markdown report:

   ```javascript
   // Agent returns text like: "### Status: PASS" or "### Status: FAIL"
   const passed = verificationReport.includes("### Status: PASS");
   const failed = verificationReport.includes("### Status: FAIL");
   ```

   **If PASS**:
   - Add to success log
   - Collect modified files for aggregation
   - Proceed to step 5 (next task)

   **If FAIL**:
   - Attempt automatic fix (up to 2 retries) using the "Fix Worker Prompt" in [sub-agent-prompts.md](sub-agent-prompts.md), re-verifying after each retry.
   - **After 2 failed retries**: add to blocking issues list for phase checkpoint review and continue to the next task (surface issues at the phase boundary — don't block autonomous flow on individual task failures).

5. **Add to aggregated lists** (after pass):
   - Modified files (for final reporting)
   - Test commands (for phase verification)
   - Implementation notes (if worker found issues)

6. **Check for newly ready tasks**:

   ```bash
   bd ready  # See what's now unblocked
   ```

7. **Spawn next worker** (repeat Step 5)

**Handle worker failures** (rare — worker left the task `in_progress` without closing it): this is a crash/incomplete, NOT a verification failure, and verification is not run. Follow the "Worker Failure Playbook" in [reference.md](reference.md) and present its options to the user.

### Step 7: Aggregate Results

**⛔ BARRIER 4: All phase tasks complete**

After all workers for the phase complete, aggregate their outputs:

#### Update Modified Files Section

Collect modified files from all workers and update tasks.md using the "Modified Files Aggregation" template in [templates.md](templates.md) — read it before writing.

#### Check Phase Completion

```bash
# Verify all phase tasks are closed
bd show ${phaseMilestoneId}

# Should show: blockedBy: [] (no remaining dependencies)
```

### Step 8: Run Phase Verification

**⛔ CHECKPOINT: Phase ${phase} Complete**

Same verification process as original `implement_tasks`:

#### 1. Verify All Phase Tasks Closed

```bash
bd show ${phaseMilestoneId}    # Authoritative: blockedBy must be empty
bd list --status=in_progress   # Should be empty for this phase
```

The milestone's dependency list is the completion check — every phase task blocks the milestone, so an empty `blockedBy` means all tasks are closed. Do not grep titles for phase membership.

**Requirement**: All phase task beads issues must be closed.

#### 2. Run Automated Verification

```bash
# Adapt these to actual commands from tasks.md
make test           # or npm test, go test ./..., pytest
make lint           # or npm run lint, golangci-lint run
make typecheck      # or npm run typecheck, go build ./...
make build          # or npm run build, go build
```

**Requirement**: All automated checks must pass.

#### 3. Request Manual Verification

Present manual verification checklist to user:

```
✅ Phase ${phase} Automated Verification Complete

**Automated checks passed:**
- ✅ All tests passing: [test command]
- ✅ Linting clean: [lint command]
- ✅ Build successful: [build command]

**Worker agents completed:**
${workerSummaries.map(w => `- ✅ ${w.title}: ${w.summary}`).join('\n')}

**Beads state:**
- ✅ All Phase ${phase} tasks closed: [list task IDs]
- 🔓 Phase milestone ready to close: ${phaseMilestoneId}

**Manual verification required:**

Please perform the following manual checks from design.md:

${manualVerificationSteps}

Reply when manual verification is complete and I'll close the phase milestone.
```

**Requirement**: Wait for user confirmation before proceeding.

#### 4. Close Phase Milestone

**ONLY after user confirms manual verification**:

```bash
bd close ${phaseMilestoneId} --reason "Phase ${phase} complete: ${summary}. All ${taskCount} tasks closed via worker agents, automated verification passed, manual verification confirmed."
bd ready  # Check what's now unblocked (next phase tasks)
```

#### 5. Report Completion

Report using the "Phase Completion Report" template in [templates.md](templates.md) — read it before writing the report.

### Step 9: Update Status

After phase completion:

1. **Verify beads state**:

   ```bash
   bd stats    # Check overall progress
   bd list --status=closed    # See what's complete
   bd ready    # See what's available next
   ```

2. **Optionally update tasks.md frontmatter** (for human reference):

   ```yaml
   current_phase: ${phase + 1}
   last_updated: YYYY-MM-DD
   status: in-progress
   execution_mode: coordinated  # Note the new pattern
   ```

3. **Add implementation notes** with worker insights, using the "Implementation Notes Entry" template in [templates.md](templates.md).

4. **Persist beads state** (beads auto-flushes `.beads/issues.jsonl` after mutations):

   ```bash
   # In git mode, commit the beads state
   if [ "$BEADS_MODE" != "stealth" ]; then
     git add .beads/
     git commit -m "Update beads state after Phase ${phase} (coordinated execution)"
   fi
   ```

## Resume Logic

When resuming work (phase = "continue"):

1. **Check beads state** (source of truth):

   ```bash
   bd stats           # Overall progress
   bd ready           # Available work
   bd list --status=in_progress  # Any workers that didn't finish?
   bd list --status=closed        # Completed work
   ```

2. **Review context**:
   - Read tasks.md "Implementation Notes" for worker insights
   - Read research.md and design.md for context
   - Check current_phase in frontmatter

3. **Handle incomplete workers**:
   - If tasks are stuck in `in_progress`, investigate why
   - Review worker outputs for errors
   - Retry failed tasks with adjusted context

4. **Continue coordination**:
   - Extract context package
   - Run `bd ready` to find next task
   - Spawn worker for next available task
   - Repeat until phase complete

## Important Guidelines

### DO

- ✅ Extract minimal context packages for workers
- ✅ Spawn workers sequentially (one at a time)
- ✅ Use appropriate model for task complexity
- ✅ Wait for each worker to complete before next
- ✅ Aggregate worker outputs thoroughly
- ✅ Handle worker failures gracefully
- ✅ All original `implement_tasks` best practices

### DON'T (ABSOLUTELY FORBIDDEN)

- ❌ All prohibitions from original `implement_tasks`
- ❌ **NEVER** spawn multiple workers in parallel (keep it simple)
- ❌ **NEVER** allow workers to add scope
- ❌ **NEVER** pass entire docs to workers (extract context)
- ❌ **NEVER** proceed without waiting for worker completion
- ❌ **NEVER** skip worker output aggregation
- ❌ **NEVER** close phase milestone before manual verification
