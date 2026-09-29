#!/usr/bin/env bash
# ledger.sh — claim ledger on orphan branch `ledger`, file LEDGER, CAS via push lease.
# Run inside any clone of the repo. Never touches the worktree or index.
#   ledger.sh init                           create empty ledger branch if absent
#   ledger.sh read
#   ledger.sh claim <id> <agent> <scope> [minutes]   exit 0 won, 2 taken, 3 remote unreachable or retries spent
#   ledger.sh done|release <id> <agent>      exit 0 ok, 2 not your claim
#   ledger.sh mine <id> <agent>              exit 0 claim still yours
# Line: id<TAB>agent<TAB>scope<TAB>started<TAB>deadline<TAB>status   (last line per id wins)
set -u
R=${LEDGER_REMOTE:-origin} B=refs/heads/ledger T=refs/ledger/tip
TTL=${LEDGER_TTL:-1800} GRACE=${LEDGER_GRACE:-300}
now(){ date -u +%Y-%m-%dT%H:%M:%SZ; }
at(){ date -u -r $(( $(date -u +%s) + $1 )) +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -d "+$1 sec" +%Y-%m-%dT%H:%M:%SZ; }
fetch(){ git fetch -q "$R" "+$B:$T" && git rev-parse -q --verify $T; }
body(){ git show "$1:LEDGER"; }
last(){ awk -F'\t' -v id="$2" '$1==id{l=$0} END{print l}' <(body "$1"); }
# free: no line | released | claimed and now > deadline+grace
free(){ local l dl st; l=$(last "$1" "$2"); [ -z "$l" ] && return 0
  IFS=$'\t' read -r _ _ _ _ dl st <<<"$l"
  [ "$st" = released ] && return 0
  [ "$st" = claimed ] && [[ "$dl" < "$(at -"$GRACE")" ]]; }  # ISO-UTC strings sort as time
mine(){ local l a st; l=$(last "$1" "$2"); IFS=$'\t' read -r _ a _ _ _ st <<<"$l"; [ "$a" = "$3" ] && [ "$st" = claimed ]; }
append(){ # tip line msg -> CAS push; 0 won, 1 lost race
  local blob tree c
  blob=$( { body "$1"; printf '%s\n' "$2"; } | git hash-object -w --stdin)
  tree=$(printf '100644 blob %s\tLEDGER\n' "$blob" | git mktree)
  c=$(git commit-tree "$tree" -p "$1" -m "$3")
  git push -q --porcelain --force-with-lease="$B:$1" "$R" "$c:$B" >/dev/null 2>&1; }
case $1 in
init) git ls-remote --exit-code "$R" $B >/dev/null && exit 0
  t=$(printf '100644 blob %s\tLEDGER\n' "$(git hash-object -w --stdin </dev/null)" | git mktree)
  git push -q --force-with-lease="$B:" "$R" "$(git commit-tree "$t" -m 'ledger')":$B ;;
read) fetch >/dev/null && body $T ;;
mine) tip=$(fetch) || exit 3; mine "$tip" "$2" "$3" ;;
claim) id=$2 ag=$3 sc=$4 ttl=$(( ${5:-$(( TTL / 60 ))} * 60 ))
  for try in 1 2 3 4 5 6 7 8; do
    tip=$(fetch) || exit 3
    free "$tip" "$id" || { echo "taken: $(last "$tip" "$id")"; exit 2; }
    append "$tip" "$(printf '%s\t%s\t%s\t%s\t%s\tclaimed' "$id" "$ag" "$sc" "$(now)" "$(at "$ttl")")" "claim $id $ag" && { echo won; exit 0; }
    echo "race lost (try $try), re-reading" >&2; sleep "$(( RANDOM % 3 )).$(( RANDOM % 10 ))"
  done; exit 3 ;;
done|release) st=$1; [ "$st" = release ] && st=released; id=$2 ag=$3
  for try in 1 2 3 4 5 6 7 8; do
    tip=$(fetch) || exit 3
    mine "$tip" "$id" "$ag" || { echo "not yours: $(last "$tip" "$id")"; exit 2; }
    l=$(last "$tip" "$id"); IFS=$'\t' read -r _ _ sc s0 dl _ <<<"$l"
    append "$tip" "$(printf '%s\t%s\t%s\t%s\t%s\t%s' "$id" "$ag" "$sc" "$s0" "$dl" "$st")" "$st $id $ag" && { echo ok; exit 0; }
    sleep "0.$(( RANDOM % 10 ))"
  done; exit 3 ;;
esac
