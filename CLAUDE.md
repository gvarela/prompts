# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a prompts repository containing Claude Code slash commands, agent definitions, and general prompt engineering resources. The repository serves as a collection of reusable prompts and commands for various purposes.

## Repository Structure

- `commands/` - Claude Code slash command definitions (markdown files)
- `agents/` - Agent definitions and specialized prompts
- `general/` - General-purpose prompts and templates
- `docs/` - Documentation and guides
- `scripts/` - Utility scripts for the repository
- `.claude/` - Claude Code configuration
  - `settings.local.json` - Permissions and hooks configuration

## Development Tools

### Markdown Linting

```bash
# Lint changed markdown files
./scripts/lint

# Auto-fix markdown issues
./scripts/lint --fix

# Lint specific files
./scripts/lint file1.md file2.md

# Lint all markdown files
./scripts/lint --all
```

**Automatic Linting**: PostToolUse hooks automatically lint markdown files after Write/Edit operations.

### Configuration

**Markdown Lint Rules** (`.markdownlintrc`):

- Line length checking disabled (MD013)
- Inline HTML allowed (MD033)
- Emphasis as heading allowed (MD036)
- Fenced code blocks without language allowed (MD040)

## Working with Prompts

### Command Files

Commands in `commands/` are markdown files that define Claude Code slash commands. Each command should:

- Include clear initial setup instructions
- Define step-by-step execution
- Provide error handling guidance
- Use consistent formatting

### Agent Definitions

Agent definitions in `agents/` should specify:

- Agent purpose and capabilities
- Input/output expectations
- Constraints and limitations
- Example usage

### General Prompts

General prompts in `general/` can include:

- Templates for common tasks
- Reusable prompt patterns
- Best practices examples

## Subdirectory Guidelines

Each major subdirectory may contain its own `CLAUDE.md` with specific instructions for that context. When working in a subdirectory with its own `CLAUDE.md`, follow those specific guidelines in addition to these general ones.

## Best Practices

When creating new prompts or commands:

1. Use clear, unambiguous language
2. Include examples where helpful
3. Document any special requirements or dependencies
4. Test thoroughly before committing
5. Keep prompts focused on a single purpose

## Git Workflow

- The main branch is `main`
- Commit messages should be descriptive
- Run `./scripts/lint` before committing markdown files
- Keep the repository organized by category

## Beads Issue Tracking

This repository uses [beads](https://github.com/steveyegge/beads) for task tracking across sessions.

### Quick Reference

```bash
bd ready              # Find available work (no blockers)
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with git (run at session end)
```

### Session Protocol

See [AGENTS.md](AGENTS.md) for the full session close protocol. Key points:

1. **Before ending**: Close completed issues with `bd close`
2. **Sync**: Run `bd sync` to persist changes
3. **Push**: Commit and push to remote

### Integration with wb Commands

The workbench commands (`/wb:*`) automatically detect beads and use it for phase tracking. See [wb/README.md](claude-code/commands/wb/README.md) for details.

