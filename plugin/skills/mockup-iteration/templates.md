# mockup-iteration — Output Templates

Read the relevant section in full when its step directs you here; match its structure exactly.

## New Version Entry (mockup-log.md)

```markdown
### v00[N] - [YYYY-MM-DD] - [Brief Description]
- **Status**: In Review
- **Changes from v00[N-1]**:
  - KEPT: [what was preserved]
  - REMOVED: [what was cut]
  - CHANGED: [what was modified]
- **Feedback incorporated**: [summary]
- **Open questions**: [remaining unknowns]
```

## decisions.md Template

```markdown
---
version: [N]
created: [YYYY-MM-DD]
previous_version: [N-1]
---

# v00[N] Decisions

## Changes from v00[N-1]

### Added
- [New element] - reason: [user feedback/requirement]

### Removed
- [Removed element] - reason: [user feedback]

### Modified
- [Element]: [old] → [new] - reason: [rationale]

## Feedback Incorporated

| Feedback | Classification | Action Taken |
|----------|---------------|--------------|
| "[user quote]" | KEEP | Preserved [element] |
| "[user quote]" | REMOVE | Cut [element] |
| "[user quote]" | CHANGE | Modified [element] |

## Cumulative Requirements

_All confirmed requirements through this version:_

1. [Requirement from v001]
2. [Requirement from v002]
3. [New requirement this version]

## Still Open

- [ ] [Unresolved question]
```
