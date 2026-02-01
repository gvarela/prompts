# Claude Code Hooks

This directory contains hooks that run automatically during Claude Code sessions.

## setup-beads-mode.sh

**Purpose**: Automatically detects whether beads is in stealth mode or git mode at session start, setting the `$BEADS_MODE` environment variable.

**When it runs**: SessionStart (once per session)

**What it does**:
- Checks if `.beads/` is gitignored using `git check-ignore`
- If gitignored: sets `BEADS_MODE=stealth`
- If tracked: sets `BEADS_MODE=git`

**Used by**: wb workflow commands to avoid repeating stealth mode detection logic

## Installation

### Automatic (via install script)

Run the install script which makes hooks executable:

```bash
./scripts/install-commands --claude
```

### Project-Level (Committed)

The hook is already configured in `.claude/settings.json` (committed), so anyone cloning this repo gets it automatically.

### User-Level (Optional)

To use this hook across all your projects, add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/hooks/setup-beads-mode.sh",
            "timeout": 5,
            "statusMessage": "Detecting beads mode"
          }
        ]
      }
    ]
  }
}
```

**Note**: User-level config only works if you have this hook script in your project's `.claude/hooks/` directory.

## Beads Mode Explained

### Stealth Mode
- `.beads/` added to `.git/info/exclude` (local gitignore)
- Beads state NOT committed to git
- Good for work repos where you don't want to expose task tracking to the team

### Git Mode
- `.beads/` tracked in git normally
- Beads state persists across machines via git
- Good for personal projects and git-based collaboration

The hook auto-detects which mode you're in and sets `$BEADS_MODE` accordingly, so wb commands can adapt their behavior without manual configuration.
