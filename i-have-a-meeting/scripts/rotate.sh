#!/usr/bin/env bash
# rotate.sh — bound what a meeting run leaves behind. Dry run unless --apply.
#   rotate.sh [--apply] [--days N] [--hours N] [--keep N]      run inside any clone
#   rotate.sh --selftest                                          builds a temp repo and checks the rules
# 1. <git-dir>/i-have-a-meeting/{publishing,handoffs,restart-backups,coordinator-verification,worktrees}:
#    entries older than N days (default 3) beyond the newest KEEP (default 5) go.
# 2. Registered worktrees: removed (never forced) when clean, merged into main, idle N hours
#    (default 6), and no running process names them.
# 3. Claude scratchpads /private/tmp/claude-<uid>/*/<session>: a session with no process and no
#    open cwd, idle N hours, goes whole when every clone in it is clean and pushed; else only its
#    Cargo target dirs go. Never touches the current session.
set -u
APPLY= DAYS=3 HOURS=6 KEEP=5 SELFTEST=
while [ $# -gt 0 ]; do case $1 in
  --apply) APPLY=1;; --days) DAYS=$2; shift;; --hours) HOURS=$2; shift;; --keep) KEEP=$2; shift;;
  --selftest) SELFTEST=1;; *) echo "usage: $0 [--apply] [--days N] [--hours N] [--keep N] | --selftest" >&2; exit 64;;
esac; shift; done
live=$(ps -axo command=; lsof -a -d cwd -Fn 2>/dev/null)
freed=0
say(){ printf '%-8s %6d MiB %s (%s)\n' "${APPLY:+rm}${APPLY:-would rm}" "$(($(du -sk "$1" | cut -f1)/1024))" "$1" "$2"; freed=$((freed+$(du -sk "$1" | cut -f1))); }
drop(){ say "$1" "$2"; [ -n "$APPLY" ] && rm -rf "$1"; }
idle(){ [ -z "$(find "$1" -path '*/target' -prune -o -type f -mmin -$((HOURS*60)) -print 2>/dev/null | head -1)" ]; }
named(){ case $live in *"$1"*) return 0;; esac; return 1; }
clean(){ [ -z "$(git -C "$1" status --porcelain 2>/dev/null)" ]; }
pushed(){ [ -z "$(git -C "$1" log --branches --not --remotes --oneline 2>/dev/null)" ]; }

rotate(){
  # 1. state dirs
  local gitdir root main d e w kb t s id keep
  gitdir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || { echo "not a git repo" >&2; return 1; }
  for d in publishing handoffs restart-backups coordinator-verification worktrees; do
    d=$gitdir/i-have-a-meeting/$d; [ -d "$d" ] || continue
    newest=$'\n'$(ls -t "$d" | head -n "$KEEP")$'\n'
    while read -r e; do
      case $newest in *$'\n'"${e##*/}"$'\n'*) continue;; esac
      drop "$e" "older than $DAYS days, beyond newest $KEEP"
    done < <(find "$d" -mindepth 1 -maxdepth 1 -mtime +"$DAYS")
  done
  # 2. worktrees
  root=$(git rev-parse --show-toplevel)
  main=$(git rev-parse -q --verify origin/main 2>/dev/null || git rev-parse -q --verify main 2>/dev/null)
  [ -n "$APPLY" ] && git worktree prune
  while read -r w; do
    [ "$w" = "$root" ] && continue
    git merge-base --is-ancestor "$(git -C "$w" rev-parse HEAD)" "$main" 2>/dev/null || { echo "keep     $w (not merged)"; continue; }
    named "$w" && { echo "keep     $w (process uses it)"; continue; }
    idle "$w" || { echo "keep     $w (touched within ${HOURS}h)"; continue; }
    clean "$w" || { echo "keep     $w (dirty)"; continue; }
    say "$w" "merged, clean, idle"
    [ -n "$APPLY" ] && git worktree remove "$w"   # never --force: dirty or untracked files make it refuse
  done < <(git worktree list --porcelain | awk '/^worktree /{print substr($0,10)}')
  # 3. scratchpads
  for s in /private/tmp/claude-"$(id -u)"/*/*/; do
    s=${s%/}; id=${s##*/}; [ -d "$s/scratchpad" ] || continue
    named "$id" && continue
    idle "$s" || continue
    keep=
    while read -r g; do
      w=${g%/.git}; clean "$w" && pushed "$w" || { keep=1; echo "keep     $w (dirty or unpushed)"; }
    done < <(find "$s" -maxdepth 5 -name .git -type d 2>/dev/null)
    if [ -n "$keep" ]; then
      while read -r t; do [ -e "$t/CACHEDIR.TAG" ] && drop "$t" "cargo output, dead session"; done \
        < <(find "$s" -maxdepth 5 -type d \( -name target -o -name 'target-*' -o -name tgt \) -prune 2>/dev/null)
    else drop "$s" "dead session, idle ${HOURS}h"; fi
  done
  echo "total    $((freed/1024)) MiB ${APPLY:+freed}${APPLY:-reclaimable}"
}

selftest(){
  tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
  git -C "$tmp" init -q -b main && git -C "$tmp" -c user.name=t -c user.email=t@t commit -q --allow-empty -m init
  mkdir -p "$tmp/.git/i-have-a-meeting/publishing"
  for i in 1 2 3 4 5 6 7; do mkdir "$tmp/.git/i-have-a-meeting/publishing/p$i"; touch -t 202601010000 "$tmp/.git/i-have-a-meeting/publishing/p$i"; done
  git -C "$tmp" worktree add -q "$tmp/wt-merged" HEAD
  git -C "$tmp" worktree add -q "$tmp/wt-dirty" HEAD && echo x >"$tmp/wt-dirty/x"
  find "$tmp" -exec touch -t 202601010000 {} +   # everything idle
  cd "$tmp" && APPLY=1 rotate >"$tmp/out" 2>&1
  [ "$(ls "$tmp/.git/i-have-a-meeting/publishing" | wc -l)" -eq 5 ] || { echo "FAIL keep newest 5"; cat "$tmp/out"; return 1; }
  [ ! -d "$tmp/wt-merged" ] || { echo "FAIL merged worktree kept"; cat "$tmp/out"; return 1; }
  [ -f "$tmp/wt-dirty/x" ] || { echo "FAIL dirty worktree removed"; return 1; }
  echo "selftest ok"
}

if [ -n "$SELFTEST" ]; then selftest; else rotate; fi
