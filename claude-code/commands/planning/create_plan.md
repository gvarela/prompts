---
description: Create detailed implementation plan through interactive discussion
argument-hint: [project-directory]
---

# Generate Implementation Plan

Creates detailed implementation plans through an interactive, iterative process. Works collaboratively with the user to produce high-quality technical specifications based on research findings.

## Initial Response

When invoked, check for arguments:

1. **If directory provided** (e.g., `/planning/create_plan docs/plans/2025-01-08-auth/`):
   - Use `$1` as the project directory
   - Read research.md and other files immediately
   - Begin interactive planning process

2. **If no arguments**:
   ```
   I'll help you create a detailed implementation plan. Please provide:
   1. Path to the project documentation directory
   2. Any specific constraints or requirements

   Example: /planning/create_plan docs/plans/2025-01-08-auth/
   ```

## Process Steps

### Step 1: Context Gathering

**⛔ BARRIER 1**: Read ALL project files FULLY before proceeding

```javascript
const projectDir = $1 || /* prompt for it */;

// Read existing documentation
const researchFile = `${projectDir}/research.md`;
const planFile = `${projectDir}/plan.md`;
const tasksFile = `${projectDir}/tasks.md`;
```

Read ALL files completely to understand:
- Research findings and discoveries
- Current implementation details
- Project scope and requirements
- Any existing plan content

### Step 2: Analyze Research & Spawn Agents

**think deeply about the research findings**

After reading the research, spawn specialized agents to gather additional context:

```javascript
// Spawn agents in parallel for efficiency
Task({
  description: "Verify implementation approach",
  prompt: `Use the codebase-analyzer agent to verify our planned approach.

  Based on the research, we're planning to [approach].
  Verify:
  - Current patterns that we should follow
  - Integration points we need to consider
  - Potential conflicts or issues

  Document findings with file:line references.`,
  subagent_type: "general-purpose"
})

Task({
  description: "Find similar implementations",
  prompt: `Use the pattern-finder agent to find similar features.

  Look for:
  - Similar functionality already implemented
  - Patterns we can follow
  - Testing approaches used

  Return examples with references.`,
  subagent_type: "general-purpose"
})
```

**⛔ BARRIER 2**: Wait for ALL agents to complete

### Step 3: Present Understanding & Questions

Based on research and agent findings, present understanding:

```
Based on the research and my analysis, I understand we need to [clear summary].

Key findings from research:
- [Finding 1 with file:line reference]
- [Finding 2 with pattern identified]
- [Finding 3 with constraint discovered]

Similar implementations found:
- [Example 1] at `file.js:123`
- [Example 2] at `other.js:456`

Before creating the plan, I need to clarify:
1. [Specific technical decision]
2. [Scope boundary question]
3. [Performance requirement]

These will help ensure the plan is complete and actionable.
```

### Step 4: Interactive Planning Discussion

**think deeply about the implementation approach**

Engage in discussion about the approach:

```
## Proposed Implementation Strategy

Based on our discussion, here's my proposed approach:

### Option A: [Approach Name]
**How it works**: [Description]
**Pros**:
- Follows existing pattern at `file.js:123`
- Minimal changes required
**Cons**:
- May need refactoring later
- Performance implications

### Option B: [Approach Name]
**How it works**: [Description]
**Pros**:
- More scalable
- Better separation of concerns
**Cons**:
- More complex initial implementation
- Requires new patterns

Which approach aligns better with the project goals?
```

### Step 5: Structure Proposal

Once approach is agreed:

```
Here's my proposed plan structure:

## Implementation Phases

**Phase 1: Foundation** (1-2 days)
- Set up base infrastructure
- Create database schema
- Add configuration

**Phase 2: Core Logic** (2-3 days)
- Implement business logic
- Add validation
- Create service layer

**Phase 3: API Layer** (1-2 days)
- Create endpoints
- Add authentication
- Write API tests

**Phase 4: Integration** (1 day)
- Connect to existing systems
- Update documentation
- Final testing

Does this phasing make sense? Should I adjust the scope or order?
```

### Step 6: Write Detailed Plan

After agreement, update the plan.md file:

````markdown
---
status: ready  # Update from draft
last_updated: [YYYY-MM-DD]
estimated_phases: [number]
git_commit: [current-commit]
---

# Implementation Plan: [Feature Name]

## Overview

[Clear description of what we're building and why]

## Current State Analysis

Based on research findings:
- [Key discovery from research.md]
- [Current implementation at `file.js:123`]
- [Pattern to follow from `pattern.js:456`]

### Key Constraints
- Must work with existing [system]
- Cannot modify [protected component]
- Performance requirement: [metric]

## Desired End State

After implementation:
- ✅ [Measurable outcome 1]
- ✅ [Measurable outcome 2]
- ✅ [Measurable outcome 3]

### Success Metrics
- [Metric 1]: [Current] → [Target]
- [Metric 2]: [Current] → [Target]

## What We're NOT Doing

Explicitly out of scope:
- ❌ Not refactoring [existing system]
- ❌ Not adding [feature X]
- ❌ Not changing [component Y]

---

## Phase 1: [Foundation Setup]

**Duration**: 1-2 days
**Dependencies**: None

### Overview
[What this phase accomplishes and why it's first]

### Changes Required

#### 1. Database Schema (`db/migrations/`)
```sql
-- Add new tables/columns
CREATE TABLE feature_data (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### 2. Configuration (`config/feature.js`)
```javascript
// Add feature configuration
module.exports = {
  feature: {
    enabled: process.env.FEATURE_ENABLED || false,
    timeout: process.env.FEATURE_TIMEOUT || 5000
  }
};
```

### Success Criteria

**⛔ CHECKPOINT: Verify before Phase 2**

#### Automated Verification
- [ ] Migration runs: `npm run migrate`
- [ ] Config loads: `npm test config`
- [ ] Schema valid: `npm run validate-schema`

#### Manual Verification
- [ ] Database tables created correctly
- [ ] Configuration accessible in app
- [ ] No breaking changes to existing data

---

## Phase 2: [Core Implementation]

**Duration**: 2-3 days
**Dependencies**: Phase 1 complete

### Overview
[Core business logic implementation]

### Changes Required

#### 1. Service Layer (`src/services/feature-service.js`)
```javascript
class FeatureService {
  async process(data) {
    // Validate input
    const validated = this.validate(data);

    // Process business logic
    const result = await this.transform(validated);

    // Store and return
    return this.store(result);
  }
}
```

#### 2. Validation (`src/validators/feature.js`)
[Implementation details with code]

### Success Criteria

**⛔ CHECKPOINT: Verify before Phase 3**

#### Automated Verification
- [ ] Unit tests pass: `npm test services`
- [ ] Integration tests: `npm test integration`
- [ ] Linting clean: `npm run lint`

#### Manual Verification
- [ ] Business logic works correctly
- [ ] Error cases handled properly
- [ ] Performance acceptable

---

## Phase 3: [API Integration]

**Duration**: 1-2 days
**Dependencies**: Phase 2 complete

[Continue with similar structure]

---

## Testing Strategy

### Unit Tests
- Test each service method
- Validate error handling
- Mock external dependencies

**Test Files**:
- `tests/services/feature.test.js`
- `tests/validators/feature.test.js`

### Integration Tests
- End-to-end flow testing
- Database interaction verification
- API response validation

### Manual Test Cases
1. Happy path: [Steps and expected result]
2. Error case: [Steps and expected result]
3. Edge case: [Steps and expected result]

## Rollback Plan

If issues arise:
1. Revert migrations: `npm run migrate:rollback`
2. Disable feature flag: `FEATURE_ENABLED=false`
3. Revert code changes: `git revert [commits]`

## Dependencies

**External**:
- Library X (v1.2.3) - for [purpose]
- Service Y - for [integration]

**Internal**:
- Existing auth system
- Current database schema

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Performance degradation | Medium | High | Load testing, gradual rollout |
| Data migration issues | Low | High | Backup before migration |
| Integration conflicts | Medium | Medium | Feature flag for gradual enable |

## References

- Research: [research.md](research.md)
- Similar implementation: `src/features/similar.js`
- Design doc: [link if applicable]

## Estimated Timeline

- Phase 1: 1-2 days
- Phase 2: 2-3 days
- Phase 3: 1-2 days
- Phase 4: 1 day
- Testing & validation: 1 day
- **Total: 6-9 days**
````

### Step 7: Update Project Status

Update tasks.md to reflect plan completion:

```markdown
### 📋 Documentation Setup
- [x] Create project structure (completed [date time])
- [x] Complete research using `/planning/create_research` (completed [date time])
- [x] Create implementation plan using `/planning/create_plan` (completed [date time])
- [ ] Generate task list using `/planning/create_tasks [directory]`
```

### Step 8: Present Summary

```
✅ Implementation plan created successfully!

📊 Plan Summary:
- Phases: [N] phases over [X-Y] days
- Approach: [Brief description]
- Risk level: [Low/Medium/High]

📁 Updated: [project-directory]/plan.md

🔑 Key Decisions:
- [Decision 1]: [Choice made]
- [Decision 2]: [Choice made]

⚠️ Main Risks:
- [Risk 1]: [Mitigation planned]
- [Risk 2]: [Mitigation planned]

📋 Progress Update:
- Planning: ✅ Complete (3/4 tasks done)
- Next: Generate task list

🔄 Next Step:
Run: /planning/create_tasks [directory]

This will extract all tasks from the plan into an actionable checklist.
```

## Important Guidelines

### Interactive Approach
- **Get buy-in** at each major decision
- **Present options** not just one solution
- **Ask clarifying questions** early
- **Iterate based on feedback**

### Quality Checks
- ✓ All phases have clear scope
- ✓ Success criteria are measurable
- ✓ Both automated and manual verification included
- ✓ No unresolved questions in the plan
- ✓ File references are accurate

### Planning Philosophy
- **Be skeptical** - question assumptions
- **Be thorough** - consider edge cases
- **Be practical** - incremental changes
- **Be specific** - exact commands and files

### Agent Usage
- Spawn agents to verify assumptions
- Use agents to find patterns and examples
- Let agents handle the detailed searching
- Focus on synthesis and decision-making

## Error Handling

**If research is incomplete**:
- Identify what's missing
- Run focused research with agents
- Update research.md first
- Then continue planning

**If conflicting patterns found**:
- Present both options to user
- Explain trade-offs
- Let user decide direction
- Document decision in plan

**If scope unclear**:
- List assumptions
- Get explicit confirmation
- Document "NOT doing" section clearly
- Prevent scope creep