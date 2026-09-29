#!/usr/bin/env bash
# coordinator.sh — route one finding through the skill's methods with TypeSafe Jev.
#   TYPESAFE_API_KEY=... coordinator.sh "finding, plus state that matters (which vision check breaks, base red?)"
#   echo "finding" | coordinator.sh
#   coordinator.sh --dry-run "finding"      print request body, send nothing
#   coordinator.sh --table                  print the routing tables; use them by hand without a key
# Env: COORDINATOR_METHODS (default ../methods).
# The tables below are the one source of routing: cells name a method file stem or give plain text.
# Needs curl and jq.
set -eu
API=https://api.typesafe.ai/v1/systemone
SKILL=$(cd "$(dirname "$0")/.." && pwd)
METHODS=${COORDINATOR_METHODS:-$SKILL/methods}
die(){ echo "$*" >&2; exit 1; }

# read -d '' instead of $(cat <<EOF): bash 3.2 misparses apostrophes in heredocs inside $( ).
IFS= read -r -d '' TABLES <<'EOF' || true
## Pick
Check before claiming and at every task boundary.
| Trigger | Pick with |
|---|---|
| Presentation version or shared check red | stop-the-line |
| Starting any iteration | finish-right-first |
| Several free issues, same priority tier | value-per-minute |
| Change deletes data, sends, rotates secrets, force-pushes, deploys publicly | door-check |
| Half of claimed estimate passed | halfway-breaker |
| Agent reports fix done or working | prove-done |
| Two or more agents fail on, claim, or fix same large check | split-the-check |
| Non-vital feature broken; fix will not verify before deadline | kill-switch |
| Last 10 minutes, or path verified and nothing larger fits | demo-reset |

## Matrix
Run the row's red check first; green rules the row out. Diagnose left to right, stop at first confirmed cause.
| You see | Symptom method | Diagnose with | Fix with |
|---|---|---|---|
| Fix passes locally, presentation still shows old behavior | stale-build | data-first on served revision | plain-fix |
| Works on one machine or host, fails on another | env-drift | data-first on both sides' config; step-the-path when differing value not obvious | plain-fix |
| Outside service answers 401, 403, 429, or quota | expired-access | data-first on error body | plain-fix |
| Empty, not-found, or blank screens on presentation host only | missing-data | data-first | plain-fix |
| Fails on first load or sometimes; retry fixes it | race | think-first, then step-the-path; skipped-update when cache or flag on path | plain-fix |
| Unusual input (empty, one item, max value, odd characters, real sample data) breaks tested path | edge-input | data-first, then think-first | pure-extract, no-special-case |
| Each side passes own tests; combined journey fails | contract-drift | data-first on one real exchange | plain-fix; easy-change when many consumers read field |
| Works, but too slow on host, with real data, or on venue Wi-Fi | slow-path | estimate-profile | plain-fix on largest share only |
| Check passes and fails on same code, no change between runs | flaky-check | data-first on failing run; step-the-path when wait or order not obvious | plain-fix; race when fault in code under test |
| Worked at known earlier revision or rehearsal | regression | recent-change when history short; bisect (from regression method) when long | revert or plain-fix |
| Fails silently, returns wrong default, or aborts far from fault | swallowed-error | step-the-path to first handler on path | plain-fix in handler |
| Works for one person only, or broke after fresh setup | hidden-step | step-the-path through written setup | plain-fix in setup path |

## No row fits
Top to bottom, stop at first confirmed cause. Cause matches no row: propose a symptom method in the handoff.
| Situation | Diagnose with |
|---|---|
| Before deep diagnosis, or sure hypothesis died | check-the-plug |
| About to read control flow | data-first |
| Fails only in some modes, states, orders | skipped-update |
| Unfamiliar code, or bug depends on state, mode, config | step-the-path |
| You know the code | think-first |
| Failing input, test, or config large; cause unclear | shrink-the-repro |
| Two hypotheses died, or 5 minutes without new evidence | fresh-view |

## Fix shape
Stack on any row: easy-change and pure-extract first, then the row's fix, then other shapes, plain-fix last.
| Trigger | Fix with |
|---|---|
| Choosing between fixes | plain-fix |
| Buggy logic tangled with global state, no test seam | pure-extract |
| Fix touches many sites or fights structure | easy-change |
| Bug lives in empty, first, last, or null branch | no-special-case |
| Several callers hit bug | fix in shared function every caller routes through; no per-caller guard |
| No tests around behavior fix must keep | characterize-first |
| New logic needed inside long tangled function; extraction too big | sprout-fix |

## Close
Every fix, in order: machine-check, same-mistake, premortem.
EOF
CLOSE='["machine-check","same-mistake","premortem"]'

DRY=
case "${1:-}" in
  --table) echo "$TABLES"; exit 0 ;;
  --dry-run) DRY=1; shift ;;
esac
FINDING=${1:-}
[ -n "$FINDING" ] || FINDING=$(cat)
FINDING=$(printf '%s' "$FINDING" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
[ -n "$FINDING" ] || die "No finding given"
command -v jq >/dev/null || die "Needs jq"

# Table rows as {section, cells[{text, stem}]}; header and separator rows dropped.
T=$(awk '/^## /{ s=substr($0, 4); hdr=1; next }
  /^\|/ { if (hdr) { hdr=0; next } if ($0 ~ /^\|[-| ]+\|$/) next
          n=split($0, c, "|"); line=s; for (i=2; i<n; i++) { v=c[i]; gsub(/^ +| +$/, "", v); line=line "\t" v }; print line }' <<<"$TABLES" |
  jq -R 'split("\t") | {section:.[0], cells:(.[1:]|map({text:., stem:(if test("^[a-z-]+$") then . else null end)}))}' | jq -sc .)
sec(){ jq -c --arg s "$1" 'map(select(.section==$s))' <<<"$T"; }
PICK=$(sec Pick); MATRIX=$(sec Matrix); NOROW=$(sec "No row fits"); SHAPE=$(sec "Fix shape")

BODY=$(jq -n --arg f "$FINDING" --argjson pick "$PICK" --argjson matrix "$MATRIX" --argjson norow "$NOROW" --argjson shape "$SHAPE" '
  def yes($i; $t): {key:$i, value:{type:"noul", instructions:"Does `finding` state or directly show this? \($t)",
    criteria:{true:"`finding` states it or quotes evidence of it", false:"`finding` does not mention it, or it is only possible"}}};
  {state:{finding:$f}, model:"jev-latest", questions:(
    {priority:{type:"choice", instructions:"How important is `finding` for the upcoming presentation?",
       criteria:{"core-journey":"Broken core presentation journey or unacceptable failure, including data loss",
                 prerequisite:"Prerequisite that unblocks several fixes or integration",
                 required:"Required behavior that works but is wrong or incomplete",
                 polish:"Polish; required behavior already works"}},
     row:{type:"choice", instructions:"Which symptom best matches what `finding` describes?",
       criteria:(($matrix|map({key:.cells[1].stem, value:.cells[0].text})|from_entries) + {none:"None of these symptoms matches"})},
     situation:{type:"choice", instructions:"Which situation best describes where diagnosis of `finding` stands?",
       criteria:($norow|map({key:.cells[1].stem, value:.cells[0].text})|from_entries)}}
    + ($pick|to_entries|map(yes("pick\(.key)"; .value.cells[0].text))|from_entries)
    + ($shape|to_entries|map(yes("shape\(.key)"; .value.cells[0].text))|from_entries))}')
[ -n "$DRY" ] && { echo "$BODY"; exit 0; }

[ -n "${TYPESAFE_API_KEY:-}" ] || die "Set TYPESAFE_API_KEY, or route by hand with --table"
OUT=$(mktemp); trap 'rm -f "$OUT"' EXIT
# Key goes through a file descriptor so it never shows in the process list.
CODE=$(curl -sS -m 30 -o "$OUT" -w '%{http_code}' -X POST "$API" \
  -H @<(printf 'Authorization: Bearer %s\nContent-Type: application/json\n' "$TYPESAFE_API_KEY") \
  --data-binary @- <<<"$BODY") || die "TypeSafe request failed"
[ "$CODE" = 200 ] || die "TypeSafe HTTP $CODE: $(head -c 500 "$OUT")"

A=$(jq -c .answers "$OUT")
ROW=$(jq -r .row.choice <<<"$A")
RED=$( { [ -f "$METHODS/$ROW.md" ] && grep -m1 '^\*\*Red check:\*\*' "$METHODS/$ROW.md" | sed 's/^\*\*Red check:\*\* *//'; } || true)
# ponytail: fixed 0.5 cut for yes/no triggers; tune when it fires too often or too rarely.
jq -r --argjson a "$A" --argjson pick "$PICK" --argjson matrix "$MATRIX" --argjson shape "$SHAPE" \
  --argjson close "$CLOSE" --arg red "$RED" -n '
  def pct: (.*100|round) as $n | "\($n/100|floor).\($n%100|tostring|if length<2 then "0"+. else . end)";
  def top($n): .probabilities|to_entries|sort_by(-.value)|.[:$n]|map("\(.key) \(.value|pct)")|join(", ");
  def hit($p; $rows): $rows|to_entries|map(select($a["\($p)\(.key)"].noul >= 0.5)|.value.cells[1]);
  def name: .stem // .text;
  ($matrix|map(select(.cells[1].stem==$a.row.choice))[0]) as $r |
  hit("pick"; $pick) as $picks | hit("shape"; $shape) as $shapes |
  ($shapes|map(select(.stem=="easy-change" or .stem=="pure-extract"))) as $first |
  ($shapes|map(select(.stem!="easy-change" and .stem!="pure-extract" and .stem!="plain-fix"))) as $more |
  "Priority:  \($a.priority.choice) (\($a.priority|top(2)))",
  (if ($picks|length)>0 then "Pick:      \($picks|map(name)|join(", "))" else empty end),
  "Row:       \($a.row.choice) (\($a.row|top(3)))",
  (if $r then ("Red check: \($red)", "Diagnose:  \($r.cells[2].text)") else empty end),
  (if $r == null or $a.row.confidence < 0.5
   then "No row:    \($a.situation.choice) (\($a.situation|top(2))); fresh-view after two dead hypotheses" else empty end),
  ($first|map(name)) + (if $r then [$r.cells[3].text] else [] end) + ($more|map(name)) as $fix |
  "Fix order: \($fix + (if ($fix|last // ""|startswith("plain-fix")) then [] else ["plain-fix"] end) | join(" > "))",
  "Close:     \($close|join(" > "))",
  (if $r and $a.row.confidence < 0.5 then "Low confidence: run red checks of top two rows before committing." else empty end)'
