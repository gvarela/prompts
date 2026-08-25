---
name: status-sync
description: Use when ending a session, wrapping up work, or completing a phase - monitors beads status and reminds about committing beads state and closing finished phase milestones.
allowed-tools: Read, Glob, Grep, Bash(bd:*)
user-invocable: false
---

# Status Sync Reminder

Interactive deep-check for beads state at phase boundaries and session end. The deterministic session-end reminder is handled by the plugin's SessionEnd hook (`hooks/beads-drift-check.sh`) — this skill is for the richer check: phase milestones left open, in-progress issues that should be closed, and drift the hook's git-only signal can't see.

## When to Activate

- User completes a phase checkpoint
- User says "done", "finished", "complete" about implementation work
- At session end (before saying work is complete)

## Check Current State

```bash
bd stats                        # Overall progress
bd ready                        # What's available
bd list --status=in_progress    # What's claimed
```

## Drift Indicators

**Work done but not persisted**:

- Issues closed this session but `.beads/` changes not committed (git mode)
- End of session approaching

**Phase complete but not closed**:

- All tasks in a phase done, but beads issue still open
- Reminder: `bd close [phase-id] --reason "..."`

**Frontmatter drift**:

- At phase end/session end, compare tasks.md frontmatter `completed_tasks`/`current_phase` against beads reality (`bd stats`, closed counts)
- On mismatch, remind the user to run `/wb:update_status [project-dir]`

## When to Remind

```
📍 Beads sync reminder:
- [X] issues updated this session
- Commit .beads/ before ending session (git mode) — issues.jsonl is auto-flushed
- Run `bd dolt push` if a Dolt remote is configured

Or if phase complete:
- Phase [N] appears complete
- Run: bd close [phase-id] --reason "Phase N complete"
```

## When NOT to Remind

- Minor work in progress (mid-phase)
- User explicitly said they'll update later
- Already reminded in this session
- Just starting work (not ending)

## DO NOT

- Update files directly
- Run commands automatically
- Interrupt creative/coding flow unnecessarily
- Remind repeatedly for the same issue
