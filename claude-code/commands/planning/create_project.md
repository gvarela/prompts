---
description: Initialize comprehensive project documentation with research, plan, and task files
argument-hint: [project-name] [base-dir] [ticket-ref]
---

# Initialize Project Documentation

Creates a comprehensive documentation structure for a new project or feature, setting up folders and files for research, planning, and task tracking with proper metadata.

## Initial Response

When invoked, check for arguments:

1. **If arguments provided** (e.g., `/create_project auth-refactor docs/plans LINEAR-456`):
   - Parse: `$1` = project-name, `$2` = base-dir, `$3` = ticket-ref
   - Skip prompting and proceed directly to Step 2

2. **If partial arguments** (e.g., `/create_project auth-refactor`):
   - Use provided arguments and prompt only for missing ones

3. **If no arguments**:
   - Prompt for all required information:
   ```
   I'll help you set up comprehensive project documentation. Please provide:
   1. Project name (short, kebab-case preferred, e.g., auth-refactor)
   2. Base directory (default: docs/plans)
   3. Ticket/issue reference (optional, e.g., GH-123, JIRA-456, LINEAR-789)

   I'll create a timestamped project directory with research, plan, and task tracking files.
   ```

## Process Steps

### Step 1: Parse Arguments

```javascript
// Parse provided arguments
const projectName = $1;  // First argument
const baseDir = $2 || 'docs/plans';  // Second argument with default
const ticketRef = $3 || null;  // Third argument (optional)

// If any required args missing, prompt for them
```

### Step 2: Gather Metadata

**think deeply**

Collect system metadata for proper tracking:

```bash
# Git metadata (if in a git repository)
git_commit=$(git rev-parse HEAD 2>/dev/null || echo "not-in-git")
git_branch=$(git branch --show-current 2>/dev/null || echo "not-in-git")
git_remote=$(git remote get-url origin 2>/dev/null || echo "no-remote")

# Extract repository name from remote URL
repo_name=$(echo $git_remote | sed 's/.*[:/]\([^/]*\/[^.]*\).*/\1/')

# System metadata
current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
current_date_simple=$(date +"%Y-%m-%d")
username=$(whoami)
```

### Step 3: Create Directory Structure

Create the project directory with format:

```
[base-directory]/[YYYY-MM-DD]-[TICKET-][project-name]/
```

Examples:
- `docs/plans/2025-01-08-auth-refactor/`
- `docs/plans/2025-01-08-LINEAR-789-api-migration/`

### Step 4: Create Initial Files with Rich Metadata

Create four foundation files:

**1. README.md** - Navigation hub
````markdown
# [Project Name]

**Created**: [YYYY-MM-DD]
**Ticket**: [ticket-reference or N/A]
**Status**: Planning

## Overview

This directory contains documentation for [project-name].

## Documentation Structure

- **[research.md](research.md)** - Codebase research and findings
- **[plan.md](plan.md)** - Detailed implementation plan
- **[tasks.md](tasks.md)** - Task tracking and progress

## Workflow

1. ✅ Project structure created
2. ⏳ Research phase (`/planning/create_research [directory]`)
3. ⏳ Planning phase (`/planning/create_plan [directory]`)
4. ⏳ Task breakdown (`/planning/create_tasks [directory]`)
5. ⏳ Implementation
6. ⏳ Testing & Verification

## Quick Commands

```bash
# Continue with research (analyzes codebase)
/planning/create_research [this-directory]

# Create implementation plan
/planning/create_plan [this-directory]

# Generate task list from plan
/planning/create_tasks [this-directory]

# Update status across all files
/planning/update_status [this-directory]
```

## Git Information

- **Branch**: [branch-name]
- **Commit**: [commit-hash]
- **Repository**: [repo-name]
````

**2. research.md** - Research documentation
````markdown
---
project: [project-name]
ticket: [ticket-reference or null]
created: [YYYY-MM-DD]
created_timestamp: [ISO-8601 timestamp]
status: draft
last_updated: [YYYY-MM-DD]
researcher: [username]
git_commit: [commit-hash or "not-in-git"]
git_branch: [branch-name or "not-in-git"]
repository: [repo-name or "unknown"]
tags: [research, codebase, [project-name]]
---

# Research: [Project Name]

**Created**: [YYYY-MM-DD HH:MM UTC]
**Researcher**: [username]
**Ticket**: [ticket-reference or N/A]
**Git Commit**: [commit-hash]
**Branch**: [branch-name]

## Research Question

[What are we trying to understand? To be filled by /planning/create_research]

## Summary

[High-level findings - to be added]

## Detailed Findings

[Research findings will be documented here by /planning/create_research]

### Component Analysis
[How components work - to be added]

### Data Flow
[How data moves through system - to be added]

### Dependencies
[External dependencies and integrations - to be added]

## Architecture Documentation

### Patterns Found
[Patterns and conventions discovered - to be added]

### File Structure
[Relevant directory structure - to be added]

## Code References

Quick reference to key files:
[Specific file:line references - to be added]

## Similar Implementations

[Examples from codebase - to be added]

## Open Questions

[Areas needing further investigation - to be added]

## Next Steps

1. Run `/planning/create_research [directory]` to populate this document
2. Review findings before planning

## References

- Plan: [plan.md](plan.md)
- Tasks: [tasks.md](tasks.md)
````

**3. plan.md** - Implementation planning
````markdown
---
project: [project-name]
ticket: [ticket-reference or null]
created: [YYYY-MM-DD]
created_timestamp: [ISO-8601 timestamp]
status: draft
last_updated: [YYYY-MM-DD]
planner: [username]
git_commit: [commit-hash or "not-in-git"]
git_branch: [branch-name or "not-in-git"]
repository: [repo-name or "unknown"]
tags: [plan, implementation, [project-name]]
estimated_phases: 0
---

# Implementation Plan: [Project Name]

**Created**: [YYYY-MM-DD HH:MM UTC]
**Planner**: [username]
**Ticket**: [ticket-reference or N/A]
**Status**: Draft

## Overview

[What we're building and why - to be filled by /planning/create_plan]

## Current State Analysis

[What exists today based on research - to be added]

### Key Discoveries
- [To be added from research]

## Desired End State

[What success looks like - to be added]

### Success Criteria
- [ ] [To be defined]

## What We're NOT Doing

[Scope boundaries - to be defined]

## Implementation Approach

[Strategy and reasoning - to be added]

## Implementation Phases

### Phase 1: [To be defined]

**Overview**: [What this phase accomplishes]

**Changes Required**:
[To be detailed]

**Success Criteria**:

#### Automated Verification
- [ ] Tests pass: `[command]`
- [ ] Lint passes: `[command]`
- [ ] Build succeeds: `[command]`

#### Manual Verification
- [ ] Feature works as expected
- [ ] Performance acceptable
- [ ] No regressions

**⛔ CHECKPOINT**: Must pass all criteria before Phase 2

---

[Additional phases to be added by /planning/create_plan]

## Testing Strategy

[To be defined]

## Performance Considerations

[To be analyzed]

## Migration/Rollback Strategy

[To be planned if applicable]

## Dependencies

[To be identified]

## Risk Assessment

[To be evaluated]

## References

- Research: [research.md](research.md)
- Tasks: [tasks.md](tasks.md)

## Estimated Effort

[To be estimated by /planning/create_plan]
````

**4. tasks.md** - Task tracking
````markdown
---
project: [project-name]
ticket: [ticket-reference or null]
created: [YYYY-MM-DD]
created_timestamp: [ISO-8601 timestamp]
status: not-started
last_updated: [YYYY-MM-DD]
assignee: [username]
current_phase: 0
total_tasks: 4
completed_tasks: 1
git_commit: [commit-hash or "not-in-git"]
git_branch: [branch-name or "not-in-git"]
repository: [repo-name or "unknown"]
tags: [tasks, tracking, [project-name]]
---

# Tasks: [Project Name]

**Created**: [YYYY-MM-DD HH:MM UTC]
**Assignee**: [username]
**Ticket**: [ticket-reference or N/A]
**Current Phase**: Planning

## Progress Overview

| Phase | Status | Tasks | Progress |
|-------|--------|-------|----------|
| Planning | 🔄 In Progress | 1/4 | 25% |
| Implementation | ⏸️ Not Started | 0/0 | 0% |

**Overall Progress**: 1/4 planning tasks (25%)

---

## Planning Phase

### 📋 Documentation Setup
- [x] Create project structure (completed [YYYY-MM-DD HH:MM])
- [ ] Complete research using `/planning/create_research [directory]`
- [ ] Create implementation plan using `/planning/create_plan [directory]`
- [ ] Generate task list using `/planning/create_tasks [directory]`

---

## Implementation Phases

[To be populated by /planning/create_tasks after plan is created]

---

## 📝 Completed Tasks Archive

- [x] Create project structure - [YYYY-MM-DD HH:MM]

---

## 🚧 Blockers & Notes

### Current Blockers
| Blocker | Impact | Action | Owner | Due Date |
|---------|--------|--------|-------|----------|
| Research needed | Can't plan | Run /planning/create_research | [username] | [date] |

### Implementation Notes
- Project initialized on [YYYY-MM-DD]

---

## 🔗 Quick Reference

### Key Files
- **Research**: [research.md](research.md)
- **Plan**: [plan.md](plan.md)

### Next Action
**Run**: `/planning/create_research [this-directory]`
````

**⛔ BARRIER 1**: Ensure all files are created with proper frontmatter before proceeding

### Step 5: Confirm Creation

Present the created structure:

```
✅ Project documentation initialized successfully!

📁 Created at: [full-path-to-directory]

📄 Files created:
├── README.md      - Project overview and navigation
├── research.md    - Research documentation (status: draft)
├── plan.md        - Implementation plan (status: draft)
└── tasks.md       - Task tracking (1/4 tasks complete)

📊 Metadata captured:
- Git commit: [commit-hash]
- Branch: [branch-name]
- Repository: [repo-name]
- Created by: [username]
- Timestamp: [ISO-8601]

🔄 Next Steps:

1. Research the codebase:
   /planning/create_research [directory]

2. After research, create plan:
   /planning/create_plan [directory]

3. Then generate tasks:
   /planning/create_tasks [directory]

Ready to begin research phase!
```

## Important Notes

### Argument Usage
- `$1` - Project name (required if using arguments)
- `$2` - Base directory (optional, defaults to docs/plans)
- `$3` - Ticket reference (optional)
- `$ARGUMENTS` - All arguments as a single string

### Status Progression
Files progress through defined states:
- `research.md`: draft → in-progress → complete
- `plan.md`: draft → ready → implementing → complete
- `tasks.md`: not-started → in-progress → complete

### Synchronization Points
Commands use explicit barriers:
1. **⛔ BARRIER 1**: After creating all files
2. **Final Confirmation**: Present complete structure

## Error Handling

Check for and handle:
- Directory already exists → Suggest different name or confirm overwrite
- Invalid project name → Request kebab-case format
- Git not available → Use placeholder values
- No write permissions → Suggest different location