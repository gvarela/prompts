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

### Finding the Mockup Context

Before processing feedback, locate the mockup:

1. **Find mockup-log.md**: Search for `mockups/mockup-log.md` in current project
2. **Read project_directory** from frontmatter to confirm location
3. **Read current_version** from frontmatter to know active version
4. **Verify v00[N] directory exists** - if not, scan for highest existing

**If mockup-log.md missing:**
```
I can't find an active mockup session.

Options:
1. Start new mockup: /wb:create_mockup [directory] [feature]
2. Point me to existing mockup-log.md location
```

**If giving feedback about non-mockup topic:**
```
I'm treating this as mockup feedback for [feature] (currently v00[N]).
If this isn't about the mockup, let me know.
```

### On Feedback Receipt

When user provides mockup feedback:

1. **Acknowledge and classify** the feedback:
   - **KEEP**: Confirmed requirement - add to "Confirmed" in mockup-log.md
   - **REMOVE**: Rejected idea - add to "Rejected" with rationale
   - **CHANGE**: Modification needed - note for next version
   - **QUESTION**: Needs clarification - ask before proceeding

   **Compound feedback** (contains multiple types):
   - Split into separate entries
   - "Keep header but make it blue" → KEEP: header layout + CHANGE: header color to blue
   - Each part gets its own log entry

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

1. **Read current_version from mockup-log.md frontmatter** (e.g., `current_version: 2`)
2. **Read mockups/v00[N]/mockup.md** fully as base
3. **Read mockup-log.md** Running Requirements for accumulated decisions
4. **Create new version directory**: `mockups/v00[N+1]/` (zero-padded: v001, v002, ..., v010)
5. **Create new mockup.md** incorporating ALL feedback
6. **Create decisions.md** documenting what changed (delta only)
7. **Update mockup-log.md**:
   - Frontmatter: `current_version: [N+1]`, `last_updated: [date]`
   - Add version entry to Version History
   - Update Running Requirements sections

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
| "revert to v00[N]" | Create new version based on v00[N] |
| "compare v00[A] and v00[B]" | Show differences between versions |
| "finalize" | Prepare for design.md |

## Revert and Compare

### On "revert to v00[N]"

1. Read mockups/v00[N]/mockup.md as new base
2. Create v00[current+1] with that content
3. Note in mockup-log.md: "Reverted to v00[N] base"
4. Decisions from v00[N+1] to v00[current] marked as "superseded by revert"
5. User can still access old versions for reference

### On "compare v00[A] and v00[B]"

Generate comparison summary:
```
## v00[A] → v00[B] Comparison

**Added in v00[B]:**
- [element]

**Removed in v00[B]:**
- [element]

**Changed:**
- [element]: [v00A state] → [v00B state]

**Decisions between versions:**
- v00[A+1]: [summary]
- v00[A+2]: [summary]
...
```

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

## Session Continuity

If session ends mid-iteration or user requests handoff:

1. **Capture pending feedback** not yet versioned
2. **Update mockup-log.md** with "Pending Feedback" section:
   ```markdown
   ## Pending Feedback (Not Yet Versioned)
   - "[feedback 1]" - KEEP
   - "[feedback 2]" - CHANGE
   ```
3. **Note in handoff document** (if using /wb:create_handoff):
   - Mockup location: [path]
   - Current version: v00[N]
   - Pending feedback: [count] items

On resume, read mockup-log.md's "Pending Feedback" section first.

## DO NOT

- Do not create mockup versions without reading the current version first
- Do not skip updating mockup-log.md
- Do not proceed with ambiguous feedback - ask for clarification
- Do not lose track of cumulative requirements across versions
- Do not assume feedback context - confirm if ambiguous whether it's about the mockup
