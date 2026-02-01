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

### Automatic (Recommended)

Run the install script which:
1. Installs hooks to `~/.claude/hooks/` (global) or `<project>/.claude/hooks/` (project)
2. Offers to configure the SessionStart hook in your settings.json
3. Makes hooks executable

```bash
# Global installation (recommended for wb commands)
./scripts/install-commands --claude

# Project-specific installation
./scripts/install-commands --claude --project /path/to/project
```

The script will prompt you to configure the SessionStart hook automatically.

### Manual Installation

If you prefer manual setup:

1. **Copy hook script** to `~/.claude/hooks/`:
   ```bash
   mkdir -p ~/.claude/hooks
   cp .claude/hooks/setup-beads-mode.sh ~/.claude/hooks/
   chmod +x ~/.claude/hooks/setup-beads-mode.sh
   ```

2. **Configure in settings.json**:
   - For global use: Edit `~/.claude/settings.json`
   - For project use: Edit `<project>/.claude/settings.json`

   Add this configuration:
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

### In This Repo

The hook is pre-configured in `.claude/settings.json` (committed), so anyone working in this prompts repo gets it automatically.

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
