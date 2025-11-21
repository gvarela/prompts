# Claude Code Usage Guide

This guide explains how to use the planning commands from this repository with Claude Code's custom slash commands feature.

## Overview

Claude Code supports custom slash commands through markdown files that can be project-specific or user-global. Our planning commands are designed to integrate seamlessly with Claude Code's workflow, providing comprehensive AI-guided project documentation and planning.

## Command Locations

### Project-Specific Commands

Located in the project at:

```
.claude/commands/
```

**When to use**: Commands specific to a single project or repository.

**Example structure**:

```
my-project/
├── .claude/
│   └── commands/
│       ├── create_project.md
│       ├── create_research.md
│       ├── create_design.md
│       ├── create_execution.md
│       ├── implement_tasks.md
│       └── update_status.md
├── .git/
└── src/
```

**Visibility**: Commands show as `(project)` in Claude Code's command list.

### User-Global Commands

Located in user config directory:

```
~/.claude/commands/
```

**When to use**: Commands you want available across all projects.

**Example structure**:

```
~/.claude/commands/
├── create_project.md
├── create_research.md
├── create_design.md
├── create_execution.md
├── implement_tasks.md
└── update_status.md
```

**Visibility**: Commands show as `(user)` in Claude Code's command list.

### Command Namespacing

Organize commands into subdirectories:

```
.claude/commands/
├── planning/
│   ├── create_project.md
│   ├── create_research.md
│   ├── create_design.md
│   ├── create_execution.md
│   └── implement_tasks.md
└── code-review/
    ├── review-pr.md
    └── review-changes.md
```

Invoke with namespace: `/planning/create_project`

## Installing Commands

### Option 1: Symlink for User-Global (Recommended)

Link commands to make them available across all projects:

```bash
# Create Claude Code commands directory if it doesn't exist
mkdir -p ~/.claude/commands

# Symlink our planning commands
ln -s /absolute/path/to/prompts/commands/planning/*.md ~/.claude/commands/

# Or create a namespaced directory
mkdir -p ~/.claude/commands/planning
ln -s /absolute/path/to/prompts/commands/planning/*.md ~/.claude/commands/planning/

# Verify installation
ls -la ~/.claude/commands/
```

**Benefits**:
- Commands stay in sync with repository updates
- Available across all projects
- Easy to update with `git pull`
- Single source of truth

**Important**: Use absolute paths for symlinks, not relative paths.

### Option 2: Copy to Project-Specific

Copy commands for a specific project:

```bash
# Create project commands directory
mkdir -p .claude/commands

# Copy all planning commands
cp /path/to/prompts/commands/planning/*.md .claude/commands/

# Or create namespaced directory
mkdir -p .claude/commands/planning
cp /path/to/prompts/commands/planning/*.md .claude/commands/planning/
```

**Benefits**:
- Project-specific customization
- No external dependencies
- Can modify without affecting other projects
- Committed with project

### Option 3: Hybrid Approach

Use global defaults with project-specific overrides:

```bash
# Global commands (symlinked) - available everywhere
ln -s /path/to/prompts/commands/planning/*.md ~/.claude/commands/

# Project-specific override for customized workflow
mkdir -p .claude/commands
cp /path/to/prompts/commands/planning/create_plan.md .claude/commands/
# Modify .claude/commands/create_plan.md for project needs
```

**Priority**: Project commands (`.claude/commands/`) take precedence over user commands (`~/.claude/commands/`).

## Command File Format

Our commands use Claude Code's markdown format with optional frontmatter:

### Basic Structure

```markdown
---
description: Brief description of what this command does
argument-hint: [project-name] [base-dir] [ticket]
---

# Command Title

Command instructions that become the prompt when invoked.

## Steps

Detailed steps Claude should follow.
```

### Frontmatter Fields

Our commands currently use:

- **`description`**: Shows in Claude Code's command list (optional but recommended)
- **`argument-hint`**: Helps users know what parameters to provide

Available but not used yet:

- **`allowed-tools`**: Restrict which tools Claude can use
- **`model`**: Override default model for this command
- **`disable-model-invocation`**: Prevent immediate execution

### Example with Frontmatter

```markdown
---
description: Initialize project documentation with research, plan, and task files
argument-hint: [project-name] [base-dir] [ticket-ref]
allowed-tools:
  - Write
  - Bash(git:*)
---

# Initialize Project Documentation

Creates a comprehensive documentation structure...
```

## Using Arguments

Claude Code supports argument placeholders:

### All Arguments

```markdown
Research the codebase focusing on: $ARGUMENTS
```

Usage: `/create_research authentication and session handling`
Result: `$ARGUMENTS` → `authentication and session handling`

### Individual Arguments

```markdown
Project: $1
Directory: $2
Ticket: $3
```

Usage: `/create_project my-feature docs/plans JIRA-123`
Result:
- `$1` → `my-feature`
- `$2` → `docs/plans`
- `$3` → `JIRA-123`

### Our Current Usage

Our commands ask for parameters interactively rather than using argument placeholders. This provides:
- Better user experience with prompts
- Validation of inputs
- Interactive clarification

Example from `create_project.md`:

```markdown
## Initial Setup

When this command is invoked, respond with:
\`\`\`
Please provide:
1. Project name (short, kebab-case preferred)
2. Base directory (default: docs/plans)
3. Ticket/issue reference (optional)
\`\`\`

Then wait for the user's input.
```

## Using the Commands

### Basic Invocation

Type `/` to see available commands, then select or type the command name:

```
/create_project
/create_research
/create_plan
/create_tasks
/update_status
```

### With Namespacing

If installed in subdirectories:

```
/planning/create_project
/planning/create_research
/planning/create_plan
```

### Sequential Workflow

Our commands follow a defined workflow:

```
Step 1: /create_project
  ↓ Claude asks for: project name, directory, ticket
  ↓ Creates: docs/plans/YYYY-MM-DD-project-name/
  ↓          ├── README.md
  ↓          ├── research.md
  ↓          ├── plan.md
  ↓          └── tasks.md

Step 2: /create_research
  ↓ Provide: project directory path
  ↓ Claude: Spawns research agents, documents findings
  ↓ Updates: research.md with detailed analysis

Step 3: /create_plan
  ↓ Provide: project directory path
  ↓ Claude: Interactive planning discussion
  ↓ Creates: plan.md with phased implementation

Step 4: /create_tasks
  ↓ Provide: project directory path
  ↓ Claude: Extracts tasks from plan
  ↓ Generates: tasks.md with tracking structure

Step 5: /update_status (as needed)
  ↓ Provide: project directory path
  ↓ Claude: Analyzes progress, updates all files
```

### Example Session

```
You: /create_project

Claude: I'll help you set up comprehensive project documentation. Please provide:
1. Project name (short, kebab-case preferred, e.g., auth-refactor)
2. Base directory (default: docs/plans)
3. Ticket/issue reference (optional, e.g., GH-123, JIRA-456, LINEAR-789)

You: payment-integration
docs/projects
LINEAR-456

Claude: [Creates structure, shows confirmation]

You: /create_research docs/projects/2025-10-08-LINEAR-456-payment-integration

Claude: I'm ready to research the codebase and document findings. Please provide:
1. Path to the project documentation directory
2. Your research question or area of interest

You: Research how we currently handle payment processing and error handling

Claude: [Spawns research agents, analyzes codebase, documents findings]
```

## Command Features

### Our Commands Leverage Claude Code's Capabilities

1. **Tool Usage**: Commands can use Read, Write, Edit, Bash, Grep, etc.
2. **File Reading**: Always read files FULLY (no limit/offset)
3. **Agent Spawning**: Use Task tool to spawn parallel research agents
4. **Interactive Workflow**: Commands guide through multi-step processes
5. **Barriers & Checkpoints**: Explicit synchronization points

### Frontmatter We Could Add

Our commands could benefit from frontmatter additions:

#### Restrict Tools for Safety

```markdown
---
description: Update project status across all documentation files
allowed-tools:
  - Read
  - Edit
  - Bash(git:*)
---
```

This prevents accidental file deletion or unintended operations.

#### Specify Model

```markdown
---
description: Conduct deep codebase research
model: claude-opus-4
---
```

Use more powerful model for complex analysis.

## Customization

### Project-Specific Modifications

Copy command to `.claude/commands/` and customize:

```bash
# Copy specific command
cp ~/.claude/commands/create_plan.md .claude/commands/

# Edit for project conventions
vim .claude/commands/create_plan.md
```

**Common customizations**:
- Default directory paths
- Project-specific sections in templates
- Custom frontmatter fields
- Tool restrictions
- Ticket format validation

### Example: Adding Project Conventions

Original `create_plan.md`:

```markdown
## Initial Setup

When this command is invoked, respond with:
\`\`\`
Please provide:
1. Path to project directory
\`\`\`
```

Customized for project:

```markdown
## Initial Setup

When this command is invoked, respond with:
\`\`\`
Please provide:
1. Path to project directory (default: ./engineering/plans)
2. JIRA ticket (required format: PROJ-1234)
3. Tech lead for review: @username

Project conventions:
- All plans must include database migration strategy
- Security review required for API changes
\`\`\`
```

### Example: Restricting Tools

For sensitive projects, restrict what commands can do:

```markdown
---
description: Research codebase (read-only analysis)
allowed-tools:
  - Read
  - Grep
  - Glob
---

# Generate Research Document

You are tasked with conducting comprehensive research...
(read-only research, no file modifications)
```

## Advanced Features

### Using Bash Commands

Commands can invoke bash with `!`:

```markdown
Get current git status:
!git status --short

Analyze recent commits:
!git log --oneline -10
```

### File References

Reference files with `@`:

```markdown
Review the implementation plan at @plan.md and...
```

### Extended Thinking

Our commands already use `**think deeply**` for strategic analysis points. Claude Code recognizes this and allocates more thinking time.

## Integration with Claude Code Workflow

### Command Discovery

- Type `/` to see all available commands
- Commands show `(project)` or `(user)` indicator
- Descriptions appear in command list
- Argument hints guide usage

### Command Execution

1. **Invocation**: Type `/command-name`
2. **Prompt Insertion**: Command content becomes context
3. **Interactive Flow**: Claude asks clarifying questions
4. **Tool Usage**: Claude uses Read, Write, Edit, etc.
5. **Barriers**: Explicit checkpoints ensure quality

### Status Tracking Integration

Our `/update_status` command integrates with Claude Code's file watching:

1. You make changes and check off tasks
2. Claude Code sees file modifications
3. Run `/update_status` to synchronize
4. All files updated with current git metadata
5. Status reflects actual progress

## Best Practices

### 1. Install Commands Appropriately

**Use global** (`~/.claude/commands/`) for:
- Standard workflow commands
- Commands used across multiple projects
- Commands that don't need customization

**Use project** (`.claude/commands/`) for:
- Project-specific workflows
- Customized templates
- Commands with project conventions

### 2. Version Control

**Do commit** (`.claude/commands/`):
- Project-specific commands
- Customized versions
- Team-shared workflows

**Don't commit** (`~/.claude/commands/`):
- Personal global commands
- Symlinks

Example `.gitignore`:

```gitignore
# Personal Claude Code settings
.claude/settings.local.json

# But include project commands
!.claude/commands/
.claude/commands/*.md
```

### 3. Keep Commands Updated

With symlinks:

```bash
cd /path/to/prompts
git pull origin main
# Global commands auto-update via symlink
```

With copies:

```bash
# Periodically re-copy updated commands
cp /path/to/prompts/commands/planning/*.md .claude/commands/
```

### 4. Document Customizations

Create `.claude/commands/README.md`:

```markdown
# Custom Commands

This project uses modified planning commands:

## Customizations

- `create_plan.md`: Requires security review section
- `create_tasks.md`: Includes SLA tracking fields

## Usage

See main documentation: /path/to/prompts/docs/claude-code-usage.md
```

### 5. Use Frontmatter Effectively

Add descriptions to aid discovery:

```markdown
---
description: 🔍 Research codebase and document findings
argument-hint: [project-directory]
---
```

Emojis help commands stand out in the list!

### 6. Test Commands Before Committing

When creating project-specific commands:

1. Test the command workflow end-to-end
2. Verify all barriers and checkpoints work
3. Check file outputs match expectations
4. Ensure git metadata captures correctly

## Troubleshooting

### Command Not Appearing

**Symptom**: Type `/create_project` but command not found

**Solutions**:

1. Check file location and naming:
   ```bash
   ls -la .claude/commands/
   ls -la ~/.claude/commands/
   ```

2. Verify `.md` extension:
   ```bash
   # Should be: create_project.md
   # Not: create_project or create_project.txt
   ```

3. Check symlink validity:
   ```bash
   # Broken symlink shows in red
   ls -la ~/.claude/commands/

   # Fix with absolute path
   ln -sf /absolute/path/to/command.md ~/.claude/commands/
   ```

4. Restart Claude Code to reload commands

### Command Shows Old Content

**Symptom**: Modified command still shows previous version

**Solutions**:

1. If using symlink, check source file was updated:
   ```bash
   cat ~/.claude/commands/create_plan.md
   ```

2. Restart Claude Code to reload

3. Clear Claude Code cache if needed

### Wrong Command Executes

**Symptom**: Project command doesn't override global

**Explanation**: Claude Code prioritizes `.claude/commands/` over `~/.claude/commands/`

**Debug**:
```bash
# Check both locations
ls .claude/commands/create_plan.md
ls ~/.claude/commands/create_plan.md

# Project version should take precedence
# If seeing wrong version, check command name exactly matches
```

### Symlink Issues

**Symptom**: Symlinked commands don't work

**Solution**: Use absolute paths:

```bash
# ❌ Wrong - relative path
ln -s ../prompts/commands/planning/*.md ~/.claude/commands/

# ✅ Correct - absolute path
ln -s /Users/yourname/projects/prompts/commands/planning/*.md ~/.claude/commands/
```

## Workflow Examples

### Complete Project Lifecycle

```
Session 1: Project Setup
─────────────────────────
> /create_project

Claude: I'll help you set up comprehensive project documentation...
> payment-gateway-integration
> docs/projects
> LINEAR-789

✅ Created: docs/projects/2025-10-08-LINEAR-789-payment-gateway-integration/

Session 2: Research Phase
─────────────────────────
> /create_research docs/projects/2025-10-08-LINEAR-789-payment-gateway-integration

Claude: I'm ready to research the codebase...
> Research current payment processing, error handling, and retry logic

[Claude spawns research agents in parallel]
✅ research.md populated with findings (status: complete)

Session 3: Planning
───────────────────
> /create_plan docs/projects/2025-10-08-LINEAR-789-payment-gateway-integration

Claude: Based on the ticket and my research, I understand we need to...
[Interactive discussion about approach]
✅ plan.md created with 3 phases (status: ready)

Session 4: Task Breakdown
─────────────────────────
> /create_tasks docs/projects/2025-10-08-LINEAR-789-payment-gateway-integration

Claude: [Extracts tasks from plan]
✅ tasks.md generated with 24 tasks across 3 phases

Session 5-N: Implementation
───────────────────────────
[Work on tasks, check them off]

> /update_status docs/projects/2025-10-08-LINEAR-789-payment-gateway-integration

Claude: 📊 Current Status Analysis:
- research.md: complete → complete (no change)
- plan.md: ready → implementing (5 tasks completed)
- tasks.md: in-progress → in-progress
  Current Phase: 1
  Completed: 5/24 tasks (21%)

✅ All files synchronized
```

### Quick Research Without Full Project

Sometimes you just need quick research:

```
> /create_research

Claude: I'm ready to research the codebase...

> Just analyze how we handle database migrations, I don't need full project docs

Claude: [Conducts research, presents findings conversationally]
```

Note: This gives you research without creating project structure.

### Status Sync After Milestone

After completing a phase:

```
[You've completed Phase 1, checked off all tasks]

> /update_status docs/projects/2025-10-08-my-project

Claude: 📊 Current Status Analysis:

**plan.md**
- Current: implementing
- Proposed: implementing (still in progress)
- Reason: Phase 1 complete, Phase 2 in progress

**tasks.md**
- Completed: 12/24 tasks (50%)
- Current Phase: 1 → 2
- Reason: All Phase 1 tasks complete, Phase 2 started

Do you want to proceed with these updates?

> yes

✅ Status updated successfully!
```

## Command Reference

Quick reference for our planning commands:

| Command            | Description                                    | When to Use                           |
| ------------------ | ---------------------------------------------- | ------------------------------------- |
| `/create_project`  | Initialize project documentation structure     | Starting new feature/project          |
| `/create_research` | Document codebase through parallel agent research | Before planning implementation     |
| `/create_plan`     | Create phased implementation plan              | After research, before coding         |
| `/create_tasks`    | Extract actionable tasks from plan             | When ready to start implementation    |
| `/update_status`   | Sync status across all documentation files     | After milestones or periodically      |

### Status Progression

| File         | Status Flow                                     |
| ------------ | ----------------------------------------------- |
| research.md  | `draft` → `in-progress` → `complete`            |
| plan.md      | `draft` → `ready` → `implementing` → `complete` |
| tasks.md     | `not-started` → `in-progress` → `complete`      |

## Additional Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Command Source Files](../commands/planning/)
- [Command Philosophy](../commands/planning/CLAUDE.md)
- [Planning Commands README](../commands/planning/README.md)

## Support

For issues with:

- **Commands themselves**: Check [commands/planning/](../commands/planning/)
- **Claude Code integration**: See [Claude Code docs](https://docs.claude.com)
- **Installation**: Review this guide's troubleshooting section
- **Workflow questions**: See [commands/planning/README.md](../commands/planning/README.md)