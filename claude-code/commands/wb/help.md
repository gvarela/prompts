---
description: Quick reference for wb workflow commands and beads integration
argument-hint: [topic]
---

# Workbench Help

Quick reference for the wb workflow commands and beads integration.

## Usage

```
/wb:help              # Show this overview
/wb:help workflow     # Command sequence
/wb:help beads        # Beads commands
/wb:help [command]    # Help for specific command
```

## Command Workflow

```
/wb:create_project    → Initialize project structure
         ↓
/wb:create_research   → Document what EXISTS (facts only)
         ↓
/wb:create_design     → Decide WHAT to build and WHY
         ↓
/wb:create_execution  → Plan HOW to implement (creates beads issues)
         ↓
/wb:implement_tasks   → Execute with TDD (Red → Green → Refactor)
         ↓
/wb:validate_execution → Verify implementation matches plan
```

**Session Management:**
```
/wb:create_handoff    → Save context for later
/wb:resume_handoff    → Restore context and continue
/wb:update_status     → Sync status across all files
```

## Beads Integration

Beads tracks phases across sessions. Required for this workflow.

### Initialize (once per project)
```bash
bd init
```

### Daily Workflow
```bash
bd ready                              # Find available work
bd update [phase-id] --status in_progress  # Claim it
# ... implement ...
bd close [phase-id] --reason "Done"   # Complete it
bd sync                               # Save to git
```

### Common Commands
| Command | Purpose |
|---------|---------|
| `bd ready` | Show phases ready to work (no blockers) |
| `bd list` | Show all issues |
| `bd show [id]` | Details for one issue |
| `bd stats` | Project progress summary |
| `bd blocked` | Show blocked phases |
| `bd sync` | Export to JSONL for git |

### Beads + Git Workflow
```bash
# End of session
bd sync              # Export beads state
git add .beads/      # Stage beads changes
git commit           # Commit everything
git push             # Push to remote

# Start of session (after git pull)
bd sync --import     # Import any remote changes
bd ready             # See what's available
```

## Command Details

### `/wb:create_project [name] [directory] [ticket]`
Creates project structure with research.md, design.md, tasks.md.

### `/wb:create_research [directory]`
Spawns parallel agents to document codebase. Facts only, no opinions.

### `/wb:create_design [directory]`
Interactive design session. Captures WHAT and WHY, not HOW.

### `/wb:create_execution [directory]`
Transforms design into phased plan. Creates beads issues for tracking.

### `/wb:implement_tasks [directory] [phase|continue]`
TDD implementation. Claims phase in beads, updates on completion.

### `/wb:validate_execution [directory]`
Verifies implementation matches plan. Run after completing work.

### `/wb:update_status [directory]`
Syncs status across all files. Uses beads as source of truth.

### `/wb:create_handoff [directory] [reason]`
Captures context for session transfer. Includes beads state.

### `/wb:resume_handoff [handoff-file]`
Restores context from handoff. Syncs beads and continues work.

## Core Principles

1. **Document, Don't Judge** - Research describes what IS, not what should change
2. **Explicit Barriers** - Stop at ⛔ BARRIER markers, wait for completion
3. **Zero Scope Creep** - Only implement what's in tasks.md
4. **TDD Discipline** - Red → Green → Refactor for each task
5. **Beads Required** - Phase tracking persists across sessions

## Quick Troubleshooting

**"beads not initialized"**
```bash
bd init
```

**"issue not found"**
```bash
bd list              # Find correct ID
```

**"beads_phases missing in frontmatter"**
```bash
/wb:create_execution [directory]   # Creates beads issues
```

**"database locked"**
Wait a moment and retry. Check for other bd processes.

**Need markdown-only workflow?**
Use `v1.0.0` tag of this repo (before beads integration).
