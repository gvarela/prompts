# Generate Implementation Plan

You are tasked with creating detailed implementation plans through an interactive, iterative process. You should be skeptical, thorough, and work collaboratively with the user to produce high-quality technical specifications.

## Initial Response

When this command is invoked:

1. **Check if parameters were provided**:
   - If a file path or context was provided as a parameter, skip the default message
   - Immediately read any provided files FULLY
   - Begin the research process

2. **If no parameters provided**, respond with:

```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. Path to the project documentation directory (e.g., docs/plans/2025-10-07-my-project/)
2. Any relevant context, constraints, or specific requirements
3. Links to related research or previous implementations

I'll analyze this information and work with you to create a comprehensive plan.
```

Then wait for the user's input.

## Process Steps

### Step 1: Context Gathering & Initial Analysis

1. **Read all mentioned files immediately and FULLY**:
   - Research documents (e.g., `research.md`)
   - Any JSON/data files mentioned
   - **IMPORTANT**: Use the Read tool WITHOUT limit/offset parameters to read entire files
   - **CRITICAL**: DO NOT spawn sub-tasks before reading these files yourself in the main context
   - **NEVER** read files partially - if a file is mentioned, read it completely

2. **Spawn initial research tasks to gather context**:
   Before asking the user any questions, use Task agents to research in parallel:

   ```
   Task 1: "Find all files related to [feature]"
   Prompt: "Search the codebase for components related to [feature].
   Document what exists, do not suggest improvements.
   Return file paths and their current implementation."

   Task 2: "Analyze current implementation"
   Prompt: "Read and document how [system] currently works.
   Focus on data flow, key functions, and integration points.
   Document what IS, not what SHOULD BE."
   ```

   These agents will:
   - Find relevant source files, configs, and tests
   - Trace data flow and key functions
   - Return detailed explanations with file:line references

3. **Read all files identified by research tasks**:
   - After research tasks complete, read ALL files they identified as relevant
   - Read them FULLY into the main context
   - This ensures you have complete understanding before proceeding

4. **Analyze and verify understanding**:
   - Cross-reference the requirements with actual code
   - Identify any discrepancies or misunderstandings
   - Note assumptions that need verification
   - Determine true scope based on codebase reality

5. **Present informed understanding and focused questions**:

   ```
   Based on my research of the codebase, I understand we need to [accurate summary].

   I've found that:
   - [Current implementation detail with file:line reference]
   - [Relevant pattern or constraint discovered]
   - [Potential complexity or edge case identified]

   Questions that my research couldn't answer:
   - [Specific technical question that requires human judgment]
   - [Business logic clarification]
   - [Design preference that affects implementation]
   ```

   Only ask questions that you genuinely cannot answer through code investigation.

### Step 2: Research & Discovery

After getting initial clarifications:

1. **If the user corrects any misunderstanding**:
   - DO NOT just accept the correction
   - Spawn new research tasks to verify the correct information
   - Read the specific files/directories they mention
   - Only proceed once you've verified the facts yourself

2. **Create a research todo list** using TodoWrite to track exploration tasks

3. **Spawn parallel sub-tasks for comprehensive research**:

   ```
   # Spawn these tasks concurrently:
   - Task: "Find database schema", db_research_prompt
   - Task: "Analyze API patterns", api_research_prompt
   - Task: "Investigate UI components", ui_research_prompt
   - Task: "Check test patterns", test_research_prompt
   ```

   Each agent should:
   - Find the right files and code patterns
   - Identify conventions and patterns to follow
   - Look for integration points and dependencies
   - Return specific file:line references
   - Find tests and examples

4. **Wait for ALL sub-tasks to complete** before proceeding

5. **Present findings and design options**:

   ```
   Based on my research, here's what I found:

   **Current State:**
   - [Key discovery about existing code]
   - [Pattern or convention to follow]

   **Design Options:**
   1. [Option A] - [pros/cons]
   2. [Option B] - [pros/cons]

   **Open Questions:**
   - [Technical uncertainty]
   - [Design decision needed]

   Which approach aligns best with your vision?
   ```

### Step 3: Plan Structure Development

**think deeply**

Once aligned on approach:

1. **Create initial plan outline**:

   ```
   Here's my proposed plan structure:

   ## Overview
   [1-2 sentence summary]

   ## Implementation Phases:
   1. [Phase name] - [what it accomplishes]
   2. [Phase name] - [what it accomplishes]
   3. [Phase name] - [what it accomplishes]

   Does this phasing make sense? Should I adjust the order or granularity?
   ```

2. **Get feedback on structure** before writing details

### Step 4: Detailed Plan Writing

After structure approval, write the plan to the specified plan.md file:

````markdown
---
project: [from existing frontmatter]
ticket: [from existing frontmatter]
created: [from existing frontmatter]
status: ready
last_updated: [YYYY-MM-DD]
---

# [Feature/Task Name] Implementation Plan

## Overview

[Brief description of what we're implementing and why]

## Current State Analysis

[What exists now, what's missing, key constraints discovered]

### Key Discoveries:
- [Important finding with `file.ext:line` reference]
- [Pattern to follow]
- [Constraint to work within]

## Desired End State

[A Specification of the desired end state after this plan is complete, and how to verify it]

### Success means:
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

## What We're NOT Doing

[Explicitly list out-of-scope items to prevent scope creep]

- NOT implementing [X] (that's future work)
- NOT refactoring [Y] (out of scope)
- NOT changing [Z] (explicitly excluded)

## Implementation Approach

[High-level strategy and reasoning]

**Key decisions**:
- [Decision 1]: [Rationale based on research]
- [Decision 2]: [Rationale based on research]

---

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes and why it comes first]

### Changes Required

#### 1. [Component/File Group]
**File**: `path/to/file.ext`

**Changes**: [Summary of changes]

```[language]
// Specific code to add/modify
// Include enough context to understand the change
```

**Rationale**: [Why this specific implementation]

#### 2. [Another Component]
[Continue pattern...]

### Success Criteria

**⛔ CHECKPOINT: Must pass before moving to Phase 2**

#### Automated Verification:
- [ ] Database migration applies cleanly: `make migrate`
- [ ] Unit tests pass: `npm test` or `go test ./...`
- [ ] Type checking passes: `npm run typecheck`
- [ ] Linting passes: `make lint`
- [ ] Build succeeds: `make build`
- [ ] Integration tests pass: `make test-integration`

#### Manual Verification:
- [ ] Feature works as expected when tested via UI
- [ ] Performance is acceptable under normal load
- [ ] Edge case [X] handled correctly
- [ ] No regressions in [related feature]

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation from the human that the manual testing was successful before proceeding to the next phase.

---

## Phase 2: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Changes Required

[Similar structure to Phase 1...]

### Success Criteria

[Similar structure with both automated and manual criteria...]

---

## Testing Strategy

### Unit Tests
**What to test**:
- [Specific functionality with file reference]
- [Key edge cases]
- [Error conditions]

**Test files**:
- `path/to/test1.spec.ts` - [what it tests]
- `path/to/test2.test.js` - [what it tests]

### Integration Tests
**End-to-end scenarios**:
1. [Scenario 1]: [Expected behavior]
2. [Scenario 2]: [Expected behavior]

**Location**: `path/to/integration/tests/`

### Manual Testing Steps
1. [Specific step to verify feature]
   - Expected: [result]
2. [Another verification step]
   - Expected: [result]
3. [Edge case to test manually]
   - Expected: [behavior]

## Performance Considerations

[Any performance implications or optimizations needed]

- Current baseline: [metrics if known]
- Expected impact: [anticipated changes]
- Monitoring: [how to verify]

## Migration/Rollback Strategy

### Migration steps:
1. [Step 1 with specific commands]
2. [Step 2 with specific commands]

### Rollback plan:
1. [How to roll back if needed]
2. [Specific commands or steps]

## Dependencies

**External dependencies**:
- [Library/service needed] - version X.Y.Z
- [Another dependency] - why it's needed

**Team dependencies**:
- [Other work that must complete first]
- [Teams or people to coordinate with]

## Risk Assessment

**Potential risks**:
- **Risk 1**: [Description]
  - Likelihood: [High/Medium/Low]
  - Impact: [High/Medium/Low]
  - Mitigation: [How we'll handle it]

- **Risk 2**: [Description]
  - Likelihood: [High/Medium/Low]
  - Impact: [High/Medium/Low]
  - Mitigation: [How we'll handle it]

## References

- Original research: `research.md`
- Related implementation: `path/to/similar/feature.ext:123`
- Documentation: [relevant docs]
- Similar pattern used in: `path/to/example.ext:45-67`

## Estimated Effort

- Phase 1: [estimate with reasoning]
- Phase 2: [estimate with reasoning]
- Testing & validation: [estimate]
- Total: [sum]
````

### Step 5: Review and Iterate

1. **Present the draft plan location**:

   ```
   I've created the implementation plan at:
   `[path]/plan.md`

   The plan has [N] phases:
   1. [Phase 1] - [brief description]
   2. [Phase 2] - [brief description]
   3. [Phase 3] - [brief description]

   Please review it and let me know:
   - Are the phases properly scoped?
   - Are the success criteria specific enough?
   - Any technical details that need adjustment?
   - Missing edge cases or considerations?
   ```

2. **Iterate based on feedback** - be ready to:
   - Add missing phases
   - Adjust technical approach
   - Clarify success criteria (both automated and manual)
   - Add/remove scope items
   - Update risk assessment

3. **Continue refining** until the user is satisfied

## Important Guidelines

### Be Skeptical

- Question vague requirements
- Identify potential issues early
- Ask "why" and "what about"
- Don't assume - verify with code

### Be Interactive

- Don't write the full plan in one shot
- Get buy-in at each major step
- Allow course corrections
- Work collaboratively

### Be Thorough

- Read all context files COMPLETELY before planning
- Research actual code patterns using parallel sub-tasks
- Include specific file paths and line numbers
- Write measurable success criteria with clear automated vs manual distinction
- Automated steps should use standard commands whenever possible

### Be Practical

- Focus on incremental, testable changes
- Consider migration and rollback
- Think about edge cases
- Include "what we're NOT doing"

### Track Progress

- Use TodoWrite to track planning tasks
- Update todos as you complete research
- Mark planning tasks complete when done

### No Open Questions in Final Plan

- If you encounter open questions during planning, STOP
- Research or ask for clarification immediately
- Do NOT write the plan with unresolved questions
- The implementation plan must be complete and actionable
- Every decision must be made before finalizing the plan

## Success Criteria Guidelines

**Always separate success criteria into two categories:**

1. **Automated Verification** (can be run by execution agents):
   - Commands that can be run: `make test`, `npm run lint`, etc.
   - Specific files that should exist
   - Code compilation/type checking
   - Automated test suites

2. **Manual Verification** (requires human testing):
   - UI/UX functionality
   - Performance under real conditions
   - Edge cases that are hard to automate
   - User acceptance criteria

**Format example:**

```markdown
### Success Criteria:

#### Automated Verification:
- [ ] Database migration runs successfully: `make migrate`
- [ ] All unit tests pass: `go test ./...`
- [ ] No linting errors: `golangci-lint run`
- [ ] API endpoint returns 200: `curl localhost:8080/api/new-endpoint`

#### Manual Verification:
- [ ] New feature appears correctly in the UI
- [ ] Performance is acceptable with 1000+ items
- [ ] Error messages are user-friendly
- [ ] Feature works correctly on mobile devices
```

## Common Patterns

### For Database Changes

1. Start with schema/migration
2. Add data access methods
3. Update business logic
4. Expose via API
5. Update clients

### For New Features

1. Research existing patterns first
2. Start with data model
3. Build backend logic
4. Add API endpoints
5. Implement UI last

### For Refactoring

1. Document current behavior
2. Plan incremental changes
3. Maintain backwards compatibility
4. Include migration strategy

## Sub-task Spawning Best Practices

When spawning research sub-tasks:

1. **Spawn multiple tasks in parallel** for efficiency
2. **Each task should be focused** on a specific area
3. **Provide clear instructions** about documenting, not evaluating
4. **Request specific file:line references** in responses
5. **Wait for all tasks to complete** before synthesizing
6. **Verify sub-task results**:
   - If results seem incorrect, spawn follow-up tasks
   - Cross-check findings against the actual codebase

## Synchronization Points

1. ⛔ **BARRIER 1**: After reading initial files - Do not proceed until context is built
2. ⛔ **BARRIER 2**: After research tasks - Wait for ALL to complete
3. ⛔ **BARRIER 3**: After user feedback - Verify understanding before writing
4. ⛔ **CHECKPOINT**: Between phases - Require verification before proceeding

## Configuration

The command accepts the directory path as a parameter:

```
/create_plan docs/plans/2025-10-07-my-project
```

Or prompts for it if not provided.
