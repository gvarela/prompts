#!/bin/bash
# SessionEnd hook: one-line reminder when beads state is uncommitted (git mode).
# Contract: <100ms, silent when clean, safe outside git repos. No bd invocations
# (daemon spin-up would blow the time budget); git-visible drift is the signal.

command -v git >/dev/null 2>&1 || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -d .beads ] || exit 0

# Stealth mode (.beads/ gitignored): local-only state, nothing to commit
git check-ignore -q .beads/ 2>/dev/null && exit 0

changes=$(git status --porcelain -- .beads/ 2>/dev/null)
[ -z "$changes" ] && exit 0

printf '{"systemMessage": "📍 Beads drift: .beads/ has uncommitted changes — run git add .beads/ && git commit before ending the session."}\n'
exit 0
