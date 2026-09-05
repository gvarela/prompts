---
project: fable-5-1-rebaseline
created: 2026-09-01
status: complete
last_updated: 2026-09-05
git_commit: 70c50bd
git_branch: docs/handoff-2026-09-05
repository: workbench
researcher: gabe@vare.la
audience: maintainer
ticket: prompts-678
sources: "Claude Code bundled claude-api skill (models cached 2026-06-24; model-migration.md, prompt-audit.md, cost-optimization.md); platform.claude.com effort and Sonnet 5 prompting docs (fetched 2026-09-01); Claude Sonnet 5 System Card §8; this repository at cf86f75"
---

# Research: Fable 5.1 Re-baseline

Facts only. Decisions are in design.md.

## 1. Current model map in the plugin

### 1.1 Session-model guidance (docs/workbench-workflow-guide.md:60-78)

| Stage | Suggested session model |
| ----- | ----------------------- |
| create_project, create_handoff, help | Sonnet |
| create_research / create_product_research | Sonnet (high effort) |
| explore_design | Fable (Opus fallback); skill self-checks and warns |
| create_design | Opus; Sonnet when formalizing a recorded decision |
| create_tasks | Opus — "Decomposition quality determines how well cheap workers perform" |
| implement_tasks | Sonnet (xhigh effort) |
| implement_coordinated | Opus (coordinator); workers per tier rule |
| validate_execution | Pinned sonnet in frontmatter |

### 1.2 Tier definitions (CLAUDE.md:158-167)

- `haiku`: file searches, pattern matching, mechanical tasks; no `effort` support
- `sonnet`: default for analysis and implementation
- `opus`: design, decomposition, escalation after verified failure
- `fable`: architecture-critical discussion (explore_design)
- `effort` typical annotations: implementation workers `xhigh`, analyzers `medium`, verifiers `high`

### 1.3 Worker tier rule (plugin/skills/implement_coordinated/SKILL.md:180-186)

Haiku for mechanical only; Sonnet default at `effort: xhigh`; Opus for architectural, cross-cutting, or previously-failed tasks. Fix workers on verification FAIL spawn with an opus override (sub-agent-prompts.md:110-121), two retries, then the task goes to the phase checkpoint's blocking list (SKILL.md:237). README.md:47 restates the same tiers.

### 1.4 Frontmatter pins and spawn pins

- `model: sonnet` pinned: validate_execution/SKILL.md:7, research-validation/SKILL.md:9
- Agents: codebase-analyzer, product-behavior-analyzer, task-verifier, research-validator = sonnet; codebase-locator, pattern-finder = haiku; task-worker = no model (per-spawn override), `maxTurns: 60`, preloads tdd-discipline
- create_tasks/SKILL.md has no `model:` line; its three Step 2 spawns are sonnet, sonnet, haiku (sub-agent-prompts.md:29,52,71)
- `model: fable` in skill frontmatter was verified to resolve at runtime (closed issue prompts-7mj)

### 1.5 Model self-check pattern

explore_design/SKILL.md:23-38 checks the session model first, prints a warning block when below Opus, and continues without blocking. No other skill has this.

## 2. Pricing (first-party API, per million tokens)

| Model | Input | Output | Cache read |
| ----- | ----- | ------ | ---------- |
| Claude Fable 5.1 | $10 | $50 | $0.25 (0.025x) |
| Claude Opus 5 | $5 | $25 | $0.50 (0.1x) |
| Claude Sonnet 5 | $2 | $10 | $0.20 (0.1x) |
| Claude Haiku 4.5 | $1 | $5 | $0.10 (0.1x) |

Fable 5.1 is the only model with a 0.025x cache-read rate. Cache writes: Fable 5.1 $12.50 (5-minute) / $20 (1-hour).

## 3. Documented Fable 5.1 behaviors (platform migration guide)

Capability areas named as improved over Fable 5: agentic coding over long sessions (multi-file features, large refactors and migrations, debugging, code review across sessions), knowledge work with documents, multistep research, vision, long-context retrieval deep in the 1M window, computer use. Gains are "largest at the higher settings"; at `medium` results roughly match Fable 5 at lower cost. "At `low`, Claude Fable 5.1 is often competitive with Opus and Sonnet on cost per task while performing better."

Behavioral notes, each with a published prompt snippet:

| Behavior | Direction | Snippet exists |
| -------- | --------- | -------------- |
| Longer turns; may overplan on ambiguous tasks | "When you have enough information to act, act" | yes |
| Elaborates beyond need at higher effort | Lead with the outcome | yes |
| Fabricated progress claims on long runs | Audit each claim against a tool result | yes |
| Unrequested adjacent actions | State what it should not do | yes |
| Parallel sub-agents are dependable; async outperforms spawn-and-block | Delegate and keep working | yes |
| Performs notably better with a memory surface (even a plain `.md`) | Tell it where, and the format | yes |
| Rare early stopping: text-only "I'll now run X" with no tool call | Autonomy reminder for pipelines | yes |
| Performs better when given the reason behind a request | "I'm working on X for Y; they need Z" | yes |
| Dense, hard-to-follow final summaries deep in long sessions | Readability addendum | yes |
| Fixes nearby code, writes extra tests, commits scratch checks | Follow-ups, not fixes; tests sized like neighbors | yes |
| Rewrites whole files where a targeted edit would do | Surgical-edit instruction | yes |
| Narrates less between tool calls than Fable 5 | Ask for updates explicitly if needed | yes |
| Answers from memory at `low` effort instead of searching | Raise effort on those turns, or instruct to verify names | yes |
| At `xhigh`/`max` on long deliverables, drafts in thinking then writes again (≈2x output) | Run at `high`; move up only on measured gain | yes |

Long-running-agent recommendations in the same guide: make self-verification explicit with fresh-context verifier sub-agents; "de-prescribe migrated prompts and skills — prompts and skills written for prior models are often too prescriptive for Claude Fable 5.1 and reduce output quality; A/B with step-by-step scaffolding removed; prefer stating the goal and constraints over enumerating the steps."

API facts relevant to Claude Code use: thinking is always on; `effort` supports `low` through `max`; safety classifiers may return `stop_reason: refusal` (Claude Code handles this in the harness); 30-day data retention required.

## 4. Sonnet 5 effort curves (System Card §8, figures 8.4.A, 8.5.A, 8.9.1.B)

Standard configuration for headline scores is adaptive thinking at **max** effort (Table 8.1.A). Terminal-Bench 2.1 (80.4%) was measured at xhigh.

| Benchmark | low | med | high | xhigh | max |
| --------- | --- | --- | ---- | ----- | --- |
| FrontierCode v1 | 18.1 | 26.6 | 28.9 | 34.0 | 38.8 |
| CursorBench | 47.7 | 54.9 | 57.0 | 59.0 | 61.2 |
| Humanity's Last Exam | 36.5 | 47.2 | 52.8 | 54.6 | 57.4 |

Monotonic on all three. Sonnet 4.6 declines at max on all three (FrontierCode 15.1→13.2, CursorBench 48.2→47.5, HLE 49.7→46.8). Opus 4.8 declines at max on FrontierCode (34.3→31.3). Fable 5 declines at max on FrontierCode (46.3→44.7).

Cost per task on those figures (Sonnet priced at the pre-Sonnet-5 $3/$15 rate, per the card):

- FrontierCode: Sonnet 5 high ≈ $4.5, xhigh ≈ $7; Fable 5 low 37.3% at ≈ $4.4
- CursorBench: Sonnet 5 xhigh 59.0% at ≈ $5.5; Fable 5 low 64.2% at ≈ $5.7

Docs' caveat on overthinking and diminishing returns is attached to `max`, not `xhigh` (Sonnet 5 effort table; Opus 4.7 table). Two harness effects at xhigh are recorded: Terminus-2 timeouts 2.7x mini-SWE-agent's; USAMO ran at high because higher settings exceeded the 300k token limit.

## 5. Scaffolding inventory (plugin/skills, plugin/agents, plugin/docs)

| Signal | Count |
| ------ | ----- |
| ⛔ | 175 |
| STOP! | 20 |
| CRITICAL | 34 |
| MUST | 14 |
| NEVER | 37 |
| ALWAYS | 11 |
| "think deeply" | 17 |
| "ultrathink" | 4 |
| "NOW and follow it exactly" | 11 |
| "Wait for ALL" | 10 |

Per-skill ⛔/CRITICAL/MUST/NEVER totals: create_product_research 40, implement_tasks 32, create_research 32, create_tasks 30, implement_coordinated 26, create_design 24, validate_execution 17, explore_design 17.

"think deeply"/"ultrathink" sites (21): every stage skill has at least one; two are bare with no object (create_project:53, update_status:96).

Not present anywhere in the shipped plugin: narration suppressors ("don't narrate", "hold findings"), formatting bans, progress-cadence instructions, surgical-edit guidance, a follow-ups-not-fixes rule, an autonomy reminder, any mention of `bd remember` or another memory surface. create_handoff and implement_tasks record "discoveries" in tasks.md Implementation Notes only.

Scope rules present: implement_tasks/SKILL.md:51-59 (five NEVER lines, "STOP and ask"); task-worker.md:25 (ZERO SCOPE CREEP); implement_coordinated/SKILL.md:71.

CLAUDE.md:169-179 ("Working with Commands") mandates: all three barriers and checkpoints, "think deeply" directives at critical decision points, read files fully, parallel agents but wait for all. CLAUDE.md:140-147 ("Command Structure Patterns") shows the triple-marker example. AGENTS.md was removed from the working tree on 2026-09-05: its 92 lines held only a Quick Reference, a session-close protocol that duplicated CLAUDE.md's (with the pre-1.0.2 `git add .beads/` step), and the auto-inserted beads block; it never had an "Agent Spawning" or "Working with Commands" section at cf86f75 or on origin/main. On origin/main it also carries a "Documentation Conventions" section that the removal branch must account for.

Documentarian-rule placements today: create_research/SKILL.md lines 29 (top-of-file), 126 (agent-spawn step), 220 (synthesis step) plus a reference link at 27; create_product_research/SKILL.md lines 26 (top-of-file) and 292 (synthesis step) plus a link at 29, with no agent-spawn-step placement.

Citation check at cf86f75: create_tasks/SKILL.md `## Initial Response` is line 27; implement_coordinated/sub-agent-prompts.md "## Fix Worker Prompt" is line 109, "opus model override" line 114, "**Retry 2**" line 125; implement_coordinated/SKILL.md `### Step 5` heading is line 175. Between cf86f75 and origin/main, task-worker.md, implement_coordinated/sub-agent-prompts.md and README.md are unchanged; implement_coordinated/SKILL.md (Step 5 sub-steps renumbered, +4 net lines before line 237), reference.md (+40 lines after the Context Package Structure), CLAUDE.md (+1 line before 158), create_tasks/SKILL.md, create_handoff/SKILL.md, and implement_tasks/SKILL.md (frontmatter block near 381 replaced by an update_status pointer) all changed.

## 6. Prior-project dispositions

### 6.1 prompt-modernization (docs/plans/2026-06-09-prompt-modernization/)

Closed at Phase 3 on 2026-06-11 (research.md "Final Disposition"). Phase 4 "Evidence-Gated Trims" deferred to a successor "after the wb-eval-harness ships (its Tier 3 scenarios become the trims' evidence base)".

| Rec | Content | Status |
| --- | ------- | ------ |
| R1 | Budget keywords: convert to `effort:` frontmatter where uniformly hard; keep decision-critical directives; delete 2 bare ones | Deferred |
| R3 | Triple-⛔ → single-⛔ normalization | Deferred, downgraded ("no evidence of harm in either direction") |
| R4 | Documentarian rule to 3 placements; CAPS scope blocks soften to plain sentences only if no scope-creep regression | Deferred |
| R15, R16 | Shell preprocessing, named args | Parked (prompts-s6c) |

KEEP verdicts recorded as protected: all ⛔ CHECKPOINTs, wait-for-all-agents barriers, tdd-discipline Iron Law, research-validation "NO TRUST WITHOUT VERIFICATION", decision-point ultrathink directives, "Remind EVERY agent".

Design scaffolding policy: "emphasis scaffolding is presumed load-bearing; only items proven dead change without behavioral evidence."

Phase 4 beads IDs cited in tasks.md (prompts-41c, 7jx, 9wg, pnr, m7o, ogp) and the epic prompts-y2a do not resolve with `bd show` at cf86f75. `bd search` on their titles returns nothing.

### 6.2 Model-strategy decision (closed prompts-2b5, 2026-07-10)

Three calls: (1) flip coordinated worker default on reasoning, not gated on the eval harness — "incumbent tiers were themselves un-evaluated guesses by weaker-generation models; harness validates go-forward"; (2) fix-worker stays opus so opus-on-verified-FAIL is a true escalation ladder; no sonnet-xhigh intermediate retry; (3) create_mockup research agents haiku→sonnet at effort low.

### 6.3 wb-eval-harness (docs/plans/2026-06-10-wb-eval-harness/)

design.md is all placeholders; tasks.md blocker: "Research needed — can't design." Open questions in beads: prompts-7w4 "which golden-run key elements survive model upgrades unchanged?", prompts-rll "can Tier 3 rubric verdicts run below sonnet?", prompts-3us headless dry-run reliability.

### 6.4 Blind-trial eval method (bd memory `wb-blind-trial-skill-eval-method`, validated 2026-07-29)

Fresh-context sonnet subagents given only the verbatim instruction block plus a synthesized fixture; 3 fixtures (clear-positive, clear-negative, trap) x 3 trials; ≈27k tokens per trial. Found and fixed a 0/3 false positive in the explore_design nudge.

### 6.5 Merge-as-checkpoint convention (bd memory)

When phase work ships as a draft PR from a background session, merging the PR stands as the ⛔ CHECKPOINT confirmation.

## 7. Prompt-audit keep list (bundled claude-api skill, prompt-audit.md)

Items an audit must not remove: context and reasons; exact scripts for fragile operations; tool contract detail; prohibitions against current demonstrated failures; calibrated trigger text; format-pinning examples; working redundancy; deliberate end-of-prompt recap; and "re-baselining adds text too — matching a prompt to a new model sometimes means adding guidance for the new model's failure modes."

Patterns the audit flags: pressure language (CRITICAL/MUST/NEVER at volume); "think step by step"/"plan before acting" on thinking models; progress-cadence choreography; step-by-step choreography for judgment tasks; prohibition lists without provenance; update suppressors; anti-formatting rules.

## 8. Release mechanics

This worktree (`dev`, cf86f75) and local `main` (f2334b9) are at plugin version 2.2.0, with `CHANGELOG.md` (top entry `[2.2.0] — 2026-07-31`) and `RELEASING.md` at the repository root. `origin` HEAD is 4995af9 "Compaction drift hardening (wb v2.3.0) (#19)", preceded by v2.2.1 (#18); its CHANGELOG top entry is `[2.3.0] — 2026-08-26`. RELEASING.md: patch for prompt bugfixes, minor for additive skills/agents/hooks/behavior, major for removed or renamed commands; cut a release by moving the CHANGELOG Unreleased section to a dated entry, bump both manifests to the same version, merge, push; verify beforehand with lint, grep audits, and a `--plugin-dir` smoke session; rollback is revert plus a new patch version. Every `file:line` reference in this document was taken at cf86f75; the edit targets checked (task-worker.md:25, sub-agent-prompts.md:114, create_tasks/SKILL.md:27, CLAUDE.md:175) are at the same lines on local `main`. Marketplace installs are cache-keyed by version; `--plugin-dir` serves the working tree. Lint: `./plugin/scripts/lint`. Its final loop runs in a pipeline subshell, so `ISSUES_FOUND` never propagates and the script exits 0 in every mode (`--all`, named files, changed files) even when markdownlint reports errors; verified on a malformed file. Open bug prompts-3ke describes the `--all` case. Errors are visible only in the printed output (`⚠ Issues found in:` lines).
