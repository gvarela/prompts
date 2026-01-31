---
name: status-sync
description: Monitors project status and reminds about sync. For beads projects, reminds about bd sync. For markdown-only projects, reminds about /wb:update_status.
allowed-tools: Read, Glob, Grep, Bash(bd:*)
---

# Status Sync Reminder

Monitors project status and reminds when synchronization is needed. Adapts behavior based on whether the project uses beads or markdown-only tracking.

## When to Activate

- User completes a phase checkpoint
- User checks off final task in a phase
- User says "done", "finished", "complete" about implementation work
- User asks about project status or progress
- At session end (before saying work is complete)

## Quick Detection: Beads vs Markdown-Only

```bash
# Check if beads is initialized
ls .beads/beads.db 2>/dev/null && echo "BEADS_PROJECT" || echo "MARKDOWN_ONLY"
```

---

## For Beads Projects

### Check Current State

```bash
bd stats    # Overall progress
bd ready    # What's available
bd list --status=in_progress  # What's claimed
```

### Drift Indicators

**Work done but not synced**:
- Issues closed in session but `bd sync` not run
- End of session approaching

**Phase complete but not closed**:
- All tasks in a phase done, but beads issue still open
- Reminder: `bd close [phase-id] --reason "..."`

### When to Remind (Beads)

```
📍 Beads sync reminder:
- [X] issues updated this session
- Run `bd sync` before ending session

Or if phase complete:
- Phase [N] appears complete
- Run: bd close [phase-id] --reason "Phase N complete"
```

---

## For Markdown-Only Projects

### Check for Drift

1. **Find project files**: Look for research.md, design.md, tasks.md in docs/plans/
2. **Read frontmatter**: Check `status`, `current_phase`, `completed_tasks`
3. **Count actual progress**: Count `[x]` vs `[ ]` in tasks.md
4. **Compare**: Does frontmatter match reality?

### Drift Indicators

**Phase complete but not recorded**:
- All tasks in Phase N checked, but `current_phase: N` (should be N+1)

**Status mismatch**:
- tasks.md has checked items but `status: not-started`
- design.md shows `status: ready` but tasks are in progress
- All tasks complete but `status: in-progress`

**Count mismatch**:
- `completed_tasks` doesn't match actual `[x]` count

### When to Remind (Markdown-Only)

```
Status may need updating:
- [specific issue, e.g., "Phase 2 complete but current_phase still shows 2"]

Run: /wb:update_status [project-directory]
```

---

## When NOT to Remind

- Minor work in progress (a few tasks checked mid-phase)
- User explicitly said they'll update later
- No project documentation exists
- Already reminded in this session
- Just starting work (not ending)

## DO NOT

- Update files directly
- Run commands automatically
- Interrupt creative/coding flow unnecessarily
- Remind repeatedly for the same issue
