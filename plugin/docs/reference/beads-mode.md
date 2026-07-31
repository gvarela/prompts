# Beads Modes: Stealth vs Git

Shared reference for all wb skills. The SessionStart hook (`hooks/setup-beads-mode.sh`) detects the mode once per session by running `git check-ignore -q .beads/` and exports `BEADS_MODE=stealth` or `BEADS_MODE=git`. Skills should read `$BEADS_MODE`, never re-detect.

## The Two Modes

| | Stealth mode | Git mode |
|---|---|---|
| `.beads/` in git | Gitignored (via `.gitignore` or `.git/info/exclude`) | Tracked and committed |
| Initialized by | `bd init --stealth` | `bd init` |
| State persistence | Local machine only | Across sessions and machines via git |
| Issue IDs in frontmatter | Still recorded (the docs travel even if the database doesn't) | Recorded and resolvable everywhere |
| Best for | Work repos where task tracking shouldn't be visible to the team | Personal projects, full-persistence workflows |

Both modes behave identically **within** a session. The difference is only what survives across sessions and machines.

## Persistence Mechanics (bd 1.0.2+)

- Beads auto-commits mutations to its embedded Dolt database and **auto-flushes `.beads/issues.jsonl`** after changes. There is no manual export step.
- Git hooks installed by `bd init` (`.beads/hooks/prepare-commit-msg`, `pre-push`) keep the JSONL consistent at commit time.
- After `git pull` updates `issues.jsonl`, beads auto-imports the changes.
- Remote *database* sync (separate from git) is `bd dolt push` / `bd dolt pull`, only when a Dolt remote is configured.

## The Only Mode-Conditional Action Skills Need

In git mode, commit beads state at session end or phase boundaries:

```bash
if [ "$BEADS_MODE" != "stealth" ]; then
  git add .beads/
  git commit -m "Update beads state after [context]"
fi
```

In stealth mode there is nothing to run — state is already flushed locally.

## Validating Mode Configuration

Mirror the hook's own predicate (do not test file tracked-ness — that false-negatives before the first commit):

```bash
if git check-ignore -q .beads/ 2>/dev/null; then
  # gitignored: consistent with stealth mode
else
  # not gitignored: consistent with git mode
fi
```

A mismatch between `$BEADS_MODE` and this predicate means the mode changed mid-session or init is misconfigured — re-run `bd init` / `bd init --stealth`.
