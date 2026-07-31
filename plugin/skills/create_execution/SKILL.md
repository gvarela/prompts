---
name: create_execution
description: Deprecated alias of create_tasks — use /wb:create_tasks (removed at 3.0.0)
argument-hint: [project-directory]
disable-model-invocation: true
allowed-tools: Read
---

# Create Execution Plan (Deprecated Alias)

This command was renamed to `/wb:create_tasks`: the `create_*` family names its artifact (create_research → research.md, create_design → design.md), and this skill writes `tasks.md` — it also pairs naturally with `/wb:implement_tasks`. The alias remains through 2.x and is removed at 3.0.0.

## Behavior

1. **Tell the user once, up front**:

   ```
   Note: /wb:create_execution is now /wb:create_tasks — same skill, new name.
   This alias works through 2.x and will be removed at 3.0.0.
   ```

2. **Then run the canonical skill**: Read [../create_tasks/SKILL.md](../create_tasks/SKILL.md) NOW and follow it exactly, passing through any arguments unchanged. Its supporting files (sub-agent-prompts.md, templates.md, examples.md) live in `../create_tasks/` — resolve every "read X NOW" directive there.

Do not duplicate any behavior here; the canonical skill is the single source of truth.
