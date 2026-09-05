---
project: fable-5-1-rebaseline
ticket: prompts-678
created: 2026-09-01
status: complete
last_updated: 2026-09-05
git_commit: 70c50bd
git_branch: main
repository: workbench
designer: gabe@vare.la
depends_on: research.md
design_approach: additive-first-trims-gated
status_note: approved via /wb:create_tasks invocation 2026-09-01; D9/D10 AGENTS.md mirror dropped 2026-09-05 when AGENTS.md was removed
---

# Design: Fable 5.1 Re-baseline

## Problem Statement

The plugin's model strategy and prompt text were calibrated against the Claude 4 generation and re-tuned once in July for Sonnet 5. Fable 5.1 changes two things. It moves the ceiling on long-horizon, multi-file coding, and its published behavior notes name failure modes the skills do not guard against (whole-file rewrites, adjacent fixes, early stopping in autonomous runs) and uplifts the skills do not exploit (a memory surface, stated reasons). At the same time the vendor states that prompts written for prior models are often too prescriptive for it and reduce output quality, which reopens the Phase 4 trims deferred from prompt-modernization.

The premise does not change: consistent execution at controlled cost. Fable goes only where a failure is expensive to detect or retry; cheaper models stay where a failure is cheap to detect.

### Success Metrics

- Every Fable 5.1 behavior note that applies to an implementation or handoff context (research.md §3) has a corresponding line in the skill or agent that runs that context, or a recorded reason for its absence
- Escalation after verified failure targets Fable with a bounded attempt count
- create_tasks warns when run below Opus, the same way explore_design does
- Each deferred Phase 4 trim (R1, R3, R4) has a recorded disposition: applied with trial evidence, reverted with evidence, or skipped with reason
- The project CLAUDE.md no longer mandates the patterns the trims remove

## Design Approach

Two phases in evidence order, then release. Phase 1 is additive: it inserts guidance and routing without removing anything, so it needs no behavioral gate. Phase 2 resurrects the deferred trims and gates each on blind trials run on Sonnet, the weakest model the stage skills run on. Judgment-level de-prescription (rewriting numbered choreography as goals and constraints) is out of scope; it is recorded as a pending decision for a successor once Phase 2 evidence exists.

### Why This Approach

- The prompt-audit keep list is explicit that re-baselining sometimes adds text; additions that target documented failure modes carry the vendor's evidence and remove nothing that might be load-bearing
- The July model-strategy decision (prompts-2b5) established acting on current-model reasoning rather than gating a guess against a guess; the Fable 5.1 notes are stronger evidence than that decision had
- The scaffolding policy from prompt-modernization ("presumed load-bearing") still governs removals, so trims keep their gate; the blind-trial method is available now and the harness is not

## Technical Decisions

### D1: Fable is the escalation target, one attempt, then the checkpoint

- Decision: on a verified FAIL, the first fix worker spawns with a `fable` override at `effort: high`. If re-verification fails again, the task goes to the phase checkpoint's blocking list. No second Fable retry.
- Rationale: escalation is the one worker slot that is, by construction, in the tail of the difficulty distribution, where model ceiling matters and per-token price does not dominate. Two Fable retries on a plan defect is the expensive failure mode; the existing plan-defect protocol already routes those to a human. This revises call (2) of prompts-2b5 by extending the ladder one rung; the Sonnet default and the absence of a same-tier retry stand.
- Trade-off: users without Fable access need the fallback. The spawn prompt states "opus if fable is unavailable."

### D2: create_tasks gets the explore_design self-check, not a frontmatter pin

- Decision: add a "Model Self-Check" block to create_tasks/SKILL.md recommending Fable with Opus as the comfortable minimum, warning below Opus, never blocking. No `model:` line.
- Rationale: the judgment steps (bridging, phasing, task bodies, dependency graph) all run on the session model; the sub-agents are fact-gatherers and stay pinned. A pin forces the cost on every run and breaks for users without access; the self-check keeps the cost premise in the user's hands, which is the pattern explore_design already established.

### D3: Fable spawns run at `effort: high`

- Decision: wherever the tier rule says "set `effort: xhigh` for sonnet or opus," Fable spawns are annotated `high`.
- Rationale: at xhigh on long deliverables Fable 5.1 drafts in thinking and writes again, roughly doubling output tokens; the vendor's recommended start is high. Worker output (a patch plus a report) is exactly that shape.

### D4: Add the four guardrail lines to implementation contexts

- Decision: task-worker.md and implement_tasks/SKILL.md gain (a) a surgical-edit sentence and (b) a follow-ups-not-fixes sentence beside the existing scope rules, ending with the clause that every requested behavior is still implemented completely. implement_coordinated's worker prompt template inherits both through task-worker. The existing NEVER lines and ZERO SCOPE CREEP stay verbatim.
- Rationale: whole-file rewrites and adjacent fixes are documented 5.1 failures with published one-line fixes; the scope rules are prohibitions against a current failure and are on the keep list. The completeness clause guards the one regression risk, under-delivery.

### D5: Memory surface is `bd remember`, with a format and a hygiene rule

- Decision: implement_tasks, implement_coordinated, and create_handoff tell the session where to record durable learnings (`bd remember --key <slug> "<fact>"`), what qualifies (a constraint or convention that would change how the next session works, not a task outcome), and that create_handoff reviews the session's entries. Exploratory notes still go to thoughts/. tasks.md Implementation Notes remain for per-project discoveries.
- Rationale: the vendor reports a notable uplift from any memory surface; the repository already uses `bd remember` and prohibits MEMORY.md files, so no new mechanism is introduced. The hygiene rule addresses the recency trap: beads memory is workspace-wide, and one session's stumble must not become a permanent rule.

### D6: Autonomy reminder, scoped to workers and the coordinator's task loop

- Decision: task-worker.md and the implement_coordinated task loop carry the autonomous-operation paragraph (act on reversible actions without asking; before ending a turn, check that the last paragraph is not an unexecuted promise). The paragraph states that phase checkpoints and plan-defect halts are excluded.
- Rationale: phase work ships from background sessions where a text-only "I'll now run X" strands the run. The exclusion protects the human gates the workflow depends on; merge-as-checkpoint remains the confirmation path.

### D7: Give workers the reason

- Decision: the context package structure in implement_coordinated/reference.md gains one field: the phase goal and who it serves, copied from design.md, in one or two sentences.
- Rationale: the vendor reports better performance when the model understands intent rather than inferring it; the package already carries constraints, so this is one field, not a restructure.

### D8: Phase 4 trims resurrected, gated by blind trials on Sonnet

- Decision: R1, R3, and R4 proceed under the original Phase 4 protocol with one substitution: the gate is the blind-trial method (fresh-context Sonnet subagents, three fixtures including a trap, three trials each) instead of harness Tier 3 scenarios. Dispositions per trim:
  - R1: convert "think deeply"/"ultrathink" verbs to the focus statement that follows them; delete the two bare directives; no `effort:` frontmatter added (session effort is the user's setting in Claude Code)
  - R3: single-⛔ normalization with the reason stated in plain prose, applied only where the trap fixture passes at normal volume
  - R4: documentarian rule to three placements in the two research skills; scope-block content stays, volume drops (CRITICAL header and CAPS to plain sentences) only where the scope-creep trap passes
- Rationale: R1's keep-half rested on budget keywords mattering on thinking models; on the 5 family thinking is always on and effort is the lever, so the verb is redundant while the object of the sentence is still context. R3 now has evidence on one side (pressure language reduces 5.1 output quality) and the KEEP verdicts on the other; a trap fixture on Sonnet decides per site. R4's scope blocks are prohibitions against a demonstrated 5.1 failure and stay by the keep list; only their volume is in question.
- Trade-off: trials cost roughly 27k tokens each; a full R3 pass across all barrier sites is the largest single spend in the plan, so it runs on a representative sample of barrier types, not every site.

### D9: CLAUDE.md "Working with Commands" is rewritten before any trim lands

- Decision: the seven-item list becomes: mark real synchronization points once with a stated reason; state what to think about at decision points; documentarian philosophy; automated versus manual verification; read files fully; parallel agents, synthesize only after all return. The "think deeply" item and "all three barriers" wording are removed.
- Rationale: the list is the root that regenerates the patterns; trimming skills without changing it guarantees regression on the next skill written. AGENTS.md, which the first draft of this decision proposed to mirror, duplicated CLAUDE.md's session protocol and nothing else; it was removed on 2026-09-05.

### D10: Documentation of the model map

- Decision: the guide table adds a Fable row note for create_tasks (Fable recommended, Opus fallback), records `high` as the Fable effort, and adds an implement_tasks note that Fable is the choice for cross-cutting phases. CLAUDE.md:158-167 tier list updates `fable` to "architecture-critical discussion, decomposition, and escalation after verified failure" and adds the effort rule.

## Scope Definition

### In Scope

- Phase 1 additions: D1 through D7, D10
- Phase 2 trims: D8, D9
- Version bump and release notes

### Out of Scope

- Changing the Sonnet worker default or its `xhigh` effort (see thoughts/ for the Fable-at-low observation; requires a worker-shaped eval that does not exist)
- Rewriting judgment choreography (numbered sub-steps in create_tasks Step 3, ultrathink blocks in research) as goals and constraints; pending decision below
- Async spawn wording for BARRIER 2 (modest payoff; research stages wait on Sonnet where waiting is cheap; coordinated already runs workers in parallel)
- The wb-eval-harness project
- R15/R16 (parked in prompts-s6c)

## Success Criteria

### Functional Requirements

- [ ] task-worker.md and implement_tasks/SKILL.md carry the surgical-edit and follow-ups lines with the completeness clause
- [ ] implement_coordinated fix-worker prompt spawns `fable` at `high` with an opus fallback, one attempt, then the checkpoint list
- [ ] create_tasks/SKILL.md has a Model Self-Check block matching explore_design's shape
- [ ] implement_tasks, implement_coordinated, create_handoff reference `bd remember` with format and qualification rule
- [ ] task-worker.md and implement_coordinated task loop carry the autonomy paragraph with the checkpoint exclusion
- [ ] Context package structure has the phase-goal field
- [ ] R1, R3, R4 each have a disposition recorded in this project's tasks.md Implementation Notes and in the prompt-modernization research.md Final Disposition table
- [ ] CLAUDE.md "Working with Commands" rewritten

### Non-Functional Requirements

- [ ] `./plugin/scripts/lint --all` clean after each phase
- [ ] No barrier site changes volume without a passing trap trial recorded
- [ ] Phase 1 shipped and released before Phase 2 trials begin

## Risk Analysis

### Technical Risks

| Risk | Impact | Likelihood | Mitigation |
| ---- | ------ | ---------- | ---------- |
| Follow-ups line causes under-delivery | High | Low | Completeness clause; task-verifier already checks scope adherence both ways |
| Autonomy paragraph bulldozes a checkpoint | High | Low | Explicit exclusion; paragraph lives only in worker and task-loop contexts, never in stage skills |
| Memory pollution across projects | Med | Med | Qualification rule; handoff review step; `bd forget` noted |
| Fable escalation burns tokens on a plan defect | Med | Low | One attempt; plan-defect protocol already precedes retries |
| Trims regress Sonnet discipline | High | Low | Per-site trap trials; revert is one commit; skipping is a recorded success |
| `fable` per-spawn override not honored by the Agent tool | Med | Low | prompts-7mj verified frontmatter; task 1.2 verifies the per-spawn path on a dry run before the prompt ships |

### Assumptions

| Assumption | Validated? |
| ---------- | ---------- |
| A per-spawn `model: fable` override resolves for the Agent tool the way frontmatter does | Pending (task 1.2) |
| The blind-trial method discriminates on barrier volume, not only on nudge wording | Pending (task 2.2) |
| The lost Phase 4 beads issues can be recreated without loss of intent from tasks.md | Pending (task 2.1) |

## Rejected Alternatives

### Pin `model: fable` on create_tasks

- Rejected because: forces cost on every run and fails for users without access; the self-check pattern is already proven on explore_design.

### Wait for the eval harness before any change

- Rejected because: the harness is at research-needed with no design; Phase 1 removes nothing and needs no gate; Phase 2 has a validated cheaper gate. This was the original Phase 4 plan and it has not moved in three months.

### Strip scaffolding wholesale for Fable

- Rejected because: the stage skills run on Sonnet by default; the workbench premise is consistency on the weakest model that runs a stage. Previously rejected in prompt-modernization ("blanket emphasis-scaffolding deletion").

### Two Fable retries

- Rejected because: the second retry on a verified failure is far more likely to be a plan defect than a capability gap, and that path already has a human protocol.

## Pending Decisions

| Decision Needed | Blocks |
| --------------- | ------ |
| Whether to open a successor for judgment-level de-prescription on the Fable stages (create_tasks Step 3, create_design, explore_design) with an A/B on real plans | Nothing in this project; decide on Phase 2 evidence |
| Whether the Sonnet worker default moves to `high` with `xhigh` reserved for coordinator-flagged hard tasks | Nothing in this project; see thoughts/ |

## References

- Research: [research.md](research.md)
- Session analysis: [thoughts/2026-09-01-effort-curves-and-fable-routing.md](thoughts/2026-09-01-effort-curves-and-fable-routing.md)
- Deferred trims: [../2026-06-09-prompt-modernization/tasks.md](../2026-06-09-prompt-modernization/tasks.md) Phase 4
- July decision: closed beads issue prompts-2b5
