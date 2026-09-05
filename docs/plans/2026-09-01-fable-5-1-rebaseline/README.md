# fable-5-1-rebaseline

**Created**: 2026-09-01
**Ticket**: prompts-678
**Status**: Complete 2026-09-05 — shipped as v2.4.0 (Phase 1, PR #20) and v2.5.0 (Phase 2 + cut, PRs #21, #22)

## Overview

Re-baseline the wb plugin against the Claude 5 model family, with Claude Fable 5.1 as the new top tier. Two parts:

1. **Additive re-baselining** — guidance the new model needs that the skills do not carry today (surgical edits, follow-ups instead of fixes, a memory surface, autonomy for background runs), plus routing Fable into the two places it pays for itself (escalation after verified failure, the create_tasks decomposition stage).
2. **Evidence-gated trims** — the successor to prompt-modernization Phase 4, which was deferred in June pending the eval harness. Fable 5.1's published behavior notes supply new evidence, and the blind-trial method replaces the harness as the gate.

## Documentation Structure

- **[research.md](research.md)** — What exists: current model map, pricing, documented Fable 5.1 behaviors, Sonnet 5 effort curves, scaffolding inventory, prior-project dispositions
- **[design.md](design.md)** — Decisions and rationale
- **[tasks.md](tasks.md)** — Phased execution plan
- **[thoughts/](thoughts/)** — The session analysis that seeded this plan (effort-curve reading, Fable routing argument)

## Related

- [../2026-06-09-prompt-modernization/](../2026-06-09-prompt-modernization/) — Phase 4 trims (R1, R3, R4) deferred to this project
- [../2026-06-10-wb-eval-harness/](../2026-06-10-wb-eval-harness/) — Still at research-needed; this plan does not wait on it
- [../2026-07-10-explore-design-stage/thoughts/2026-07-10-model-strategy-and-riper-prework.md](../2026-07-10-explore-design-stage/thoughts/2026-07-10-model-strategy-and-riper-prework.md) — The July model-strategy decision this plan revises

## Quick Commands

```bash
/wb:implement_tasks docs/plans/2026-09-01-fable-5-1-rebaseline/
/wb:validate_execution docs/plans/2026-09-01-fable-5-1-rebaseline/
/wb:update_status docs/plans/2026-09-01-fable-5-1-rebaseline/
```

## Git Information

- **Branch**: dev (worktree `workbench-modernize-2.0`) — behind `origin` (v2.3.0); implementation branches from `origin/main`
- **Commit**: cf86f75 (all `file:line` references in this project are at this commit)
- **Repository**: gvarela/workbench
