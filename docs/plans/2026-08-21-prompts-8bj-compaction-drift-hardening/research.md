---
project: compaction-drift-hardening
ticket: prompts-8bj
created: 2026-08-21
created_timestamp: 2026-08-22T00:47:32Z
status: complete
last_updated: 2026-08-24
researcher: gabevarela
git_commit: 504129c290186f17b15089aa294102145a467ce6
git_branch: worktree-compaction-drift-hardening
repository: gvarela/workbench
tags: [research, codebase, compaction-drift-hardening]
---

# Research: Compaction Drift Hardening

**Created**: 2026-08-22 00:47 UTC
**Last Updated**: 2026-08-24
**Ticket**: prompts-8bj

## Research Question

How does the wb plugin currently handle context compaction, session recovery, doc-adherence enforcement, plan-doc status frontmatter, and coordinated-worker failure handling? (Baseline for hardening the plugin against the documentation drift observed in the fitness-agent session dfc788d7.)

## Summary

The plugin has no machinery on either side of a compaction boundary. Its hooks cover SessionStart (beads mode detection only), PostToolUse (markdown lint), and SessionEnd (beads drift reminder); there is no PreCompact hook and no SessionStart handling of the `compact` source. Skill instructions — including every ⛔ BARRIER and read-FULLY directive — exist only in the turn where a skill is invoked, and no skill or hook re-anchors the session on the active plan documents after a compaction. Doc re-reads happen at exactly two kinds of moments: skill invocation (BARRIER 1 in each workflow skill) and explicit resume paths (`implement_coordinated`/`implement_tasks` Resume Logic, `resume_handoff` Step 2).

Platform constraints (verified against current Claude Code hooks documentation): a PreCompact hook exists with `manual`/`auto` matchers but its stdout is NOT surfaced to the model and no `additionalContext`/custom-instruction field is honored — it cannot shape the compaction summary. SessionStart supports a `compact` matcher and is the one event whose plain-text stdout IS added as context visible to the model. Any post-compaction re-anchoring therefore must ride on SessionStart(compact).

Two adjacent findings: (1) worker-truncation handling was already fixed by commit 504129c (v2.2.1) — the retry-with-same-context playbook option is gone and tool-call-budget sizing guidance exists in `implement_coordinated` and `create_tasks` (issues prompts-wcn and prompts-nar closed against that commit). (2) The status/progress frontmatter fields (`current_phase`, `total_tasks`, `completed_tasks`, `status`) are emitted by templates, required by `validate_project`, and rewritten by `update_status` — while every skill that touches them declares beads the source of truth, so the same datum is recorded in two independently-updatable places.

## Detailed Findings

### Hook Infrastructure

**Location**: `plugin/.claude-plugin/plugin.json:16-61`, `plugin/hooks/`

**What exists**:

- `SessionStart` (no matcher) → `plugin/hooks/setup-beads-mode.sh`: writes `BEADS_MODE=stealth|git` to `$CLAUDE_ENV_FILE` based on whether `.beads/` is gitignored (`setup-beads-mode.sh:5-11`). Emits nothing to the model.
- `PostToolUse` on `Write` and `Edit` → `plugin/scripts/lint-hook` (markdown lint).
- `SessionEnd` → `plugin/hooks/beads-drift-check.sh`: one-line `systemMessage` reminder when `.beads/` has uncommitted changes in git mode (`beads-drift-check.sh:13-16`). Contract documented in the script header: <100ms, no `bd` invocations.
- No `PreCompact` entry. No `SessionStart` entry distinguishes the `compact` source. No hook mentions plan directories or doc re-reading.

### Platform Hook Semantics (Claude Code, verified 2026-08-24 against code.claude.com/docs/en/hooks.md)

- **PreCompact**: exists; matchers `manual` (user `/compact`) and `auto`. Input JSON carries the trigger. Honored outputs are limited to permission decision fields, `systemMessage`, and `continue` — hook stdout is not shown to the model and no field injects instructions into the compaction summary. Exit 2 blocks compaction.
- **SessionStart**: matchers `startup`, `resume`, `clear`, `compact`, `fork` (matcher string in the plugin hooks block filters which entries run; the script also receives the source in input JSON). Plain-text stdout is added as context visible to the model — the documented exception among hook events. SessionStart cannot block.
- Consequence for this project: summary-shaping via PreCompact is not possible; post-compaction context injection via SessionStart(compact) stdout is.

### Coordinated Execution and Failure Handling

**Location**: `plugin/skills/implement_coordinated/` (SKILL.md, reference.md, sub-agent-prompts.md, templates.md, README.md), `plugin/agents/task-worker.md`

**What exists**:

- Coordinator reads research.md, design.md, tasks.md FULLY once per invocation behind `⛔⛔⛔ BARRIER 1` (`SKILL.md:75-118`), extracts a per-task `contextPackage` (`reference.md:5-53`), and spawns one sequential `task-worker` per beads task (`SKILL.md:175-192`; "NEVER spawn multiple workers in parallel" `SKILL.md:424`; "NEVER pass entire docs to workers" `SKILL.md:426`).
- Barriers: BARRIER 1 (`SKILL.md:77`), BARRIER 2 before `bd ready` (`:160`), BARRIER 3 per-worker verify (`:196`), BARRIER 4 phase aggregation (`:258`), ⛔ CHECKPOINT human gate (`:277`).
- Delegation sizing (added by 504129c): coordinator projects worker tool-call cost; "A task projecting past ~50 calls: split it at its natural seam before spawning" (`SKILL.md:181`). Same guidance in `create_tasks/SKILL.md:387`.
- Unfinished-worker triage (`SKILL.md:254` → `reference.md:59-99`): Case A truncation (budget exhaustion near ~70 calls; finish the tail, "Never retry the whole task" `reference.md:76`) vs Case B genuine failure (user options: retry with additional context, mark blocked, manual intervention `reference.md:93-96`). Verification failures are separate: implementation defect → up to 2 opus fix-worker retries (`SKILL.md:234-239`, `sub-agent-prompts.md:109-125`); plan defect → Plan-Defect Deviation Protocol, never fix workers (`reference.md:101-125`).
- Worker contract: `bd close` is the final action; errors leave the task `in_progress` with a report (`task-worker.md:33`); `maxTurns: 60` (`task-worker.md:6`).
- Ceiling measurement: `docs/subagent-tool-call-ceiling.md` (maintainer-only): 129 transcripts, max observed 70 calls, confirmed truncations at 69-70, highest success 67, median 27; context exhaustion ruled out; guidance written around the symptom, 70 cited as measured evidence not a constant (`:138-147`).
- Compaction appears only as rationale, never as a handled event: `SKILL.md:15` ("Recommended for … sessions where context compaction would be disruptive"), `README.md:24,35`, `templates.md:45,56`. Mid-execution doc re-reads exist only in Resume Logic (`SKILL.md:380-407`: re-read tasks.md Implementation Notes, research.md, design.md when `phase="continue"`); `implement_tasks/SKILL.md:439-442` has identical resume wording.

### Handoff Machinery

**Location**: `plugin/skills/create_handoff/`, `plugin/skills/resume_handoff/`

**What exists**:

- `create_handoff` gathers docs + conversation history + beads queries behind BARRIER 1 (`SKILL.md:49-92`), commits beads state in git mode (`:127-132`), writes `[project-dir]/handoff-YYYY-MM-DD-HH-MM.md` from `templates.md` with frontmatter `project`, `phase`, `beads_epic`, `beads_active_phase`, git metadata (`templates.md:8-20`). "When to Create Handoffs" (`SKILL.md:227-235`): session ending incomplete, model switch, blocked, milestone, discoveries.
- `resume_handoff` Step 1 reads the handoff COMPLETELY behind BARRIER 1 (`SKILL.md:49-98`, includes git commit comparison and beads reconciliation). Step 2 (`SKILL.md:102-129`) mandates reading research.md, design.md, tasks.md from the handoff's project directory — as sequenced prose, without its own ⛔ BARRIER marker. Stale-handoff handling at `SKILL.md:276-307`.
- The active plan directory has no independent lookup mechanism anywhere: it is whatever path the handoff document names; the path convention is `docs/plans/<YYYY-MM-DD>-<project>/` (`create_handoff/SKILL.md:30,39`; `project-structure/SKILL.md:3`). No frontmatter field names the plan directory explicitly.
- Neither handoff skill mentions `/compact` (repo-wide grep: zero matches in both files). No skill text anywhere chooses between handoff, same-session continuation, and `/compact`.

### Auto-Activated (Background) Skill Conventions

**Location**: `plugin/skills/verification-before-completion/`, `tdd-discipline/`, `status-sync/`, `project-structure/`

**What exists**:

- Frontmatter: `name` (kebab-case), `description` starting "Use when [behavioral moment] - [behavior]" (or "Enforces …" for structural skills), `user-invocable: false` (all four at SKILL.md:3-5); optional `allowed-tools` (`status-sync/SKILL.md:4`: `Read, Glob, Grep, Bash(bd:*)`).
- Body: H1 title, 1-2 sentence principle paragraph, an ALL-CAPS core rule in a code block ("Iron Law" pattern: `verification-before-completion/SKILL.md:13-16`, `tdd-discipline/SKILL.md:13-20`), H2 concept sections, comparison tables (Claim/Requirement `verification-before-completion/SKILL.md:35-41`; Excuse/Reality `tdd-discipline/SKILL.md:61-68`), a "## Red Flags - STOP" section (`verification-before-completion/SKILL.md:54`, `tdd-discipline/SKILL.md:70`), 60-200 lines, imperative voice.
- Existing adherence-adjacent content: "never paraphrase from memory" directive for supporting files (`create_tasks/SKILL.md:21`, `update_status/SKILL.md:13`, `implement_coordinated/SKILL.md:17`, `validate_execution/SKILL.md:15`, and others); fresh-verification rule "If you haven't run the verification command in this response, you cannot claim it passes" (`verification-before-completion/SKILL.md:19,52`). No skill covers resuming after compaction or citing plan docs from a current-context read.

### Status/Progress Frontmatter Ownership

**Location**: `CLAUDE.md:131-156`, template files under `plugin/skills/create_*/templates.md`, `plugin/skills/update_status/`, `plugin/skills/validate_project/`

**What exists**:

- Standard: `CLAUDE.md:149-156` defines Progress fields `current_phase`, `total_tasks`, `completed_tasks`; `CLAUDE.md:131-136` states "Beads for STATUS, Markdown for PLAN". AGENTS.md does not carry the standard.
- Emitters: `create_project/templates.md` tasks.md stub (`current_phase: 0`, `total_tasks: 4`, `completed_tasks: 1` at lines 237-239 — planning-checklist placeholders); `create_tasks/templates.md:12-16` (`status`, `last_updated`, `current_phase: 1`, `total_tasks: [calculated]`, `completed_tasks: 0`) plus an inline instruction to bump `current_phase: 2` at a Phase-1 checkpoint (`:175`); research/design templates carry `status`/`last_updated` only.
- Writers: `update_status` is the dedicated reconciler — computes actuals from beads ("Beads is the ONLY source of truth", `SKILL.md:113`), proposes a diff behind a user-confirmation barrier (`:161-201`), writes `status`/`last_updated`/`git_*` on research/design and additionally `current_phase`/`completed_tasks` plus the Progress Overview table on tasks.md (`update_status/templates.md:9-46`), then verifies all files share `last_updated` (`SKILL.md:216-230`). `implement_tasks/SKILL.md:361-379` and `implement_coordinated/SKILL.md:347-378` say "Optionally update tasks.md frontmatter (for human reference)" at phase end — with the explicit per-task prohibition "❌ Update frontmatter counts manually (beads is source of truth)" (`implement_tasks/SKILL.md:271`). `status-sync` never touches frontmatter ("Update files directly" is on its DO-NOT list, `SKILL.md:58`). `create_research/SKILL.md:171-173` updates `last_updated`/`last_updated_note` on follow-up research.
- Validator: `validate_project/reference.md:24-28` REQUIRES `current_phase`, `total_tasks`, `completed_tasks` (and `beads_epic`/`beads_phases`/`beads_tasks`) in tasks.md frontmatter; `reference.md:41-67` enforces status-value enums and cross-file progression; `reference.md:156-164` points fixes back to `/wb:update_status`.
- Duplication map (same datum in two systems): `current_phase` ↔ beads phase-milestone state; `completed_tasks`/`total_tasks` ↔ counts over `beads_tasks` issues (`update_status/SKILL.md:124-130` computes them from `bd list`); tasks.md `status` ↔ aggregate beads issue state (`update_status/SKILL.md:287-297`).

### Observed Failure Evidence (fitness-agent session dfc788d7, Jul 29 - Aug 22 2026)

Transcript: `~/.claude/projects/-Users-gabevarela-Development-Personal-fitness-agent/dfc788d7-*.jsonl` (8578 lines, 5 compact boundaries at lines 1241/2986/3840/5509/7788, 6 manual `/compact` commands, full wb pipeline in one session).

- Post-compaction state assertions from summaries: proposed re-capturing RLGL data already pulled Jul 30 (~line 6051); proposed re-ingesting already-ingested intervals.icu data (~line 6675); argued against the project's validated TR-import conclusion (~lines 6688-6714). Each corrected only after user pushback.
- Barrier degradation between invocations: first post-compaction `/wb:implement_coordinated` re-read all three docs (lines 3027/3037/3047); the invocation after the Aug 3 double compaction re-read only tasks.md (line 5552) — design.md next read 16 days later (line 7837).
- Doc rot: tasks.md found 12 tasks stale on Aug 19 (frontmatter 24/14 vs reality 26/26, Phase 2 retired), surfaced only when the user asked.
- Task written against a guessed, nonexistent column name, caught only when the user asked "have you validated the plan?" (~line 6775).

## Architecture Documentation

**Current patterns found**:

- Barrier pattern: ⛔ markers gate context acquisition at skill-invocation time only — `implement_coordinated/SKILL.md:77`, `create_tasks/SKILL.md:55`, `create_design/SKILL.md:68`, `explore_design/SKILL.md:120`, `validate_project/SKILL.md:116`.
- Context-recovery-by-hook precedent: beads' `bd prime` re-injects workflow context via SessionStart hook (repo-level beads integration, not the wb plugin); wb's own SessionStart hook emits only an env var.
- Hook output contract precedent: `beads-drift-check.sh` header documents a <100ms/no-`bd` budget and JSON `systemMessage` output.

**Component connections**:

- plugin.json `hooks` block → `plugin/hooks/*.sh` (SessionStart/SessionEnd) and `plugin/scripts/lint-hook` (PostToolUse).
- Workflow skills → plan dir docs (`docs/plans/<date>-<project>/{research,design,tasks}.md`) → beads IDs in tasks.md frontmatter (`beads_epic`/`beads_phases`/`beads_tasks`) → `bd` state.
- `validate_project` ← frontmatter standard ← `create_*/templates.md` emitters; `update_status` is the sanctioned writer.

**Conventions observed**:

- Skills live at `plugin/skills/<name>/SKILL.md` with supporting `templates.md`/`reference.md`/`sub-agent-prompts.md`; background skills use `user-invocable: false` with "Use when …" trigger descriptions.
- Releasing requires version bumps in `plugin/.claude-plugin/plugin.json` AND `.claude-plugin/marketplace.json` (currently both 2.2.1) per CLAUDE.md release protocol.

## Code References

- `plugin/.claude-plugin/plugin.json:16-61` - complete hook registration (no PreCompact, no compact matcher)
- `plugin/hooks/setup-beads-mode.sh:5-11` - SessionStart env-var-only behavior
- `plugin/hooks/beads-drift-check.sh:1-17` - SessionEnd reminder + hook-budget contract
- `plugin/skills/implement_coordinated/SKILL.md:75-118,181,254,380-407` - BARRIER 1, sizing, unfinished-worker triage, resume logic
- `plugin/skills/implement_coordinated/reference.md:59-99` - truncation/genuine-failure playbook
- `plugin/agents/task-worker.md:6,33` - maxTurns 60, close-as-final-action contract
- `plugin/skills/resume_handoff/SKILL.md:102-129` - mandated doc re-read on resume (no barrier marker)
- `plugin/skills/create_handoff/SKILL.md:227-235` - handoff triggers (no compact mention)
- `plugin/skills/verification-before-completion/SKILL.md:13-19,52,54` - Iron Law, fresh-verification, Red Flags patterns
- `plugin/skills/update_status/SKILL.md:113,161-230,287-297` - beads-derived reconciliation flow
- `plugin/skills/validate_project/reference.md:24-28,41-67` - required frontmatter fields incl. progress counts
- `plugin/skills/create_tasks/templates.md:12-16,175` - progress-field emission + manual current_phase bump
- `CLAUDE.md:131-156` - Beads-for-STATUS philosophy and frontmatter standard
- `docs/subagent-tool-call-ceiling.md` - ceiling measurement (maintainer doc)

## Similar Implementations

**bd prime recovery pattern** (beads integration, visible in session-start hook output): full workflow context re-injected at SessionStart with the explicit note "Run `bd prime` after compaction, clear, or new session". This is the in-repo precedent for hook-driven context recovery that the wb plugin itself lacks.

**Fresh-verification rule** (`plugin/skills/verification-before-completion/SKILL.md:19`): "If you haven't run the verification command in this response, you cannot claim it passes" — the same shape as a cite-or-re-read rule for doc contents ("if you haven't read the doc in the current context window, you cannot assert what it says").

**"Never paraphrase from memory"** (`implement_coordinated/SKILL.md:17` et al.): existing wording applied to skill supporting files, not yet to plan documents across a compaction boundary.

## Open Questions

Questions that require resolution before proceeding are tracked in beads, NOT in this document.

**Active questions**: none blocking design. All platform facts needed (PreCompact/SessionStart semantics) were verified against current Claude Code documentation on 2026-08-24.

## Next Steps

1. Note for design: the epic's child prompts-8bj.1 (PreCompact summary-shaping) is infeasible as filed — PreCompact cannot inject instructions into the summary; its intent must fold into the SessionStart(compact) recovery hook (prompts-8bj.2).
2. Review the research document.
3. Run `/create_design` to create design decisions.
