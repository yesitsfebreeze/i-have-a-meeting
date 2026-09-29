#!/usr/bin/env bash
# triage.sh — route a finding to the fastest way forward with TypeSafe Jev.
#   TYPESAFE_API_KEY=... triage.sh "problem text"
#   echo "problem text" | triage.sh
#   triage.sh --dry-run "problem text"      print request body, send nothing
# Env: TRIAGE_METHODS (default ../methods), TRIAGE_COORDINATOR (default ../COORDINATOR.md).
# Methods are Markdown: `# Title`, then `**You see:**` (symptom) or `**Use when:**` (craft).
# Needs curl and jq.
set -eu
API=https://api.typesafe.ai/v1/systemone
SKILL=$(cd "$(dirname "$0")/.." && pwd)
METHODS=${TRIAGE_METHODS:-$SKILL/methods}
COORD=${TRIAGE_COORDINATOR:-$SKILL/COORDINATOR.md}
die(){ echo "$*" >&2; exit 1; }

DRY=
[ "${1:-}" = --dry-run ] && { DRY=1; shift; }
PROBLEM=${1:-}
[ -n "$PROBLEM" ] || PROBLEM=$(cat)
PROBLEM=$(printf '%s' "$PROBLEM" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
[ -n "$PROBLEM" ] || die "No problem given"
command -v jq >/dev/null || die "Needs jq"

# One JSON object per method file: stem, title, and the fields both kinds use.
methods(){ for f in "$METHODS"/*.md; do [ -f "$f" ] || continue
  awk -v stem="$(basename "$f" .md)" '
    NR==1 { t=$0; sub(/^#+ */, "", t) }
    function grab(label,   p) { p="**" label ":**"
      if (index($0, p)==1 && !(label in v)) { s=substr($0, length(p)+1); sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); v[label]=s } }
    { grab("You see"); grab("Underneath"); grab("Red check"); grab("Use when"); grab("Move") }
    END { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", stem, t, v["You see"], v["Underneath"], v["Red check"], v["Use when"], v["Move"] }' "$f"
done | jq -R 'split("\t") | {stem:.[0], name:.[1], you_see:.[2], cause:.[3], red_check:.[4], use_when:.[5], move:.[6]}
  | if .you_see != "" then .kind="symptom" elif .use_when != "" then .kind="craft" else empty end' | jq -s .; }

# Pick methods (COORDINATOR.md "## Pick" table) choose work, not causes; keep them out of first_move.
PICK=$([ -f "$COORD" ] && awk '/^## /{on=($0=="## Pick")} on' "$COORD" | grep -o 'methods/[a-z-]*\.md' | sed 's|methods/||; s|\.md$||' | jq -R . | jq -s . || echo '[]')
M=$(methods | jq --argjson pick "$PICK" 'map(select(.stem as $s | $pick | index($s) | not))')
[ "$(jq '[.[]|select(.kind=="symptom")]|length' <<<"$M")" -gt 0 ] && [ "$(jq '[.[]|select(.kind=="craft")]|length' <<<"$M")" -gt 0 ] \
  || die "No symptom or craft methods found in $METHODS"

BODY=$(jq -n --arg p "$PROBLEM" --argjson m "$M" '
  ($m|map(select(.kind=="symptom"))) as $s | ($m|map(select(.kind=="craft"))) as $c |
  {state:{finding:$p}, model:"jev-latest", questions:{
    symptom:{type:"choice", instructions:"Which known failure pattern best explains `finding`?",
      criteria:(($s|map({key:.stem, value:{you_see, usual_cause:.cause}})|from_entries) + {none:"No listed pattern fits this finding"})},
    first_move:{type:"choice", instructions:"Which working method gets `finding` to a confirmed cause or verified fix fastest?",
      criteria:($c|map({key:.stem, value:.use_when})|from_entries)},
    priority:{type:"choice", instructions:"How important is `finding` for the upcoming presentation and the project vision?",
      criteria:{"core-journey":"Broken core journey or unacceptable failure, including data loss",
                prerequisite:"Prerequisite that unblocks several fixes or integration",
                required:"Required behavior that works but is wrong or incomplete",
                polish:"Polish; required behavior already works"}}}}')
[ -n "$DRY" ] && { echo "$BODY"; exit 0; }

[ -n "${TYPESAFE_API_KEY:-}" ] || die "Set TYPESAFE_API_KEY"
OUT=$(mktemp); trap 'rm -f "$OUT"' EXIT
# Key goes through a file descriptor so it never shows in the process list.
CODE=$(curl -sS -m 30 -o "$OUT" -w '%{http_code}' -X POST "$API" \
  -H @<(printf 'Authorization: Bearer %s\nContent-Type: application/json\n' "$TYPESAFE_API_KEY") \
  --data-binary @- <<<"$BODY") || die "TypeSafe request failed"
[ "$CODE" = 200 ] || die "TypeSafe HTTP $CODE: $(head -c 500 "$OUT")"

[ -f "$COORD" ] && C=$(cat "$COORD") || C=
jq -r --argjson m "$M" --arg coord "$C" '
  def pct: (.*100|round) as $n | "\($n/100|floor).\($n%100|tostring|if length<2 then "0"+. else . end)";
  def top($n): .probabilities|to_entries|sort_by(-.value)|.[:$n]|map("\(.key) \(.value|pct)")|join(", ");
  def unlink: gsub("\\[(?<t>[^]]+)\\]\\([^)]+\\)"; "\(.t)")|gsub("^ +| +$"; "");
  # Matrix row whose symptom cell links methods/<slug>.md
  def row($slug): [$coord|split("\n")[]|split("|")|select(length==6 and (.[2]|contains("methods/\($slug).md")))|map(unlink)][0];
  ($m|map({key:.stem, value:.})|from_entries) as $by | .answers as $a | $by[$a.symptom.choice] as $s |
  "Priority:   \($a.priority.choice) (\($a.priority|top(2)))",
  "Symptom:    \($a.symptom.choice) (\($a.symptom|top(3)))",
  (if $s.kind=="symptom" then "Red check:  \($s.red_check)", (row($s.stem)|values|"Diagnose:   \(.[3])", "Fix:        \(.[4])") else empty end),
  "First move: \($a.first_move.choice) (\($a.first_move|top(3)))",
  "            \($by[$a.first_move.choice].move)",
  (if ([$a.symptom.confidence, $a.first_move.confidence]|min) < 0.5
   then "Low confidence: run the top two red checks before committing to one path." else empty end)' "$OUT"
