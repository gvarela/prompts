---
description: Transform design into detailed phased execution plan with embedded tasks
argument-hint: [project-directory]
---

# Create Execution Plan

Transforms design decisions into a detailed, phased execution plan with embedded tasks. Focuses on HOW to implement what was designed.

## Initial Response

When invoked, check for arguments:

1. **If directory provided** (e.g., `/create_execution docs/plans/2025-01-08-my-project/`):
   - Use `$1` as the project directory
   - Read research.md, design.md, and tasks.md immediately
   - Begin execution planning

2. **If no arguments**:

   ```
   I'll help you create an execution plan from the approved design. Please provide:
   1. Path to the project documentation directory (e.g., docs/plans/2025-01-08-my-project/)

   I'll read the research and design documents to create a detailed implementation plan with tasks.
   ```

## Prerequisites

- **MUST** have research.md (validated)
- **MUST** have design.md (approved)
- Both documents should be in the specified project directory

## Process Steps

### Step 1: Read Foundation Documents

**⛔⛔⛔ BARRIER 1: STOP! Read ALL documents FULLY - research.md, design.md, tasks.md ⛔⛔⛔**

```javascript
const projectDir = $1 || /* prompt for it */;

// Read all project files
const researchFile = `${projectDir}/research.md`;
const designFile = `${projectDir}/design.md`;
const tasksFile = `${projectDir}/tasks.md`;
```

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

**think deeply about HOW to bridge from current state to target state**

Synthesize research (current state) and design (target state) to determine the implementation path.
Remember: Now you're planning HOW to build what was designed.

### Step 2: Spawn Analysis Agents

**Leverage Claude Code's agent capabilities for implementation analysis:**

After reading all documents, spawn specialized agents in parallel:

```javascript
// Spawn dependency analysis agents
Task({
  description: "Analyze file dependencies",
  prompt: `Analyze dependencies for implementing the design.

  From research.md:
  - Current file structure: [key files]
  - Integration points: [systems]

  From design.md:
  - Target architecture: [approach]
  - Components to build: [list]

  Determine:
  - Build order (what must be done first)
  - Parallel work opportunities
  - Critical path dependencies
  - External dependencies needed

  Return dependency graph with specific file references.`,
  subagent_type: "general-purpose",
  model: "sonnet"  // Complex dependency analysis
})

Task({
  description: "Identify test coverage needs",
  prompt: `Identify testing requirements for the implementation.

  From design.md:
  - Success criteria: [criteria]
  - Risk areas: [risks]

  From research.md:
  - Existing test patterns: [patterns]
  - Test frameworks in use: [frameworks]

  Determine:
  - Unit tests needed (with file:line for each component)
  - Integration tests required
  - Edge cases from risk analysis
  - Test fixtures needed

  Return test plan with specific test scenarios.`,
  subagent_type: "general-purpose",
  model: "sonnet"  // Test planning requires careful analysis
})

Task({
  description: "Generate rollback procedures",
  prompt: `Create rollback procedures for each phase.

  From design.md:
  - Changes being made: [changes]
  - Risk areas: [risks]

  From research.md:
  - Current state: [state]
  - Existing rollback patterns: [if any]

  For each major change, determine:
  - How to undo it safely
  - What data needs preservation
  - Testing rollback procedures
  - Specific commands to run

  Return rollback plan with step-by-step procedures.`,
  subagent_type: "general-purpose",
  model: "haiku"  // Procedural task generation
})

Task({
  description: "Find similar implementation patterns",
  prompt: `Find examples of similar implementations in the codebase.

  From design.md:
  - Type of change: [type]
  - Components affected: [components]

  Search for:
  - Similar features already implemented
  - Phased rollout patterns used
  - Testing approaches for similar changes
  - Configuration patterns to follow

  Return examples with file:line references.`,
  subagent_type: "general-purpose",
  model: "haiku"  // Quick pattern search
})
```

**⛔⛔⛔ BARRIER 2: STOP! Wait for ALL agents - dependency, test, rollback, pattern agents ⛔⛔⛔**

### Step 3: Determine Implementation Strategy

**think deeply about the safest, most logical implementation sequence**

Based on the gap between current and target state, and agent findings:

1. **Identify dependencies** (from dependency agent):
   - What must be built first?
   - What can be done in parallel?
   - What requires prerequisites?

2. **Assess risk** (from test coverage agent):
   - What changes are highest risk?
   - What needs extra testing?
   - Where might we need rollback?

3. **Plan phases** (synthesize all findings):
   - Group related changes
   - Minimize risk per phase
   - Enable incremental validation
   - Follow patterns from similar implementations

### Step 4: Generate Execution Plan

Update or create tasks.md with the following structure:

````markdown
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
[Explain why phases are ordered this way - dependencies from agents, risk mitigation, etc.]

Based on dependency analysis:
- [Key dependency finding from agent]
- [Parallel work opportunity from agent]

### Testing Strategy
[Overall approach to testing throughout implementation, incorporating test coverage agent findings]

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
- [ ] [Dependencies from agent analysis]

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
**Pattern Reference**: [Similar implementation from agent at file:line]

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

#### Testing Tasks
(Generated from test coverage agent findings)
- [ ] Write unit tests for [Component] at `tests/component.test.ts`
  - Test [scenario 1 from agent]
  - Test [edge case from agent]
  - Test [error condition from agent]
- [ ] Write integration tests at `tests/integration/feature.test.ts`
  - Test [integration scenario from agent]

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
(From design.md success criteria)
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
- [ ] [Additional prerequisites from dependency agent]

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

(Generated from rollback agent findings)

If implementation needs to be reverted:

### Phase 3 Rollback
1. [Specific step from agent]
2. [Command to run from agent]
3. [Verification step]

### Phase 2 Rollback
1. [Specific step from agent]
2. [Command to run from agent]
3. [Verification step]

### Phase 1 Rollback
1. [Specific step from agent]
2. [Command to run from agent]
3. [Verification step]

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
````

**⛔⛔⛔ BARRIER 3: STOP! Verify NO placeholder values - ALL tasks MUST be specific and executable ⛔⛔⛔**

### Step 5: Validate Completeness

Verify with agent findings:

1. **All success criteria** from design.md have corresponding tasks
2. **All scope items** from design.md are addressed
3. **Knowledge gaps** from research.md are handled
4. **Risk mitigations** from design.md are incorporated
5. **Every task is specific and executable**
6. **Test coverage** matches test agent recommendations
7. **Dependencies** follow agent-identified order
8. **Rollback procedures** cover all phases

### Step 6: Present the Plan

```
✅ Execution plan created at: [path]/tasks.md

Implementation structure:
- Phase 1: [Name] - [X] tasks
- Phase 2: [Name] - [Y] tasks
- Phase 3: [Name] - [Z] tasks

Total tasks: [total count]

Agent findings incorporated:
- Dependency order: [key dependency from agent]
- Test coverage: [X] unit tests, [Y] integration tests
- Rollback procedures: Detailed steps for each phase
- Similar patterns: [reference to pattern agent findings]

Key features of the plan:
- Clear implementation sequence based on dependency analysis
- Specific code changes with before/after context
- Comprehensive test coverage from agent analysis
- Automated and manual verification per phase
- Detailed rollback procedures from agent findings
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
   - Use agent findings to order phases
   - Riskiest changes early (fail fast)
   - Dependencies before dependents
   - Infrastructure before features

3. **Make Tasks Executable**:
   - Specific file and line references
   - Exact code to add/change
   - Clear test scenarios from agent
   - Runnable commands

4. **Enable Incremental Progress**:
   - Each phase independently valuable
   - Checkpoints prevent cascading issues
   - Rollback possible at each phase (with agent procedures)

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

### Leveraging Agent Findings

Use agent findings throughout execution plan:

1. **Dependencies**: Order phases based on dependency agent analysis
2. **Testing**: Incorporate test coverage agent recommendations
3. **Rollback**: Use rollback agent procedures verbatim
4. **Patterns**: Reference similar implementations found by pattern agent
5. **Risk mitigation**: Address risks identified by agents

## Task Granularity

Tasks should be:

- **Specific**: "Create PaymentRetry class at src/retry/PaymentRetry.ts"
- **Sized**: 1-4 hours of work typically
- **Testable**: Clear completion criteria
- **Independent**: Minimal blocking between tasks

## Synchronization Points

1. **⛔ BARRIER 1**: After reading documents - ensure full context
2. **⛔ BARRIER 2**: After spawning agents - wait for ALL agents
3. **⛔ BARRIER 3**: Before writing - verify no placeholders
4. **⛔ CHECKPOINT**: Between phases - require human verification

## Configuration

This command creates an execution plan from approved research and design documents. It leverages Claude Code's agent spawning capabilities to analyze dependencies, test coverage, rollback procedures, and similar patterns.
