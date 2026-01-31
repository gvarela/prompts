# Project Documentation Commands

A comprehensive set of Claude Code slash commands for managing project documentation, research, planning, and task tracking with enterprise-grade context engineering.

## Core Philosophy

### 🎯 Guiding Principles

**Document, Don't Judge**: Research describes what EXISTS, not what should be changed

**Interactive Planning**: Collaborate through discussion before writing plans

**Explicit Barriers**: Clear synchronization points prevent rushing ahead

**Verification Gates**: Automated AND manual checks between phases

**Zero Scope Creep**: Tasks come from plans only - no additions

**Complete Context**: Always read files FULLY before analysis

## Command Workflow

```mermaid
/create_project → /create_research → /create_design → /create_execution → /implement_tasks → /validate_execution
     ↓                   ↓                 ↓                 ↓                    ↓                   ↓
[Structure]        [Research.md]      [Design.md]       [Tasks.md]         [Implementation]    [Validation]
                        ↓                 ↓                 ↓                    ↓                   ↓
                   [What EXISTS]    [WHAT & WHY]      [HOW to do it]      [TDD Cycle]        [Verification]

For multi-session work:
[Session 1] → /create_handoff → [Session 2] → /resume_handoff → [Continue work]
```

### Workflow Stages

1. **Initialize**: Create project structure with metadata
2. **Research**: Document codebase as it EXISTS today (facts only)
3. **Design**: Decide WHAT to build and WHY (architectural decisions)
4. **Execution**: Plan HOW to implement (phased plan with tasks)
5. **Implement**: Execute using TDD with checkpoints
6. **Validate**: Verify implementation matches plan
7. **Handoff** (optional): Transfer context between sessions

### Beads Integration (Optional)

If [beads](https://github.com/steveyegge/beads) is initialized in your project (`bd init`), commands automatically:

- **`/create_execution`**: Creates beads issues for each phase with dependencies
- **`/implement_tasks`**: Uses `bd ready`/`bd update`/`bd close` to track phases
- **`/update_status`**: Reads beads state as source of truth

**Beads workflow**:
```bash
bd ready                              # Find available phases
bd update [phase-id] --status in_progress  # Claim phase
# ... implement ...
bd close [phase-id] --reason "..."    # Complete phase
bd sync                               # Persist to git
```

**Without beads**: Commands fall back to markdown-only tracking (checkboxes in tasks.md).

---

## Commands Reference

### `/create_project` - Initialize Project Documentation

Creates a comprehensive documentation structure with Git metadata tracking.

**Usage**:

```bash
/create_project my-feature
/create_project my-feature docs/projects
/create_project my-feature docs/projects LINEAR-789
```

**Creates**:

```
docs/plans/2025-10-07-LINEAR-789-my-feature/
├── README.md     # Navigation and overview
├── research.md   # Research documentation (with metadata)
├── design.md     # Design decisions (with metadata)
└── tasks.md      # Execution plan with tasks (with metadata)
```

**Key Features**:

- Captures Git metadata (commit, branch, repo)
- Creates timestamped directories
- Initializes with rich frontmatter
- Sets up workflow sequence
- Creates initial planning tasks

---

### `/research` - Quick Codebase Research (Conversational)

Conducts fast research without file output - for quick answers.

**Usage**:

```bash
/research
> How does our authentication middleware work?
```

**Returns**: Conversational findings with file:line references

**When to use**: Quick questions, no documentation needed

---

### `/create_research` - Document Research Findings

Conducts comprehensive research with parallel agents and saves detailed findings.

**Usage**:

```bash
/create_research docs/plans/2025-10-07-my-feature
> Research how we handle API rate limiting and error recovery
```

**Critical Behaviors**:

- **⛔ BARRIER 1**: Reads mentioned files FULLY first
- **⛔ BARRIER 2**: Waits for ALL agents to complete
- **⛔ BARRIER 3**: No placeholder values in output

**Agent Strategy**:

```
Code Locator Agents → Find WHERE components live
Code Analyzer Agents → Understand HOW code works
Pattern Finder Agents → Find similar implementations
```

**All agents are told**: "Document what IS, not what SHOULD BE"

**Creates**: Structured research.md with:

- Research question and summary
- Detailed findings with `file.ext:line` references
- Architecture documentation (patterns found)
- Code references quick list
- Similar implementations
- Open questions
- Follow-up research support

---

### `/create_design` - Create Design Document

Creates architectural design decisions based on validated research. Focuses on WHAT to build and WHY.

**Usage**:

```bash
/create_design docs/plans/2025-10-07-my-feature
```

**Interactive Process**:

1. **Reads research** and spawns verification agents
2. **Analyzes patterns** and integration points
3. **Presents design options** with trade-offs
4. **Discusses decisions** interactively
5. **Documents approved design** with rationale

**Design Structure**:

- Problem statement and success metrics
- Design approach with rationale
- Technical decisions (architecture, data model, integrations)
- Scope definition (in/out of scope)
- Success criteria (functional and non-functional)
- Risk analysis
- Rejected alternatives

**Critical Rules**:

- **WHAT and WHY only** - never HOW
- NO implementation sequences or code changes
- Explicit decisions with rationale
- Clear scope boundaries
- Measurable success criteria

---

### `/create_execution` - Create Execution Plan

Transforms approved design into detailed phased execution plan with embedded tasks.

**Usage**:

```bash
/create_execution docs/plans/2025-10-07-my-feature
```

**Planning Process**:

1. **Reads research and design** completely
2. **Spawns analysis agents** for dependencies, testing, rollback
3. **Determines implementation strategy** from agent findings
4. **Generates phased plan** with specific tasks

**Execution Plan Structure**:

```markdown
## Phase 1: [Descriptive Name]

### Changes Required
- Specific file modifications with line numbers
- Before/after code examples
- Integration points

### Tasks
- [ ] Setup tasks (directories, dependencies, config)
- [ ] Implementation tasks (specific components)
- [ ] Testing tasks (unit, integration)
- [ ] Integration tasks (connections)

### Success Criteria
#### Automated Verification
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Build succeeds

#### Manual Verification
- [ ] Feature works as designed
- [ ] No regressions

### ⛔ CHECKPOINT: Phase 1 Complete
```

**Features**:

- Dependency-based phase ordering
- Specific code changes with file:line references
- Comprehensive test coverage from agent analysis
- Rollback procedures for each phase
- Quick test commands per phase
- Progress tracking
- Modified files tracking

---

### `/implement_tasks` - Implement with TDD

Implements tasks following Test-Driven Development (Red → Green → Refactor).

**Usage**:

```bash
/implement_tasks docs/plans/2025-10-07-my-feature
```

**TDD Process**:

1. **Red**: Write failing test for next task
2. **Green**: Implement minimum code to pass
3. **Refactor**: Clean up while tests pass
4. **Verify**: Run phase verification
5. **Checkpoint**: Get human approval

**Critical Rules**:

- **ZERO SCOPE CREEP** - only implement what's in tasks.md
- Follow TDD cycle strictly
- Respect phase boundaries
- Stop at checkpoints for human verification
- Update task checkboxes as you complete work

---

### `/validate_execution` - Validate Implementation

Validates that execution plan was correctly implemented. Run after implementation is complete.

**Usage**:

```bash
/validate_execution docs/plans/2025-10-07-my-feature
```

**Validation Process**:

1. **Spawns validation agents** for code changes, testing, success criteria, documentation
2. **Compares actual vs planned** implementation
3. **Identifies deviations** and missing items
4. **Generates comprehensive report**

**Validation Report**:

- Implementation completeness
- Success criteria verification
- Test coverage analysis
- Deviations from plan
- Recommendations

---

### `/create_handoff` - Create Session Handoff

Creates comprehensive handoff document for session transfer.

**Usage**:

```bash
/create_handoff docs/plans/2025-10-07-my-feature
```

**Captures**:

- Current progress and phase
- Critical learnings not in formal docs
- Problems solved
- Active blockers
- Next steps with specific recommendations
- Git state and uncommitted changes

---

### `/resume_handoff` - Resume from Handoff

Resumes work from a handoff document created in previous session.

**Usage**:

```bash
/resume_handoff docs/plans/2025-10-07-my-feature/handoff-2025-01-08-14-30.md
```

**Restoration**:

- Reads handoff and project documentation
- Restores context and learnings
- Applies discovered patterns
- Continues from exact stopping point
- Prevents repeating solved problems

---

### `/update_status` - Update Project Status

Intelligently updates status across all documentation files based on actual progress.

**Usage**:

```bash
/update_status docs/plans/2025-10-07-my-feature
```

**What It Does**:

1. **Reads ALL files FULLY** - Analyzes research.md, design.md, tasks.md
2. **Determines actual state** - Checks content, not just frontmatter
3. **Proposes updates** - Shows what will change and why
4. **Applies consistently** - Updates all files atomically
5. **Verifies consistency** - Ensures no conflicting states

**Status Progressions**:

```
research.md: draft → in-progress → complete
design.md: draft → ready → implementing → complete
tasks.md: not-started → in-progress → complete
```

**Smart Detection**:

- Detects completion percentage from checked tasks
- Identifies current active phase
- Validates status transitions across files
- Prevents invalid state changes
- Updates git metadata for audit trail

**Key Features**:

- No manual status updates needed
- Prevents status regression
- Maintains consistency across all files
- Provides clear transition reasoning
- Cascading updates (plan → tasks)

---

## Critical Implementation Patterns

### 📚 File Reading Protocol

**ALWAYS**:

```
1. Read mentioned files FULLY (no limit/offset)
2. Read BEFORE spawning agents
3. Build context in main thread first
4. NEVER use partial reads
```

### 🚧 Synchronization Barriers

Commands implement explicit barriers:

```
⛔ BARRIER 1: After file reading - full context required
⛔ BARRIER 2: After agent spawning - wait for ALL
⛔ BARRIER 3: Before writing - no placeholders allowed
⛔ CHECKPOINT: Between phases - human verification required
```

### 🤖 Agent Instructions

Every research agent receives:

```
You are documenting the codebase as it exists.
DO NOT suggest improvements or identify issues.
Document what IS, not what SHOULD BE.
```

### ✅ Dual Verification Model

Plans separate verification into:

**Automated** (CI can run):

- Unit tests: `npm test`
- Linting: `make lint`
- Build: `make build`

**Manual** (Human required):

- UI functionality
- Performance validation
- Edge case testing
- User acceptance

---

## Workflow Example

### Complete Project Lifecycle

#### 1. Initialize Project

```bash
/create_project add-auth-middleware docs/projects LINEAR-789
```

Creates timestamped directory with metadata-rich files.

#### 2. Research Codebase

```bash
/create_research docs/projects/2025-10-07-LINEAR-789-add-auth-middleware
> Research current middleware architecture, auth patterns, and session handling
```

Spawns parallel agents, documents findings objectively.

#### 3. Create Design

```bash
/create_design docs/projects/2025-10-07-LINEAR-789-add-auth-middleware
```

Interactive discussion → Design decisions (WHAT and WHY).

#### 4. Create Execution Plan

```bash
/create_execution docs/projects/2025-10-07-LINEAR-789-add-auth-middleware
```

Generates phased plan with specific tasks (HOW to implement).

#### 5. Implement with TDD

```bash
/implement_tasks docs/projects/2025-10-07-LINEAR-789-add-auth-middleware
```

Work through tasks.md using TDD cycle:

```markdown
- [x] Review existing middleware (completed 2025-10-07 14:30)
- [x] Set up test environment (completed 2025-10-07 15:15)
- [>] Implement auth check function
- [ ] Add session validation
```

Update frontmatter as you progress:

```yaml
current_phase: 1
completed_tasks: 8
total_tasks: 24
```

---

## Metadata & Tracking

### Rich Frontmatter

All files include:

```yaml
---
# Basic tracking
project: feature-name
ticket: LINEAR-789
created: 2025-10-07
status: in-progress
last_updated: 2025-10-07

# Git metadata
git_commit: abc123def
git_branch: feature/add-auth
repository: org/repo

# User tracking
researcher: jsmith
planner: jsmith
assignee: jsmith

# Progress metrics
current_phase: 2
total_tasks: 24
completed_tasks: 15
---
```

### Status Progression

Files move through defined states:

**research.md**: `draft` → `in-progress` → `complete`

**plan.md**: `draft` → `ready` → `implementing` → `complete`

**tasks.md**: `not-started` → `in-progress` → `complete`

---

## Configuration & Customization

### Directory Structure

Default: `docs/plans/YYYY-MM-DD-[TICKET-]project-name/`

Customize base directory per command:

```bash
/create_project feature custom/location
```

### Ticket Formats

Flexible ticket support:

- GitHub: `GH-123`
- Jira: `PROJ-456`
- Linear: `ENG-789`
- Custom: `CUSTOM-999`
- None: omit entirely

### Extending Commands

All commands are markdown files - edit to customize:

```
commands/
├── create_project.md   # Structure and metadata
├── create_research.md  # Research approach
├── create_plan.md      # Planning process
└── create_tasks.md     # Task extraction
```

---

## Best Practices

### Research Phase

- **Read files FULLY** before analysis
- **Document objectively** - what IS, not opinions
- **Include all references** - file:line format
- **Find patterns** - conventions in use
- **Note connections** - how components interact

### Planning Phase

- **Discuss before writing** - get alignment
- **Define OUT of scope** - prevent creep
- **Make it measurable** - clear success criteria
- **Phase thoughtfully** - incremental value
- **Include rollback** - safety first

### Task Management

- **Extract everything** - miss no tasks
- **Maintain barriers** - checkpoints matter
- **Track blockers** - with actions/owners
- **Archive weekly** - keep focus
- **Update frontmatter** - overall metrics

### Verification Strategy

- **Automate what's possible** - CI/CD checks
- **Document manual needs** - human verification
- **Enforce checkpoints** - between phases
- **Require confirmation** - before proceeding

---

## Common Patterns

### Database Changes

1. Schema/migration first
2. Data access layer
3. Business logic
4. API endpoints
5. Client updates

### New Features

1. Research patterns
2. Data model
3. Backend logic
4. API layer
5. UI implementation

### Refactoring

1. Document current
2. Incremental changes
3. Maintain compatibility
4. Migration strategy

---

## Troubleshooting

### Issue: Agents not finding files

**Solution**: Be specific about directories and patterns in agent prompts

### Issue: Plan has open questions

**Solution**: Research more or ask user - never write with unknowns

### Issue: Tasks missing from plan

**Solution**: Re-read plan.md FULLY, extract every mentioned task

### Issue: Phases too large

**Solution**: Break into smaller increments with checkpoints

---

## Philosophy Deep Dive

### Why "Document, Don't Judge"?

Research should be **objective documentation** of the current system. Improvements come during planning, not research. This separation ensures:

- Clear understanding of current state
- Unbiased analysis
- Better planning decisions
- Reduced assumptions

### Why Barriers and Checkpoints?

Explicit synchronization prevents:

- Incomplete context
- Racing ahead
- Skipping verification
- Missing dependencies
- Cascading errors

### Why Dual Verification?

Automated checks catch technical issues.
Manual verification catches:

- UX problems
- Performance issues
- Edge cases
- Business logic errors
- Integration issues

### Why No Scope Creep?

Tasks ONLY from plan ensures:

- Predictable delivery
- Clear expectations
- Controlled changes
- Traceable work
- Measurable progress

---

## Credits

Inspired by enterprise context engineering patterns and refined through real-world usage. Incorporates learnings from HumanLayer's command architecture with adaptations for general use.

Commands leverage Claude Code's powerful agent system while maintaining strict behavioral boundaries through careful prompt engineering.

---

## Version

Current Version: 2.0.0

- Added comprehensive barriers and checkpoints
- Enhanced metadata tracking
- Strengthened agent directives
- Improved verification model
- Added progress tracking features
