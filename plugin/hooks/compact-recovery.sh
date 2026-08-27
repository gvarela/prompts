#!/bin/bash
# SessionStart(compact) hook: re-anchor a compacted session on the active plan docs.
# Contract: <100ms, no bd invocations, silent when nothing to recover, plain-text
# stdout (SessionStart is the one event whose plain-text stdout is model-visible).

payload=$(cat 2>/dev/null || true)
[ -z "$payload" ] && exit 0
echo "$payload" | grep -q '"compact"' || exit 0

[ -d docs/plans ] || exit 0

candidates=""
for f in $(ls -t docs/plans/*/tasks.md 2>/dev/null); do
  status=$(sed -n '2,30p' "$f" | grep -m1 '^status:' | sed 's/^status:[[:space:]]*//')
  [ "$status" = "complete" ] && continue
  dir=$(dirname "$f")
  candidates="$candidates${candidates:+ }$(basename "$dir")"
done

[ -z "$candidates" ] && exit 0

count=$(echo "$candidates" | wc -w | tr -d ' ')

echo "Context was just compacted — any plan-doc summaries above are paraphrase, not verified content."
if [ "$count" -eq 1 ]; then
  echo "Active plan: docs/plans/$candidates"
else
  echo "Candidate plans (newest first): $candidates"
fi
echo "Before asserting what research.md/design.md/tasks.md say, re-read them fully from the plan directory above. Check bd state (bd ready / bd list) for project status rather than trusting the summary."

exit 0
