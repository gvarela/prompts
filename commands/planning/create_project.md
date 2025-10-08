# Initialize Project Documentation

Creates a comprehensive documentation structure for a new project or feature, setting up folders and files for research, planning, and task tracking with proper metadata.

## Initial Setup

When this command is invoked, respond with:

```
I'll help you set up comprehensive project documentation. Please provide:
1. Project name (short, kebab-case preferred, e.g., auth-refactor)
2. Base directory (default: docs/plans)
3. Ticket/issue reference (optional, e.g., GH-123, JIRA-456, LINEAR-789)

I'll create a timestamped project directory with research, plan, and task tracking files.
```

Then wait for the user's input.

## Steps to Execute

### Step 1: Gather Information

Collect from user:

- **Project name**: Short descriptor in kebab-case (e.g., "auth-refactor", "api-v2")
- **Base directory**: Where to create project docs (default: `docs/plans`)
- **Ticket reference**: Optional ticket/issue number (format: `SYSTEM-NUMBER`)

Validate inputs:

- Project name should be lowercase with hyphens only
- Base directory should exist or be creatable
- Ticket format should match: `[A-Z]+-[0-9]+`

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
[base-directory]/[YYYY-MM-DD]-[project-name]/
```

If ticket reference provided, include it:

```
[base-directory]/[YYYY-MM-DD]-[TICKET]-[project-name]/
```

**Examples:**

- `docs/plans/2025-10-07-auth-refactor/`
- `docs/plans/2025-10-07-GH-123-auth-refactor/`
- `docs/plans/2025-10-07-LINEAR-789-api-migration/`

### Step 4: Create Initial Files with Rich Metadata

Create three foundation files with comprehensive frontmatter:

**1. research.md**

```markdown
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

[What are we trying to understand? To be filled by /create_research]

## Summary

[High-level findings - to be added]

## Detailed Findings

[Research findings will be documented here by /create_research]

## Architecture Documentation

[Patterns and conventions discovered - to be added]

## Code References

[Specific file:line references - to be added]

## Similar Implementations

[Examples from codebase - to be added]

## Open Questions

[Areas needing further investigation - to be added]

## Next Steps

1. Run `/create_research` to populate this document
2. Review findings before planning

## References

- Plan: [plan.md](plan.md)
- Tasks: [tasks.md](tasks.md)
- Related docs: [to be added]
```

**2. plan.md**

```markdown
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

[What we're building and why - to be filled by /create_plan]

## Current State Analysis

[What exists today based on research - to be added]

### Key Discoveries:
- [To be added from research]

## Desired End State

[What success looks like - to be added]

### Success means:
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

#### Automated Verification:
- [ ] [To be defined]

#### Manual Verification:
- [ ] [To be defined]

**⛔ CHECKPOINT**: Must pass before Phase 2

---

[Additional phases to be added by /create_plan]

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
- Related: [to be added]

## Estimated Effort

[To be estimated by /create_plan]
```

**3. tasks.md**

```markdown
---
project: [project-name]
ticket: [ticket-reference or null]
created: [YYYY-MM-DD]
created_timestamp: [ISO-8601 timestamp]
status: not-started
last_updated: [YYYY-MM-DD]
assignee: [username]
current_phase: 0
total_tasks: 0
completed_tasks: 0
git_commit: [commit-hash or "not-in-git"]
git_branch: [branch-name or "not-in-git"]
repository: [repo-name or "unknown"]
tags: [tasks, tracking, [project-name]]
---

# Tasks: [Project Name]

**Created**: [YYYY-MM-DD HH:MM UTC]
**Assignee**: [username]
**Ticket**: [ticket-reference or N/A]
**Current Phase**: Not started

## Progress Overview

| Phase | Status | Tasks | Progress |
|-------|--------|-------|----------|
| Planning | 🔄 In Progress | 3/3 | 100% |
| Implementation | ⏸️ Not Started | 0/0 | 0% |

**Overall Progress**: 0/0 implementation tasks (0%)

---

## Planning Phase

### 📋 Documentation Setup
- [x] Create project structure (completed [YYYY-MM-DD HH:MM])
- [ ] Complete research using `/create_research`
- [ ] Create implementation plan using `/create_plan`
- [ ] Generate task list using `/create_tasks`

---

## Implementation Phases

[To be populated by /create_tasks after plan is created]

---

## 📝 Completed Tasks Archive

[Completed tasks will be moved here]

---

## 🚧 Blockers & Notes

### Current Blockers
| Blocker | Impact | Action | Owner | Due Date |
|---------|--------|--------|-------|----------|
| Research needed | Can't plan | Run /create_research | [username] | [date] |

### Implementation Notes
- Project initialized on [YYYY-MM-DD]
- [Additional notes to be added]

---

## 🔗 Quick Reference

### Key Files
- **Research**: [research.md](research.md)
- **Plan**: [plan.md](plan.md)

### Common Commands
```bash
# To be added based on project type
```

### Next Steps

1. Run `/create_research [directory]` to conduct research
2. Run `/create_plan [directory]` to create implementation plan
3. Run `/create_tasks [directory]` to generate task list
```

**⛔ BARRIER 1**: Ensure all three foundation files are created before proceeding

### Step 5: Create README for Navigation

Create a README.md in the project directory:

```markdown
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
2. ⏳ Research phase (`/create_research`)
3. ⏳ Planning phase (`/create_plan`)
4. ⏳ Task breakdown (`/create_tasks`)
5. ⏳ Implementation
6. ⏳ Testing & Verification

## Quick Links

- Ticket: [ticket-url if applicable]
- Repository: [repo-url if available]
- Branch: [branch-name]

## Commands

Run these commands from the project root:

```bash
# Continue research
/create_research [this-directory]

# Create plan
/create_plan [this-directory]

# Generate tasks
/create_tasks [this-directory]
```
```

**⛔ BARRIER 2**: Verify README is created before final confirmation

### Step 6: Confirm Creation

Present the created structure with enhanced details:

✅ Project documentation initialized successfully!

📁 Created at: [full-path-to-directory]

📄 Files created:
├── README.md      - Project overview and navigation
├── research.md    - Research documentation (status: draft)
├── plan.md        - Implementation plan (status: draft)
└── tasks.md       - Task tracking (3 planning tasks created)

📊 Metadata captured:

- Git commit: [commit-hash]
- Branch: [branch-name]
- Repository: [repo-name]
- Created by: [username]
- Timestamp: [ISO-8601]

🔄 Workflow sequence:

1. ✅ Structure created
2. ⏳ Run `/create_research [directory]` to research codebase
3. ⏳ Run `/create_plan [directory]` to plan implementation
4. ⏳ Run `/create_tasks [directory]` to break down tasks

📝 Initial tasks created in tasks.md:

- [ ] Complete research using /create_research
- [ ] Create implementation plan using /create_plan
- [ ] Generate task list using /create_tasks

Ready to begin research phase!

## Important Notes

### Metadata Tracking
- Captures git information for traceability
- Records timestamps in ISO-8601 format
- Tracks user/researcher/planner names
- Maintains repository context

### Status Progression
Files progress through states:
- `research.md`: draft → in-progress → complete
- `plan.md`: draft → ready → implementing → complete
- `tasks.md`: not-started → in-progress → complete

### Frontmatter Standards
All files use consistent YAML frontmatter:
- Basic fields: project, ticket, created, status, last_updated
- Git fields: git_commit, git_branch, repository
- User fields: researcher/planner/assignee
- Tracking fields: timestamps, tags, phase info

### File Relationships
- Each file references the others
- README provides navigation
- Consistent linking structure
- Workflow enforces proper sequence

## Configuration Options

The command accepts parameters in various formats:

```bash
# Basic usage
/create_project my-feature

# With custom base directory
/create_project my-feature docs/projects

# With ticket reference
/create_project my-feature docs/plans GH-456

# All parameters
/create_project auth-refactor docs/plans LINEAR-789
```

Format: `/create_project [project-name] [base-dir] [ticket]`

## Error Handling

Check for and handle:

- Directory already exists → Suggest different name or confirm overwrite
- Invalid project name → Request kebab-case format
- Git not available → Use placeholder values
- No write permissions → Suggest different location

## Synchronization Points

Commands use explicit barriers to ensure proper sequencing:

1. **⛔ BARRIER 1**: After creating foundation files (research.md, plan.md, tasks.md)
   - Do not proceed until all three files exist with proper frontmatter
   - Verify metadata is captured correctly

2. **⛔ BARRIER 2**: After creating README.md
   - Ensure navigation and overview is complete
   - Verify all file links work correctly

3. **Final Confirmation**: Only after all barriers pass
   - Present complete structure overview
   - Provide next steps for workflow

This ensures consistency and proper tracking from inception.
