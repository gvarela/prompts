# AmpCode Usage Guide

This guide explains how to use the planning commands from this repository with AmpCode's custom slash commands feature.

## Overview

AmpCode supports custom slash commands through two mechanisms:

1. **Markdown Commands**: Simple prompt insertion
2. **Executable Commands**: Dynamic prompt generation with scripting

Our planning commands are designed as **Markdown commands** that provide comprehensive instructions to the AI.

### Critical Difference from Claude Code

**AmpCode commands are prompt templates you can edit before submitting:**

When you invoke `/create_project`, AmpCode:
1. Loads the entire command file into your input field
2. **Lets you edit/append before hitting send**
3. Then sends the complete message (command + your additions) to the AI

This enables a powerful pattern:

```bash
# Type the command
/create_project

# AmpCode loads the full prompt into your input
# You can now add context at the END:

[...entire command prompt...]

---
Project name: payment-integration
Directory: docs/projects
Ticket: LINEAR-456
```

**Two approaches work:**
1. **Append parameters**: Add context to end before submitting
2. **Interactive**: Submit command as-is, AI asks questions, you respond next message

Our commands support both patterns by ending with clear parameter prompts.

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

### Command Behavior in AmpCode

When you invoke a markdown command:

1. **Command is triggered**: You type `/create_project`
2. **Prompt loads in input**: The entire command file appears in your input field
3. **You can edit**: Add parameters, context, or constraints before submitting
4. **You submit**: Press enter to send the complete message

**Pattern 1: Pre-fill parameters (faster)**

```bash
# Type command
/create_project

# AmpCode loads prompt in input, you add at the end:

[...full command prompt...]

---
Project: payment-integration
Directory: docs/projects
Ticket: LINEAR-456

# Submit → AI has all context immediately
```

**Pattern 2: Interactive (safer for complex decisions)**

```bash
# Type command
/create_project

# Submit as-is without additions

# AI responds asking for parameters:
"Please provide: 1. Project name 2. Directory 3. Ticket"

# You respond:
payment-integration
docs/projects
LINEAR-456
```

**Best practice**: For simple commands with known parameters, append them. For research/planning where you want AI guidance, submit as-is.

## Command Files

Our commands are markdown files structured for flexible parameter input:

```markdown
# Command Title

Brief description of what the command does.

## Initial Setup

When this command is invoked, respond with:
```
I'll help you [do the thing]. Please provide:
1. Parameter 1
2. Parameter 2
```

Then wait for the user's input.

## Steps to Execute

Detailed workflow with barriers and checkpoints.

[... rest of command ...]

---

## User Input Section

**If you provided parameters above, I'll use them. Otherwise, I'll ask.**

Parameters:
- Project name:
- Directory:
- Ticket:
```

The structure accommodates both usage patterns:
- **Pre-filled**: User appends parameters before submitting → AI reads and executes
- **Interactive**: User submits empty → AI follows "Initial Setup" to ask questions

### Key Features of Our Commands

1. **Interactive Parameter Collection**: AI asks for inputs after command loads
2. **Explicit Barriers**: `⛔ BARRIER` markers ensure proper sequencing
3. **Think Deeply**: Strategic analysis points
4. **Full File Reading**: Commands always read files completely
5. **Dual Verification**: Automated + manual checks
6. **Status Progression**: Defined state transitions

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

**Approach A: Pre-fill parameters (fastest)**

```bash
# 1. Initialize project
> /create_project
[prompt loads, you append:]
---
Project: payment-integration
Directory: docs/projects
Ticket: LINEAR-456
[submit]

# AI creates immediately without asking

# 2. Research existing code
> /create_research
[prompt loads, you append:]
---
Directory: docs/projects/2025-10-08-LINEAR-456-payment-integration
Question: Research how we currently handle payment processing
[submit]

# AI spawns research agents immediately

# 3-5. Continue pattern...
```

**Approach B: Interactive (for complex decisions)**

```bash
# 1. Initialize project
> /create_project
[submit without additions]

Claude: Please provide: 1. Project name 2. Directory 3. Ticket
> payment-integration, docs/projects, LINEAR-456

# 2. Research - want AI to help frame the question
> /create_research
[submit without additions]

Claude: What's the project directory? What should I research?
> docs/projects/2025-10-08-LINEAR-456-payment-integration
> I'm not sure exactly what to research - can you suggest based on the project?

Claude: Based on "payment-integration", I recommend researching:
- Current payment processing flow
- Error handling patterns
- [etc...]
```

**Mixed approach**: Pre-fill simple commands, go interactive for research/planning where AI guidance helps.

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