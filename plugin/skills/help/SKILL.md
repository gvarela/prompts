---
name: help
description: Quick reference for wb workflow commands and beads integration
argument-hint: [topic]
---

# Workbench Help

This document is a reference for both the user AND Claude. When invoked:

1. **Read the topic** (if provided) - e.g., `/wb:help beads` means focus on beads section
2. **Explain** the relevant commands, workflow, or concepts conversationally
3. **Answer questions** - help the user understand how to use these tools effectively
4. **Guide Claude too** - this reference helps Claude understand the workflow it should follow

You are a helpful guide to this workflow system, not just dumping text.

## Topics

```
/wb:help              # Overview of everything
/wb:help workflow     # Command sequence and when to use each
/wb:help beads        # Beads commands and integration
/wb:help mockup       # Mockup iteration workflow
/wb:help [command]    # Specific command (e.g., /wb:help create_design)
```

## Command Workflow

```
/wb:create_project    → Initialize project structure
         ↓
/wb:create_research   → Document what EXISTS (facts only)
         ↓
/wb:explore_design    → (optional) Explore architecture directions, record decision
         ↓
/wb:create_design     → Decide WHAT to build and WHY
         ↓
/wb:create_tasks  → Plan HOW to implement (creates beads issues)
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

**UI Mockup Workflow:**

```
/wb:create_mockup     → Research UI patterns + create v001
[iterate with feedback] → Keep/remove/change decisions captured
[mockup-iteration skill] → Creates versioned mockups automatically
finalize              → Compile requirements into design.md
```

## Beads Integration

Beads tracks work across sessions. Required for this workflow.

### Planning Phase (Questions & Decisions)

Beads helps ensure nothing falls through the cracks during planning:

| What to Track | When | Why |
| --------------- | ------ | ----- |
| `Q: [question]` | Research finds unknowns | Blocks design until answered |
| `Decide: [choice]` | Design needs stakeholder input | Blocks execution until decided |
| `Validate: [assumption]` | Design assumes something | Must verify during implementation |
| `UI Q: [question]` | Mockup iteration raises issue | Blocks finalization |

```bash
# Before moving to next phase, check for blockers:
bd list -n 0 --status=open | grep -E "Q:|Decide:|Validate:|UI Q:"
```

**`Decide:` lifecycle**: an **open** `Decide:` issue is a pending decision (blocks as above); a **closed** one means the decision was made — chosen direction and rationale live in the close reason. Prefixes count only when the title BEGINS with them — mid-title mentions are ignored. `/wb:explore_design` creates and closes its record in one session; `/wb:create_design` finds it via:

```bash
bd list -n 0 --status=closed | grep "Decide:"
```

### Execution Phase (Phases & Tasks)

### Initialize (once per project)

```bash
bd init
```

### Execution Workflow

```bash
bd ready                              # Find available work
bd update [phase-id] --claim          # Claim it
# ... implement ...
bd close [phase-id] --reason "Done"   # Complete it
# push to the Dolt remote if one is configured (see plugin/docs/reference/beads-mode.md)
```

### Beads Slash Commands

Use these instead of CLI when working in Claude Code:

| Command | When to Use |
| --------- | ------------- |
| `/beads:ready` | Start of session - find available work |
| `/beads:list` | See all issues with filters |
| `/beads:show [id]` | Review issue details before starting |
| `/beads:create` | Create new issue (task, bug, feature, epic) |
| `/beads:update [id]` | Change status, priority, or assignee |
| `/beads:close [id]` | Mark issue complete |
| `/beads:blocked` | See what's stuck and why |
| `/beads:dep` | Manage dependencies between issues |
| `/beads:stats` | Project health and progress |

**Less Common:**

| Command | When to Use |
| --------- | ------------- |
| `/beads:init` | First time setup in a project |
| `/beads:search` | Find issues by text |
| `/beads:epic` | Manage epics and their children |
| `/beads:reopen` | Reopen a closed issue |
| `/beads:comments` | Add notes to an issue |
| `/beads:compact` | Archive old closed issues |
| `/beads:workflow` | Show the full workflow guide |

### CLI vs Slash Commands

Both work - use whichever fits your flow:

```bash
# CLI (in terminal or scripts)
bd ready
bd close prompts-abc --reason "Done"

# Slash commands (in Claude Code conversation)
/beads:ready
/beads:close prompts-abc
```

### Beads persistence

```bash
# Three tiers (see plugin/docs/reference/beads-mode.md)
# 1. Local: the embedded Dolt database under .beads/ is the source of truth; never committed
# 2. Cross-machine: a Dolt remote (bd dolt push / bd dolt pull) or bd backup (bd backup init <url>, bd backup sync)
# 3. Interchange: bd export writes issues.jsonl for viewers only (export.auto is off by default)
bd config get sync.remote    # a URL means a remote is configured; "not set" means local only
bd dolt push                 # end of session, only when a remote is configured
```

## Command Details

### `/wb:create_project [name] [directory] [ticket]`

Creates project structure with research.md, design.md, tasks.md.

### `/wb:create_research [directory]`

Spawns parallel agents to document codebase. Facts only, no opinions.

### `/wb:explore_design [directory]`

(optional) Facilitated architecture discussion between research and design. Invoke when research surfaced multiple viable approaches, the change is cross-cutting or introduces a new subsystem, or the choice is hard to reverse. Skip for small well-scoped fixes, single-approach research, or when create_design's built-in option step is proportionate. Records the decision as a closed `Decide:` issue plus a thoughts/ doc; create_design detects and formalizes it.

### `/wb:create_design [directory]`

Interactive design session. Captures WHAT and WHY, not HOW. Formalizes a recorded decision when explore_design ran; generates options itself when not.

### `/wb:create_tasks [directory]`

Transforms design into phased plan. Creates beads issues for tracking. (`/wb:create_execution` is a deprecated alias — removed at 3.0.0.)

### `/wb:implement_tasks [directory] [phase|continue]`

TDD implementation. Claims phase in beads, updates on completion.

### `/wb:validate_execution [directory]`

Verifies implementation matches plan. Run after completing work.

### `/wb:update_status [directory]`

Syncs status across all files. Uses beads as source of truth.

### `/wb:create_mockup [directory] [feature]`

Researches existing UI patterns, asks clarifying questions, creates versioned mockup. Use mockup-iteration skill to refine.

### `/wb:create_handoff [directory] [reason]`

Captures context for session transfer. Includes beads state. A phase that has already needed one `/compact` should hand off rather than compact again.

### `/wb:resume_handoff [handoff-file]`

Restores context from handoff. Syncs beads and continues work. A phase that has already needed one `/compact` should hand off rather than compact again.

## Core Principles

1. **Document, Don't Judge** - Research describes what IS, not what should change
2. **Explicit Barriers** - Stop at ⛔ BARRIER markers, wait for completion
3. **Zero Scope Creep** - Only implement what's in tasks.md
4. **TDD Discipline** - Red → Green → Refactor for each task
5. **Beads Required** - Phase tracking persists across sessions
6. **Compaction Recovery** - After `/compact`, the SessionStart(compact) hook re-anchors on the active plan docs; doc-content claims require a read in the current context window (doc-adherence skill)

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
/wb:create_tasks [directory]   # Creates beads issues
```

**"database locked"**
Wait a moment and retry. Check for a stale `.beads/daemon.lock` or another bd process (`bd daemon` status).

**Need markdown-only workflow?**
Use `v1.0.0` tag of this repo (before beads integration).
