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
/create_project → /create_research → /create_plan → /create_tasks
     ↓                   ↓                ↓              ↓
[Structure]        [Research.md]      [Plan.md]     [Tasks.md]
                        ↓                ↓              ↓
                   [What EXISTS]    [What to BUILD]  [How to DO IT]
```

### Workflow Stages

1. **Initialize**: Create project structure with metadata
2. **Research**: Document codebase as it EXISTS today
3. **Plan**: Design implementation through discussion
4. **Tasks**: Extract actionable items with barriers
5. **Execute**: Implement with verification checkpoints

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
├── plan.md       # Implementation plan (with metadata)
└── tasks.md      # Task tracking (with initial tasks)
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

### `/create_plan` - Create Implementation Plan

Creates detailed implementation plan through interactive discussion.

**Usage**:

```bash
/create_plan docs/plans/2025-10-07-my-feature
```

**Interactive Process**:

1. **Reads research** and spawns analysis agents
2. **Confirms understanding** with discovered context
3. **Asks focused questions** only about unknowns
4. **Proposes structure** before writing
5. **Writes detailed plan** after approval

**Plan Structure**:

- Current state analysis (from research)
- Desired end state (measurable)
- **What We're NOT Doing** (scope protection)
- Phased implementation
- **Dual verification**:
  - Automated checks (CI/CD)
  - Manual verification (human)
- **⛔ CHECKPOINTS** between phases

**Critical Rules**:

- NO open questions in final plan
- Every decision made before writing
- Success criteria MUST be measurable
- Phases require verification to proceed

---

### `/create_tasks` - Generate Task List

Extracts ALL tasks from plan into trackable format.

**Usage**:

```bash
/create_tasks docs/plans/2025-10-07-my-feature
```

**Task Extraction**:

- Every "Changes Required" → Implementation task
- Every "Success Criteria" → Verification task
- Every test mentioned → Testing task
- Every command preserved exactly
- Every file:line reference maintained

**Creates**: Rich tasks.md with:

```markdown
## Progress Overview
| Phase | Status | Tasks | Progress |
|-------|--------|-------|----------|
| Phase 1 | 🔄 In Progress | 5/12 | 42% |

### ⛔ CHECKPOINT: Phase 1 Complete
Before proceeding to Phase 2:
1. ✅ All implementation tasks complete
2. ✅ All automated checks passing
3. ✅ Manual verification by human
4. ✅ Update status in frontmatter
```

**Features**:

- Progress tracking tables
- Blocker management system
- Decision log
- Completed task archive
- Quick reference section
- Daily workflow guidance

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

#### 3. Plan Implementation

```bash
/create_plan docs/projects/2025-10-07-LINEAR-789-add-auth-middleware
```

Interactive discussion → Phased plan with checkpoints.

#### 4. Generate Tasks

```bash
/create_tasks docs/projects/2025-10-07-LINEAR-789-add-auth-middleware
```

Extracts every task from plan, organizes by phase.

#### 5. Execute with Tracking

Work through tasks.md:

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
