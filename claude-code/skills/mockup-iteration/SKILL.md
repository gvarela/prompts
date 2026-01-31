---
name: mockup-iteration
description: Iterate on UI mockups, capturing keeps/removes/changes with full fidelity. Versions each iteration and maintains decision log.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(ls:*, mkdir:*)
triggers:
  - mockup feedback
  - iterate on mockup
  - change the mockup
  - keep this
  - remove this
  - update mockup
  - next version
  - refine design
---

# Mockup Iteration Skill

Helps iterate on UI mockups efficiently, capturing decisions without fidelity loss.

## Activation

This skill activates when:
- User provides feedback on a mockup ("keep the header", "remove the sidebar")
- User asks to iterate or create next version
- User discusses mockup changes
- User wants to finalize mockup into design

## Core Behavior

### On Feedback Receipt

When user provides mockup feedback:

1. **Acknowledge and classify** the feedback:
   - **KEEP**: Confirmed requirement - add to "Confirmed" in mockup-log.md
   - **REMOVE**: Rejected idea - add to "Rejected" with rationale
   - **CHANGE**: Modification needed - note for next version
   - **QUESTION**: Needs clarification - ask before proceeding

2. **Update mockup-log.md** immediately:
   ```markdown
   ### Confirmed (KEEP)
   - [Requirement] - confirmed [date] - "[user quote]"

   ### Rejected (REMOVE)
   - [Idea] - rejected [date] - reason: "[user rationale]"
   ```

3. **Summarize understanding** before creating new version:
   ```
   Got it. For the next version:

   ✓ KEEPING: [list]
   ✗ REMOVING: [list]
   ~ CHANGING: [list]
   ? CLARIFYING: [questions if any]

   Ready to create v[N+1]?
   ```

### On Version Request

When user confirms or says "next version":

1. **Read current version** fully
2. **Read mockup-log.md** for accumulated decisions
3. **Create new version directory**: `mockups/v00[N+1]/`
4. **Create new mockup.md** incorporating ALL feedback
5. **Create decisions.md** documenting what changed
6. **Update mockup-log.md** with version entry

### Version Naming

```
v001 - Initial draft
v002 - First iteration
v003 - Second iteration
...
v00N - Final (before design.md)
```

## Iteration Workflow

```
User feedback → Classify → Update log → Confirm understanding → Create version
     ↑                                                              │
     └──────────────────────────────────────────────────────────────┘
```

## Templates

### New Version Entry (mockup-log.md)

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

### decisions.md for New Version

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

## Fidelity Preservation

**CRITICAL**: Never lose design decisions. Every piece of feedback must be:

1. **Captured verbatim** - Quote user's exact words
2. **Classified** - KEEP/REMOVE/CHANGE/QUESTION
3. **Recorded** - In mockup-log.md immediately
4. **Incorporated** - In next version or noted as open

### Anti-patterns to Avoid

- Do not assume feedback without recording
- Do not overwrite previous version
- Do not lose "REMOVE" decisions (they inform design)
- Do not use vague summaries instead of specific quotes
- Do not create version without updating log

## Finalizing to Design

When user says "finalize" or "ready for design":

1. **Compile all KEEP decisions** from mockup-log.md
2. **List all REMOVE decisions** as "Out of Scope"
3. **Identify remaining OPEN questions**
4. **Generate design.md section**:

```markdown
## UI Design: [Feature]

### Requirements (from mockup iteration)

_Confirmed through [N] mockup iterations_

1. [Requirement] - v00[X]
2. [Requirement] - v00[Y]

### Out of Scope

_Explicitly excluded during mockup iteration_

1. [Excluded item] - reason: [from REMOVE log]

### Final Mockup Reference

See: `mockups/v00[final]/mockup.md`

### Open Items for Implementation

- [ ] [Remaining question]
```

## Quick Commands

During iteration, user can say:

| Command | Action |
|---------|--------|
| "keep [X]" | Add to Confirmed, preserve in next version |
| "remove [X]" | Add to Rejected, cut from next version |
| "change [X] to [Y]" | Note modification for next version |
| "next version" | Create v00[N+1] with all feedback |
| "show log" | Display current mockup-log.md |
| "show keeps" | List all confirmed requirements |
| "show removes" | List all rejected ideas |
| "finalize" | Prepare for design.md |

## Example Interaction

```
User: "Keep the card layout but remove the sidebar. The header should be sticky."

Claude: Updated mockup-log.md:

✓ KEEPING:
  - Card layout - "Keep the card layout"
  - Header (will make sticky)

✗ REMOVING:
  - Sidebar - "remove the sidebar"

~ CHANGING:
  - Header: static → sticky - "header should be sticky"

Ready to create v002?

User: "Yes, and make the cards 3 columns on desktop"

Claude: Got it, adding to changes:

~ CHANGING:
  - Card grid: current → 3 columns on desktop

Creating v002...

✅ Created mockups/v002/
- mockup.md: Updated with all changes
- decisions.md: Documented rationale
- mockup-log.md: Added v002 entry
```

## DO NOT

- Do not create mockup versions without reading the current version first
- Do not skip updating mockup-log.md
- Do not proceed with ambiguous feedback - ask for clarification
- Do not lose track of cumulative requirements across versions
