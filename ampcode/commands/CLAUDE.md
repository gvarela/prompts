# CLAUDE.md - AmpCode Commands

Guidelines for working with AmpCode slash command files in this directory.

## AmpCode Command Structure

AmpCode commands are markdown files that serve as prompt templates loaded directly into the user's input field before submission.

### Critical: User Input Section Ordering

**IMPORTANT**: In the "User Input Section" at the end of each command, the order MUST be:

1. **Example** (with filled-in values)
2. **Parameters** (blank fields for user to fill)

This ordering is **required** by AmpCode because:

- Users can pre-fill parameters before submitting
- The example shows them what format to use
- Blank parameters appear last so users can easily fill them in

### Correct Format

```markdown
## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

\`\`\`
- Project name: auth-refactor
- Base directory: docs/plans
- Ticket reference: LINEAR-456
\`\`\`

**Parameters:**

- Project name:
- Base directory: (default: docs/plans)
- Ticket reference: (optional)
```

### Incorrect Format (DO NOT USE)

```markdown
## User Input Section

**Parameters:**  <!-- ❌ WRONG - Parameters should come after Example -->

- Project name:
- Base directory: (default: docs/plans)

**Example:**  <!-- ❌ WRONG - Example should come first -->

\`\`\`
- Project name: auth-refactor
\`\`\`
```

## Command Categories

### Planning Commands (`planning/`)

Sequential workflow for project documentation:

- `/create_project` - Initialize documentation structure
- `/create_research` - Document codebase research
- `/create_plan` - Create implementation plan
- `/create_tasks` - Extract actionable tasks
- `/update_status` - Sync status across files

### Action Commands (`actions/`)

Read-only codebase analysis:

- `/locate_code` - Find components and files
- `/analyze_code` - Understand implementations
- `/find_patterns` - Identify conventions

## Key Differences from Claude Code

### 1. No Task Tool

AmpCode doesn't have Claude Code's `Task` tool for spawning agents. Commands should:

- Provide direct instructions instead of spawning sub-agents
- Include concrete bash/grep command examples
- Offer step-by-step strategies for analysis

### 2. User Can Edit Before Submission

AmpCode loads the entire command into the input field, allowing users to:

- Append parameters before submitting
- Add additional context
- Modify the prompt if needed

This enables two usage patterns:

- **Pre-filled**: User adds parameters at the end before submitting
- **Interactive**: User submits as-is, AI asks for parameters

### 3. Simpler Agent Model

Commands should be self-contained instructions rather than orchestrators of other agents.

## Command File Requirements

### Frontmatter (Optional but Recommended)

```markdown
---
description: Brief description of what this command does
argument-hint: [arg1] [arg2] [arg3]
---
```

### Required Sections

1. **Title** - Clear command name
2. **Initial Setup** - What to ask if parameters not provided
3. **Steps to Execute** - Detailed workflow
4. **User Input Section** - Example THEN Parameters (critical order)

### Barriers and Checkpoints

Maintain explicit synchronization points:

- `⛔ BARRIER 1/2/3` - Synchronization points during execution
- `⛔ CHECKPOINT` - Human verification required between phases

### Documentation Philosophy

For action commands especially:

- **Document, don't judge** - Describe what EXISTS, not what should be
- **No recommendations** - Only objective documentation
- **File:line references** - Always provide precise references
- **Concrete examples** - Show actual code snippets

## Testing Commands

When modifying commands:

1. **Test both usage patterns**:
   - Submit with pre-filled parameters
   - Submit blank and respond interactively

2. **Verify ordering**:
   - Example comes before Parameters
   - User fields are at the very end

3. **Check markdown**:
   - Run `./scripts/lint` before committing
   - Auto-fix with `./scripts/lint --fix`

4. **Validate workflow**:
   - Barriers are enforced
   - Checkpoints are clear
   - Instructions are actionable

## Common Patterns

### Interactive Parameter Collection

```markdown
## Initial Setup

**Check if user provided parameters below before asking:**

If the user filled in the "User Input Section" at the bottom of this prompt, use those parameters and proceed directly.

If parameters are NOT provided, respond with:

\`\`\`
I'll help you [action]. Please provide:
1. Parameter 1
2. Parameter 2
\`\`\`

Then wait for the user's input.
```

### Barrier Implementation

```markdown
### Step 1: Read Context

[Instructions for reading files]

**⛔ BARRIER 1**: Do not proceed until ALL files are read FULLY
```

### User Input Section Template

```markdown
## User Input Section

**Fill in these parameters before submitting, or leave blank for interactive mode.**

**Example:**

\`\`\`
- Parameter 1: example-value
- Parameter 2: another-value
\`\`\`

**Parameters:**

- Parameter 1:
- Parameter 2:
```

## File Organization

```
ampcode/commands/
├── CLAUDE.md           (this file - guidelines)
├── planning/
│   ├── CLAUDE.md       (planning-specific guidelines)
│   ├── README.md       (user documentation)
│   ├── create_project.md
│   ├── create_research.md
│   ├── create_plan.md
│   ├── create_tasks.md
│   └── update_status.md
└── actions/
    ├── README.md       (user documentation)
    ├── locate_code.md
    ├── analyze_code.md
    └── find_patterns.md
```

## Linting

All markdown files should pass markdownlint:

```bash
# Lint changed files
./scripts/lint

# Auto-fix issues
./scripts/lint --fix

# Lint all command files
./scripts/lint ampcode/commands/**/*.md
```

## When Modifying Commands

**Always remember**:

1. ✅ Example before Parameters in User Input Section
2. ✅ Examples show filled-in values
3. ✅ Parameters are blank fields
4. ✅ Run linter before committing
5. ✅ Test both usage patterns

This ensures commands work correctly in AmpCode's unique workflow.
