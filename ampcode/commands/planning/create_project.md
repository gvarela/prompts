# Initialize Project Documentation

Creates a comprehensive documentation structure for a new project or feature, setting up folders and files for research, planning, and task tracking with proper metadata.

## Initial Setup

**Check if user provided parameters below before asking:**

If the user filled in the "User Input Section" at the bottom of this prompt, use those parameters and proceed directly to create the project structure.

If parameters are NOT provided, respond with:

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

**2. design.md**

```markdown
---
project: [project-name]
ticket: [ticket-reference or null]
created: [YYYY-MM-DD]
created_timestamp: [ISO-8601 timestamp]
status: draft
last_updated: [YYYY-MM-DD]
designer: [username]
git_commit: [commit-hash or "not-in-git"]
git_branch: [branch-name or "not-in-git"]
repository: [repo-name or "unknown"]
tags: [design, architecture, [project-name]]
depends_on: research.md
---

# Design: [Project Name]

**Created**: [YYYY-MM-DD HH:MM UTC]
**Designer**: [username]
**Ticket**: [ticket-reference or N/A]
**Status**: Draft

## Problem Statement

[What problem we're solving and why - to be filled by /create_design]

### Success Metrics
- [ ] [To be defined]

## Design Approach

[High-level solution approach - to be added]

### Why This Approach
- [To be added from design analysis]

## Technical Decisions

### Architecture
- [To be defined]

### Data Model
- [To be defined]

### Integration Points
- [To be identified]

## Scope Definition

### In Scope
- [To be defined]

### Out of Scope
- [To be defined]

## Success Criteria

### Functional Requirements
- [ ] [To be defined]

### Non-Functional Requirements
- [ ] [To be defined]

## Risk Analysis

[To be evaluated]

## Rejected Alternatives

[To be documented during design]

## Pending Decisions

[Design decisions needing input - to be identified]

## References

- Research: [research.md](research.md)
- Tasks: [tasks.md](tasks.md)
- Related: [to be added]
```

**3. tasks.md**

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
total_tasks: 0
completed_tasks: 0
git_commit: [commit-hash or "not-in-git"]
git_branch: [branch-name or "not-in-git"]
repository: [repo-name or "unknown"]
tags: [tasks, execution, [project-name]]
depends_on: [research.md, design.md]
---

# Execution Plan: [Project Name]

**Created**: [YYYY-MM-DD HH:MM UTC]
**Assignee**: [username]
**Ticket**: [ticket-reference or N/A]
**Current Phase**: Planning

## Progress Overview

| Phase | Status | Tasks | Progress |
|-------|--------|-------|----------|
| Planning | 🔄 In Progress | 3/4 | 75% |
| Implementation | ⏸️ Not Started | 0/0 | 0% |

**Overall Progress**: 0/0 implementation tasks (0%)

---

## Planning Phase

### 📋 Documentation Setup
- [x] Create project structure (completed [YYYY-MM-DD HH:MM])
- [ ] Complete research using `/create_research`
- [ ] Create design using `/create_design`
- [ ] Generate execution plan using `/create_execution`

---

## Implementation Phases

[To be populated by /create_execution after design is approved]

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
````

### Next Steps

1. Run `/create_research` to conduct research
2. Run `/create_design` to make design decisions
3. Run `/create_execution` to generate execution plan

**⛔ BARRIER 1**: Ensure all three foundation files are created before proceeding

### Step 5: Create README for Navigation

Create a README.md in the project directory:

````markdown
# [Project Name]

**Created**: [YYYY-MM-DD]
**Ticket**: [ticket-reference or N/A]
**Status**: Planning

## Overview

This directory contains documentation for [project-name].

## Documentation Structure

- **[research.md](research.md)** - Codebase research and findings
- **[design.md](design.md)** - Design decisions and architecture
- **[tasks.md](tasks.md)** - Execution plan and task tracking

## Workflow

1. ✅ Project structure created
2. ⏳ Research phase (`/create_research`)
3. ⏳ Design phase (`/create_design`)
4. ⏳ Execution planning (`/create_execution`)
5. ⏳ Implementation (`/implement_tasks`)
6. ⏳ Testing & Verification

## Quick Links

- Ticket: [ticket-url if applicable]
- Repository: [repo-url if available]
- Branch: [branch-name]

## Commands

Run these commands from the project root:

```bash
# Continue research
/create_research

# Create design
/create_design

# Generate execution plan
/create_execution
```
````

**⛔ BARRIER 2**: Verify README is created before final confirmation

### Step 6: Confirm Creation

Present the created structure with enhanced details:

✅ Project documentation initialized successfully!

📁 Created at: [full-path-to-directory]

📄 Files created:
├── README.md      - Project overview and navigation
├── research.md    - Research documentation (status: draft)
├── design.md      - Design decisions (status: draft)
└── tasks.md       - Execution plan (4 planning tasks created)

📊 Metadata captured:

- Git commit: [commit-hash]
- Branch: [branch-name]
- Repository: [repo-name]
- Created by: [username]
- Timestamp: [ISO-8601]

🔄 Workflow sequence:

1. ✅ Structure created
2. ⏳ Run `/create_research [directory]` to research codebase
3. ⏳ Run `/create_design [directory]` to make design decisions
4. ⏳ Run `/create_execution [directory]` to create execution plan

📝 Initial tasks created in tasks.md:

- [ ] Complete research using /create_research
- [ ] Create design using /create_design
- [ ] Generate execution plan using /create_execution

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

This command creates project documentation in timestamped directories. See the User Input Section at the bottom to provide parameters directly, or submit without parameters for interactive mode.

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

---

## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

```
- Project name: auth-refactor
- Base directory: docs/plans
- Ticket reference: LINEAR-456
```

**Parameters:**

- Project name:
- Base directory: (default: docs/plans)
- Ticket reference: (optional)
