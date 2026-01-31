# Prompts Repository

A collection of reusable prompts, slash commands, and agent definitions for AI-powered development workflows with Claude Code and AmpCode.

## Overview

This repository contains enterprise-grade documentation commands, prompt templates, and agent definitions designed to streamline software development through structured planning, comprehensive research, and systematic task tracking.

## Quick Start

### Installation

Install the planning commands globally for Claude Code or AmpCode:

```bash
# Clone the repository
git clone <repository-url>
cd prompts

# Install globally for Claude Code
./scripts/install-commands --claude

# Install globally for AmpCode
./scripts/install-commands --amp

# Install for both
./scripts/install-commands --both

# Install to a specific project
./scripts/install-commands --claude --project ~/my-project
```

### How Installation Works

**Claude Code** (uses symlinks):
- Commands, agents, and skills are **symlinked** to your installation directory
- Individual `.md` files symlinked for commands and agents
- Entire directories symlinked for skills
- **Benefit**: Edits in this repository immediately reflect in Claude Code
- **Updates**: Run `git pull` in this repo - changes apply automatically, no reinstall needed

**AmpCode** (uses copies):
- Files are **copied** (not symlinked) to installation directory
- **Updates**: Re-run `./scripts/install-commands --amp` after `git pull`

### Using Commands

Once installed, use the workbench commands in your workflow:

```bash
# Initialize project documentation
/wb:create_project my-feature docs/plans LINEAR-123

# Research existing codebase
/wb:create_research docs/plans/2025-10-08-LINEAR-123-my-feature

# Create design decisions
/wb:create_design docs/plans/2025-10-08-LINEAR-123-my-feature

# Create execution plan
/wb:create_execution docs/plans/2025-10-08-LINEAR-123-my-feature

# Implement with TDD
/wb:implement_tasks docs/plans/2025-10-08-LINEAR-123-my-feature

# Validate implementation
/wb:validate_execution docs/plans/2025-10-08-LINEAR-123-my-feature

# Update project status
/wb:update_status docs/plans/2025-10-08-LINEAR-123-my-feature
```

**Skills** (automatically activated):

- `project-structure` - Document separation (research.md, design.md, tasks.md, thoughts/)
- `tdd-discipline` - RED-GREEN-REFACTOR enforcement
- `verification-before-completion` - Evidence before completion claims
- `status-sync` - Status drift detection
- `review-prep` - Interactive tmux/nvim code review

## What's Inside

### 📋 Workbench Commands (`/wb:*`)

Enterprise-grade slash commands for project documentation and task management:

- **`/wb:create_project`** - Initialize structured documentation with rich metadata
- **`/wb:create_research`** - Document codebase using parallel research agents
- **`/wb:create_design`** - Create architectural design decisions (WHAT and WHY)
- **`/wb:create_execution`** - Transform design into phased execution plan (HOW)
- **`/wb:implement_tasks`** - Implement with TDD (Red-Green-Refactor)
- **`/wb:validate_execution`** - Validate implementation matches plan
- **`/wb:create_handoff`** - Create session handoff for work continuity
- **`/wb:resume_handoff`** - Resume from handoff document
- **`/wb:update_status`** - Intelligently sync status across all documentation files

**Key Features**:
- Three-document separation: research.md (facts), design.md (decisions), tasks.md (implementation)
- Explicit barriers and synchronization points
- "Document, Don't Judge" research philosophy
- Dual verification model (automated + manual)
- Rich frontmatter with git metadata tracking
- Status progression with validation
- Zero scope creep enforcement
- Session continuity with handoff system
- **Beads integration** for cross-session task tracking (optional)

[Full Commands Documentation →](claude-code/commands/wb/README.md)

### 🤖 Workbench Agents (`/wb:*`)

Specialized agents for codebase analysis:

- **`/wb:codebase-locator`** - Find specific components and files
- **`/wb:codebase-analyzer`** - Analyze implementation details with file:line references
- **`/wb:pattern-finder`** - Find similar patterns and implementations

### 🧠 Skills (auto-activated)

Background capabilities that Claude automatically invokes:

- **`project-structure`** - Enforces document separation (research.md, design.md, tasks.md, thoughts/)
- **`tdd-discipline`** - Enforces RED-GREEN-REFACTOR cycle before writing production code
- **`verification-before-completion`** - Requires running verification commands before claiming work is done
- **`status-sync`** - Monitors for status drift and reminds to run `/wb:update_status`
- **`review-prep`** - Interactive code review walkthrough using tmux and nvim for pair programming

[Skills Guide →](docs/claude-code-skills-guide.md)

### 🛠️ Development Scripts

Utility scripts for repository management:

- **`scripts/install-commands`** - Install commands to Claude Code/AmpCode
- **`scripts/lint`** - Markdown linting with auto-fix support
- **`scripts/lint-hook`** - Automatic linting hook for file operations

### 📚 Documentation

Comprehensive guides for using this repository:

- **[Claude Code README](claude-code/README.md)** - Using commands with Claude Code
- **[AmpCode README](ampcode/README.md)** - Using commands with AmpCode
- **[Planning Commands README](commands/planning/README.md)** - Detailed command reference

## Core Philosophy

### Document, Don't Judge

Research commands objectively document what EXISTS without suggesting improvements. This ensures unbiased understanding before planning changes.

### Explicit Barriers

Commands use clear synchronization points:
- **⛔ BARRIER 1**: After file reading - full context required
- **⛔ BARRIER 2**: After agent spawning - wait for ALL
- **⛔ BARRIER 3**: Before writing - no placeholders allowed
- **⛔ CHECKPOINT**: Between phases - human verification required

### Dual Verification

Plans separate verification into:
- **Automated**: Tests, linting, builds that CI can run
- **Manual**: UI functionality, performance, edge cases requiring human validation

### Zero Scope Creep

Tasks come ONLY from plans - no additions during implementation. This maintains predictable delivery and traceable work.

### Beads Integration (Required)

The wb commands require [beads](https://github.com/steveyegge/beads) for task tracking:

```bash
# Initialize beads in your project
bd init
```

**Beads provides**:
- **Persistent memory**: Task state survives compaction and new sessions
- **Dependency tracking**: Phases block/unblock automatically
- **Git-backed**: Syncs with your repository
- **Source of truth**: Authoritative status for phases

See [AGENTS.md](AGENTS.md) for the beads workflow protocol.

**Note**: For markdown-only tracking, use the `v1.0.0` tag.

## Repository Structure

```
prompts/
├── commands/           # Slash command definitions
│   └── planning/       # Project documentation commands
├── agents/             # Agent definitions (future)
├── general/            # General-purpose prompts (future)
├── docs/               # Documentation and usage guides
├── scripts/            # Utility scripts
│   ├── install-commands
│   ├── lint
│   └── lint-hook
└── .claude/            # Claude Code configuration
    └── settings.local.json
```

## Installation Details

### Global Installation

Commands are installed globally and available in all projects:

**Claude Code**: `~/.claude/commands/`
**AmpCode**: `~/.config/amp/commands/` (or `$XDG_CONFIG_HOME/amp/commands/`)

### Project Installation

Commands are installed in a specific project directory:

**Claude Code**: `<project>/.claude/commands/`
**AmpCode**: `<project>/.agents/commands/`

### Symlinks vs Copies

The installation script creates **symlinks** (not copies) by default. This means:
- Commands automatically update when you `git pull`
- Single source of truth in this repository
- No need to reinstall after updates

## Workflow Example

A complete project lifecycle using planning commands:

```bash
# 1. Initialize
/create_project payment-integration docs/projects LINEAR-456

# 2. Research
/create_research docs/projects/2025-10-08-LINEAR-456-payment-integration
> Research how we currently handle payment processing and error recovery

# 3. Plan
/create_plan docs/projects/2025-10-08-LINEAR-456-payment-integration
# Interactive discussion → detailed phased plan

# 4. Generate tasks
/create_tasks docs/projects/2025-10-08-LINEAR-456-payment-integration

# 5. Execute (work through tasks.md checking off items)
# ...implementation work...

# 6. Update status periodically
/update_status docs/projects/2025-10-08-LINEAR-456-payment-integration
```

Result: Comprehensive documentation with:
- Research findings with file:line references
- Phased implementation plan with checkpoints
- Trackable tasks organized by phase
- Modified files tracking (code vs tests)
- Progress metrics and status tracking
- Full git metadata audit trail

## Development

### Linting

Markdown files are automatically linted via PostToolUse hooks when using Claude Code:

```bash
# Manual linting
./scripts/lint

# Auto-fix issues
./scripts/lint --fix

# Lint specific files
./scripts/lint README.md commands/planning/*.md

# Lint all markdown files
./scripts/lint --all
```

Configuration: `.markdownlintrc`

### Hooks

Claude Code hooks are configured in `.claude/settings.local.json`:
- PostToolUse hooks run linting after Write/Edit operations
- Automatic permission for linting and installation scripts

## Customization

### Modifying Commands

Commands are markdown files - edit them to customize behavior:

```bash
# Edit command
vim commands/planning/create_plan.md

# Test changes
/create_plan test-project
```

### Project-Specific Overrides

Install globally, then override specific commands per-project:

```bash
# Global installation
./scripts/install-commands --both

# Copy one command for customization
cp commands/planning/create_plan.md ~/my-project/.claude/commands/

# Edit project-specific version
vim ~/my-project/.claude/commands/create_plan.md
```

Claude Code and AmpCode check project commands first, then fall back to global.

## Best Practices

### Research Phase
- Read files FULLY before analysis
- Document objectively - what IS, not opinions
- Include all references in file:line format
- Find patterns and conventions in use

### Planning Phase
- Discuss before writing - get alignment
- Define OUT of scope - prevent creep
- Make success criteria measurable
- Phase thoughtfully for incremental value

### Task Management
- Extract everything from plan - miss no tasks
- Maintain barriers and checkpoints
- Track blockers with actions and owners
- Update status regularly

### Verification
- Automate what's possible via CI/CD
- Document manual verification needs
- Enforce checkpoints between phases
- Require confirmation before proceeding

## Contributing

This is a personal repository, but pull requests are welcome for:
- Bug fixes in existing commands
- Documentation improvements
- New utility scripts
- Additional prompt templates

Please:
1. Run `./scripts/lint --fix` before committing
2. Test commands thoroughly
3. Update documentation
4. Follow existing patterns

## Credits

Planning commands inspired by enterprise context engineering patterns and refined through real-world usage. Incorporates learnings from HumanLayer's command architecture with adaptations for general use.

## License

[Your license here]

## Support

- **Commands**: See [Planning Commands README](commands/planning/README.md)
- **Claude Code Integration**: See [Claude Code README](claude-code/README.md)
- **AmpCode Integration**: See [AmpCode README](ampcode/README.md)
- **Issues**: Open an issue in this repository
