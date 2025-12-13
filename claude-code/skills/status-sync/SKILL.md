---
name: status-sync
description: Monitors project documentation for status drift. Activates when completing tasks, finishing phases, or when status may be stale. Reminds to run /wb:update_status when needed.
allowed-tools: Read, Glob, Grep
---

# Status Sync Reminder

Monitors docs/plans/ project directories for status drift and reminds when synchronization is needed.

## When to Activate

- User completes a phase checkpoint
- User checks off final task in a phase
- User says "done", "finished", "complete" about implementation work
- User asks about project status or progress
- Working in a project that has docs/plans/ documentation

## Quick Status Check

When activated, check for drift:

1. **Find project files**: Look for research.md, design.md, tasks.md in docs/plans/
2. **Read frontmatter**: Check `status`, `current_phase`, `completed_tasks`
3. **Count actual progress**: Count `[x]` vs `[ ]` in tasks.md
4. **Compare**: Does frontmatter match reality?

## Drift Indicators

**Phase complete but not recorded**:

- All tasks in Phase N checked, but `current_phase: N` (should be N+1)

**Status mismatch**:

- tasks.md has checked items but `status: not-started`
- design.md shows `status: ready` but tasks are in progress
- All tasks complete but `status: in-progress`

**Count mismatch**:

- `completed_tasks` doesn't match actual `[x]` count

## When to Remind

If drift detected, provide a concise reminder:

```
Status may need updating:
- [specific issue, e.g., "Phase 2 complete but current_phase still shows 2"]

Run: /wb:update_status [project-directory]
```

## When NOT to Remind

- Minor work in progress (a few tasks checked mid-phase)
- User explicitly said they'll update later
- No project documentation exists
- Already reminded in this session

## DO NOT

- Update files directly
- Run the command automatically
- Interrupt creative/coding flow unnecessarily
- Remind repeatedly for the same issue
