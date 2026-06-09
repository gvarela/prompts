# create_execution — Examples

Read the relevant section in full when its step directs you here; match its structure exactly.

## Phase Milestone Creation Examples (Step 5c)

```bash
# Phase 1 - capture the ID from output
bd create "Phase 1 Milestone: [Phase Name]" \
  --type=task \
  --priority=2 \
  -d "All Phase 1 tasks complete. Objective: [phase objective]. See tasks.md Phase 1 for details."
# → Created prompts-xyz (save this as PHASE1_MILESTONE_ID)

# Phase 2 - capture the ID from output
bd create "Phase 2 Milestone: [Phase Name]" \
  --type=task \
  --priority=2 \
  -d "All Phase 2 tasks complete. Objective: [phase objective]. See tasks.md Phase 2 for details."
# → Created prompts-abc (save this as PHASE2_MILESTONE_ID)

# Set up dependency: Phase 2 milestone depends on Phase 1 milestone
bd dep add [PHASE2_MILESTONE_ID] [PHASE1_MILESTONE_ID]
```

## Task Creation Examples (Step 5d)

```bash
# Setup task example
bd create "Create new directory structure at path/to/new/" \
  --type=task \
  --priority=2 \
  -d "Phase 1 setup task. Create directory structure for new component."
# → Created prompts-def (save as TASK1_ID)

# Implementation task example
bd create "Create [Component] class at src/component.ts" \
  --type=task \
  --priority=2 \
  -d "Phase 1 implementation. Create component with constructor, method1 for [purpose], method2 for [purpose]."
# → Created prompts-ghi (save as TASK2_ID)

# Testing task example
bd create "Write unit tests for [Component] at tests/component.test.ts" \
  --type=task \
  --priority=2 \
  -d "Phase 1 testing. Test scenario 1, edge case X, error condition Y."
# → Created prompts-jkl (save as TASK3_ID)

# Integration task example
bd create "Connect [Component] to [ExistingSystem]" \
  --type=task \
  --priority=2 \
  -d "Phase 1 integration. Update API endpoint at api/routes.ts:78."
# → Created prompts-mno (save as TASK4_ID)
```
