# Releasing wb

How changes reach installers, and the process that keeps that deliberate. Context: the plugin has multiple installers; this repo is also the marketplace.

## The channel model

| Channel | Who | What they get | When |
|---|---|---|---|
| Dev | Maintainer, canaries | The working tree, live | `claude --plugin-dir <repo>/plugin` — always serves current files, shadows any installed version (even an equal one), no bump needed |
| Release | Installers | The `plugin/` subtree at the manifest version | Only when the version bumps AND they run `claude plugin update wb@gvarela-workbench` |

Two facts shape everything else (verified 2026-06-11):

1. **A session without `--plugin-dir` serves the installed cache.** Working-tree changes are invisible to it, including to its `/reload-skills`. If edits "aren't taking effect," check the flag before suspecting the version.
2. **`main` is effectively the install channel even between bumps.** Existing installers only receive bumped versions, but a *fresh* `claude plugin install` copies whatever `main` currently holds under the current version label. Therefore: **main must always be releasable, and a breaking change merges together with its version bump or not at all.**

## Semver for a prompt library

- **Patch** (x.y.Z): prompt bugfixes, typo/clarity edits, doc fixes. No behavior contract changes.
- **Minor** (x.Y.0): new skills/agents/hooks, additive behavior, new supporting files.
- **Major** (X.0.0): removed/renamed commands, changed workflow contracts, changed invocation behavior, or new environment requirements (bd version, Claude Code feature dependencies).

Bump `version` in **both** `plugin/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` — they must match.

## Process

1. **One concern per branch/PR**, phase-sized, merged to main without a version bump only if non-breaking (see fact 2 above).
2. **Cutting a release**: update [CHANGELOG.md](CHANGELOG.md) (move Unreleased → version + date, write Migration notes if anything breaks), bump both manifests, merge, push.
3. **Verification before any bump**: `./plugin/scripts/lint --all`, the grep audits, and a `--plugin-dir` smoke session (`/wb:` menu correct, `/wb:help` renders, one workflow skill's intake flow works). As the eval harness lands, this becomes: Tier 0 on every PR, Tier 2 golden runs before any bump, Tier 3 before anything behavior-shaping.
4. **Canary for majors**: maintainer is the standing canary via `--plugin-dir`; one volunteer installer updates first; announce to the rest after a quiet interval.
5. **Announce**: tell installers the version, the one-line summary, and any migration steps (link the changelog entry). Updates are pull-based — the changelog is their entire decision input.

## Rollback

There is no downgrade mechanism. Rollback = revert commit(s) + new **patch** version + `claude plugin update`. Roll forward, always.

## Update mechanics (for reference)

- The cache is keyed by version: `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/`.
- `/reload-plugins` re-reads the existing cache only; it never pulls.
- Pushing to GitHub alone delivers nothing; the marketplace clone doesn't auto-pull.
- Bumping without users running `claude plugin update` delivers nothing.
