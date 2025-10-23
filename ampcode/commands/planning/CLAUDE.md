# CLAUDE.md - Commands Directory

This file provides specific guidance for working with the documentation commands in this directory.

## Overview

This directory contains Claude Code slash commands for project documentation, research, planning, and task tracking. The commands implement enterprise-grade context engineering patterns with explicit barriers, verification gates, and structured workflows.

## Command Workflow

The commands follow a strict sequential workflow:

```
/create_project → /create_research → /create_design → /create_execution → /implement_tasks
```

Each command builds upon the previous one's output, creating structured documentation in timestamped directories under `docs/plans/`.

## Core Command Philosophy

### Critical Principles

1. **Document, Don't Judge**: Research describes what EXISTS, not what should be changed
2. **Explicit Barriers**: Commands implement synchronization points (⛔ BARRIER) to ensure complete context
3. **File Reading Protocol**: ALWAYS read files FULLY (no limit/offset) before analysis
4. **Dual Verification**: Separate automated checks from manual verification
5. **Zero Scope Creep**: Tasks only come from plans, no additions

### Command Structure

Each command file contains:

- Initial setup prompts
- Step-by-step execution with barriers
- Agent instructions for parallel research
- Output templates with YAML frontmatter
- Synchronization points and checkpoints

### Critical Implementation Patterns

When modifying commands, maintain these patterns:

```markdown
⛔ BARRIER 1: After file reading - full context required
⛔ BARRIER 2: After agent spawning - wait for ALL
⛔ BARRIER 3: Before writing - no placeholders allowed
⛔ CHECKPOINT: Between phases - human verification required
```

Agent instructions must include:

```
You are documenting the codebase as it exists.
DO NOT suggest improvements or identify issues.
Document what IS, not what SHOULD BE.
```

### Frontmatter Standards

All generated documentation files use consistent YAML frontmatter:

- Basic: `project`, `ticket`, `created`, `status`, `last_updated`
- Git metadata: `git_commit`, `git_branch`, `repository`
- User tracking: `researcher`, `planner`, `assignee`
- Progress: `current_phase`, `total_tasks`, `completed_tasks`

## Working with These Commands

When modifying or creating new documentation commands:

1. Follow the existing command patterns
2. Include all three barriers and checkpoints
3. Use "think deeply" directives at critical decision points
4. Maintain the documentarian philosophy for research
5. Separate automated from manual verification
6. Always read files FULLY before processing
7. Use parallel agents for efficiency but wait for ALL to complete

## Status Progression

Files created by commands progress through defined states:

- `research.md`: draft → in-progress → complete → validated
- `design.md`: draft → in-review → approved
- `tasks.md`: not-started → in-progress → complete

## Command Descriptions

### `/create_project`

Initializes project documentation structure with metadata tracking.

### `/create_research`

Conducts comprehensive research using parallel agents, documenting what EXISTS without judgment. No recommendations or improvements.

### `/create_design`

Makes architectural and design decisions based on validated research. Interactive process with explicit approach selection.

### `/create_execution`

Creates detailed execution plan with embedded tasks, phases, and verification criteria. Replaces the old create_tasks command.

### `/implement_tasks`

Executes the tasks from the execution plan following TDD practices. Respects phase boundaries and checkpoints.

### `/update_status`

Intelligently updates status across all documentation files based on actual progress. Ensures consistency and validates state transitions.

## Testing Commands

When testing changes to commands:

1. Create a test project with `/create_project test-feature`
2. Run through the full workflow
3. Verify all barriers and checkpoints work correctly
4. Check that frontmatter is properly populated
5. Ensure status progression works as expected
