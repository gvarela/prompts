# AmpCode Usage Guide

This guide explains how to use the planning commands from this repository with AmpCode's custom slash commands feature.

## Overview

AmpCode supports custom slash commands through two mechanisms:

1. **Markdown Commands**: Simple prompt insertion
2. **Executable Commands**: Dynamic prompt generation with scripting

Our planning commands are designed as **Markdown commands** that provide comprehensive instructions to the AI.

## Command Locations

### Project-Specific Commands

Located in the workspace at:

```
.agents/commands/
```

**When to use**: Commands specific to a single project or codebase.

**Example structure**:

```
my-project/
├── .agents/
│   └── commands/
│       ├── create_project.md
│       ├── create_research.md
│       ├── create_plan.md
│       ├── create_tasks.md
│       └── update_status.md
└── src/
```

### Global Commands

Located in user config directory:

```
~/.config/amp/commands/
```

Or if `$XDG_CONFIG_HOME` is set:

```
$XDG_CONFIG_HOME/amp/commands/
```

**When to use**: Commands you want available across all projects.

**Example structure**:

```
~/.config/amp/commands/
├── create_project.md
├── create_research.md
├── create_plan.md
├── create_tasks.md
└── update_status.md
```

## Installing Commands

### Option 1: Symlink to This Repository

Link the commands directory to make commands available globally:

```bash
# Create AmpCode config directory if it doesn't exist
mkdir -p ~/.config/amp/commands

# Symlink our planning commands
ln -s /path/to/prompts/commands/planning/*.md ~/.config/amp/commands/

# Verify
ls -la ~/.config/amp/commands/
```

**Benefits**:

- Commands stay in sync with repository updates
- Easy to update with `git pull`
- Single source of truth

### Option 2: Copy Commands

Copy commands directly for a specific project:

```bash
# Create project commands directory
mkdir -p .agents/commands

# Copy all planning commands
cp /path/to/prompts/commands/planning/*.md .agents/commands/

# Make project-specific modifications if needed
```

**Benefits**:

- Project-specific customization
- No external dependencies
- Can modify without affecting other projects

### Option 3: Hybrid Approach

Use global commands by default, override with project-specific versions:

```bash
# Global commands (symlinked)
ln -s /path/to/prompts/commands/planning/*.md ~/.config/amp/commands/

# Project-specific override for one command
mkdir -p .agents/commands
cp /path/to/prompts/commands/planning/create_plan.md .agents/commands/
# Now customize .agents/commands/create_plan.md for this project
```

**How it works**: AmpCode checks `.agents/commands` first, then falls back to global commands.

## Using the Commands

### Basic Usage

Simply type `/` followed by the command name (without `.md` extension):

```
/create_project my-feature
```

### Command Workflow

Our planning commands follow a sequential workflow:

```
1. /create_project my-feature
   ↓ Creates: docs/plans/YYYY-MM-DD-my-feature/

2. /create_research docs/plans/YYYY-MM-DD-my-feature
   ↓ Populates: research.md

3. /create_plan docs/plans/YYYY-MM-DD-my-feature
   ↓ Creates: plan.md

4. /create_tasks docs/plans/YYYY-MM-DD-my-feature
   ↓ Generates: tasks.md

5. /update_status docs/plans/YYYY-MM-DD-my-feature
   ↓ Updates: All files with current status
```

### Passing Parameters

Commands accept parameters after the command name:

```bash
# Create project with all parameters
/create_project my-feature docs/plans LINEAR-123

# Research a specific directory
/create_research docs/plans/2025-10-08-my-feature

# Update status
/update_status docs/plans/2025-10-08-my-feature
```

### Command Behavior in AmpCode

When you invoke a markdown command:

1. **Command is triggered**: You type `/create_project`
2. **Content is inserted**: The entire markdown file content becomes the prompt
3. **AI responds**: Following the instructions in the command file
4. **Interactive**: You can respond to the AI's questions

## Command Files

Our commands are markdown files with special structure:

```markdown
# Command Title

Brief description of what the command does.

## Initial Setup

Instructions for how the AI should respond initially.

## Steps to Execute

Detailed workflow with barriers and checkpoints.

## Templates

Output templates for generated files.
```

### Key Features of Our Commands

1. **Explicit Barriers**: `⛔ BARRIER` markers ensure proper sequencing
2. **Think Deeply**: Strategic analysis points
3. **Full File Reading**: Commands always read files completely
4. **Dual Verification**: Automated + manual checks
5. **Status Progression**: Defined state transitions

## Customizing Commands

### Project-Specific Customization

Copy a command to `.agents/commands/` and modify:

```bash
# Copy command
cp ~/.config/amp/commands/create_plan.md .agents/commands/

# Edit for project needs
vim .agents/commands/create_plan.md
```

**Common customizations**:

- Change default directory paths
- Add project-specific sections
- Modify frontmatter fields
- Add project conventions

### Example Customization

Original:

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
1. Path to project directory (default: ./docs/features)
2. JIRA ticket number (format: PROJ-1234)
\`\`\`
```

## Advanced Usage

### Combining with Executable Commands

You can create executable wrapper commands that invoke our markdown commands:

```bash
#!/bin/bash
# File: .agents/commands/quick-plan

# Extract Linear ticket info
TICKET_ID="$1"

# Generate context
echo "Creating plan for Linear ticket: $TICKET_ID"
echo ""

# Invoke the markdown command
cat ~/.config/amp/commands/create_plan.md
```

Make it executable:

```bash
chmod +x .agents/commands/quick-plan
```

Use it:

```
/quick-plan ENG-123
```

### Environment Variables

Executable commands have access to environment variables:

- `AGENT_TOOL_NAME`: The name of the invoked tool
- Standard shell variables

Example:

```bash
#!/bin/bash
# File: .agents/commands/my-command

PROJECT_ROOT="${PWD}"
DOCS_DIR="${PROJECT_ROOT}/docs/plans"

echo "Working in: ${PROJECT_ROOT}"
echo "Docs directory: ${DOCS_DIR}"

# Then insert your command content
cat ~/.config/amp/commands/create_project.md
```

## Troubleshooting

### Command Not Found

**Symptom**: Typing `/create_project` shows "command not found"

**Solutions**:

1. Check file location:

   ```bash
   ls ~/.config/amp/commands/
   ls .agents/commands/
   ```

2. Verify filename has `.md` extension:

   ```bash
   # Should be: create_project.md
   # Not: create_project
   ```

3. Check symlinks are valid:
   ```bash
   ls -la ~/.config/amp/commands/
   ```

### Commands Don't Update

**Symptom**: Modified commands still show old behavior

**Solution**: Restart AmpCode or reload commands

### Wrong Command Executes

**Symptom**: Project-specific command doesn't override global

**Explanation**: Ensure project command is in `.agents/commands/` not `.agents/command/` (singular)

## Best Practices

### 1. Use Global for Standard Workflow

Install standard commands globally:

```bash
ln -s /path/to/prompts/commands/planning/*.md ~/.config/amp/commands/
```

### 2. Customize Per-Project Only When Needed

Only copy to `.agents/commands/` when you need project-specific changes.

### 3. Keep Commands in Sync

If using symlinks, update with:

```bash
cd /path/to/prompts
git pull origin main
# Commands automatically update via symlink
```

### 4. Document Project-Specific Commands

Add `.agents/README.md` explaining any customizations:

```markdown
# Custom Commands

This project uses modified versions of:

- `create_plan.md` - Customized to require JIRA ticket format
- `create_research.md` - Added database schema analysis step
```

### 5. Version Control

**Do commit**: Project-specific commands in `.agents/commands/`

**Don't commit**: Symlinks to global commands

Example `.gitignore`:

```gitignore
# Ignore symlinked commands
.agents/commands/*.md

# But include project-specific overrides
!.agents/commands/custom_*.md
```

## Integration with Our Workflow

### Full Workflow Example

```bash
# 1. Initialize project
/create_project payment-integration docs/projects LINEAR-456

# AI creates: docs/projects/2025-10-08-LINEAR-456-payment-integration/
#   ├── README.md
#   ├── research.md
#   ├── plan.md
#   └── tasks.md

# 2. Research existing code
/create_research docs/projects/2025-10-08-LINEAR-456-payment-integration
> Research how we currently handle payment processing

# AI populates research.md with findings

# 3. Create implementation plan
/create_plan docs/projects/2025-10-08-LINEAR-456-payment-integration

# AI asks questions, creates plan.md with phases

# 4. Generate task list
/create_tasks docs/projects/2025-10-08-LINEAR-456-payment-integration

# AI extracts tasks.md from plan

# 5. Start implementation
# (check off tasks as you work)

# 6. Update status periodically
/update_status docs/projects/2025-10-08-LINEAR-456-payment-integration

# AI updates status across all files based on progress
```

### Status Tracking

The `/update_status` command intelligently updates:

- **research.md**: draft → in-progress → complete
- **plan.md**: draft → ready → implementing → complete
- **tasks.md**: not-started → in-progress → complete

All files stay synchronized automatically.

## Command Reference

Quick reference for our planning commands:

| Command            | Purpose                          | Input                      |
| ------------------ | -------------------------------- | -------------------------- |
| `/create_project`  | Initialize documentation         | project-name, dir, ticket  |
| `/create_research` | Document codebase research       | project-directory          |
| `/create_plan`     | Create implementation plan       | project-directory          |
| `/create_tasks`    | Extract tasks from plan          | project-directory          |
| `/update_status`   | Sync status across all files     | project-directory          |

## Additional Resources

- [AmpCode Documentation](https://ampcode.com/manual#cli-custom-slash-commands)
- [Command Source](../commands/planning/)
- [Command Philosophy](../commands/planning/CLAUDE.md)

## Support

For issues with:

- **Commands themselves**: Check [commands/planning/](../commands/planning/)
- **AmpCode integration**: See [AmpCode manual](https://ampcode.com/manual)
- **General usage**: Review [commands/planning/README.md](../commands/planning/README.md)