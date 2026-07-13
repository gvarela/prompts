---
project: explore-design-stage
created: 2026-07-10
created_timestamp: 2026-07-10T22:13:38Z
status: exploration
author: gabevarela
git_commit: 0c1250840dbce9ab373a6d718a2600e4489539f9
git_branch: modernize-2.0
repository: gvarela/workbench
tags: [thoughts, exploration, model-strategy, riper, explore-design-stage]
---

# Pre-Work: Model Strategy Review & RIPER Analysis

Exploration notes from the 2026-07-10 discussion that led to this project. Two threads converged here: (1) a cost-efficiency review of which models orchestrate vs execute across the wb loops, and (2) the observation that the workflow lacks a discrete design/architecture discussion stage — which turned out to be the natural home for Fable 5. This doc preserves the analysis as input for `/create_research` and `/create_design`; nothing here is a committed decision.

## 1. Context: Model Landscape (as of 2026-07-10)

| Model | Input/Output per MTok | Positioning |
| ------- | ---------------------- | ------------- |
| Fable 5 | $10 / $50 | Mythos-class tier above Opus; deepest reasoning, long-horizon judgment, thought partnership; always-on thinking |
| Opus 4.8 | $5 / $25 | Most capable Opus; autonomous/agentic execution, long-session coherence |
| Sonnet 5 | $3 / $15 ($2/$10 intro through 2026-08-31) | Near-Opus quality on coding and agentic work; first Sonnet with `xhigh` effort |
| Haiku 4.5 | $1 / $5 | Fast, cheap; 200K context (others 1M); no `effort` parameter support |

Two shifts since the repo's `haiku`/`sonnet`/`opus` guidance was written:

1. **Sonnet 5 reaches near-Opus quality on coding/agentic tasks** at 60% of Opus pricing — the "opus by default" calibration is stale.
2. **`effort` (low→xhigh/max) is a second cost lever.** "Sonnet at low effort" often beats "downgrade to Haiku" because quality degrades gracefully instead of falling off a tier. (Effort errors on Haiku 4.5 — only annotate sonnet/opus agents.)

## 2. Current State (survey of modernize-2.0 branch)

- v2.0.0 layout: no `commands/` — all former slash commands are `plugin/skills/<name>/SKILL.md` with `disable-model-invocation: true`. Spawn sites live in each skill's `sub-agent-prompts.md`.
- Seven agents in `plugin/agents/`: `codebase-locator` (haiku), `pattern-finder` (haiku), `codebase-analyzer` (sonnet), `product-behavior-analyzer` (sonnet), `research-validator` (sonnet), `task-verifier` (sonnet), `task-worker` (no model — per-spawn override by design).
- Model selection priority: `CLAUDE_CODE_SUBAGENT_MODEL` env → per-spawn override → agent frontmatter → inherit session model.
- Research fan-outs (create_research, create_product_research, create_design, create_execution, create_mockup): 3–5 parallel read-only agents on haiku/sonnet. Correctly calibrated; little to gain.
- `implement_tasks`: single-agent, main session does all TDD work; no model selection.
- `implement_coordinated`: sequential coordinator+worker loop. Coordinator judges tier per task (SKILL.md:181-185): haiku = simple (config/docs/renames), sonnet = standard implementation, **opus = everything else / DEFAULT when unsure**. Fix workers on verification FAIL: opus (both retries). `determineModel()` regex was retired 2026-06 (prompts-0my) in favor of coordinator judgment.
- Skill frontmatter models: `validate_execution` and `research-validation` carry `model: sonnet` + `effort: high`.
- Only stale literal ID: `create_handoff/templates.md:246` placeholder `[claude-3-sonnet/opus/haiku]`.

## 3. Cost-Efficiency Map (proposed recalibration)

Governing principle: **pay for judgment, not throughput** — and (from the RIPER analysis, §5) **model cost should track a mode's degrees of freedom, not the artifact's difficulty**. Constrained modes are safe on cheap models; divergent modes are where expensive judgment pays.

The verify-then-retry architecture (worker → task-verifier → opus escalation) is what makes cheap-worker-by-default safe: we're not trusting Sonnet blindly.

### Orchestrator (main session) per stage

| Stage | Recommended session model | Rationale |
| ------- | -------------------------- | ----------- |
| create_project, create_handoff, help | Sonnet 5 | Interviews and doc writing; Opus is overkill |
| create_research / create_product_research | Sonnet 5 (high) | Synthesis of subagent reports is in Sonnet 5's competence now |
| **explore_design (new stage)** | **Fable 5** | Divergent, judgment-dense, human-in-the-loop; Fable's only clear home in the workflow |
| create_design | Opus 4.8 (drops toward Sonnet once explore_design exists) | Documents an already-made decision instead of silently making one |
| create_execution | Opus 4.8 | Decomposition quality determines how well cheap workers perform |
| implement_coordinated (coordinator) | Opus 4.8 | Doesn't code; judges tiers, parses reports, holds long session. Fable = $10/$50 dispatcher, overkill |
| implement_tasks (single-agent) | Sonnet 5 @ xhigh | It does the coding itself |
| validate_execution | Keep `sonnet` + `effort: high`; consider opus for release gates | Already pinned sensibly |

### Subagent spawn-site verdicts

| Site | Current | Verdict |
| ------ | --------- | --------- |
| Locators + pattern-finders (all skills) | haiku | Keep. Grep/glob work; 200K context fine for tool-limited agents |
| Analyzers (research/design/execution) | sonnet | Keep; consider `effort: medium` for gathering work |
| create_mockup analyzers | haiku (deliberate downgrade) | Revisit: Sonnet 5 @ low effort degrades gracefully; intro pricing narrows the gap to ~2× |
| research-validator, task-verifier | sonnet | Keep; add `effort: high`. Don't drop to haiku — missed failures are the expensive outcome |
| **task-worker tier table** | haiku / sonnet / **opus default-when-unsure** | **Flip the default**: haiku = mechanical only; **Sonnet 5 (xhigh) = default when unsure** incl. bugs/refactors; opus = architectural, cross-cutting, or previously-failed tasks. Biggest recurring saving |
| Fix workers on FAIL | opus ×2 | Keep — escalation on verified failure is correct. Optional: retry 1 = sonnet xhigh, retry 2 = opus |
| validate_execution `general-purpose` regression check | haiku | Keep — mechanical |

### Implied changes (mostly separate from this project's scope)

1. `implement_coordinated/SKILL.md:181-185` + `README.md:43-47` — Sonnet-default tier table.
2. `CLAUDE.md:158-164` — four tiers + effort lever guidance.
3. `effort:` annotations on agent frontmatter/spawns (workers xhigh, analyzers medium, verifiers high).
4. create_mockup haiku overrides → reconsider as sonnet + low effort.
5. Housekeeping: stale `claude-3-*` placeholder in `create_handoff/templates.md:246`.

## 4. The Gap: No Discrete Design Discussion

`create_design` is a *documentation* step, not a *decision* step: it reads research.md, fans out three read-only agents, and writes design.md in a single pass. The architectural choice happens implicitly — no divergence, no explored alternatives, no structured back-and-forth with the human. The philosophy says design.md captures "WHAT and WHY," but nothing ever generates competing WHATs.

That's also why Fable had no home: every existing stage is artifact production; Fable's value is judgment and thought partnership.

### Proposed stage (working name: `explore_design` / `create_options`)

Flow becomes: `create_project → create_research → explore_design → create_design → create_execution → …`

1. **Input**: research.md, read fully (BARRIER 1).
2. **Diverge**: 2–4 genuinely distinct architectural directions with trade-offs. Cost-efficient even in a Fable session: optionally fan out one Sonnet/Opus subagent per direction to *draft* it, so Fable spends tokens judging and comparing, not typing.
3. **Discuss**: interactive trade-off interview with the user (same pattern as create_project's interview) — what breaks under each option, what's irreversible, what risk precedents imply.
4. **Converge and record**: decision + rationale via `bd decision`; the exploration itself (all directions considered, trade-off discussion) is preserved under `thoughts/`. Note: `thoughts/` is not a graveyard for rejected alternatives — by convention it holds *any* exploratory work that may or may not be taken into account in the final plan (this pre-work doc is itself an example).
5. **Hand off**: create_design documents the chosen architecture (cheaper session).

### Why a separate skill, not a phase inside create_design

- Skill frontmatter `model:` applies to the whole run — separate skill lets `model: fable` cover only the discussion.
- Optional and gated: small changes skip it; keeps the fast path fast.
- The decision gets its own ⛔ CHECKPOINT — human approves a direction before anything downstream consumes it.

### Invocation criteria (for the skill description)

Research surfaced multiple viable approaches; change is cross-cutting or introduces a new subsystem; choice is hard to reverse (schema, API contract, new dependency); wrong architecture would cascade. Otherwise go straight to create_design.

## 5. RIPER Analysis

The wb workflow is almost RIPER (Research → Innovate → Plan → Execute → Review); the missing mode is Innovate:

| RIPER mode | Rule | wb equivalent |
| ------------ | ------ | --------------- |
| Research | Gather only; no suggestions | create_research ("Document, Don't Judge") |
| **Innovate** | Ideas as *possibilities*, never decisions; no planning, no code | **Missing — this project** |
| Plan | Exhaustive spec; no implementation | create_design + create_execution (wb splits WHAT/WHY from HOW) |
| Execute | Implement *exactly* the plan; deviation → return to Plan | implement_tasks / implement_coordinated ("Zero Scope Creep") |
| Review | Validate against plan; explicit verdict | validate_execution + task-verifier PASS/FAIL |

### Lessons to import

1. **Innovate is a first-class mode.** Import its rules verbatim into the new skill's philosophy: outputs are possibilities with trade-offs, never commitments; no implementation detail; convergence only on explicit user signal (maps to the existing "GO!" checkpoint pattern).
2. **Symmetric contamination rules.** Each stage's output spec should carry an explicit "must NOT contain" list, the way research.md already forbids recommendations. Design.md must not contain task breakdowns; the options doc must not contain a chosen answer unless the user chose it.
3. **Formal deviation protocol in Execute.** wb handles *implementation* failure (fix-worker retries) but not *plan* failure. When a worker/verifier report reveals the design doesn't survive contact with the code: coordinator files a `bd create` design-revision issue, blocks dependent tasks (`bd dep add`), and halts the phase for a human checkpoint — instead of burning two opus retries on a task that can't succeed as specified.
4. **Degrees-of-freedom pricing** (already folded into §3): Execute's strictness is exactly what makes cheap models safe there; Innovate's openness is why Fable belongs there and nowhere else.

### What NOT to take from RIPER

Its enforcement mechanism. RIPER polices modes via prompt discipline in a single session (known failure mode: mode drift). wb is structurally stronger — modes are separate skills with durable artifacts, state lives in beads, verification is done by independent agents. Import RIPER's *rules*, keep wb's *enforcement*.

## 6. Open Questions (for research/design phases)

- Skill name: `explore_design`, `create_options`, or something else consistent with the `create_*` verb convention?
- Output artifact: dedicated `options.md` in the project dir, or a `thoughts/` doc + `bd decision` records only?
- Should the stage fan out drafting subagents (one per direction) or have the Fable session draft directions itself? Cost vs. coherence trade-off.
- How does `create_design` detect/consume the stage's output when present, and behave unchanged when absent (optional-stage compatibility)?
- Does `model: fable` in skill frontmatter behave as expected in the current plugin runtime (`haiku|sonnet|opus|fable|<full-id>|inherit` is documented at docs/claude-code-skills-guide.md:83)?
- Do the contamination lists and deviation protocol (§5 lessons 2–3) belong in this project's scope or a follow-up? They touch other skills (create_design, implement_coordinated).
- Where do `bd decision` records live relative to design.md — is the decision log the source of truth and design.md the narrative, or vice versa?
