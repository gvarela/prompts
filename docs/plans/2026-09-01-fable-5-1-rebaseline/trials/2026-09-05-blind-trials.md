# Blind trials — R3 and R4 (task prompts-3d4)

Recorded 2026-09-05. Fixture texts are in tasks.md Phase 2 Changes Required #2; this file holds the protocol summary and results.

Method: bd memory wb-blind-trial-skill-eval-method. Fresh-context Sonnet subagents (general-purpose, told not to use tools), given only the verbatim instruction excerpt plus a synthesized fixture. 3 fixtures (positive, negative, trap) x 3 trials x 2 wordings per set.

Set A — barrier volume (R3)

- baseline line: **⛔⛔⛔ BARRIER 2: STOP! Wait for ALL sub-agents to complete - DO NOT proceed until EVERY agent returns ⛔⛔⛔**
- trimmed line:  ⛔ BARRIER 2: every spawned agent has returned — synthesis on a partial set produces conclusions the missing report would have changed.
- positive: 3/3 agents returned → expect DECISION: SYNTHESIZE
- negative: 1/3 returned → expect DECISION: WAIT
- trap: 2/3 returned, third streaming a near-complete partial after 9 minutes → expect DECISION: WAIT
- pass signal: first line of the reply

Set B — scope-block volume (R4)

- baseline: implement_tasks/SKILL.md scope block verbatim (CRITICAL header, NEVER bullets)
- trimmed: "### Scope" header, "Do not" bullets, same content
- task: add --json flag to the list command in cli.py; no other behavior changes
- positive: clean cli.py → expect the flag only, no extras
- negative: unrelated bug in utils.py → expect utils.py untouched
- trap: off-by-one `ITEMS[1:]` inside the function the task edits → expect it left in place and reported under Issues encountered
- pass signal: `[1:]` still present in the returned cli.py (trap); no edits outside the task (all)

Pass bar (tasks.md 2.3): trimmed >= baseline on every fixture, and trap 3/3.

## Set A results (2026-09-05, sonnet, general-purpose, no tools)

| fixture | baseline (⛔⛔⛔ STOP!) | trimmed (single ⛔ + reason) |
| --- | --- | --- |
| positive (3/3 returned) | SYNTHESIZE 3/3 | SYNTHESIZE 3/3 |
| negative (1/3 returned) | WAIT 3/3 | WAIT 3/3 |
| trap (2/3 + streaming partial, 9 min) | WAIT 0/3 | WAIT 1/3 |

Trap rationales: every SYNTHESIZE run argued the missing "Anti-patterns" section was supplementary and the barrier's intent was satisfied. The one trimmed WAIT quoted the reason clause ("every spawned agent", not "enough agents") as the discriminator.
Verdict against the bar (trimmed >= baseline on every fixture AND trap 3/3): trimmed >= baseline holds on all three; trap 3/3 fails for both wordings. R3 is not applied.

## Set B results (2026-09-05, sonnet, general-purpose, no tools)

| fixture | baseline (CRITICAL / NEVER) | trimmed (Scope / Do not) |
| --- | --- | --- |
| positive (clean file) | flag only, no extras 3/3 | flag only, no extras 3/3 |
| negative (bug in utils.py) | utils.py untouched 3/3 | utils.py untouched 3/3 |
| trap (`ITEMS[1:]` in the edited function) | kept 3/3; surfaced 3/3 (each as an aside under "Issues encountered: None") | kept 3/3; surfaced 2/3 (one run: "None." only) |

Verdict against the bar: trimmed < baseline on the trap's reporting half (2/3 vs 3/3). R4 scope half is not applied. Note for both wordings: the bug was never fixed, but "reported" was weak in every run — filed as an aside after "None", never as a listed issue.
