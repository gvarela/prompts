---
project: prompt-modernization
created: 2026-06-09
status: complete
last_updated: 2026-06-09
git_commit: b8658f4
git_branch: modernize-2.0
repository: workbench
researcher: gabe@vare.la
audience: maintainer
beads_issue: prompts-fkz
---

# Prompt Modernization Evaluation Report

Four parallel reviewers evaluated all 27 prompt files (21 skills, 6 agents) against modern-model (Fable 5 / Opus 4.x era) best practices and current Claude Code capabilities. **Nothing in this report is applied. Check the boxes on the recommendations you approve; application happens in risk-ordered batches afterward.**

## Executive Summary

| Dimension | Headline finding |
|---|---|
| A — Scaffolding | 37 in-body BARRIERs (~61 incl. duplicates), 20 think/ultrathink directives, the documentarian rule stated up to 10× per file. ~170 lines deletable with zero instruction loss; barriers worth keeping should be normalized to single ⛔. |
| B — Context economy | 8,439 total SKILL.md lines → ~5,200 core after moving templates/agent-prompts/reference to on-demand supporting files (38% less context per invocation). Biggest wins: create_execution −55%, create_mockup −60%, create_project −66%. |
| C — New capabilities | 5 adoptions recommended (worker agent, SessionEnd hook, shell preprocessing, model/effort overrides, named args); 2 explicitly rejected (context: fork on interactive skills, memory: project on search agents); 1 reviewer proposal rejected on technical grounds. |
| D — Duplication & correctness | ~143 lines of cross-file duplication (BEADS_MODE block in 7 files); 5 real bd CLI correctness bugs; 6 model hints that **contradict** the new agent frontmatter. |

**Total impact if everything below is approved**: ~530 lines deleted outright, ~3,200 lines moved out of invocation-time context, 11 correctness fixes.

---

## Batch 1 — TRIM (low risk: deletions/softening, no behavior change)

- [ ] **R1 (TRIM)** — Delete all 20 `think deeply` / `ultrathink` directives across 13 files. None introduce constraints; the surrounding step text is self-sufficient. (Reviewer A, full list in Appendix A.)
- [ ] **R2 (TRIM)** — Delete the 8 end-of-file "Synchronization Points" summary sections (create_design 470-476, create_execution 775-782, create_product_research 523-527, create_project 445-449, create_research 419-422, implement_tasks 670-675, validate_execution 422-425, validate_project 510-514). They restate inline barriers and three of them reference **phantom barriers** that don't exist in the body (implement_tasks "BARRIER 3", validate_execution "BARRIER 3", validate_project "BARRIER 2/3"). ~50 lines.
- [ ] **R3 (TRIM)** — Normalize all `⛔⛔⛔ BARRIER N: STOP! ... ⛔⛔⛔` markers to single `⛔ BARRIER N:` form (10 files). Uniform triple-⛔ dilutes the genuinely load-bearing sync points. All barriers stay — only formatting changes.
- [ ] **R4 (TRIM)** — State each repeated rule once: documentarian rule ("Document what IS") kept once per file, delete the 6-9 restatements each in create_research/create_product_research and the trailing "REMEMBER" sections in codebase-analyzer/product-behavior-analyzer; soften the 8-line CAPS scope blocks in implement_tasks/implement_coordinated to 2-3 plain sentences; delete the duplicated 10-line "CRITICAL Agent Instructions" blocks (agents get constraints from their own .md system prompts). ~80 lines.
- [ ] **R5 (TRIM)** — Delete the boilerplate "Configuration" closing paragraph in ~12 skills (restates frontmatter description verbatim). ~50 lines.
- [ ] **R6 (TRIM)** — implement_coordinated: delete the "Evolution from implement_tasks" history (14-30) and "Advantages Over Sequential Implementation" narrative (732-770). Operationally inert. ~50 lines.
- [ ] **R7 (TRIM)** — validate_project: delete the JavaScript validation pseudo-code (316-433, ~118 lines). The checklist at lines 33-96 already captures the same logic in the form the model actually executes. (Reviewer B flagged this as the largest delete-not-demote block.)

**KEEP verdicts worth recording** (no action; protects them from future trims): all phase ⛔ CHECKPOINTs (human gates), wait-for-all-agents barriers, the ⛔ CHECKPOINT inside the tasks.md output template, tdd-discipline's Iron Law, research-validation's "NO TRUST WITHOUT VERIFICATION", create_mockup BARRIERs 2-5, update_status BARRIERs 2-3.

## Batch 2 — CORRECTNESS (low risk, behavioral fixes)

- [ ] **R8 (TRIM/fix)** — bd CLI correctness (Reviewer D, verified against `bd --help` output):
  - `bd list` defaults to open-only and `--limit 50`: validate_project:166 needs `bd list --all`; the 5 grep pipelines (help:73, create_research:318, create_design:312, validate_project:166, mockup-iteration:235) need `-n 0` to avoid silently missing issues past 50.
  - Standardize task claiming on `bd update [id] --claim` (atomic status+assignee, prevents double-claim in coordinated mode) instead of `--status in_progress` (implement_tasks ×4, implement_coordinated ×2).
  - validate_project:153 `git ls-files .beads/issues.jsonl` tests *tracked*, not *exists/configured* — replace with `git check-ignore -q .beads/` logic.
  - implement_coordinated:532 `bd list --status=closed | grep "phase${phase}"` only matches milestone titles, not tasks — use `bd show ${phaseMilestoneId}` blocker check instead.
- [ ] **R9 (fix)** — Six model hints **contradict** the new agent frontmatter: create_mockup spawns `codebase-analyzer` with `model: haiku` 4× (frontmatter says sonnet — lines 59, 75, 92, 126); validate_execution spawns `codebase-analyzer` with haiku (97) and `pattern-finder` with sonnet (149). Fix: remove the per-spawn model hints on typed agents and let frontmatter govern. The 13 redundant-but-matching hints can be removed in the same pass; hints on `general-purpose` (untyped) spawns **must stay** (validate_execution:116,131; implement_coordinated worker tiers).

## Batch 3 — RESTRUCTURE (medium risk: file splits, no semantic change)

- [ ] **R10 (RESTRUCTURE)** — Split oversized SKILL.md files into core + on-demand supporting files using a fixed four-name convention: `templates.md` (output document skeletons), `sub-agent-prompts.md` (verbatim spawn prompts), `reference.md` (helpers, error catalogs, pseudo-code), `examples.md` (illustrative dialogues). Per-file plan in Appendix B. Headline moves: create_handoff's 256-line handoff template, create_execution's 257-line tasks.md template, create_project's four ~300-line init templates, all five create_mockup agent prompts + four output templates. Projected: 8,439 → ~5,200 core lines. Each split leaves a one-line pointer ("When writing the file, follow [templates.md](templates.md)").
- [ ] **R11 (RESTRUCTURE)** — Extract cross-file duplicated blocks to `docs/reference/` (reachable from any skill via relative path): `beads-mode.md` (BEADS_MODE explanation, 7 files, ~70 lines saved), `agent-conventions.md` (READ-ONLY sub-agent rule, 5 files), `documentarian-philosophy.md` (2 research skills; the 2 agents keep it inline since agents must be self-contained), beads-not-initialized error block (2 files). TDD: implement_coordinated's worker prompt references the tdd-discipline skill by name instead of restating the cycle. ~143 lines saved.

## Batch 4 — NEW-CAPABILITY (pilot one at a time, verify, then roll on)

- [ ] **R12 (NEW-CAPABILITY, S effort, high confidence)** — Add `model: sonnet` + `effort: high` to the frontmatter of `validate_execution` and `research-validation`. Verification verdicts are high-stakes; this pins them off cheap models. Failure mode: none meaningful — override simply pins what's already intended.
- [ ] **R13 (NEW-CAPABILITY, M effort, high confidence)** — Create `agents/task-worker.md` with `skills: [tdd-discipline]` preload for implement_coordinated workers; retire the 40-line `determineModel()` regex function in favor of agent frontmatter `model:` plus a short coordinator note for when to override to opus. Benefit: TDD discipline is *injected* into every worker rather than hoped-for; model selection becomes declarative. Failure mode: a mis-set model degrades worker quality on complex tasks — pilot on one phase of a real project before rollout.
- [ ] **R14 (NEW-CAPABILITY, M effort, high confidence)** — Add a `SessionEnd` hook (`hooks/beads-drift-check.sh`) to plugin.json: checks `git diff --name-only .beads/` + open in_progress issues, prints a one-line reminder ONLY when drift exists, silent otherwise. Slim the status-sync skill to the interactive "deep check" role. Failure modes (must engineer for): hook fires on every session end including trivial ones — script must run <100ms and exit silently when clean; must not error in detached-HEAD/non-git states.
- [ ] **R15 (NEW-CAPABILITY, S effort, medium confidence)** — Pilot `` !`cmd` `` shell preprocessing to inject live state: `` !`bd ready` `` in implement_tasks, `` !`bd status` `` in update_status, `` !`bd list --status=in_progress -n 0` `` in create_handoff. Failure mode (must engineer for): if bd is missing/erroring, the model sees an error string where data should be — each injection site needs a "if the above shows an error, run the command manually and stop if beads is unavailable" line. Pilot in ONE skill (implement_tasks) first.
- [ ] **R16 (NEW-CAPABILITY, S effort, low-medium confidence)** — Named `arguments:` in research-skill frontmatter. **Verify actual syntax/semantics against current docs before applying** — Reviewer C's proposed invocation syntax (`key=value`) is unverified; the documented form is a simple list mapping positional args to `$name` substitutions. Apply only if it genuinely improves the no-args prompting flow.

## Rejected proposals (recorded so they aren't re-litigated)

| Proposal | Why rejected |
|---|---|
| `context: fork` on create_research / create_product_research / create_mockup | These skills are interactive (create_mockup asks 10 clarifying questions mid-flow; research skills confirm scope). A forked subagent cannot converse with the user. Transparency into agent fan-out is also lost. |
| `memory: project` on codebase-locator / analyzer / pattern-finder | Staleness: remembered file:line references rot as code changes, and the agents would confidently report them. Stateless fresh search is the feature, not the bug. |
| Orchestrating "research-codebase" / "research-product" wrapper agents (Reviewer C #4) | **Technically infeasible**: subagents cannot spawn subagents in Claude Code, so a wrapper agent cannot fan out to locator/analyzer/pattern-finder. The main-conversation skill must remain the orchestrator. |
| `effort:` override on implement_tasks | Task complexity varies too widely within one invocation for a single effort pin. |

## Caveats / reviewer corrections

- Reviewer D reported `bd doctor` exists in bd 1.0.2. True at the CLI surface, but it prints "not yet supported in embedded mode" and does nothing in embedded-Dolt repos (verified in this repo) — the Phase 1 migration to `bd info` stands.
- Reviewer D verified as CORRECT (no action needed): `bd ready`, `bd show`, `bd update --status/--claim`, `bd close --reason/-r`, `bd stats` (alias of `bd status`), `bd info`, `bd init [--stealth]`, `bd blocked`, `bd list --status=...`, `bd create --type/--priority/-d` (incl. epic type), `bd dep add` (positional and `--blocked-by`), `bd export`, `bd dolt push/pull`, `bd prime`.
- Line numbers in this report reference branch `modernize-2.0` at commit `b8658f4`; Batch 1-2 edits will shift them, so apply batches in order and re-locate by content, not line.

---

## Appendix A — Scaffolding findings (Reviewer A, condensed)

Per-file deletions/softenings. KEEP items omitted (listed in Batch 1 note above).

| File | Actions |
|---|---|
| create_design | Soften CAPS WHAT/WHY block (12-20) to 2-3 lines; soften 3×⛔ barriers (62, 159); delete think-directives (89, 163); delete 5th WHAT/HOW restatement (440); delete sync summary (470-476) |
| create_execution | Soften 3×⛔ (40, 148, 433); delete think-directives (67, 152); delete sync summary (775-782); KEEP template CHECKPOINT (336) |
| create_handoff | Soften 3×⛔ (44); delete think-directive (87) |
| create_mockup | Soften 3×⛔ (42); delete think-directive (172); BARRIERs 2-5 already correct weight |
| create_product_research | Soften CAPS block (12-21); soften 3×⛔ (70); delete ultrathink ×3 (83, 90-96, 225); delete CRITICAL Agent Instructions block (209-219, −12); delete duplicate wait + REMEMBER (227-234); delete "one final time" (402); delete philosophy repeats (491-498); delete sync summary (523-527) |
| create_project | Delete bare "think deeply" (50); soften BARRIER label (385); delete sync summary (445-449) |
| create_research | Soften CAPS block (12-21); soften 3×⛔ (52, 197); delete think/ultrathink (63, 67, 205); delete CRITICAL Agent Instructions (187-195, −10); delete duplicate wait (207-208); delete "one final time" (350); soften Critical Ordering, delete philosophy repeats (395-409); delete sync summary (419-422) |
| implement_coordinated | Soften CAPS scope block (70-78); soften 3×⛔ (85); delete think-header (119); soften worker-prompt CRITICAL headers (316, 349-355); soften FORBIDDEN block (794-803) |
| implement_tasks | Soften CAPS scope block (48-56); soften 3×⛔ (84); delete think-directive (115); soften 13-bullet FORBIDDEN block (654-668) to 5-6 unique items; delete sync summary incl. phantom BARRIER 3 (670-675) |
| resume_handoff | Soften 3×⛔ (41); delete think-directive (94) |
| update_status | Soften CAPS philosophy bullets (14-20); delete bare "think deeply" (95) |
| validate_execution | Soften 3×⛔ (46, 154); delete think-directives (72, 179); delete sync summary (422-425) |
| validate_project | Delete think-directive (126); delete sync summary w/ phantom barriers (510-514) |
| agents/codebase-analyzer | Soften CAPS block (10-16); delete trailing REMEMBER (111-113) |
| agents/product-behavior-analyzer | Soften CAPS block (10-17); de-CAPS traceability header (19-22, keep content); delete trailing REMEMBER (147-151) |
| clean (no findings) | help, mockup-iteration (1 trivial), project-structure, research-validation, review-prep, status-sync, tdd-discipline, verification-before-completion, codebase-locator, pattern-finder, research-validator, task-verifier |

## Appendix B — Restructure plan (Reviewer B, condensed)

| Skill | Current → Core | Moves |
|---|---|---|
| implement_coordinated | 808 → ~475 | worker prompt template (287-372) → sub-agent-prompts.md; verification + retry prompts → sub-agent-prompts.md; context-package + determineModel + failure playbook → reference.md (determineModel retired entirely if R13 approved); 3 output templates → templates.md |
| create_execution | 785 → ~350 | 3 agent prompts → sub-agent-prompts.md; 257-line tasks.md skeleton (175-431) → templates.md; bd create examples → examples.md; frontmatter/tracking templates → templates.md |
| implement_tasks | 679 → ~580 | 4 small output templates → templates.md (densest skill; stays largest) |
| create_mockup | 646 → ~260 | 5 agent prompts (47-129) → sub-agent-prompts.md; research summary, mockup.md, decisions.md, HTML, mockup-log templates → templates.md |
| create_product_research | 536 → ~300 | 4 agent prompts (incl. validator) → sub-agent-prompts.md; 130-line output template → templates.md |
| validate_project | 528 → ~245 | 108-line report template → templates.md; error/warning catalogs → reference.md; pseudo-code deleted per R7 |
| create_handoff | 508 → ~250 | 256-line handoff template (157-412) → templates.md |
| update_status | 502 → ~385 | frontmatter examples + confirmation template → templates.md; 3 error blocks → reference.md |
| create_design | 480 → ~295 | 3 agent prompts → sub-agent-prompts.md; 127-line design.md template → templates.md |
| create_project | 457 → ~155 | all 4 init file templates (88-383) → templates.md |
| resume_handoff | 435 → ~355 | resumed-output template → templates.md; 3 error blocks → reference.md |
| validate_execution | 435 → ~215 | 4 agent prompts → sub-agent-prompts.md; 145-line report template → templates.md |
| create_research | 434 → ~210 | 3 agent prompts + specialized list → sub-agent-prompts.md; 125-line output template → templates.md |
| mockup-iteration | 451 → ~365 | log/decisions templates → templates.md; example dialogue → examples.md |
| no split | help (212), project-structure, research-validation, review-prep, status-sync, tdd-discipline, verification-before-completion |

## Appendix C — Duplication inventory (Reviewer D, condensed)

| Block | Files (count) | Proposal | Savings |
|---|---|---|---|
| BEADS_MODE detection/explanation | 7 | docs/reference/beads-mode.md + keep only the 4-line git-mode commit conditional where needed | ~70 |
| Sub-agents READ-ONLY rule | 5 | one-line inline + agent-conventions.md | ~8 |
| Documentarian CAPS block | 2 skills + 2 agents | reference file for skills; agents keep inline (self-contained) | ~12 |
| "Beads Not Initialized" error | 2 | docs/reference/beads-not-initialized.md | ~13 |
| Persist-beads-state prose | 4 | keep script, point prose at beads-mode.md | ~25 |
| TDD cycle restatement | 2 | implement_coordinated worker prompt references tdd-discipline skill | ~15 |
