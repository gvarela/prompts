# create_mockup — Output Templates

Read the relevant section in full when its step directs you here; match its structure exactly.

## UI Research Summary (Step 2)

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

### Icon System
- Library: [Font Awesome / Material Icons / Heroicons / SVG sprites / Custom / None]
- Location: [file:line where icons imported/defined]
- Usage pattern: [<i class="..."> / <Icon name="..."> / <svg><use href="...">]
- Sizing: [classes or conventions]
- Examples: [file:line references to icon usage]

### Similar Features
- [Feature 1]: [path] - [how it's structured]
- [Feature 2]: [path] - [how it's structured]

### Patterns to Follow
1. [Pattern from research]
2. [Pattern from research]
```

## mockup.md v001 Template (Step 5)

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

## Icons

- System: [icon library/approach from research, or "None - text only"]
- Usage: [how icons are applied, with examples]
- Locations: [where icons appear in this mockup]

**If no icon system found but icons needed:**
Create beads issue: `bd create "UI Q: Icon system?" --type=task --priority=2 -d "Mockup needs icons but no system found. Options: add library, use text only, custom SVG"`

## Open Questions

UI questions are tracked in beads, NOT in this document.

**To add a UI question**:

```bash
bd create "UI Q: [your question]" --type=task --priority=2 \
  -d "From mockup v[version]. Blocks: [what can't proceed without answer]"
# → Returns issue ID (e.g., prompts-abc)
```

**Active questions** (reference only, beads is source of truth):

Use `bd list -n 0 --status=open | grep "UI Q:"` to see all open UI questions, or reference by ID:
- `[id]`: [Brief question summary] - blocks finalization
- `[id]`: [Brief question summary] - blocks [what it blocks]

To see full question details: `bd show [id]`
````

## decisions.md Template (Step 5)

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

## HTML Mockup Template (Step 6)

`````html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mockup: [Feature Name] v001</title>

  <!-- Import app's styles based on research -->
  <!-- If using Tailwind: -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- If using app's CSS files (adjust paths): -->
  <!-- <link rel="stylesheet" href="../../src/styles/main.css"> -->

  <!-- If using icon library from research: -->
  <!-- Font Awesome example: -->
  <!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"> -->

  <!-- Material Icons example: -->
  <!-- <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons"> -->

  <style>
    /* Add any custom styles needed to match app exactly */
    /* Copy from discovered theme/color tokens */
  </style>
</head>
<body class="[discovered body classes from research]">

  <!-- Header/Navigation - copy structure from research file:line -->
  <header class="[actual header classes from app]">
    <!-- Use actual nav structure from research -->
  </header>

  <!-- Main content area -->
  <main class="[layout classes from research]">

    <!-- Feature mockup using real component HTML -->
    <div class="[container classes from research]">

      <h1 class="[heading classes from research]">
        <!-- Icon if system found: -->
        <!-- <i class="fa-solid fa-[icon-name]"></i> -->
        [Feature Title]
      </h1>

      <!-- Content sections matching ASCII diagram -->

      <!-- Buttons using app's actual button HTML -->
      <div class="[button container classes]">
        <button class="[primary button classes from research]">
          <!-- Icon if used in app: -->
          <!-- <i class="fa-solid fa-save"></i> -->
          Primary Action
        </button>
        <button class="[secondary button classes from research]">
          Secondary Action
        </button>
      </div>

    </div>

  </main>

  <!-- Footer if app has one -->

</body>
</html>
`````

## mockup-log.md Template (Step 8)

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
- **Icon system**: [library and usage pattern, or "None - text only"]
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
