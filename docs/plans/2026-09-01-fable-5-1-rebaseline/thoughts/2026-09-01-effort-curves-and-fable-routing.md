# Effort curves and Fable routing — session analysis, 2026-09-01

Exploratory record of the discussion that seeded this project. Not a decision document; design.md holds the decisions.

## The question

Fable 5.1 "writes better code." The workbench premise is consistent execution at controlled cost. Where does the better model earn its price, and where do cheaper models stay?

## Reading the Sonnet 5 effort curves

Gabe's instinct was that Sonnet deteriorates at xhigh and suits high. The system card figures say otherwise for Sonnet 5: monotonic through max on FrontierCode, CursorBench, and HLE. The instinct has a real source in the previous generation — Sonnet 4.6 collapses at max on all three charts, and Opus 4.8 drops at max on FrontierCode. Sonnet 5 is the first Sonnet whose top end holds.

Two "deterioration" effects at xhigh that are real but are harness effects, not quality: more tmux timeouts in Terminus-2; the USAMO run stayed at high because xhigh exceeded the 300k token limit. The docs' overthinking caveat is attached to max only.

What that means for workers: Sonnet at xhigh is defensible. The marginal gain is measured on hard multi-file PR tasks; a decomposed beads task sits on the flatter part of the curve, so high is a reasonable default with xhigh for tasks the coordinator judges hard. This is a cost-per-task call, not a quality one.

## The Fable-at-low observation

On the same figures, Fable 5 at low scores above Sonnet 5 at xhigh on both coding benchmarks at roughly the same cost per task (Sonnet priced at the old $3/$15 rate; at $2/$10 the Sonnet curve shifts a third cheaper, making it close rather than a clear loss). Fable 5.1's 0.025x cache-read rate pushes the other way in long loops. This is the one pairing worth a blind-trial comparison before touching the worker default — it is deliberately **not** in this plan's scope because none of the published benchmarks use a TDD-constrained single-task harness like task-worker.

## Where Fable 5.1 shines in the wb workflow

The workflow deliberately decomposes work into small beads tasks, which manufactures the regime where Sonnet saturates. So Fable earns its place where decomposition fails or has not happened yet:

1. **Escalation after verified failure.** A task that already failed once is in the tail, and the tail is where the money goes. Escalations are rare, so cost is bounded.
2. **create_tasks.** Task bodies are code written in prose (file:line, before/after, test scenarios); phasing is a multi-file migration problem; the dependency graph is long-context retrieval across the whole plan. All three run on the session model — the skill has no `model:` pin and its sub-agents are fact-gatherers. Cost is paid once per project and amortized over every worker, retry, and checkpoint.
3. **implement_tasks on cross-cutting phases**, where the session itself does the coding. Not in this plan beyond a guide-table note; the user picks the session model.

Where cheaper models stay: haiku locators (checkable retrieval), sonnet analyzers and validators (document and check, do not decide), sonnet workers on well-decomposed tasks with the verify-then-retry loop as the safety net. Research stays on Sonnet also because Fable at low answers from memory instead of reading, which cuts against the file-reading protocol.

## Prescriptiveness tension

Anthropic's clearest 5.1 note is that skills written for prior models are often too prescriptive and reduce output quality. The plugin is built on that scaffolding (175 ⛔ markers). Two things cut against stripping it: the skills are written for the weakest model that runs them, and the audit's keep list protects exact scripts for fragile operations, which is what barriers and checkpoints are. Resolution in design.md: keep synchronization points at normal volume; treat judgment choreography as an A/B candidate for a later successor; do not de-prescribe for Fable at the expense of Sonnet consistency.

## Relationship to prompt-modernization Phase 4

R1 (budget keywords), R3 (barrier formatting), R4 (repetition and CAPS scope blocks) were deferred pending the eval harness. Fable 5.1 changes the evidence: R1's keep-half weakens (the verb is redundant when thinking is always on); R3 gains its first evidence for the single-marker side; R4 cuts the other way for the scope blocks (5.1 demonstrably adds scope, so those prohibitions are against a current failure and stay — only their volume drops). The harness is still at research-needed; the blind-trial method is the cheap stand-in.
