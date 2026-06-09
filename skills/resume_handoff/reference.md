# resume_handoff — Reference

Read the relevant section in full when its step directs you here; match its structure exactly.

## Error Handling Catalog

### Handoff File Not Found

```
❌ Error: Handoff file not found at [path]

Please check:
1. File path is correct
2. You're in the right repository
3. File wasn't moved or deleted

You may need to:
- Search for handoff files: find . -name "handoff-*.md"
- Start fresh with project documentation
```

### Invalid Handoff Format

```
❌ Error: Handoff document missing critical sections

Required sections not found:
- [Missing section]

This may not be a valid handoff document.
Check the file path or create a new handoff.
```

### Git State Mismatch

```
⚠️ Warning: Git state doesn't match handoff

Handoff commit: [commit]
Current commit: [different commit]

Options:
1. Continue anyway (may have merge conflicts)
2. Checkout handoff commit: git checkout [commit]
3. Create new handoff from current state
```
