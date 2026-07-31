# Beads Not Initialized — Standard Response

Shared reference for wb skills that require beads tracking (`implement_tasks`, `implement_coordinated`, `create_tasks`, and others). When `bd info` fails or beads is otherwise unavailable, present this and stop:

```
⚠️ Beads Not Initialized

Beads is required for task tracking in the wb workflow.

To initialize beads for this project:

    cd [project-root]
    bd init            # git mode (.beads/ committed)
    bd init --stealth  # stealth mode (.beads/ gitignored)

Then run /wb:create_tasks to set up beads issues for all tasks.
```

**Stop and wait for the user to initialize beads before proceeding.** Do not fall back to markdown checkboxes or TaskCreate/TodoWrite — beads is the only sanctioned status tracker in the wb workflow.

If beads IS initialized but a `bd` command fails:

1. **Diagnose**: `bd info` (initialization), `bd status` (overview)
2. **Report** the specific error to the user
3. **Common fixes**: "issue not found" → `bd list -n 0` to find the right ID; "database locked" → wait and retry, check for a stale `.beads/daemon.lock`
4. **Retry** the failed command after fixing
