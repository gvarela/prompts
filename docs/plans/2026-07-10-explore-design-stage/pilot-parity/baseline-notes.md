# create_design Parity Baseline (pre-Phase-2 edits)

Captured per the pilot-parity method (docs/plans/2026-06-09-prompt-modernization/tasks.md:218-256)
before any Phase 2 edit to `plugin/skills/create_design/SKILL.md`.

**Git ref**: `9f48fa0` (Add explore_design skill: optional architecture-discussion stage (Phase 1))
**Captured**: 2026-07-28
**Beads task**: prompts-0wl

## Baseline artifacts

- `step4-baseline-pre-edit.txt` — verbatim extract of Step 4 "Solution Exploration"
  (`plugin/skills/create_design/SKILL.md:133-166` at the ref above). The Phase 2 gate
  (prompts-64j) diffs the post-edit no-record branch against this file — it must be
  byte-identical.

## No-record dry-run structure (fast-path reference)

A `/wb:create_design` run on a project with NO closed `Decide:` record flows:

1. Initial Response — argument parsing (directory or prompt)
2. Prerequisites — research.md complete; `bd list -n 0 --status=open | grep "Q:"` for blockers
3. Step 1 / BARRIER 1 — read research.md + existing design.md fully
4. Step 2 / BARRIER 2 — spawn 3 read-only verification agents (patterns, integration, risks); wait for all
5. Step 3 — problem definition
6. Step 4 — generate 2–3 options (Option A/B format) → trade-off discussion → explicit approach approval (DECISION POINT)
7. Step 5 / BARRIER 3 — write design.md from templates.md; no placeholders
8. Step 6 — present, iterate, explicit APPROVAL GATE

Synchronization Points list has exactly five entries (`SKILL.md:296-302`).

The fast-path guarantee for Phase 2: every element above is unchanged when no decision
record exists — the only additions visible in the file are the conditional branch text
itself, which a no-record run passes through without behavioral effect.
