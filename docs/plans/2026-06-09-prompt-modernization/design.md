---
project: prompt-modernization
ticket: prompts-fkz
created: 2026-06-09
status: ready
last_updated: 2026-06-09
git_commit: db40dea
git_branch: modernize-2.0
repository: workbench
designer: gabe@vare.la
depends_on: research.md
design_approach: mechanism-first-trims-last
status_note: approved via /wb:create_execution invocation 2026-06-09
---

# Design: wb Prompt Modernization

## Problem Statement

The wb prompts carry three distinct liabilities documented in [research.md](research.md) (Rev 2):

1. **Verified defects** that silently corrupt workflow decisions: `bd list` truncates at 50 items in five pipelines that gate decisions, task claiming is non-atomic in coordinated mode, validate_project's git-mode check tests the wrong predicate, and three files reference phantom barriers that don't exist.
2. **Context-compaction exposure**: monolithic 500-800 line skills get tail-truncated under compaction during long implementation sessions — and the tail is where the DO/DON'T constraints live.
3. **Unrealized enforcement**: discipline that is *requested in prose* (worker TDD adherence, session-end beads persistence) could be *injected or enforced by mechanism* (`skills:` preload, lifecycle hooks).

If unaddressed: workflows mis-decide on projects with >50 open issues, long sessions degrade as constraints fall out of context, and reliability remains probabilistic where it could be deterministic.

### Success Metrics

- Zero recurrence of the verified defects (R8 list) — confirmed by grep audit and a live `validate_project` run.
- Implementation-skill core context reduced ~40% (implement_coordinated 808→~475, implement_tasks 679→~580 as first targets) with output structure verified unchanged against pre-split baselines.
- Behavioral parity on any applied trims: no editorializing during research, no skipped gates, no placeholder output, on the before/after test protocol (`prompts-409`).
- Worker TDD discipline mechanically injected (preloaded skill) rather than prose-requested, verified on one piloted phase of a real project.

## Design Approach

**Mechanism-first, trims-last (evidence-strength ordering).** Changes ship in descending order of evidential confidence: verified correctness fixes first, structural relocations second (semantics preserved by construction), capability adoptions third (each individually piloted), and behavior-shaping trims last — decided with behavioral evidence gathered from the preceding pilots rather than static analysis.

### Why This Approach

- The contested territory in research.md was never the bugs or the splits — it was whether emphasis scaffolding from the HumanLayer lineage is still load-bearing on Fable 5-class models. That question is empirical; this ordering makes the pilots (which exercise the real workflows end-to-end) generate the evidence before the trims are decided.
- Every stage is a natural abort point: stopping after correctness still nets the defect fixes; stopping after restructure still nets compaction protection.
- Precedent: Phase 1 of the modernization (commits `7b0aadd`..`db40dea` on this branch) shipped as six staged commits with per-stage verification, cleanly.
- Testing is zero-friction: `claude --plugin-dir` loads the working tree directly, so each stage is verifiable from the branch (optionally via a git worktree) without version bumps or releases.

## Technical Decisions

### Staging strategy: evidence-strength ordering

- Decision: correctness → restructure → capability → trims, with the trims gated on pilot-derived behavioral evidence.
- Rationale: aligns risk with confidence; the Rev 2 epistemic standard ("added for a reason" ≠ "still necessary" — only behavior settles it) applied to sequencing.
- Trade-off: the visible "cleanup" (trims) lands last or, if evidence says the scaffolding still earns its keep, never. Accepted.

### Restructure architecture: fixed four-name supporting-file convention

- Decision: skills split into a core SKILL.md plus at most four on-demand files with fixed names — `templates.md` (output skeletons), `sub-agent-prompts.md` (verbatim spawn prompts), `reference.md` (helpers, error catalogs, pseudo-code specs), `examples.md` (illustrative dialogues). Cross-skill shared *explanatory* content goes to `docs/reference/` (beads-mode semantics, documentarian philosophy); *operative* snippets stay inline. Agents remain fully self-contained.
- Rationale: predictable directory shape (research.md Appendix B); on-demand loading implements the lineage's own context-compaction philosophy; lean cores survive compaction with constraints intact.
- Trade-off / accepted risk: a model that skips reading a supporting file produces unstructured output — mitigated by imperative pointers ("Read templates.md NOW, before writing") and by the pilot gate below.
- Pattern reference: research.md Appendix B per-file plan; pilot target is implement_coordinated (largest file, longest-session usage).

### Worker discipline: defined agent with skill preload

- Decision: implement_coordinated's ad-hoc worker prompts are replaced by a defined `task-worker` agent that preloads the tdd-discipline skill; per-task model selection moves from keyword regex (`determineModel()`) to coordinator judgment passing per-spawn model overrides.
- Rationale: preloading converts TDD from requested to injected; a modern coordinator classifies task complexity better than regex; the three-tier (haiku/sonnet/opus) intent is preserved through the documented override mechanism (per-spawn > frontmatter).
- Trade-off: one more agent definition to maintain; a mis-judged override degrades a single task (caught by task-verifier), not the phase.
- Assumption: plugin agents can preload plugin skills by name (`prompts-70p`).

### Persistence reliability: deterministic hook alongside slimmed skill

- Decision: session-end beads-drift reminding moves to a SessionEnd hook (fast, silent when clean, safe in non-git states); the status-sync skill remains as the interactive deep-check.
- Rationale: must-happen reminders should be deterministic (hooks) rather than probabilistic (skill activation); the skill predates SessionEnd's existence.
- Trade-off: hook fires on every session end including trivial ones — the silence-when-clean requirement is part of the decision, not an optimization.
- Assumption: SessionEnd hook output is user-visible (`prompts-dr7`).

### Verification budget: declarative pins

- Decision: validate_execution and research-validation carry `model: sonnet` + `effort: high` frontmatter.
- Rationale: verification verdicts gate phases — highest-stakes outputs get pinned budgets; this is the declarative form of what the inline budget keywords (ultrathink lineage) were doing.
- Trade-off: marginal cost increase on validation runs. Accepted.

### Scaffolding policy

- Decision: emphasis scaffolding (barriers, positioned repetition, budget keywords, CAPS blocks) is presumed load-bearing; only items proven dead (phantom references, frontmatter-restating boilerplate) change without behavioral evidence. Budget keywords convert to declarative `effort:`/retained keywords, never silent deletion. Per-spawn model hints are reviewed as intentional overrides, not normalized.
- Rationale: Rev 1 → Rev 2 corrections table in research.md; the scaffolding encodes observed failure modes.

## Scope Definition

### In Scope

- R8 bd correctness fixes + phantom-barrier reference fixes + R5 boilerplate removal + R9 per-site intent review (correctness stage)
- R10 restructure of the 14 workflow skills, implementation skills first, implement_coordinated as pilot; R11 docs/reference/ extraction (restructure stage)
- R12 verification pins, R13 task-worker agent, R14 SessionEnd drift hook (capability stage)
- R1-R4 trims as revised in research.md Rev 2, applied only with behavioral-parity evidence (trims stage)

### Out of Scope

- `context: fork` on interactive skills, `memory: project` on search agents, wrapper orchestrator agents (rejected in research.md with reasons; not revisited here)
- R15 shell preprocessing and R16 named arguments — pending decision `prompts-s6c`; nothing blocks on them
- Any change to the 21 `/wb:*` names, the workflow sequence, or the research→design→execution philosophy
- Markdown-only (beads-less) workflow support (remains v1.0.0-tag territory)

## Success Criteria

### Functional Requirements

- [ ] All five `bd list` decision pipelines return complete result sets on >50-issue projects
- [ ] Coordinated workers claim tasks atomically (`--claim`); no double-claim window
- [ ] validate_project reports correct mode configuration on stealth, git, and unconfigured repos
- [ ] Piloted split skills produce output structurally identical to pre-split baselines
- [ ] task-worker runs RED-GREEN-REFACTOR with tdd-discipline content verifiably in its context
- [ ] Drift reminder appears at session end when beads changes are uncommitted, and only then

### Non-Functional Requirements

- [ ] SessionEnd hook completes in <100ms and is silent on clean state
- [ ] implement_coordinated core SKILL.md ≤ ~500 lines post-split
- [ ] Each stage independently shippable; Phase 1 verification checklist passes after every stage

## Risk Analysis

### Technical Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Model skips reading supporting file post-split → unstructured output | High | Low-Med | Imperative pointers; pilot gate with baseline comparison before rollout |
| Trims regress discipline (editorializing, skipped gates) | High | Low | Trims last; behavioral-parity protocol (`prompts-409`) gates each trim batch; revert is one commit |
| `skills:` preload doesn't resolve plugin skill names | Med | Med | Validate first (`prompts-70p`); fallback: inline TDD rules in task-worker prompt |
| SessionEnd hook output invisible or noisy | Low | Med | Validate display (`prompts-dr7`); fallback to Stop event or skill-only |
| Coordinator misjudges worker model tier | Low | Low | task-verifier already gates every worker; single-task blast radius |

### Assumptions

| Assumption | Beads ID | Validated? |
|------------|----------|------------|
| Plugin agents can preload plugin skills via `skills:` frontmatter | `prompts-70p` | Pending |
| SessionEnd hook stdout is visible to the user | `prompts-dr7` | Pending |
| A discriminative before/after behavioral test is constructible | `prompts-409` | Pending |

## Rejected Alternatives

### Option: Correctness-only (research Option A)

- **Approach**: Ship R8/R5/phantom fixes; stop.
- **Rejected because**: leaves the compaction exposure and probabilistic discipline unaddressed; shelves the Phase 2 investment with the lowest-risk structural wins (pure relocations) unrealized.
- **Trade-offs**: would have been near-zero risk.

### Option: Full Rev 2 program in batch order (research Option B)

- **Approach**: All 16 recommendations in the report's batch order (trims first as "Batch 1").
- **Rejected because**: puts the most contested, least-evidenced changes first; behavioral testing burden lands before the pilots that would inform it.
- **Trade-offs**: shortest calendar path to full scope, traded for ordering risk.

### Previously rejected (research.md, not re-litigated)

`context: fork` on interactive skills; `memory: project` on search agents; wrapper orchestrator agents (subagents cannot spawn subagents); blanket emphasis-scaffolding deletion.

## Pending Decisions

| Decision Needed | Beads ID | Blocks |
|-----------------|----------|--------|
| Include R15 (shell preprocessing) / R16 (named args) as a final optional stage, or drop | `prompts-s6c` | nothing until capability stage completes |

## References

- Research: [research.md](research.md) (Rev 2, including Rev 1→Rev 2 corrections table and reviewer appendices)
- Phase 1 precedent: branch `modernize-2.0`, commits `7b0aadd`..`db40dea` (PR #2)
- Upstream lineage: HumanLayer `.claude/commands` (research→plan→implement workflow)
