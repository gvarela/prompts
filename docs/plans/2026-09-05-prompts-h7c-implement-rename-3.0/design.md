---
project: implement-rename-3.0
ticket: prompts-h7c
created: 2026-09-05
created_timestamp: 2026-09-06T00:23:23Z
status: approved
last_updated: 2026-09-06
designer: gabe@vare.la
status_note: approved by Gabe via /wb:create_tasks invocation 2026-09-06
git_commit: 447a1c618f330ec439547f4c564a7bce364be90b
git_branch: worktree-implement-rename-3.0
repository: gvarela/workbench
tags: [design, architecture, implement-rename-3.0]
depends_on: research.md
design_approach: alias-rename-bundled-major
---

# Design: implement-rename-3.0

## Problem Statement

The two implementation skills are named by history, not by role. `implement_coordinated` is the execution path the plugin recommends (workers per task, verification, escalation) and `implement_tasks` is the path that runs on the session model; the names describe them as a base and a variant, so the recommended path reads as the special case. The `create_execution` alias has carried a promise since v2.2.0 that it is removed at 3.0.0, and no 3.0.0 has been cut. Three small defects sit open in the same files this rename sweeps: the plugin documents a JSONL auto-flush that beads does not perform by default, the lint script reports clean regardless of findings, and the coordinated skill's reference doc still names opus as the worker default when unsure.

Releasing has also been one bump per phase, three cuts in a single day for the last plan. RELEASING.md permits non-breaking phases to merge unbumped, but the process list does not say when to cut, when a breaking phase may land, or that a cut is tagged. This release is the first to exercise a bundled cut, so the process rule ships with it.

### Success Metrics

- `/wb:implement` and `/wb:implement_inline` are the canonical commands; `/wb:implement_coordinated` and `/wb:implement_tasks` print a one-time notice and run the canonical skill unchanged
- `/wb:create_execution` no longer exists in the shipped plugin
- Every live rendering of the workflow sequence and model map names the new commands, with `implement` as the default execution path
- No live file outside CHANGELOG.md and `docs/plans/` states that beads auto-flushes `issues.jsonl`
- The lint script exits non-zero when markdownlint reports an error, in every mode
- One statement of the worker tier rule exists in the coordinated skill, and it names sonnet as the default when unsure
- RELEASING.md states when a cut happens, where a breaking phase lands, that cuts are tagged, and what a major's canary period is
- Installed plugin reports 3.0.0 in a fresh session, and `v3.0.0` is tagged on the bump commit

## Design Approach

Rename by directory move plus deprecated alias stubs, exactly as v2.2.0 did, and ship it as 3.0.0 together with the scheduled alias removal, the three ride-along corrections, and the RELEASING.md amendment. The rename is non-breaking for anyone who types the old names; the removal of `create_execution` is what makes the release a major, and it was promised for this version.

### Why This Approach

- The stub-plus-pointer alias is the one rename precedent in the repository (research.md §4, §11), and the decision record prompts-xn4 rejected a hard rename because it "breaks muscle memory + external users' docs"; the same reasoning holds for names that appear in every generated project README
- RELEASING.md classifies renamed commands as major (line 21), and the create_execution stub, CHANGELOG 2.2.0, and the skills guide all schedule the alias's removal at 3.0.0; cutting 3.0.0 without honoring that would leave the promise dangling
- The three ride-alongs are patch-level corrections whose sites overlap the rename sweep (implement_tasks and implement_coordinated Step 7, reference.md), so bundling them costs one grep audit each and no separate release
- Fact 2 of RELEASING.md (a breaking change merges with its bump or not at all) fixes where the breaking piece lands; the bundling rule is written down so the next multi-phase plan does not default back to a cut per phase

## Technical Decisions

### D1: Canonical names are `implement` and `implement_inline`

- Decision: `implement_coordinated` becomes `implement`; `implement_tasks` becomes `implement_inline`. Directory name and `name:` field change together, matching the convention every skill follows (research.md §1). Underscore stays the separator, matching the sixteen workflow commands (background skills use hyphens).
- Rationale: the recommended path gets the plain verb; the session-model path gets a qualifier that names what is different about it (it runs inline, on whatever model the session has). This is the reading prompts-h7c recorded: "implement (today's implement_coordinated) becomes the default execution path; implement_inline (today's implement_tasks) executes in the current session and therefore assumes the session model".
- Trade-off: `implement` is the first single-word workflow command and the most generic trigger word in the menu. Its description must carry the discrimination the two skills already have ("worker agents", "main context kept clean" versus "inline by the current session model"). Tracked as assumption prompts-zmy.
- Pattern reference: `docs/claude-code-skills-guide.md:41-53, 74`; `plugin/skills/implement_tasks/SKILL.md:3`; `plugin/skills/implement_coordinated/SKILL.md:3`

### D2: The old names become deprecated aliases in the v2.2.0 shape

- Decision: `plugin/skills/implement_coordinated/` and `plugin/skills/implement_tasks/` remain as alias directories: a stub SKILL.md that announces the rename once and then reads and follows the canonical SKILL.md with arguments passed through, plus one pointer file per supporting file the canonical skill has (five for implement, one for implement_inline), so a session holding a stale skill body still resolves its reads. Stubs carry `disable-model-invocation: true` and the same `argument-hint` and `allowed-tools` as the canonical skill.
- Rationale: identical to the precedent (`plugin/skills/create_execution/`), which has served since July with one recorded gotcha (stale cached bodies) that the pointer files exist to absorb. `disable-model-invocation` on the stubs keeps the prose router choosing between two skills, not four.
- Trade-off: two more directories in the `/wb:` menu until removal.
- Pattern reference: `plugin/skills/create_execution/SKILL.md:1-24`, `examples.md:1-5`; `CHANGELOG.md:82`

### D3: Aliases live through 3.x and are removed at 4.0.0

- Decision: the stubs state "works through 3.x, removed at 4.0.0" in their description, body, and notice, mirroring the create_execution wording with the versions advanced.
- Rationale: the precedent gave one major cycle; the promise was kept in this release, which is the evidence the pattern works.

### D4: `create_execution` is removed in this release

- Decision: the alias directory is deleted, and the three live mentions that describe it as the only user-only skill (`CLAUDE.md:13, 104`; `docs/claude-code-skills-guide.md:310`) are rewritten to describe the new aliases instead. Historical plan documents keep their text.
- Rationale: scheduled at 3.0.0 in three places; this is the change that makes the major honest under RELEASING.md's semver rule.
- Trade-off: any installer still typing `/wb:create_execution` gets an unknown command rather than a notice. The v2.2.0 notice has been printed on every use for six weeks.

### D5: `implement` is the default in every sequence rendering

- Decision: the seven workflow-sequence renderings (research.md §6) end in `/wb:implement`, and the generated project README from `create_project` templates names `/wb:implement`. `implement_inline` is documented beside it as the session-model path, in the model map, the help skill, the README command list, and the coordinated skill's README (whose "Evolution from" and "Migration from" sections describe the relationship in the new names).
- Rationale: the point of the rename is that the recommended path is the unqualified one. The handoff skills' "continue with" lines follow the same rule.
- Trade-off: the create_project template change means every project created after 3.0.0 names the new default; projects created before keep `implement_tasks` in their README, which the alias handles.
- Pattern reference: `plugin/skills/create_project/templates.md:31, 50`; `plugin/skills/help/SKILL.md:31-43`; `CLAUDE.md:86`; `docs/workbench-workflow-guide.md:73-74`

### D6: Beads persistence text states what bd does

- Decision: `plugin/docs/reference/beads-mode.md` becomes the single statement of persistence mechanics: the embedded Dolt database is the store; `issues.jsonl` is written only when `export.auto` is set or `bd export` is run; git mode therefore requires one of those before committing `.beads/`. Every other live site that repeats the auto-flush claim (research.md §7, roughly a dozen files) either drops the claim or points at the reference doc. The SessionEnd drift-check reminder keeps its behavior and loses nothing, since it only checks for uncommitted `.beads/` changes.
- Rationale: prompts-vwo records the observed behavior on bd 1.0.2 (export five weeks stale while the database moved on); a reference doc that all skills already link to is the right single source, and duplicated one-liners are how the claim spread to a dozen files.
- Trade-off: git-mode installers gain a one-time setup step (`bd config set export.auto true`) that the docs must name.

### D7: The lint script's exit code reflects findings

- Decision: `./plugin/scripts/lint` exits non-zero when any file had a markdownlint error, in all three modes (named files, changed files, `--all`), and has a defined exit on the `--fix` path. The PostToolUse hook keeps exiting 0 so an edit is never blocked by a lint finding.
- Rationale: prompts-3ke and research.md §8 both record that the flag is set inside a piped subshell and read outside it; RELEASING.md's pre-bump verification names `lint --all`, and the last two plans redefined "lint clean" as reading the output because the exit code was meaningless.
- Trade-off: the repository carries pre-existing findings in about 58 files (MD024, MD060), so `lint --all` will exit non-zero until those are fixed or the rules relaxed. Per-file checks against changed files stay the working gate; whether to fix the backlog is out of scope here.

### D8: One statement of the worker tier rule

- Decision: the "Worker Model Selection" section in `implement_coordinated/reference.md` no longer restates the tiers; it records that the keyword-regex spec was retired and points at the tier list in the canonical SKILL.md Step 5, which names sonnet as the default when unsure.
- Rationale: four places state the rule today and one disagrees (research.md §9). Removing the copy removes the drift path; the SKILL.md list is the one the coordinator reads at spawn time.

### D9: RELEASING.md gains a bundling rule

- Decision: the Process section states: non-breaking phases merge to main under an Unreleased heading with no bump; a cut happens when the plan completes, or earlier only when wb sessions in other repositories need a shipped phase; a breaking phase is the last phase of its plan and carries the bump in its own PR, or the whole plan lives on a release branch dogfooded through `--plugin-dir` and merges with the bump; every cut is tagged `vX.Y.Z` on the bump commit; a major's canary step is a stated number of real sessions on the release branch before the bump.
- Rationale: fact 2 already forces where a breaking change lands; the rest is the practice the last plan did not follow (three cuts in a day, no tags since v2.2.0). The dev channel already serves as the pre-release channel, so no new mechanism is introduced.
- Trade-off: installers wait longer between versions. This repository's own sessions never wait, since `--plugin-dir` serves the working tree.

### D10: Release is 3.0.0 with a Breaking and a Migration section

- Decision: CHANGELOG 3.0.0 follows the 2.0.0 shape: a Breaking section (create_execution removed; the two renames with their aliases), Added and Changed sections for the rest, a Migration section (update the plugin, restart or reload, optionally switch to the new names). Both manifests move to 3.0.0 in the same PR as the alias removal; the tag `v3.0.0` lands on that commit.
- Rationale: RELEASING.md lines 15, 21, 28; the 2.0.0 entry is the only prior major and its shape carried the migration steps installers needed.

## Scope Definition

### In Scope

- D1 through D5: the rename, aliases, alias removal, and every live doc and template that renders the commands or the model map
- D6 through D8: the three ride-along corrections
- D9: the RELEASING.md amendment
- D10: the 3.0.0 cut and tag

### Out of Scope

- Backfilling tags for 2.2.1 through 2.6.0 (commits identified in research.md §10; can be done by hand at any time)
- Fixing the pre-existing lint backlog or changing lint rules
- Changing the behavior of either implementation skill, their tier rules, or their effort defaults (prompts-yfh stays open)
- The skills guide's stated name character set (line 95 lists hyphens while every workflow skill uses underscores); noted, not changed
- Rewriting historical plan documents under `docs/plans/`
- Release candidates as a version concept (see Rejected Alternatives)
- prompts-9l1 (goal-to-design cascade) and prompts-4cn

## Success Criteria

### Functional Requirements

- [ ] `/wb:implement` runs the coordinated skill; `/wb:implement_inline` runs the inline skill; both old names print the notice and then behave identically to the canonical skill
- [ ] `/wb:create_execution` is absent from the `/wb:` menu
- [ ] The generated project README, help skill, CLAUDE.md, README.md, commands reference, and workflow guide render the new default
- [ ] `plugin/agents/task-worker.md` names `/wb:implement` as its spawner
- [ ] beads-mode.md states the export condition; no other live file claims auto-flush
- [ ] lint exits 1 on a file with a markdownlint error and 0 on a clean file, in each mode
- [ ] reference.md points at the SKILL.md tier list instead of restating it
- [ ] RELEASING.md carries the bundling rule; CHANGELOG 3.0.0 has Breaking and Migration sections; manifests match; `v3.0.0` tag exists

### Non-Functional Requirements

- [ ] Per-file lint delta against HEAD is zero on every touched file
- [ ] A `--plugin-dir` smoke session shows the `/wb:` menu with the two new names and two aliases, `/wb:help` renders, and one intake flow works (RELEASING.md line 29)
- [ ] The breaking PR is the last merge before the tag; no state exists on main where `create_execution` is gone but the version is still 2.x

## Risk Analysis

### Technical Risks

| Risk | Impact | Likelihood | Mitigation |
| ---- | ------ | ---------- | ---------- |
| `implement` does not resolve or collides with a harness name | High | Low | prompts-7mo dry run before the doc sweep |
| Prose requests route to the wrong mode after the rename | Med | Med | prompts-zmy headless trigger test; descriptions rewritten if it fails |
| A stale session references an old supporting-file path | Low | Med | Pointer files per supporting file; CHANGELOG gotcha repeated |
| Sweep misses a rendering site | Med | Med | The inventory in research.md §5 is the checklist; grep for the old names must return only alias stubs, CHANGELOG, and `docs/plans/` |
| `lint --all` now fails on the pre-existing backlog and blocks the pre-bump check | Med | High | The pre-bump check uses per-file deltas until the backlog is addressed; RELEASING.md wording says so |
| Installers on a git-mode beads setup act on the corrected docs and change config | Low | Low | The Migration section names the one command |

### Assumptions

| Assumption | Beads ID | Validated? |
| ---------- | -------- | ---------- |
| A single-word skill directory `implement` resolves as `/wb:implement` and the alias stubs redirect | `prompts-7mo` | Pending |
| The two descriptions discriminate the modes well enough that "implement phase N" routes to `implement` | `prompts-zmy` | Pending |

## Rejected Alternatives

### Option: Hard rename, no aliases

- **Approach**: move the directories and sweep the docs; old names stop working at 3.0.0.
- **Rejected because**: prompts-xn4 rejected this shape for create_execution ("breaks muscle memory + external users' docs"); every project README generated before 3.0.0 names `implement_tasks`, and the aliases cost eight small files.
- **Trade-offs**: a cleaner menu now against a broken command in every existing project directory.

### Option: Rename in a 2.x minor, remove create_execution later

- **Approach**: ship the aliases as additive in 2.7.0, defer the major.
- **Rejected because**: RELEASING.md classifies renamed commands as major regardless of aliases, and the create_execution promise already names 3.0.0. Two majors in short order would be worse than one.
- **Trade-offs**: a smaller release now against a second breaking release soon after.

### Option: Release candidates as versions

- **Approach**: cut `3.0.0-rc.1` to the marketplace for a dogfood period.
- **Rejected because**: the marketplace has one entry and one version string, so an RC on main is what every fresh install receives; a real RC track needs a branch plus a marketplace registration targeting it (the `1.x` mechanism), which is overhead with no consumer for a plugin with one maintainer. The dev channel already serves as the pre-release channel, and whether `claude plugin update` orders prerelease suffixes was not established.
- **Trade-offs**: a named pre-release against a dogfood period on a branch with the same effect.

### Option: Keep the duplicated tier-rule paragraph and correct its wording

- **Approach**: change "opus ... default when unsure" to sonnet in reference.md.
- **Rejected because**: the paragraph drifted once already; a fourth copy of the rule is the cause, not the wording.

## Pending Decisions

None. The bundle, the names, and the release shape were confirmed in conversation on 2026-09-05 and 2026-09-06 before this document was written.

## References

- Research: [research.md](research.md)
- Prior decision: beads `prompts-xn4` (create_execution → create_tasks, additive alias, stub removed at 3.0.0)
- Related issues: `prompts-h7c`, `prompts-vwo`, `prompts-3ke`
- Release process: `RELEASING.md`; precedent entries `CHANGELOG.md` 2.0.0 and 2.2.0
- Prior plan: [../2026-09-01-fable-5-1-rebaseline/](../2026-09-01-fable-5-1-rebaseline/)
