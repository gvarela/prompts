# Explore Design Stage

**Created**: 2026-07-10
**Ticket**: N/A
**Status**: Planning

## Overview

This directory contains documentation for explore-design-stage — a new discrete architecture-discussion stage (the workflow's "Innovate" mode) between `create_research` and `create_design`, incorporating RIPER-derived rules: possibilities-not-decisions output, per-stage contamination lists, and a plan-defect escape hatch for execution.

## Documentation Structure

- **[research.md](research.md)** - Codebase research and findings
- **[design.md](design.md)** - Architectural design decisions
- **[tasks.md](tasks.md)** - Execution plan and task tracking

## Workflow

1. ✅ Project structure created
2. ⏳ Research phase (`/create_research [directory]`)
3. ⏳ Design phase (`/create_design [directory]`)
4. ⏳ Execution planning (`/create_execution [directory]`)
5. ⏳ Implementation (`/implement_tasks [directory]`)
6. ⏳ Testing & Verification

## Quick Commands

```bash
# Continue with research (analyzes codebase)
/create_research docs/plans/2026-07-10-explore-design-stage

# Create design decisions
/create_design docs/plans/2026-07-10-explore-design-stage

# Generate execution plan with tasks
/create_execution docs/plans/2026-07-10-explore-design-stage

# Implement tasks with TDD
/implement_tasks docs/plans/2026-07-10-explore-design-stage

# Update status across all files
/update_status docs/plans/2026-07-10-explore-design-stage
```

## Git Information

- **Branch**: modernize-2.0
- **Commit**: 0c1250840dbce9ab373a6d718a2600e4489539f9
- **Repository**: gvarela/workbench
