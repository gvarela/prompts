---
project: explore-design-stage
ticket: null
created: 2026-07-10
created_timestamp: 2026-07-10T22:13:38Z
status: ready
last_updated: 2026-07-10
designer: gabevarela
git_commit: 0c1250840dbce9ab373a6d718a2600e4489539f9
git_branch: modernize-2.0
repository: gvarela/workbench
tags: [design, architecture, explore-design-stage]
depends_on: research.md
design_approach: Adaptive thought partner
---

# Design: explore_design Stage

## Problem Statement

The wb workflow has no stage where architectural alternatives are explored with the human before being documented. `create_design` decides and documents in a single pass: its Step 4 generates 2–3 options from research alone (`create_design/SKILL.md:133-166`), and everything that shapes the decision beyond research.md — the framing, priorities, constraints discussed with the user — lives only in ephemeral session context. The repo tacitly admits this context is load-bearing: `create_handoff` explicitly snapshots "conversation history" (`create_handoff/SKILL.md:49`) because the thinking dies with the session.

Consequences: architectural decisions get no genuine divergence; exploration is never durable; `create_design` cannot run cold (a fresh session knows only research.md); and the workflow has no home for its highest-judgment model tier (Fable) — every existing stage is artifact production, while Fable's value is thought partnership.

In RIPER terms, the workflow implements Research, Plan, Execute, and Review but lacks Innovate — the mode where ideas are possibilities, never commitments, and convergence happens only on explicit user signal.

### Success Metrics

- `create_design` passes a **cold-start test**: run in a fresh session with zero conversational history, it produces an equivalent design.md from durable artifacts alone (research.md + decision record + referenced thoughts docs)
- The fast path pays **zero cost**: a project that skips the stage (e.g. a small ticketed bug fix) sees no new prompts, no new files, no behavior change in any other skill
- Exploration is durable: after an explore_design session, a reader who wasn't present can reconstruct what was considered, what was chosen, and why

## Design Approach

**Adaptive thought partner** — a separate, optional, user-only workflow-stage skill named `explore_design`, positioned between `create_research` and `create_design`, that runs a facilitated architecture discussion (frame → diverge → discuss → converge → record) and produces two durable outputs: an elastic exploration record in `thoughts/` and a fixed-shape decision record as a closed `Decide:` beads issue. `create_design` becomes a **formalizer**: it consumes the decision record when one exists (Step 4 confirms instead of generates) and behaves exactly as today when none does.

The stage's weight adapts to the problem: for a large decision space it frames axes, drafts multiple directions, and runs a trade-off interview; for a small one it is a short conversation with a one-note record. What never varies is the hand-off shape — "fixed hand-off, elastic exploration."

### Why This Approach

- **Converts ephemeral context into durable artifacts** — the stage's core job is capturing the thinking that today evaporates between sessions, which is what makes the cold-start test achievable.
- **Follows the proven optional-stage precedent** — `create_product_research` runs standalone or in-pipeline with its own outputs and no adjacent-contract changes (`create_product_research/SKILL.md:61-67`); `create_mockup` already demonstrates continuous capture + decision synthesis feeding design.md (`create_mockup/SKILL.md:278-288`) and is listed "(optional)" in every workflow rendering — the notation this stage reuses.
- **Preserves design.md as the sole formal design artifact** — the stage writes no formal pipeline artifact, so `update_status`'s single-writer transition rules (`update_status/reference.md:1-56`) and the `depends_on` chain are untouched.
- **Matches the degrees-of-freedom cost principle** — the most divergent mode in the workflow gets the strongest model (Fable recommended), while constrained stages stay cheap; recorded in the model-strategy decisions (`prompts-2b5`).
- **Mechanically incapable of adding fast-path weight** — as a `disable-model-invocation: true` skill its description is never loaded into context (docs/claude-code-skills-guide.md:96, :128); it cannot fire by accident.

Decision provenance: converged with explicit user approval 2026-07-10 (closed `prompts-ar9`); exploration in [thoughts/2026-07-10-innovate-session-stage-architecture.md](thoughts/2026-07-10-innovate-session-stage-architecture.md); four integration micro-decisions resolved during this design (recorded below).

## Technical Decisions

### Architecture

- **Separate user-only skill** (`plugin/skills/explore_design/`, standard stage frontmatter: `disable-model-invocation: true`, `allowed-tools: Read`)
  - Rationale: optionality with a mechanical guarantee; its own convergence CHECKPOINT; independent evolution from create_design
  - Trade-off: one more skill to maintain vs. a phase inside create_design
  - Pattern reference: `create_product_research/SKILL.md:61-67` (standalone-or-pipeline), stage-skill skeleton per research.md Workflow-Stage Skill Anatomy

- **Three-layer output model**: continuous capture (thoughts/) → synthesis (closed `Decide:` issue) → specification (design.md, written later by create_design)
  - Rationale: fidelity where it's cheap, structure only at the hand-off point, no new formal artifact type
  - Trade-off: no machine-validated exploration schema; cold-readability of thoughts docs depends on the skill's capture instructions
  - Pattern reference: `create_mockup` mockup-log.md/decisions.md continuous-capture precedent

- **Innovate-mode content rules** (the skill's own contamination list): outputs are possibilities with trade-offs, never commitments; no implementation detail; no task breakdowns; no chosen answer unless the user chose it; convergence only on explicit user signal (same approval language as `create_design/SKILL.md:166`)
  - Rationale: RIPER's Innovate rules imported into wb's stronger enforcement structure (separate skill + durable artifacts + gates)

- **Elastic exploration, fixed hand-off**: the session drafts directions itself by default and may fan out drafting subagents only when scope warrants (runtime judgment, mirroring `implement_coordinated/SKILL.md:181-184` coordinator judgment)
  - Trade-off: no fixed fan-out means run-to-run variance in exploration depth; accepted as inherent to a thought-partner stage

- **Model: guidance + tripwire, no pin**: frontmatter carries `effort: high` only; the skill opens with a self-check instructing the session to surface to the user when running below Opus; documentation recommends Fable
  - Rationale: static `model:` frontmatter cannot express usage-limit fallback (Fable → Opus); adaptability was a hard requirement
  - Trade-off: nothing enforces the strong model; accepted (rejected pin recorded in Rejected Alternatives)

### Data Model

- **Decision record** (the fixed hand-off): a beads issue titled `Decide: [decision summary]`, priority 1, created and closed within the stage; the description carries options considered + trade-offs, the close reason carries the chosen direction + rationale + relative path(s) to the exploration doc(s)
  - **Lifecycle semantics (clarifying, not changing, the existing convention)**: an *open* `Decide:` issue = pending decision (today's usage, `create_design/templates.md:111-126`); a *closed* `Decide:` issue = decision made, rationale in close reason. explore_design compresses create→close into one session because the decision is made there. Consumption queries `bd list -n 0 --status=closed | grep "Decide:"` — a new query pattern (all existing prefix greps filter `--status=open`), which is why it must be specified here rather than assumed
- **Exploration record**: one or more markdown docs under `docs/plans/<project>/thoughts/`, carrying the established minimal frontmatter (project, created, status: exploration, topic, tags); no required internal structure. Consistent with `project-structure/SKILL.md:24-35` as-is (no change to that skill needed)
- **No new formal artifact**: design.md frontmatter (`design_approach`, `depends_on: research.md`) and status progressions are unchanged

### Integration Points

- **create_design (consumer)**: BARRIER 1 reading set (`create_design/SKILL.md:68-76`) additionally includes closed `Decide:` issues for the project and the thoughts docs they reference; Step 4 (`:133-166`) gains a conditional branch — when a decision record exists, present it for confirmation and proceed on approval; when none exists, current behavior verbatim. Synchronization Points list (`:296-302`) gains the conditional entry
- **create_research (nudge)**: Step 8 completion summary (`create_research/SKILL.md:176-203`, the "Next:" line at `:201`) and templates.md Next Steps (`create_research/templates.md:121-129`) gain a conditional suggestion of `/wb:explore_design` **only when findings show multiple viable approaches** (assumption `prompts-01d` tracks nudge-trigger reliability)
- **validate_project (conflict resolution)**: its orphaned-beads-issue detection (`validate_project/reference.md:78-99`) exempts issues whose titles carry the four planning prefixes (`Q:`, `Decide:`, `Validate:`, `UI Q:`) — these are planning-phase records intentionally not anchored in tasks.md frontmatter
- **Workflow-sequence renderings**: all listings add explore_design with the "(optional)" notation used by create_mockup today — CLAUDE.md:86, README.md:47-72, docs/commands-reference.md:24 + :581-626 + :719-722, docs/workbench-workflow-guide.md:24-57 + :162-166, plugin/skills/help/SKILL.md:28-42 + :153-169, create_project/templates.md:24-50 + :260-301, create_mockup/SKILL.md:278-288, create_product_research/SKILL.md:277 + templates.md:135
- **Beads**: uses only existing verbs (`bd create`, `bd close`, `bd list`); `plugin.json` unaffected (skills are filesystem-discovered); release requires the standard synchronized version bump in both manifests per RELEASING.md

## Scope Definition

### In Scope

- New skill `plugin/skills/explore_design/` (SKILL.md core ≤ ~500 lines + supporting files per the standard convention)
- create_design consumption branch (BARRIER 1 read set + Step 4 conditional + sync-points entry)
- create_research conditional exit nudge (SKILL.md Step 8 + templates.md Next Steps)
- validate_project planning-prefix exemption in orphan detection
- "(optional)" additions to all workflow-sequence renderings listed in Integration Points
- help skill documentation of the stage and the closed-`Decide:` record semantics
- Synchronized version bump (2.0.0 → 2.1.0, new feature) in plugin.json + marketplace.json

### Out of Scope

- Retrofitting contamination lists onto other stages — tracked as `prompts-4q0`
- Plan-defect deviation protocol in implement_coordinated — tracked as `prompts-vv8`
- Model recalibration work — already tracked (`prompts-v4e`, `prompts-bbt`, `prompts-hls`, `prompts-f9r`, `prompts-0ar`, `prompts-1sr`)
- Introducing `bd decision` as a practice (rejected below)
- Any change to update_status, implement_tasks, implement_coordinated, create_execution, or the design.md/tasks.md templates
- Eval-harness fixtures for the stage (this project's own artifacts serve as the first worked example; formal evals belong to the wb-eval-harness project)

## Success Criteria

### Functional Requirements

- [ ] `/wb:explore_design [project-directory]` runs against a project with `research.md` status: complete; refuses (with guidance) when research is missing or incomplete
- [ ] The stage frames the decision space, presents directions as possibilities (per its contamination list), and converges only on an explicit user signal
- [ ] On convergence it produces ≥1 thoughts/ doc with the minimal frontmatter and a closed `Decide:` issue whose close reason contains the chosen direction, rationale, and thoughts-doc path(s)
- [ ] `create_design` in a **fresh session** detects the closed decision record, presents it for confirmation at Step 4, and produces a design.md consistent with the recorded decision (cold-start test)
- [ ] `create_design` on a project with **no** decision record behaves byte-for-byte as today (fast-path no-op)
- [ ] `create_research`'s completion summary suggests explore_design only when findings show multiple viable approaches
- [ ] `validate_project` reports no orphan warnings for `Q:`/`Decide:`/`Validate:`/`UI Q:` issues; still flags genuinely orphaned execution-phase issues
- [ ] The skill's model self-check surfaces a warning when the session runs below Opus

### Non-Functional Requirements

- [ ] Zero fast-path cost: no new context load for sessions that never invoke the stage (user-only invocation; description not loaded)
- [ ] SKILL.md core stays within the ~500-line ceiling; supporting files use imperative "Read X NOW" pointers
- [ ] All touched markdown passes `plugin/scripts/lint`
- [ ] Release ships as one version bump with both manifests synchronized (main stays releasable per RELEASING.md)

## Risk Analysis

### Technical Risks

| Risk | Impact | Likelihood | Mitigation |
| ------ | -------- | ------------ | ------------ |
| Nudge miscalibration (over-fires on small fixes / under-fires on real forks) | Med | Med | Trigger condition worded conservatively; tracked as assumption `prompts-01d`; tune from dogfooding |
| Closed-`Decide:` consumption grep is novel (no existing closed-by-prefix query) | Med | Low | Semantics specified in this design + help skill; cold-start test exercises it directly |
| Thoughts docs unreadable cold (capture too loose for a fresh create_design session) | Med | Med | Skill's capture instructions require a synthesis section; decision record carries the essential summary independently |
| Mode drift inside the stage (session commits early, skips divergence) | Med | Med | Contamination list + explicit convergence CHECKPOINT in the skill core (not tail), per compaction-truncation lesson from prompt-modernization |
| Stage forgotten when warranted | Low | Med | create_research exit nudge; help + sequence docs list the stage with invocation criteria |

### Assumptions

Based on knowledge gaps from research - track in beads to ensure validation:

| Assumption | Beads ID | Validated? |
|------------|----------|------------|
| create_research sessions can reliably judge "multiple viable approaches" for the exit nudge | `prompts-01d` | Pending |

## Rejected Alternatives

### Option: First-class exploration artifact (`exploration.md` with frontmatter hand-off)

- **Approach**: Formal artifact beside research.md with `status`/`chosen_direction` frontmatter, subagent-per-direction fan-out, `bd decision` records (Direction B in the exploration)
- **Rejected because**: fixed schema fights elastic scope; new artifact type per project; the closed `Decide:` issue delivers the machine-readable hand-off at a fraction of the ceremony. Its fan-out idea survives as the "when warranted" branch of adaptive divergence
- **Trade-offs**: gave up machine-validated exploration structure; kept minimalism and scope-elasticity

### Option: `model: fable` frontmatter pin

- **Rejected because**: static frontmatter cannot express usage-limit fallback (Fable → Opus) — a hard requirement. Also independently listed among retired patterns in the risk-precedent review
- **Trade-offs**: gave up enforcement; kept adaptability

### Option: Seeding design.md directly from the stage (Direction C)

- **Approach**: Stage writes `design_approach` frontmatter and Design Approach / Rejected Alternatives sections; create_design completes the rest
- **Rejected because**: two skills co-authoring design.md collides with update_status's single-writer transition rules and muddies artifact ownership
- **Trade-offs**: gave up the most literal "output is design.md" reading; kept clean stage ownership

### Option: Introducing `bd decision`

- **Rejected because**: a second decision mechanism alongside the established `Decide:` prefix adds practice surface without adding capability; the prefix convention extended with closed-state semantics covers the need

### Option: Pure-conversation stage (no machine-readable hand-off)

- **Rejected because**: fuzzy thoughts-doc detection makes the cold-start test unreliable; create_design needs a predictable consumption target

## Pending Decisions

None. All design decisions were resolved before or during this design session — provenance: closed `prompts-ar9` (stage architecture), closed `prompts-2b5` (model recalibration context), and the four integration micro-decisions approved 2026-07-10 (validate_project prefix exemption; all sequence renderings updated with "(optional)" notation; skill name `explore_design`; RIPER retrofits split to `prompts-4q0`/`prompts-vv8`).

| Decision Needed | Beads ID | Blocks |
|-----------------|----------|--------|
| — | — | — |

## References

- Research: [research.md](research.md)
- Exploration: [thoughts/2026-07-10-innovate-session-stage-architecture.md](thoughts/2026-07-10-innovate-session-stage-architecture.md)
- Pre-work: [thoughts/2026-07-10-model-strategy-and-riper-prework.md](thoughts/2026-07-10-model-strategy-and-riper-prework.md)
- Decision records: closed beads `prompts-ar9`, `prompts-2b5`
- Precedents: `create_product_research` (optional stage), `create_mockup` (continuous capture + optional notation), prompt-modernization project (restructure playbook, parity gating)
