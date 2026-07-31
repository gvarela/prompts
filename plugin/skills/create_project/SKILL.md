---
name: create_project
description: Initialize comprehensive project documentation with research, design, and task files
argument-hint: [project-name] [base-dir] [ticket-ref]
disable-model-invocation: true
allowed-tools: Read
---

# Initialize Project Documentation

Creates a comprehensive documentation structure for a new project or feature, setting up folders and files for research, planning, and task tracking with proper metadata.

Supporting file: [templates.md](templates.md) — the four initial file templates. Read each when its creation step directs you to.

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

   I'll create a timestamped project directory with research, design, and task tracking files.
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

Read the "README.md Template" section of [templates.md](templates.md) NOW and create the file from it with all metadata values filled in.

**2. research.md** - Research documentation

Read the "research.md Template" section of [templates.md](templates.md) NOW and create the file from it with all metadata values filled in.

**3. design.md** - Design decisions

Read the "design.md Template" section of [templates.md](templates.md) NOW and create the file from it with all metadata values filled in.

**4. tasks.md** - Task tracking

Read the "tasks.md Template" section of [templates.md](templates.md) NOW and create the file from it with all metadata values filled in.

**⛔ BARRIER 1**: Ensure all files are created with proper frontmatter before proceeding

### Step 5: Confirm Creation

Present the created structure:

```
✅ Project documentation initialized successfully!

📁 Created at: [full-path-to-directory]

📄 Files created:
├── README.md      - Project overview and navigation
├── research.md    - Research documentation (status: draft)
├── design.md      - Design decisions (status: draft)
└── tasks.md       - Execution plan (1/4 tasks complete)

📊 Metadata captured:
- Git commit: [commit-hash]
- Branch: [branch-name]
- Repository: [repo-name]
- Created by: [username]
- Timestamp: [ISO-8601]

🔄 Next Steps:

1. Research the codebase:
   /create_research [directory]

2. After research, create design:
   /create_design [directory]

3. Then generate execution plan:
   /create_tasks [directory]

4. Implement with TDD:
   /implement_tasks [directory]

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
- `design.md`: draft → ready → implementing → complete
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
