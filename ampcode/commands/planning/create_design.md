# Create Design Document

Creates architectural and technical design decisions based on validated research. Focuses on WHAT to build and WHY, not HOW to implement.

## Initial Setup

**Check if user provided parameters below before asking:**

If the user filled in the "User Input Section" at the bottom of this prompt, use those parameters and proceed directly to design.

If parameters are NOT provided, respond with:

```
I'll help you create a design document based on the research. Please provide:
1. Path to the project documentation directory (e.g., docs/plans/2025-10-07-my-project/)
2. Any specific constraints or requirements for the design
3. Any architectural preferences or patterns to follow

I'll analyze the research findings and work with you to make design decisions.
```

Then wait for the user's input.

## Prerequisites

- **MUST** have completed research.md in the project directory
- Research should be validated (facts confirmed accurate)
- Knowledge gaps from research should be reviewed

## Process Steps

### Step 1: Read and Analyze Research

**⛔ BARRIER 1**: Read research.md FULLY before proceeding

1. **Read research.md completely**:
   - Understand current implementation
   - Note all patterns and conventions found
   - Identify constraints that must be respected
   - Review knowledge gaps section

2. **Extract key design inputs**:
   - What exists that we must work with
   - What patterns should we follow
   - What constraints limit our options
   - What gaps might affect our design

**think deeply**

Synthesize the research into design constraints and opportunities.

### Step 2: Problem Definition

Based on research, clearly articulate:

1. **The Problem**:
   - What specific problem are we solving?
   - Why does it need to be solved now?
   - What happens if we don't solve it?

2. **Success Metrics**:
   - How will we measure success?
   - What are the acceptance criteria?
   - What are the performance requirements?

3. **Constraints**:
   - Technical constraints from research
   - Business constraints
   - Time/resource constraints

### Step 3: Solution Exploration

**Interactive Design Discussion**

1. **Generate design options**:
   ```
   Based on the research, I see [2-3] possible approaches:

   **Option A: [Descriptive Name]**
   - Approach: [Brief description]
   - Pros: [Benefits]
   - Cons: [Drawbacks]
   - Risk: [Main risk]

   **Option B: [Descriptive Name]**
   - Approach: [Brief description]
   - Pros: [Benefits]
   - Cons: [Drawbacks]
   - Risk: [Main risk]

   Which approach aligns best with your priorities?
   Or should we explore a hybrid approach?
   ```

2. **Discuss trade-offs**:
   - Performance vs simplicity
   - Time to market vs completeness
   - Flexibility vs specificity

3. **Get explicit approval** on the chosen approach before proceeding

### Step 4: Document Design Decisions

Create design.md with the following structure:

```markdown
---
project: [from existing frontmatter]
ticket: [from existing frontmatter]
created: [from existing frontmatter]
status: draft
last_updated: [YYYY-MM-DD]
depends_on: research.md
design_approach: [selected option name]
---

# Design: [Feature/Task Name]

## Problem Statement

[Clear articulation of the problem we're solving and why it matters]

### Success Metrics
- [Measurable outcome 1]
- [Measurable outcome 2]
- [Measurable outcome 3]

## Design Approach

[High-level description of the chosen solution approach]

### Why This Approach
- [Rationale for choosing this over alternatives]
- [How it aligns with existing patterns from research]
- [How it addresses the core problem]

## Technical Decisions

### Architecture
- [Key architectural decision 1]
  - Rationale: [Why this choice]
  - Trade-off: [What we're giving up]

### Data Model
- [Data structure/schema decisions]
- [State management approach]
- [Data flow design]

### Integration Points
- [How this integrates with existing systems]
- [API contracts or interfaces]
- [Dependencies on other components]

## Scope Definition

### In Scope
- [Specific feature/capability 1]
- [Specific feature/capability 2]
- [Specific feature/capability 3]

### Out of Scope
- [What we explicitly won't do]
- [Features deferred to later]
- [Problems we're not solving]

## Success Criteria

### Functional Requirements
- [ ] [User-facing capability 1]
- [ ] [User-facing capability 2]
- [ ] [System behavior 1]

### Non-Functional Requirements
- [ ] Performance: [Specific metric]
- [ ] Reliability: [Specific metric]
- [ ] Security: [Specific requirement]

## Risk Analysis

### Technical Risks
| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [Strategy] |

### Assumptions
Based on knowledge gaps from research:
- Assuming [gap 1] works as [description]
- Assuming [gap 2] can be resolved by [approach]

## Rejected Alternatives

### Option: [Alternative Approach Name]
- **Approach**: [What it would have done]
- **Rejected because**: [Specific reasons]
- **Trade-offs**: [What we would have gained/lost]

## Pending Decisions

Design decisions that need stakeholder input:
- [Decision 1]: [What needs to be decided]
- [Decision 2]: [Options and trade-offs]

Note: These don't block execution planning but should be resolved before implementation.

## References

- Research: [research.md](research.md)
- Related designs: [if any]
- External docs: [if any]
```

### Step 5: Review and Iterate

1. **Present the design**:
   ```
   ✅ Design document created at: [path]/design.md

   Design approach: [selected approach name]

   Key decisions made:
   - [Major decision 1]
   - [Major decision 2]
   - [Major decision 3]

   Pending decisions: [count]

   The design document includes:
   - Problem statement and success metrics
   - Technical architecture decisions
   - Clear scope boundaries
   - Risk analysis and mitigation

   Please review and provide feedback:
   - Are the success criteria appropriate?
   - Do the technical decisions align with your vision?
   - Are there risks we haven't considered?
   - Should any out-of-scope items be included?
   ```

2. **Iterate based on feedback**:
   - Adjust success criteria
   - Refine technical decisions
   - Add/remove scope items
   - Update risk analysis

3. **Get explicit approval**:
   ```
   Once you're satisfied with the design, please confirm approval.
   After approval, run `/create_execution` to build the implementation plan.
   ```

## Important Guidelines

### Design Principles

1. **Separate WHAT from HOW**:
   - Design says WHAT to build and WHY
   - Execution plan says HOW to build it
   - Don't include implementation sequences

2. **Make Decisions Explicit**:
   - Document every significant choice
   - Include rationale and trade-offs
   - Note what was rejected and why

3. **Respect Research Findings**:
   - Build on patterns found in research
   - Respect constraints discovered
   - Don't contradict factual findings

4. **Keep It Disposable**:
   - Design should be complete but changeable
   - If approach is wrong, should be able to start over
   - Research remains valid even if design changes

### What Belongs in Design vs Execution

**Design (THIS document)**:
- ✅ Architecture decisions
- ✅ Data models
- ✅ API contracts
- ✅ Success criteria
- ✅ Scope boundaries
- ✅ Technical approach

**Execution (tasks.md)**:
- ❌ Phase sequencing
- ❌ Specific code changes
- ❌ Step-by-step implementation
- ❌ Test writing tasks
- ❌ File modification lists
- ❌ Command sequences

### Handling Knowledge Gaps

When research has knowledge gaps:

1. **Document assumptions**:
   - State what you're assuming
   - Note risk if assumption is wrong
   - Plan for discovery during implementation

2. **Design for flexibility**:
   - Don't over-commit to uncertain areas
   - Build in abstraction where needed
   - Plan for multiple scenarios

3. **Flag for implementation**:
   - Mark decisions that depend on unknowns
   - Note what needs investigation
   - Will be resolved in execution phase

## Synchronization Points

1. **⛔ BARRIER 1**: After reading research - ensure full understanding
2. **⛔ DECISION POINT**: After presenting options - get approach approval
3. **⛔ APPROVAL GATE**: After writing design - get explicit approval

## Configuration

This command creates design decisions based on validated research. See the User Input Section at the bottom to provide parameters directly, or submit without parameters for interactive mode.

---

## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

```
- Project directory: docs/plans/2025-10-08-payment-integration
- Design constraints: Must maintain backwards compatibility, use existing Redis
- Architectural preference: Event-driven where possible
```

**Parameters:**

- Project directory:
- Design constraints: (optional)
- Architectural preference: (optional)