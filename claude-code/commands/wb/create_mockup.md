---
description: Research UI patterns and create initial mockup with clarifying questions
argument-hint: [project-directory] [feature-description]
---

# Create Mockup

Researches existing UI patterns, styles, and layouts, then creates an initial mockup iteration through interactive discussion. Follows the "research what EXISTS" philosophy before proposing changes.

## Purpose

This command:
- Documents current UI patterns and styles (research phase)
- Asks clarifying questions about the desired feature
- Creates a versioned mockup with rationale
- Sets up iteration tracking for refinement

## Initial Response

When invoked, check for arguments:

1. **If directory and feature provided** (e.g., `/create_mockup docs/plans/2025-01-08-dashboard/ "user settings panel"`):
   - Use `$1` as project directory
   - Use `$2+` as feature description
   - Begin research immediately

2. **If no arguments**:
   ```
   I'll help you create a UI mockup. Please provide:
   1. Path to the project documentation directory
   2. Brief description of what you want to mockup

   I'll research existing patterns first, then we'll discuss the design together.
   ```

## Process Steps

### Step 1: Research Existing UI

**⛔⛔⛔ BARRIER 1: STOP! Research current UI patterns before proposing anything ⛔⛔⛔**

Spawn parallel agents to document what EXISTS:

```javascript
// Agent 1: Layout Patterns
Task({
  description: "Research UI layouts",
  prompt: `You are documenting the codebase UI as it exists.

Find and document:
- Page layout patterns (grid, flex, containers)
- Navigation structure
- Content area organization
- Responsive breakpoints

Return with file:line references. DO NOT suggest improvements.`,
  subagent_type: "codebase-analyzer",
  model: "haiku"
})

// Agent 2: Component Library
Task({
  description: "Research UI components",
  prompt: `You are documenting the codebase UI as it exists.

Find and document:
- Existing component library (buttons, forms, cards, modals)
- Component naming conventions
- Props/API patterns
- Where components are defined

Return with file:line references. DO NOT suggest improvements.`,
  subagent_type: "codebase-analyzer",
  model: "haiku"
})

// Agent 3: Styling Patterns
Task({
  description: "Research styling approach",
  prompt: `You are documenting the codebase styling as it exists.

Find and document:
- CSS approach (CSS modules, Tailwind, styled-components, etc.)
- Color tokens/variables
- Typography scale
- Spacing system
- Theme configuration

Return with file:line references. DO NOT suggest improvements.`,
  subagent_type: "codebase-analyzer",
  model: "haiku"
})

// Agent 4: Similar Features
Task({
  description: "Find similar UI features",
  prompt: `You are documenting similar features in the codebase.

Find examples of:
- Similar panels/modals/pages to [feature description]
- How similar features are structured
- Patterns for [feature type] in this codebase

Return with file:line references. DO NOT suggest improvements.`,
  subagent_type: "pattern-finder",
  model: "haiku"
})
```

**⛔ BARRIER 2**: Wait for ALL agents to complete before proceeding.

### Step 2: Synthesize Research

Create a UI research summary:

```markdown
## UI Research Summary

### Layout System
- Pattern: [grid/flex/etc]
- Container widths: [values]
- Breakpoints: [mobile/tablet/desktop values]

### Component Library
- Location: [path]
- Key components: [list with file:line]
- Naming convention: [pattern]

### Styling Approach
- Method: [CSS modules/Tailwind/etc]
- Colors: [token location]
- Typography: [scale location]
- Spacing: [system]

### Similar Features
- [Feature 1]: [path] - [how it's structured]
- [Feature 2]: [path] - [how it's structured]

### Patterns to Follow
1. [Pattern from research]
2. [Pattern from research]
```

### Step 3: Clarifying Questions

**think deeply about what information is needed**

Before creating mockup, ask clarifying questions:

```
Based on my research of the existing UI, I have some questions:

**Scope & Purpose**
1. What problem does this [feature] solve for users?
2. Who is the primary user of this feature?

**Content & Data**
3. What information needs to be displayed?
4. What actions can users take?
5. Are there states to handle? (empty, loading, error, success)

**Placement & Flow**
6. Where does this fit in the navigation?
7. What triggers this UI to appear?
8. Where does the user go after completing this?

**Constraints**
9. Any technical constraints I should know about?
10. Mobile support required?

Please answer what you can - we can iterate on unknowns.
```

Wait for user responses before proceeding.

### Step 4: Create Mockup Directory

Set up versioned mockup structure:

```
[project-dir]/mockups/
├── mockup-log.md        # Decision log across versions
├── v001/
│   ├── mockup.md        # The mockup itself
│   └── decisions.md     # Rationale for this version
├── v002/
│   └── ...
```

### Step 5: Create Initial Mockup (v001)

**⛔ BARRIER 3**: No placeholders - all content must be specific based on research + answers.

Create `mockups/v001/mockup.md`:

````markdown
---
version: 1
created: [YYYY-MM-DD]
status: draft
feature: [feature name]
based_on: [similar feature from research]
---

# Mockup: [Feature Name] v001

## Overview

**Purpose**: [From clarifying questions]
**User**: [From clarifying questions]
**Trigger**: [How user gets here]

## Layout

```
┌─────────────────────────────────────────────────┐
│ [Header/Navigation - per existing pattern]       │
├─────────────────────────────────────────────────┤
│                                                 │
│   ┌─────────────────────────────────────────┐   │
│   │ [Component Area]                        │   │
│   │                                         │   │
│   │  [Content structure using ASCII]        │   │
│   │                                         │   │
│   │  ┌──────────┐  ┌──────────┐            │   │
│   │  │ Button 1 │  │ Button 2 │            │   │
│   │  └──────────┘  └──────────┘            │   │
│   │                                         │   │
│   └─────────────────────────────────────────┘   │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Components Used

| Component | From Library | Purpose |
|-----------|--------------|---------|
| [Component] | [file:line] | [what it does here] |

## Content Specifications

### [Section 1]
- **Data**: [what's displayed]
- **Source**: [where data comes from]
- **Empty state**: [what shows when no data]

### [Section 2]
...

## Interactions

1. **[Action]**: User clicks [element] → [result]
2. **[Action]**: User types in [field] → [validation/result]

## States

| State | Trigger | Display |
|-------|---------|---------|
| Loading | Initial load | [skeleton/spinner] |
| Empty | No data | [message + CTA] |
| Error | API failure | [error message] |
| Success | Action complete | [confirmation] |

## Styling Notes

- Uses [color tokens] from [file]
- Follows [spacing system]
- Typography: [heading/body styles]

## Open Questions

Track in beads to ensure resolution before finalizing:

| Question | Beads ID | Blocks |
|----------|----------|--------|
| [Question needing resolution] | `[id]` | finalization |

```bash
# Create beads issues for UI questions:
bd create --title="UI Q: [brief question]" --type=task --priority=2 \
  --description="From mockup v001. Blocks: [what can't proceed]"
```
````

Create `mockups/v001/decisions.md`:

```markdown
---
version: 1
created: [YYYY-MM-DD]
---

# v001 Decisions

## Choices Made

### Layout Choice
- **Decision**: [what was chosen]
- **Rationale**: [why, referencing research]
- **Alternative considered**: [what else could work]

### Component Choices
- **Decision**: Use [component] for [purpose]
- **Rationale**: Matches existing pattern at [file:line]

## Based On Research

- Layout follows pattern from [similar feature]
- Components reused from [library location]
- Styling matches [existing page]

## Assumptions

1. [Assumption made due to unclear requirement]
2. [Assumption about user behavior]

## Needs Validation

- [ ] [Thing to verify with user/stakeholder]
- [ ] [Technical feasibility question]
```

### Step 6: Initialize Mockup Log

Create `mockups/mockup-log.md`:

```markdown
---
feature: [feature name]
created: [YYYY-MM-DD]
current_version: 1
status: iterating
project_directory: [full path to project directory]
last_updated: [YYYY-MM-DD]
---

# Mockup Iteration Log

## Feature: [Name]

**Goal**: [From clarifying questions]

## Version History

### v001 - [YYYY-MM-DD] - Initial Draft
- **Status**: In Review
- **Key decisions**: [brief summary]
- **Feedback needed**: [what to validate]

## UI Research Reference

_From initial research - apply to all versions:_

- **Layout pattern**: [pattern from research]
- **Component library**: [location]
- **Styling system**: [approach]
- **Similar features**: [references]

## Running Requirements

### Confirmed (KEEP)
_Requirements confirmed through iteration_

### Rejected (REMOVE)
_Ideas explored and rejected with rationale_

### Open (DECIDING)
_Still being discussed_

## Design Principles Emerging

1. [Principle discovered through iteration]
```

### Step 7: Present for Iteration

```
✅ Initial mockup created!

📁 Location: [project-dir]/mockups/v001/

**What I created based on research:**
- Layout following [pattern] from [similar feature]
- Using components: [list]
- Styling per existing [system]

**Key decisions made:**
1. [Decision 1] - because [rationale]
2. [Decision 2] - because [rationale]

**Open questions:**
- [Question 1]
- [Question 2]

**Next steps:**
- Review the mockup at mockups/v001/mockup.md
- Use the mockup-iteration skill to refine: just discuss changes
- Each iteration will be versioned with decisions captured

Ready to iterate? Just tell me what to keep, change, or remove.
```

## Output Files

| File | Purpose |
|------|---------|
| `mockups/mockup-log.md` | Track all versions and running requirements |
| `mockups/v001/mockup.md` | The actual mockup |
| `mockups/v001/decisions.md` | Rationale for this version |

## Important Guidelines

### Research First
- ALWAYS research existing UI before proposing
- Reference specific file:line locations
- Follow established patterns unless explicitly breaking them

### Clarifying Questions
- Ask before assuming
- Understand the WHY not just the WHAT
- Identify constraints early

### Versioning
- Never overwrite - always create new version
- Document what changed and why
- Keep decision trail for design.md

### Fidelity
- ASCII mockups for layout structure
- Component specs for implementation detail
- State documentation for edge cases

## Relationship to Other Commands

**Typical workflow:**
1. `/wb:create_research` - Understand the codebase
2. **`/wb:create_mockup`** - Research UI + create initial mockup
3. [Iterate with mockup-iteration skill]
4. `/wb:create_design` - Finalize design from mockup decisions
5. `/wb:create_execution` - Plan implementation

The mockup process feeds into design.md with validated requirements.
