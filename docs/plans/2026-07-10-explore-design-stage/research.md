---
project: explore-design-stage
ticket: null
created: 2026-07-10
created_timestamp: 2026-07-10T22:13:38Z
status: complete
last_updated: 2026-07-10
researcher: gabevarela
git_commit: 0c1250840dbce9ab373a6d718a2600e4489539f9
git_branch: modernize-2.0
repository: gvarela/workbench
tags: [research, codebase, explore-design-stage, skills]
---

# Research: Explore Design Stage

**Created**: 2026-07-10 22:13 UTC
**Last Updated**: 2026-07-10
**Ticket**: N/A

## Research Question

Document all wb plugin skills as they exist on the modernize-2.0 branch — their anatomy, orchestration loops, inter-stage hand-offs, and the cross-cutting mechanisms identified as relevant in the pre-work ([thoughts/2026-07-10-model-strategy-and-riper-prework.md](thoughts/2026-07-10-model-strategy-and-riper-prework.md)) — with references to implementation, as the factual basis for designing a new discrete design/architecture-discussion stage.

## Summary

The plugin contains 21 skills (50 files) under `plugin/skills/`, split into two invocation classes on a single mechanism: 13 user-only workflow steps carrying `disable-model-invocation: true` (the `/wb:*` commands), and background/discipline skills carrying `user-invocable: false` (tdd-discipline, verification-before-completion, project-structure, status-sync) or default invocation (research-validation, mockup-iteration, review-prep, help). All twelve workflow-stage skills share an identical skeleton — Initial Response (argument parsing), numbered Process Steps punctuated by ⛔ BARRIER / ⛔ CHECKPOINT gates, Important Notes, Error Handling — with supporting files (`sub-agent-prompts.md`, `templates.md`, `examples.md`, `reference.md`) loaded on demand via "Read X NOW" directives. Stages hand off through frontmatter-tracked artifacts (`research.md` → `design.md` → `tasks.md`, chained by `depends_on` and `status` fields) while beads carries live work state ("Beads for STATUS, Markdown for PLAN", CLAUDE.md:131-136).

Two findings materially sharpen the pre-work's picture of the design stage. First, `create_design` already contains a decision point: Step 4 presents 2–3 design options and requires explicit user approval of the chosen approach (`create_design/SKILL.md:166`), followed by a final approval gate (`:218`), and the selected option is recorded in design.md frontmatter as `design_approach` (`create_design/templates.md:8-16`). What does not exist is any *research-informed drafting* of those options (the three spawned agents verify patterns/integration/risks; no agent drafts alternatives), any durable artifact of the exploration, or any stage-level separation between deciding and documenting. Second, `bd decision` is used nowhere — decisions are tracked as ordinary issues with a `Decide:` title prefix (`create_design/templates.md:120-124`), one of four documented planning-phase prefixes (`Q:`, `Decide:`, `Validate:`, `UI Q:` — `help/SKILL.md:66-77`).

On mechanisms: skill and agent frontmatter accepts `model: haiku|sonnet|opus|fable|<full-id>|inherit` and `effort: low|medium|high|xhigh|max` (docs/claude-code-skills-guide.md:83-84, :198), with per-invocation overrides beating frontmatter (`:221`). `fable` appears only in that enum — no skill or agent uses it today (verification tracked as beads `prompts-7mj`). The precedent for an optional pipeline stage exists: `create_product_research` runs standalone or in-pipeline and writes its own artifact (`product-research.md`) with independent status and `validation_status` fields, without disturbing the research→design chain (`create_product_research/SKILL.md:61-67`, `templates.md:8-15`).

## Detailed Findings

### Skill System Layout and Inventory

**Location**: `plugin/skills/` (21 skills, 50 files), `plugin/agents/` (7 agents), `plugin/.claude-plugin/plugin.json` (manifest + hooks), `plugin/docs/reference/` (shared reference docs), `plugin/scripts/` (lint, lint-hook).

**What exists** — supporting-file tiers:

| Tier | Files | Skills |
| ------ | ------- | -------- |
| Full | SKILL.md + sub-agent-prompts.md + templates.md + reference.md + README.md | implement_coordinated |
| Extended | SKILL.md + sub-agent-prompts.md + templates.md + examples.md | create_execution |
| Standard w/ agents | SKILL.md + sub-agent-prompts.md + templates.md | create_research, create_product_research, create_design, create_mockup, validate_execution |
| Templates + reference | SKILL.md + templates.md + reference.md | resume_handoff, update_status, validate_project |
| Templates + examples | SKILL.md + templates.md + examples.md | mockup-iteration |
| Basic | SKILL.md + templates.md | create_project, create_handoff, implement_tasks |
| Script-bearing | SKILL.md + nvim-helper.sh | review-prep |
| Single-file | SKILL.md only | help, project-structure, research-validation, status-sync, tdd-discipline, verification-before-completion |

Only 5 of 21 skills spawn subagents (those with sub-agent-prompts.md); 18 of 21 have templates.md.

### Workflow-Stage Skill Anatomy

**Location**: `plugin/skills/<name>/SKILL.md`

**What exists**: All twelve stage skills share frontmatter shape `name`, `description`, `argument-hint`, `disable-model-invocation: true`, `allowed-tools: Read` (e.g. `create_project/SKILL.md:1-7`, `create_design/SKILL.md:1-7`). `validate_execution/SKILL.md:7-8` is the only stage skill adding `model: sonnet` and `effort: high`. None declares a `skills:` preload field.

**How it works**:

1. **Initial Response** — positional args `$1`/`$2`/`$3` with defaults; prompt for missing (`create_project/SKILL.md:40-49`, `create_execution/SKILL.md:49-56`).
2. **Process Steps** — numbered, gated by barriers (below).
3. **Supporting files loaded on demand** — "Read [file] NOW", "never paraphrase from memory", "match its structure exactly" (`create_project/SKILL.md:13`, create_research SKILL.md supporting-files header).
4. **Important Notes / Error Handling** close each skill; three skills (resume_handoff, update_status, validate_project) externalize error catalogs to `reference.md` (e.g. `resume_handoff/reference.md:5-46`, `update_status/reference.md:1-56`).

### Synchronization Gates by Skill

**What exists** (barrier/checkpoint/approval-gate inventory):

- `create_project`: BARRIER 1 after file creation (`SKILL.md:105`). No approval gate.
- `create_research`: BARRIER 1 file reads (`:60`), BARRIER 2 agent completion (`:133`), BARRIER 3 no-placeholders (`:154`). No approval gate.
- `create_product_research`: four barriers (`:78`, `:166`, `:210`, `:228`) — the fourth follows a post-write validation agent.
- `create_design`: five gates listed at `SKILL.md:296-302` — BARRIER 1 (`:68`), BARRIER 2 (`:110`), **DECISION POINT** (`:166` "Get explicit approval on the chosen approach before proceeding"), BARRIER 3 (`:174`), **APPROVAL GATE** (`:218` "Once you're satisfied with the design, please confirm approval").
- `create_execution`: BARRIER 1 (`:47`), BARRIER 2 (`:89`), BARRIER 3 (`:118`); the generated tasks.md embeds `⛔ CHECKPOINT: Phase N Complete... Do not proceed without human confirmation of manual tests` (`create_execution/templates.md:168-179`).
- `create_mockup`: five barriers (`:50`, `:62`, `:122`, `:130`, `:161` — the last a Playwright visual validation) plus two explicit waits for user input (`:98` clarifying questions, `:195` feedback).
- `implement_tasks`: BARRIER 1 (`:87`), BARRIER 2 (`:291`), `⛔ CHECKPOINT: Phase [N] Complete` with "Requirement: Wait for user confirmation before proceeding" on manual verification (`:311-355`, `:346`).
- `implement_coordinated`: BARRIER 1 (`:77`), BARRIER 2 ready-tasks (`:160`), BARRIER 3 per-task verification (`:193`), BARRIER 4 phase aggregation (`:249`), same human phase checkpoint (`:268-323`).
- `validate_execution`: BARRIER 1 (`:54`), BARRIER 2 (`:90`), BARRIER 3 requires every automated verification command actually run in-session before the report (`:141`).
- `update_status`: BARRIER 1 (`:49`), explicit yes/no approval gate (`:196`), BARRIER 2 wait-for-confirmation (`:201`), BARRIER 3 verify-applied (`:218`).
- `create_handoff` / `resume_handoff`: single BARRIER 1 each (`:49` in both); resume_handoff adds stale-handoff detection (`:276-307`).

### Inter-Stage Data Flow

**What exists**:

- `create_project` seeds four files; research/design start `status: draft`, tasks `status: not-started`; design.md carries `depends_on: research.md` (`create_project/templates.md:67`, `:145`, `:152`, `:230`).
- `create_research` checks existing research.md status (`create_research/SKILL.md:66-68`), rewrites it `status: complete` (`create_research/templates.md:12`).
- `create_design` gates on open blocking questions via `bd list -n 0 --status=open | grep "Q:"` (`create_design/SKILL.md:59`), reads research.md and design.md fully (`:70-93`), writes design.md with `status: draft`, `depends_on: research.md`, and `design_approach: [selected option name]` (`create_design/templates.md:8-16`).
- `create_execution` reads all three docs (`create_execution/SKILL.md:47-77`), writes tasks.md with `depends_on: [research.md, design.md]` plus beads anchors `beads_epic`, `beads_phases`, `beads_tasks` (`create_execution/templates.md:8-18`, `:265-286`).
- `implement_tasks`/`implement_coordinated` read all docs at BARRIER 1 and require the beads frontmatter anchors (`implement_tasks/SKILL.md:145-149`, `implement_coordinated/SKILL.md:136-150`); markdown checkboxes are explicitly not used for status (`implement_tasks/SKILL.md:268-271`, `:555-569`); implement_coordinated stamps `execution_mode: coordinated` (`:350-357`).
- `update_status` owns cross-file status transitions — research draft→in-progress→complete; design draft→ready→implementing→complete; tasks not-started→in-progress→complete (`update_status/SKILL.md:136-159`, triggers `:260-297`) — with invalid-transition rules (e.g. design can't be `implementing` while research is `draft`, `update_status/reference.md:1-56`).
- `create_product_research` writes a separate `product-research.md` (`status: complete`, `audience: product`, `validation_status: not-yet-run→passed|passed_with_warnings`) and can run standalone or in-pipeline (`create_product_research/SKILL.md:61-67`, `templates.md:8-15`).
- `create_mockup` writes a `mockups/` tree (mockup-log.md `status: iterating`, versioned `v00N/`) feeding design.md (`create_mockup/templates.md:47`, `:265`, `SKILL.md:278-288`).

### Subagent Orchestration

**What exists** (spawn sites; every spawn is a `Task({subagent_type, model})` block in the skill's sub-agent-prompts.md):

| Skill | Spawns (type @ model) | Topology |
| ------- | ---------------------- | ---------- |
| create_research | codebase-locator@haiku (:22), codebase-analyzer@sonnet (:49), pattern-finder@haiku (:68) | Parallel, wait-all |
| create_product_research | locator@haiku (:22), product-behavior-analyzer@sonnet (:51), pattern-finder@haiku (:76); research-validator@sonnet post-write (:96) | Parallel + sequential validator |
| create_design | pattern-finder@haiku (:27), codebase-analyzer@sonnet (:50), pattern-finder@haiku (:69) | Parallel, wait-all |
| create_execution | codebase-analyzer@sonnet (:30, :52), pattern-finder@haiku (:71) | Parallel, wait-all |
| create_mockup | codebase-analyzer@haiku ×4 (:20, :39, :59, :99), pattern-finder@haiku (:77) | Parallel, wait-all |
| validate_execution | codebase-analyzer@(inherit) (:24), general-purpose@sonnet (:43), general-purpose@haiku (:58), pattern-finder@sonnet (:76) | Parallel, wait-all |
| implement_coordinated | task-worker@{coordinator judgment} per task; task-verifier per task; fix-worker task-worker@opus (`sub-agent-prompts.md:114`) | Strictly sequential (`SKILL.md:415`) |

`implement_coordinated`'s loop: `bd ready` → `bd show` → coordinator judges tier (haiku = config/docs/renames; sonnet = standard implementation; opus = everything else, default when unsure — `SKILL.md:181-184`) → spawn worker → spawn verifier → parse literal `### Status: PASS|FAIL` (`:217-220`) → on FAIL spawn opus fix-worker, up to 2 retries (`:229`) → after 2 failures, add to blocking-issues list for phase checkpoint review and continue (`:230`). A distinct Worker Failure Playbook covers crashed workers (verification skipped; user offered 4 options — `reference.md:56-78`). The `determineModel()` keyword regex was retired in favor of coordinator judgment (`reference.md:51-53`). `implement_tasks` spawns nothing — the main session implements directly.

### Beads Integration

**What exists**:

- Philosophy: "Beads for STATUS, Markdown for PLAN" (CLAUDE.md:131-136); beads required for all task tracking (CLAUDE.md:114-117); `bd remember` for persistent knowledge (CLAUDE.md:238-240).
- Planning-phase issue-title conventions: `Q:` (research/design questions — `create_research/templates.md:108-116`), `Decide:` (pending decisions, priority 1 — `create_design/templates.md:120-124`), `Validate:` (assumptions — `create_design/templates.md:97-101`), `UI Q:` (mockups — `create_mockup/templates.md:134-137`); documented together in `help/SKILL.md:66-77`.
- Execution-phase: epic + phase milestones + granular tasks with `bd dep add` chains created by create_execution (`create_execution/SKILL.md:141-191`, `examples.md:8-55`); claim/close cycle in implement skills; worker prompts embed `bd update --claim` / `bd close` (`implement_coordinated/sub-agent-prompts.md:37,62`).
- `bd decision` appears nowhere in plugin skills, agents, or docs (grep: zero matches); it is referenced only in this project's own pre-work thoughts doc.
- Hooks provide deterministic beads behavior: SessionStart `setup-beads-mode.sh` exports `BEADS_MODE=stealth|git` based on `.beads/` gitignore state; SessionEnd `beads-drift-check.sh` emits a commit reminder from `git status --porcelain -- .beads/` only (<100ms contract, no bd invocations); PostToolUse `lint-hook` runs `lint --fix` on written/edited `.md` files (all wired in `plugin/.claude-plugin/plugin.json`).

### Background/Discipline Skills and Invocation Control

**What exists**:

- Claude-only (`user-invocable: false`): `tdd-discipline` ("NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST", SKILL.md:16), `verification-before-completion` ("NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE", SKILL.md:16), `project-structure` (research=facts / design=decisions / tasks=steps / thoughts/=explorations, with decision table "Unsure → thoughts/", SKILL.md:9-35), `status-sync` (richer beads-drift check deferring to the SessionEnd hook, SKILL.md:10, with an explicit DO-NOT list :56-61).
- Default invocation (user + Claude): `research-validation` (`model: sonnet`, `effort: high`, read-only allowlist + `Bash(test:*, ls:*)`; updates `validation_status`/`last_validated` frontmatter — SKILL.md:1-11, :76-80), `mockup-iteration` (uses `when_to_use` field appended to description), `review-prep` (ships executable `nvim-helper.sh`), `help`.
- User-only: the twelve stage skills plus `validate_project` (two barriers at `:116`, `:213`).
- Invocation-control semantics documented at docs/claude-code-skills-guide.md:121-135; `disable-model-invocation: true` skills' descriptions are never loaded into context (`:96`, `:128`), and they cannot be preloaded into subagents via `skills:` (`:214-216`).

### Agent Definitions and Model Selection Mechanism

**What exists**:

| Agent | tools | model | maxTurns | skills |
| ------- | ------- | ------- | ---------- | -------- |
| codebase-locator | Grep, Glob, Bash(find:\*, ls:\*) | haiku | 25 | — |
| pattern-finder | Grep, Glob, Read | haiku | 25 | — |
| codebase-analyzer | Read, Grep, Glob, Bash(ls:\*) | sonnet | — | — |
| product-behavior-analyzer | Read, Grep, Glob, Bash(ls:\*) | sonnet | — | — |
| research-validator | Read, Grep, Glob, Bash(ls:\*, test:\*) | sonnet | — | — |
| task-verifier | Bash, Read, Grep, Glob | sonnet | — | — |
| task-worker | Read, Write, Edit, Grep, Glob, Bash | *(none)* | 60 | [tdd-discipline] |

(`plugin/agents/*.md:1-7` each.) `task-worker` omits `model:` deliberately — "Spawned by /wb:implement_coordinated with a per-task model override" (`task-worker.md:2`), relying on the documented priority order `CLAUDE_CODE_SUBAGENT_MODEL` env → per-invocation parameter → agent frontmatter → inherit (docs/claude-code-skills-guide.md:221). Its `skills: [tdd-discipline]` preload injects the full discipline skill at startup (`task-worker.md:9`; mechanism at guide :214-216).

Skill/agent `model:` accepts `haiku|sonnet|opus|fable|<full-id>|inherit` (guide :83, :198); `effort:` accepts `low|medium|high|xhigh|max` (:84). `fable` is documented but unused anywhere in the plugin. Other relevant documented mechanisms: `context: fork` + `agent:` runs a skill in an isolated subagent (:166-182); dynamic substitutions `$ARGUMENTS`, `$0`/`$1`, `${CLAUDE_SKILL_DIR}` (:141-151); skill content persists in context with ~25K-token auto-compaction budget, first ~5K tokens per skill (:100-102).

### Documentarian Philosophy Propagation

**What exists**: `plugin/docs/reference/documentarian-philosophy.md` is the shared reference for the research skills and every agent they spawn (:3): "Document what IS, not what SHOULD BE" (:6-9) with a five-item DO-NOT list (:13-18). Typed agents (locator, analyzer, pattern-finder, product-behavior-analyzer) carry the constraint in their own system prompts (e.g. `codebase-analyzer.md:9-14`); ad-hoc `general-purpose` spawns do not, so spawning prompts must include it explicitly (:26-28). The "unless explicitly asked" escape hatch is documented at :30-32.

## Architecture Documentation

**Current patterns found**:

- **Stage-skill skeleton**: Initial Response → numbered Process Steps with ⛔ gates → Important Notes → Error Handling; supporting files split by role (prompts / templates / examples / reference) and loaded via "Read X NOW".
  - Example: `create_research/SKILL.md`, `create_design/SKILL.md`
- **Per-stage prohibition lists** (contamination rules) exist in three stages: research ("DO NOT suggest improvements..." — `create_research/SKILL.md` CRITICAL block), design ("This Document is About WHAT and WHY - NEVER HOW"; no task lists, no file modifications — `create_design/SKILL.md` CRITICAL block), implementation ("NO SCOPE ADDITIONS - NONE!" — `implement_tasks/SKILL.md`, `implement_coordinated/SKILL.md`).
- **Human approval gates** use consistent language: present options/plan → ask explicit question → "Wait for user confirmation before proceeding" (`create_design/SKILL.md:166`, `create_mockup/SKILL.md:98`, `update_status/SKILL.md:196-201`, `implement_tasks/SKILL.md:346`).
- **Per-spawn model override > agent frontmatter**: intentional-override review recorded in `docs/plans/2026-06-09-prompt-modernization/research.md` (R9) and `design.md:83`.
- **Deterministic-vs-probabilistic split**: hooks handle fast deterministic checks; background skills handle judgment-requiring versions of the same concern (`status-sync/SKILL.md:10`).

**Component connections**:

- create_project → create_research → create_design → create_execution → implement_* → validate_execution, linked by artifact `status`/`depends_on` frontmatter; update_status reconciles; create_handoff/resume_handoff snapshot and restore across sessions (handoff file `handoff-YYYY-MM-DD-HH-MM.md`, `create_handoff/SKILL.md:159-163`).
- Entry gate into design: `bd list -n 0 --status=open | grep "Q:"` (`create_design/SKILL.md:59`).
- Exit from design into execution: `design_approach` frontmatter + Success Criteria consumed by create_execution (`create_execution/SKILL.md:47-77`).

**Conventions observed**:

- Skills named `verb_noun` with underscores (`create_*`, `implement_*`, `validate_*`, `update_*`, `resume_*`); paired operations (create_handoff ↔ resume_handoff).
- Artifacts under `docs/plans/YYYY-MM-DD-[TICKET-]project-name/`; explorations under `thoughts/` (per project-structure skill; confirmed convention: any exploratory work that may or may not feed the final plan, not only rejected alternatives).
- Barriers numbered sequentially per skill; triple-⛔ variant for highest-importance stops; "think deeply"/"ultrathink" directives at judgment points (create_research/create_product_research Steps 3 and 5).
- Frontmatter core fields uniform across artifacts: project, ticket, created, created_timestamp, status, last_updated, git_commit, git_branch, repository, tags.

## Code References

Quick reference list:

- `plugin/skills/create_design/SKILL.md:166` — existing Decision Point (2–3 options, explicit approval)
- `plugin/skills/create_design/SKILL.md:218` — final design approval gate
- `plugin/skills/create_design/SKILL.md:59` — blocking-questions gate (`grep "Q:"`)
- `plugin/skills/create_design/templates.md:8-16` — design.md frontmatter incl. `design_approach`
- `plugin/skills/create_design/templates.md:97-124` — `Validate:` / `Decide:` beads issue patterns
- `plugin/skills/create_product_research/SKILL.md:61-67` — standalone-or-pipeline optional-stage precedent
- `plugin/skills/create_product_research/templates.md:8-15` — separate artifact with own `validation_status`
- `plugin/skills/implement_coordinated/SKILL.md:181-184` — coordinator model-tier judgment
- `plugin/skills/implement_coordinated/SKILL.md:213-231` — verify→fix-worker retry loop (opus, ≤2)
- `plugin/skills/implement_coordinated/reference.md:51-78` — model-selection history + Worker Failure Playbook
- `plugin/skills/update_status/SKILL.md:136-159` — status transition ownership
- `plugin/skills/help/SKILL.md:66-77` — beads title-prefix conventions
- `plugin/agents/task-worker.md:1-9` — model-less agent + `skills: [tdd-discipline]` preload
- `docs/claude-code-skills-guide.md:83-84, :198` — `model`/`effort` frontmatter enums (incl. `fable`)
- `docs/claude-code-skills-guide.md:221` — model-selection priority order
- `docs/claude-code-skills-guide.md:166-182` — `context: fork` / `agent:` mechanism
- `docs/claude-code-skills-guide.md:214-216` — `skills:` preload (cannot preload user-only skills)
- `plugin/docs/reference/documentarian-philosophy.md:26-28` — constraint propagation to spawned agents
- `plugin/.claude-plugin/plugin.json` — hook wiring (SessionStart / PostToolUse / SessionEnd)

## Similar Implementations

Existing patterns most relevant to a new discrete design-discussion stage:

**Options + approval — `create_design/SKILL.md:166` (Step 4 Decision Point)**: presents 2–3 design options, requires explicit approval of one before writing design.md, and records the choice as `design_approach` frontmatter. This is the closest existing analog to an "Innovate" convergence gate; it operates without dedicated option-drafting agents or a durable exploration artifact.

**Optional stage with own artifact — `create_product_research/SKILL.md:61-67`**: runs standalone or within the pipeline, writes `product-research.md` beside `research.md` with independent `status`/`audience`/`validation_status` frontmatter, and adds a post-write validation agent behind its own barrier (`:228`). Demonstrates how a stage can be inserted without modifying adjacent stages' contracts.

**Interactive interview with hard waits — `create_mockup/SKILL.md:98, :195`**: categorized clarifying questions ("Please answer what you can - we can iterate on unknowns") with explicit "Wait for user responses before proceeding", and per-iteration approval — the established pattern for human-in-the-loop divergence/convergence cycles.

**Skill-level model/effort pinning — `validate_execution/SKILL.md:7-8`** (`model: sonnet`, `effort: high`): the only stage skill that overrides the session model while it runs; the mechanism a Fable-pinned stage would use.

**Judgment-concentrated orchestration — `implement_coordinated/SKILL.md:181-184`**: coordinator holds judgment (tier selection, report parsing) while spawned workers hold throughput — the same shape as a discussion stage that fans out direction-drafting to cheaper subagents and reserves the expensive model for comparison and synthesis.

**Beads-tracked pending decisions — `create_design/templates.md:120-124`**: `bd create "Decide: [brief decision]" --type=task --priority=1` is the existing decision-record convention a new stage would either adopt or extend.

## Open Questions

Questions that require resolution before proceeding are tracked in beads, NOT in this document.

**Active questions** (reference only, beads is source of truth):

- `prompts-7mj`: Verify skill frontmatter `model: fable` resolves at runtime — blocks the design decision on how the new stage pins its model (frontmatter vs. session-launch guidance). Documented as an enum value only (docs/claude-code-skills-guide.md:83, :198); zero usage in the repo.

Use `bd list --status=open` to see all open questions; `bd show prompts-7mj` for details.

## Next Steps

Based on the research findings:

1. Design the new stage against the `create_product_research` optional-stage precedent (own artifact, independent status, no changes to adjacent stage contracts) and the `create_design` Step 4 decision-point/approval-gate language.
2. Decide the relationship between the new stage and `create_design`'s existing Step 4: whether Step 4 consumes the stage's output when present (pre-selected `design_approach`) and retains current behavior when absent.
3. Resolve `prompts-7mj` (fable frontmatter runtime behavior) before committing to the model-pinning mechanism.
4. Decide decision-record mechanics: adopt the existing `Decide:` title-prefix convention vs. introducing new practice; define where the exploration artifact lives (`thoughts/` per the confirmed convention) vs. what graduates to the formal pipeline.
5. Review the research document.
6. Run `/create_design docs/plans/2026-07-10-explore-design-stage` to create design decisions.
