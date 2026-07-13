---
project: explore-design-stage
created: 2026-07-10
status: exploration
author: gabevarela
topic: architecture direction for the explore_design stage (ad-hoc run of the stage on itself)
git_branch: modernize-2.0
repository: gvarela/workbench
tags: [thoughts, exploration, innovate-session, explore-design-stage]
---

# Innovate Session: Architecture of the explore_design Stage

This document is the exploration record of a **manual, ad-hoc run of the proposed stage on itself** — conducted 2026-07-10 in a Fable session, following the process the stage will eventually codify (frame → diverge → discuss → converge → record). It doubles as the first worked example / fixture for the skill's design.

Inputs: [research.md](../research.md) (status: complete), [pre-work doc](2026-07-10-model-strategy-and-riper-prework.md).
Output: closed `Decide:` beads issue (see Synthesis below) → consumed by `/wb:create_design`.

## Decision Space (framed and confirmed by user)

1. **Integration shape** — new skill vs. extend create_design Step 4 vs. `context: fork` variant. *(User pre-locked: separate skill.)*
2. **Artifact strategy** — formal `options.md`/`exploration.md` vs. thoughts/-only + decision records vs. seeding design.md directly.
3. **Divergence mechanics** — session drafts vs. subagent-per-direction fan-out vs. adaptive.
4. **Model selection** — frontmatter `model: fable` pin vs. guidance vs. guidance + tripwire. User constraint: must adapt to usage limits (e.g. fall back to Opus).
5. **Decision recording** — existing `Decide:` title-prefix convention vs. introducing `bd decision`.

## Directions Drafted

**A — "Structured conversation"**: no new artifact; thoughts/ doc + closed `Decide:` issue; session drafts; no model pin. Cheapest, most adaptable; weakest hand-off (fuzzy detection), highest mode-drift risk.

**B — "First-class optional stage"**: formal `exploration.md` with `status`/`chosen_direction` frontmatter (create_product_research pattern); subagent-per-direction fan-out; frontmatter `model: fable` pin; introduce `bd decision`. Strongest structure and machine-readable hand-off; highest build cost; static pin conflicts with the usage-limits requirement; mandatory fan-out is overkill at small scope.

**C — "Seed the design doc"**: stage writes `design_approach` frontmatter + Design Approach / Rejected Alternatives sections into design.md directly; create_design completes the rest; adaptive divergence; guidance + tripwire model selection. Honors "end output is design.md" most literally; co-authoring design.md collides with update_status's single-writer transition rules (update_status/reference.md:1-56).

## Discussion (key moves, in order)

1. **Thought-partner reframing** (user): the stage is a thought partner; problem scope may be small or large → fixed-weight designs (B's mandatory fan-out, A's minimal record) both fail one end of the scale.
2. **Ambient-context finding**: create_design formally reads only research.md + placeholder design.md + the beads Q-gate (create_design/SKILL.md:59-93); *what is being decided* otherwise comes from ephemeral session context. create_handoff snapshotting "conversation history" (create_handoff/SKILL.md:49) is the repo's tacit admission that this context is load-bearing and evaporates. → The stage's real job: convert the ephemeral part (framing, directions, rationale) into something durable.
3. **Three-layer model**: Capture (continuous, low-ceremony thoughts/ writing during the session) → Synthesis (small fixed-shape decision record) → Specification (create_design formalizes decision into full design.md: scope, success criteria, risks, integration). create_design shifts from decider to formalizer; Step 4 becomes confirm-not-generate when a decision exists.
4. **Cold-start test** (acceptance criterion): create_design must produce the same design.md in a fresh session with zero conversational history, from research.md + decision record + referenced thoughts docs alone. Same-session context becomes optimization, not dependency.
5. **"Fixed hand-off, elastic exploration"**: exploration artifact scales with problem size; the hand-off create_design consumes is the same small predictable thing regardless.
6. **Precedent**: create_mockup already does continuous capture + decision synthesis (versioned mockups/v00N/ + decisions.md + mockup-log.md feeding design.md — create_mockup/SKILL.md:278-288). This direction generalizes that architecture from UI to architecture decisions.
7. **Pressure test — small bug fix with Jira ticket**: ticket-ref is first-class in create_project ($3 arg, dir naming, frontmatter). Stage never fires (user-only: description never enters context — docs/claude-code-skills-guide.md:96,128); create_design's consume-decision logic is a no-op when absent. Zero added weight on the fast path. Failure mode is inverted: forgetting the stage when warranted → the nudge sub-decision.
8. **Nudge options**: none / create_research exit nudge / create_design entry tripwire / both.

## Synthesis — Converged Direction: "Adaptive thought partner"

Explicit user convergence (GO) on 2026-07-10:

1. **Separate, user-only skill** (working name `explore_design`; final name confirmed at design). Invocation criteria and explicit non-triggers documented in skill description and help.
2. **Three layers**: continuous thoughts/ capture (frontmatter-only convention: topic, status, date; no required internal structure) → fixed synthesis: closed `Decide:` issue carrying choice + rationale + links to thoughts docs → design.md untouched by the stage, remains the sole formal design artifact.
3. **create_design = formalizer**: BARRIER 1 reading list grows by closed `Decide:` issues + referenced thoughts docs; Step 4 confirms recorded decision when present, generates as today when absent. Acceptance: cold-start test.
4. **Elastic exploration, fixed hand-off**: session drafts directions by default; fan out drafting subagents only when scope warrants (runtime judgment, coordinator-style).
5. **Model: guidance + tripwire, no pin**: `effort: high` frontmatter only; skill opens with a self-check ("this stage wants the strongest available model — surface to user if session is below Opus"); docs recommend Fable. Satisfies usage-limit fallback. Consequence: prompts-7mj (fable frontmatter runtime verification) closed as non-blocking.
6. **Decision records**: existing `Decide:` prefix convention; `bd decision` not introduced.
7. **Nudge**: create_research exit nudge — completion summary suggests explore_design only when findings genuinely show multiple viable approaches. create_design entry unchanged.

## Rejected (with reasons — kept per thoughts/ convention as explored options, not failures)

- **B's formal `exploration.md` artifact**: machine-readable hand-off was the attraction; rejected because a fixed schema fights elastic scope and adds a new artifact type per project — the closed `Decide:` issue provides the machine-readable hand-off at a fraction of the ceremony. B's fan-out survives as the "when warranted" branch of adaptive divergence.
- **B's `model: fable` frontmatter pin**: conflicts directly with the usage-limits adaptability requirement; static frontmatter cannot express fallback.
- **B's `bd decision` adoption**: a second decision mechanism alongside the existing `Decide:` prefix convention adds practice surface without adding capability the prefix lacks.
- **C's design.md seeding**: two skills co-authoring design.md collides with update_status's single-writer status-transition rules and muddies artifact ownership; "end output is design.md" is honored instead by create_design consuming the decision record.
- **A-pure (no machine-readable hand-off)**: fuzzy thoughts-doc detection makes the cold-start test unreliable.

## Deferred to design phase

- Final skill name (`explore_design` working name; verb_noun convention check).
- Exact `Decide:` record shape (fields in description/close-reason; linking format to thoughts docs).
- Exact create_design contract wording (BARRIER 1 addition + Step 4 confirm branch) and create_research exit-nudge wording/trigger condition.
- Invocation criteria + non-trigger list wording.
- Whether pre-work lessons 2–3 (symmetric contamination lists, plan-defect deviation protocol) ride along in this project or split to a follow-up.
