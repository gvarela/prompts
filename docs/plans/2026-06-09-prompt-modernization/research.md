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
ticket: prompts-fkz
revision: 2
revision_note: "Rev 2 after maintainer pushback: re-evaluated against the HumanLayer provenance of these prompts; several Rev 1 verdicts reversed or narrowed. See Provenance & Evaluation Standard."
---

# Prompt Modernization Evaluation Report (Rev 2)

Four parallel reviewers evaluated all 27 prompt files (21 skills, 6 agents) against modern-model (Fable 5 / Opus 4.x era) best practices and current Claude Code capabilities. **Nothing in this report is applied. Check the boxes on the recommendations you approve; application happens in risk-ordered batches afterward.**

## Provenance & Evaluation Standard

These workflow prompts descend from HumanLayer's `.claude/commands` (Dex Horthy's research → plan → implement workflow). The scaffolding was engineered against *observed model failure modes*: racing ahead of sub-agents, writing placeholder output, editorializing during research, skipping full file reads, scope creep. Rev 1 of this report judged some of that scaffolding aesthetically; Rev 2 corrects that. Two principles govern this revision:

1. **"Added for a reason" and "still necessary on Fable 5" are different claims.** Neither provenance nor reviewer opinion settles the second — only behavior does.
2. **Behavioral gate**: no behavior-shaping trim (R1-R4) ships without a before/after check — run `create_research` and one `implement_tasks` phase against a real question with trimmed vs. untrimmed prompts; compare for editorializing, skipped gates, and placeholder output. Mechanical fixes (R5, R8) and relocations (R6, R7, R10, R11) need only standard verification.

### Rev 1 → Rev 2 corrections (recorded so the reasoning isn't lost)

| Rev 1 claim | Correction |
|---|---|
| "think deeply"/"ultrathink" are metacognitive fluff; delete all 20 | **Wrong.** These are extended-thinking budget triggers in Claude Code (escalating think/think hard/ultrathink keywords), placed at decision-critical steps. They are budget controls, not rhetoric. |
| Delete the 10-line "CRITICAL Agent Instructions" blocks (agents get constraints from their .md files) | **Wrong for untyped spawns.** Typed agents carry the documentarian rule in their system prompts; the ad-hoc general-purpose specialists (database/API/frontend) the research skills also spawn do not. "Remind EVERY agent" exists for them. |
| 6 model hints "contradict" agent frontmatter (bug) | **Misframed.** Per-invocation model parameters override frontmatter by documented priority — that's the designed mechanism. create_mockup's haiku researchers were a deliberate cost choice predating the frontmatter. These are intentional overrides to review, not bugs to fix. |
| Delete validate_project's 118-line validation pseudo-code | **Overreach.** Pseudo-code is an unambiguous spec (exact commands, precedence) that models follow more reliably than prose. Relocate to reference.md, don't delete. |
| Documentarian rule: state once per file | **Under-weighted positioned repetition.** The editorializing failure mode strikes late (at synthesis); restatements at spawn/write steps are point-of-failure reminders. Floor is ~3 strategic placements, not 1. |
| Delete the 8 "Synchronization Points" end-of-file summaries | **Under-weighted recency anchoring.** After 700 lines, re-stating the gates at the end re-anchors them. Fix the phantom references (real bugs); keep the summaries; re-evaluate per-file only after splits shrink the file. |

## Executive Summary

| Dimension | Headline finding (Rev 2) |
|---|---|
| A — Scaffolding | Most emphasis scaffolding is load-bearing or defensible; true dead branches are narrower than Rev 1 claimed: phantom barrier references (3 files), boilerplate "Configuration" paragraphs (~12 files), bare no-object think-directives (2), historical narrative in implement_coordinated. Budget keywords should be formalized (`effort:`), not deleted. |
| B — Context economy | 8,439 total SKILL.md lines → ~5,200 core by moving templates/agent-prompts/reference to on-demand files. Aligned with the prompts' own provenance (intentional context compaction), plus: under context compaction, monolithic skills get tail-truncated — and the tail is where DO/DON'T constraints live. Priority revised: implementation skills first (they sit in context for hours). |
| C — New capabilities | 5 adoptions recommended (worker agent, SessionEnd hook, shell preprocessing pilot, model/effort pins, named args); 3 rejections recorded (context: fork on interactive skills, memory: project on search agents, wrapper orchestrator agents — technically infeasible). |
| D — Duplication & correctness | ~143 lines of cross-file duplication (BEADS_MODE block in 7 files); 4 verified bd CLI bugs (silent 50-item truncation, wrong git-mode check, non-atomic claiming, fragile phase grep). |

**Total impact if approved**: ~300-400 lines deleted, ~3,400 moved out of invocation-time context, 9 correctness fixes, 0 load-bearing gates removed.

---

## Batch 1 — TRIM (behavioral gate applies: before/after check required)

- [ ] **R1 (REVISED — convert, don't delete)** — Formalize thinking-budget control. The `ultrathink`/`think deeply` keywords at decision-critical steps (research decomposition, implementation sequencing, problem definition) are budget triggers and stay or convert to `effort: high` skill frontmatter where the whole skill is uniformly hard. Only the 2 bare no-object directives (create_project:50, update_status:95 — mechanical steps) are delete candidates, individually verified.
- [ ] **R2 (REVISED — fix bugs only)** — Fix the 3 phantom-barrier references in the "Synchronization Points" summaries (implement_tasks "BARRIER 3", validate_execution "BARRIER 3", validate_project "BARRIER 2/3" cite gates that don't exist in the body — provably unmaintained copy-paste). Summaries themselves stay as recency anchors; re-evaluate per-file after R10 splits shrink files below ~350 lines.
- [ ] **R3 (DOWNGRADED — optional/defer)** — Triple-⛔ → single-⛔ normalization. No evidence of harm in either direction; formatting change in a working system is uncompensated risk. Apply only if bundled with the behavioral test batch, or skip.
- [ ] **R4 (REVISED — strategic placement, not single statement)** — Reduce documentarian-rule repetition from ~8-10× to ~3 strategic placements per file: top-of-file definition, agent-spawn step, synthesis/write step. **Keep** the "Remind EVERY agent" instruction (covers untyped general-purpose spawns that have no agent .md). Soften the 8-line CAPS scope blocks in implement_tasks/implement_coordinated to plain sentences only if the behavioral check shows no scope-creep regression.
- [ ] **R5 (TRIM — stands)** — Delete the boilerplate "Configuration" closing paragraphs (~12 skills, ~50 lines) that restate frontmatter verbatim. Verify per-file that nothing unique rides along.
- [ ] **R6 (REVISED — relocate, don't delete)** — implement_coordinated's "Evolution from implement_tasks" (14-30) and "Advantages" (732-770) sections are written for human maintainers, not the model. Move to a README.md in the skill directory (not loaded at invocation).
- [ ] **R7 (REVISED — relocate, don't delete)** — validate_project's validation pseudo-code (316-433) moves to `reference.md` with an imperative pointer at the validation step. It's the precise spec; the checklist is the summary.

**KEEP verdicts (protected from future trims)**: all ⛔ CHECKPOINTs (human gates), wait-for-all-agents barriers, the CHECKPOINT inside the tasks.md output template, tdd-discipline's Iron Law, research-validation's "NO TRUST WITHOUT VERIFICATION", create_mockup BARRIERs 2-5, update_status BARRIERs 2-3, end-of-file barrier summaries (post-fix), decision-point ultrathink directives, "Remind EVERY agent" instructions.

## Batch 2 — CORRECTNESS (verified bugs; standard verification)

- [ ] **R8 (fix — stands)** — bd CLI correctness (verified against `bd --help` output):
  - `bd list` defaults to open-only with `--limit 50`: validate_project:166 needs `--all`; the 5 grep pipelines gating workflow decisions (help:73, create_research:318, create_design:312, validate_project:166, mockup-iteration:235) need `-n 0` or they silently miss issues past 50.
  - Standardize claiming on `bd update [id] --claim` (atomic status+assignee; prevents double-claim in coordinated mode) where the intent is claiming (implement_tasks ×4, implement_coordinated ×2).
  - validate_project:153 `git ls-files .beads/issues.jsonl` tests *tracked*, not *configured* — replace with `git check-ignore -q .beads/` logic.
  - implement_coordinated:532 `bd list --status=closed | grep "phase${phase}"` matches only milestone titles — use `bd show ${phaseMilestoneId}` blocker check.
- [ ] **R9 (REVISED — review, don't normalize)** — Per-spawn model hints override agent frontmatter by design (documented priority: invocation > frontmatter > inherit). Decide intent per site rather than "fixing": create_mockup × 4 codebase-analyzer@haiku (likely deliberate — lightweight doc-gathering); validate_execution:97 codebase-analyzer@haiku (questionable — diff analysis is sonnet-class work) and :149 pattern-finder@sonnet (possibly deliberate quality-analysis upgrade). The 13 redundant-identical hints may stay (harmless, self-documenting) or go — maintainer's call. Hints on untyped `general-purpose` spawns must stay regardless.

## Batch 3 — RESTRUCTURE (relocations; pilot-gated)

- [ ] **R10 (REVISED priority + safeguards)** — Split oversized SKILL.md into core + on-demand files (`templates.md`, `sub-agent-prompts.md`, `reference.md`, `examples.md` — fixed names). This implements, not contradicts, the prompts' own context-compaction philosophy; it also protects DO/DON'T constraints from compaction tail-truncation. **New failure mode to engineer for**: a model that skips reading the supporting file produces unstructured output — every pointer must be imperative ("Read [templates.md](templates.md) NOW, before writing") and the split must be **piloted on one skill end-to-end** (output structure verified against pre-split output) before rollout. **Revised order**: implement_tasks and implement_coordinated first (long-session context pressure), create_* one-shots second (they load once per explicit invocation into a 1M-token window — the economy argument is weaker there). Per-file plan in Appendix B.
- [ ] **R11 (RESTRUCTURE — stands, narrowed)** — Extract duplicated blocks to `docs/reference/`: explanatory content only (BEADS_MODE semantics, documentarian philosophy for the 2 research skills, beads-not-initialized message). Operative content (the 4-line git-commit conditional) stays inline. Agents keep their documentarian blocks inline — they must be self-contained. ~100 lines saved.

## Batch 4 — NEW-CAPABILITY (pilot one at a time, verify, then roll on)

- [ ] **R12 (S effort, high confidence)** — `model: sonnet` + `effort: high` frontmatter on `validate_execution` and `research-validation`. This is the formalized version of what the inline budget keywords were doing — same intent, declarative mechanism.
- [ ] **R13 (M effort, high confidence)** — Create `agents/task-worker.md` with `skills: [tdd-discipline]` preload for implement_coordinated workers. Replace the regex `determineModel()` with coordinator judgment passing per-spawn model overrides (a modern model classifies task complexity better than keyword regex; the per-tier intent is preserved, the mechanism improves). Pilot on one phase of a real project before rollout.
- [ ] **R14 (M effort, high confidence)** — `SessionEnd` hook (`hooks/beads-drift-check.sh`) in plugin.json: prints a one-line reminder ONLY when beads drift exists, silent otherwise; <100ms; safe in non-git states. status-sync skill slims to the interactive deep-check role. Deterministic where the skill was probabilistic.
- [ ] **R15 (S effort, medium confidence)** — Pilot `` !`cmd` `` preprocessing in ONE skill (implement_tasks: `` !`bd ready` ``). Caveats: output is a load-time snapshot (goes stale mid-session — the iterative `bd ready` instructions stay); each injection site needs an error-string fallback line ("if the above shows an error, run the command manually").
- [ ] **R16 (S effort, low-medium confidence)** — Named `arguments:` frontmatter on research skills. Verify actual syntax/semantics against current docs first (Rev 1 reviewer's proposed `key=value` invocation syntax is unverified; documented form maps positional args to `$name`).

## Rejected proposals (recorded so they aren't re-litigated)

| Proposal | Why rejected |
|---|---|
| `context: fork` on create_research / create_product_research / create_mockup | Interactive skills (create_mockup asks 10 clarifying questions mid-flow); forked subagents cannot converse with the user. Fan-out transparency also lost. |
| `memory: project` on codebase-locator / analyzer / pattern-finder | Remembered file:line references rot as code changes and agents would confidently report them. Stateless fresh search is the feature. |
| Wrapper "research-codebase" orchestrator agents | Technically infeasible: subagents cannot spawn subagents. The main-conversation skill must remain the orchestrator. |
| `effort:` override on implement_tasks | Task complexity varies too widely within one invocation for a single pin. |
| Blanket deletion of emphasis scaffolding (Rev 1's framing) | The scaffolding encodes observed failure modes from the HumanLayer lineage; trims must be narrow, positioned, and behaviorally verified — not aesthetic. |

## Caveats

- Reviewer D reported `bd doctor` exists in bd 1.0.2 — true at the CLI surface, but it prints "not yet supported in embedded mode" and does nothing in embedded-Dolt repos (verified here). The Phase 1 migration to `bd info` stands.
- bd commands verified CORRECT (no action): `bd ready`, `bd show`, `bd update --status/--claim`, `bd close --reason/-r`, `bd stats` (alias of `bd status`), `bd info`, `bd init [--stealth]`, `bd blocked`, `bd list --status=...`, `bd create --type/--priority/-d` (incl. epic), `bd dep add` (positional and `--blocked-by`), `bd export`, `bd dolt push/pull`, `bd prime`.
- Line numbers reference branch `modernize-2.0` at commit `b8658f4`; apply batches in order and re-locate by content, not line.

---

## Appendix A — Scaffolding findings (Reviewer A raw verdicts — superseded where they conflict with revised R1-R4 above)

> Rev 2 note: this appendix preserves Reviewer A's original static-analysis verdicts for audit. Where a verdict below says DELETE for a think-directive, documentarian restatement, agent-instructions block, or sync summary, the **revised recommendations above govern** (convert/fix/strategic-placement instead).

| File | Reviewer A raw actions |
|---|---|
| create_design | Soften CAPS WHAT/WHY block (12-20); soften 3×⛔ (62, 159); think-directives (89, 163); 5th WHAT/HOW restatement (440); sync summary (470-476) |
| create_execution | Soften 3×⛔ (40, 148, 433); think-directives (67, 152); sync summary (775-782); KEEP template CHECKPOINT (336) |
| create_handoff | Soften 3×⛔ (44); think-directive (87) |
| create_mockup | Soften 3×⛔ (42); think-directive (172); BARRIERs 2-5 correct weight |
| create_product_research | Soften CAPS block (12-21); 3×⛔ (70); ultrathink ×3 (83, 90-96, 225); Agent Instructions block (209-219); duplicate wait + REMEMBER (227-234); "one final time" (402); philosophy repeats (491-498); sync summary (523-527) |
| create_project | Bare "think deeply" (50); BARRIER label (385); sync summary (445-449) |
| create_research | CAPS block (12-21); 3×⛔ (52, 197); think/ultrathink (63, 67, 205); Agent Instructions (187-195); duplicate wait (207-208); "one final time" (350); Critical Ordering + philosophy repeats (395-409); sync summary (419-422) |
| implement_coordinated | CAPS scope block (70-78); 3×⛔ (85); think-header (119); worker-prompt CRITICAL headers (316, 349-355); FORBIDDEN block (794-803) |
| implement_tasks | CAPS scope block (48-56); 3×⛔ (84); think-directive (115); 13-bullet FORBIDDEN block (654-668); sync summary w/ phantom BARRIER 3 (670-675) |
| resume_handoff | 3×⛔ (41); think-directive (94) |
| update_status | CAPS philosophy bullets (14-20); bare "think deeply" (95) |
| validate_execution | 3×⛔ (46, 154); think-directives (72, 179); sync summary (422-425) |
| validate_project | Think-directive (126); sync summary w/ phantom barriers (510-514) |
| agents/codebase-analyzer | CAPS block (10-16); trailing REMEMBER (111-113) |
| agents/product-behavior-analyzer | CAPS block (10-17); traceability header caps (19-22); trailing REMEMBER (147-151) |
| clean (no findings) | help, mockup-iteration, project-structure, research-validation, review-prep, status-sync, tdd-discipline, verification-before-completion, codebase-locator, pattern-finder, research-validator, task-verifier |

## Appendix B — Restructure plan (Reviewer B, condensed; Rev 2 order: implementation skills first)

| Skill | Current → Core | Moves |
|---|---|---|
| implement_coordinated | 808 → ~475 | worker prompt template (287-372) → sub-agent-prompts.md; verification + retry prompts → sub-agent-prompts.md; context-package + failure playbook → reference.md (determineModel retired if R13 approved); 3 output templates → templates.md; narrative → README.md per R6 |
| implement_tasks | 679 → ~580 | 4 small output templates → templates.md (densest skill; stays largest) |
| create_execution | 785 → ~350 | 3 agent prompts → sub-agent-prompts.md; 257-line tasks.md skeleton (175-431) → templates.md; bd create examples → examples.md; frontmatter/tracking templates → templates.md |
| create_mockup | 646 → ~260 | 5 agent prompts (47-129) → sub-agent-prompts.md; research summary, mockup.md, decisions.md, HTML, mockup-log templates → templates.md |
| create_product_research | 536 → ~300 | 4 agent prompts (incl. validator) → sub-agent-prompts.md; 130-line output template → templates.md |
| validate_project | 528 → ~245 | 108-line report template → templates.md; error/warning catalogs + validation pseudo-code (per R7) → reference.md |
| create_handoff | 508 → ~250 | 256-line handoff template (157-412) → templates.md |
| update_status | 502 → ~385 | frontmatter examples + confirmation template → templates.md; 3 error blocks → reference.md |
| create_design | 480 → ~295 | 3 agent prompts → sub-agent-prompts.md; 127-line design.md template → templates.md |
| create_project | 457 → ~155 | all 4 init file templates (88-383) → templates.md |
| resume_handoff | 435 → ~355 | resumed-output template → templates.md; 3 error blocks → reference.md |
| validate_execution | 435 → ~215 | 4 agent prompts → sub-agent-prompts.md; 145-line report template → templates.md |
| create_research | 434 → ~210 | 3 agent prompts + specialized list → sub-agent-prompts.md; 125-line output template → templates.md |
| mockup-iteration | 451 → ~365 | log/decisions templates → templates.md; example dialogue → examples.md |
| no split | help (212), project-structure, research-validation, review-prep, status-sync, tdd-discipline, verification-before-completion |

## Appendix C — Duplication inventory (Reviewer D, condensed; Rev 2: explanatory content only externalizes)

| Block | Files (count) | Proposal | Savings |
|---|---|---|---|
| BEADS_MODE detection/explanation | 7 | docs/reference/beads-mode.md; keep the 4-line git-mode commit conditional inline | ~70 |
| Sub-agents READ-ONLY rule | 5 | one-line inline statement stays; longer rationale → agent-conventions.md | ~8 |
| Documentarian CAPS block | 2 skills + 2 agents | reference file for skills (top-of-file placement per R4 stays); agents keep inline (self-contained) | ~12 |
| "Beads Not Initialized" error | 2 | docs/reference/beads-not-initialized.md | ~13 |
| Persist-beads-state prose | 4 | keep script, point prose at beads-mode.md | ~25 |
| TDD cycle restatement | 2 | implement_coordinated worker prompt references tdd-discipline skill (R13 makes this automatic via skills: preload) | — |

---

## Final Disposition (2026-06-11)

Project closes at Phase 3 + release; Phase 4 trims deferred to a successor project that will run after the wb-eval-harness ships (its Tier 3 scenarios against the Faraday fixture become the trims' evidence base — see docs/plans/2026-06-10-wb-eval-harness/).

| Recommendation | Disposition |
|---|---|
| R2 (phantom-barrier fixes) | APPLIED Phase 1 — plus two maintainer-decided gate *promotions* (validate_execution BARRIER 3, validate_project BARRIER 2) |
| R5 (Configuration boilerplate) | APPLIED Phase 1 |
| R8 (bd CLI correctness) | APPLIED Phase 1 (8 truncation sites, 14 claim sites, mode predicate, milestone checks) |
| R9 (model-hint review) | APPLIED Phase 1 per maintainer decisions (mockup haiku kept; validate_execution:97 deferred to frontmatter; :149 sonnet kept) |
| R6, R7, R10, R11 (relocations/splits/dedup) | APPLIED Phase 2 — 8,439 → 5,275 core lines, parity-gated, adversarially audited |
| R12 (verification pins), R13 (task-worker), R14 (SessionEnd drift hook) | APPLIED Phase 3, assumption-validated and piloted |
| R1 (budget keywords), R4 (strategic placement) | DEFERRED to successor — pending harness Tier 3 behavioral evidence (prompts-41c/7jx/9wg/pnr deferred in beads) |
| R3 (barrier formatting) | DEFERRED, still downgraded — decide on parity evidence or skip |
| R15, R16 (preprocessing, named args) | PARKED — open decision prompts-s6c, nothing blocked |
