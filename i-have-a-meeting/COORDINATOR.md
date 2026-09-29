# Coordinator

Index of every method in `methods/`, and how to combine them. Open only files a row names, plus closing methods in Order step 5.

Three kinds:

- **Pick methods** choose what to work on and when to stop. Same fields as craft methods.
- **Symptom methods** start from what you see. Each gives usual cause, red check that confirms it, where fix belongs, trap.
- **Craft methods** work on any cause. Each gives trigger, move, done condition, trap, source.

## Pick

Before claiming, and at every task boundary:

| Trigger | Pick with |
|---|---|
| Presentation version or shared check red | [stop-the-line](methods/stop-the-line.md) (preempts all) |
| Starting any iteration | [finish-right-first](methods/finish-right-first.md) |
| Several free issues, same priority tier | [value-per-minute](methods/value-per-minute.md) |
| Change deletes data, sends, rotates secrets, force-pushes, deploys publicly | [door-check](methods/door-check.md) |
| Half of claimed estimate passed | [halfway-breaker](methods/halfway-breaker.md) |

## Order

1. Build red loop (SKILL.md, Diagnose).
2. Find symptom row below. `TYPESAFE_API_KEY` set: run `scripts/triage.sh "<symptom>"` first; it names likely row, red check, and priority. Treat its pick as hypothesis; matrix row wins over its first move. Run that method's red check. Several rows match: run each row's red check. Red check stays green: row ruled out; try next row or **No row fits**.
3. Diagnose with row's craft methods, left to right, until cause confirmed.
4. Fix in order given under **Combining**.
5. Close every fix with [machine-check](methods/machine-check.md), then [same-mistake](methods/same-mistake.md), then [premortem](methods/premortem.md).

## Matrix

| You see | Symptom method | Diagnose with | Fix with |
|---|---|---|---|
| Fix passes locally, presentation still shows old behavior | [stale-build](methods/stale-build.md) | [data-first](methods/data-first.md) on served revision | [plain-fix](methods/plain-fix.md) |
| Works on one machine or host, fails on another | [env-drift](methods/env-drift.md) | [data-first](methods/data-first.md) on both sides' config; [step-the-path](methods/step-the-path.md) when differing value not obvious | [plain-fix](methods/plain-fix.md) |
| Outside service answers 401, 403, 429, or quota | [expired-access](methods/expired-access.md) | [data-first](methods/data-first.md) on error body | [plain-fix](methods/plain-fix.md) |
| Empty, not-found, or blank screens on presentation host only | [missing-data](methods/missing-data.md) | [data-first](methods/data-first.md) | [plain-fix](methods/plain-fix.md) |
| Fails on first load or sometimes; retry fixes it | [race](methods/race.md) | [think-first](methods/think-first.md), then [step-the-path](methods/step-the-path.md); [skipped-update](methods/skipped-update.md) when cache or flag on path | [plain-fix](methods/plain-fix.md) |
| Unusual input (empty, one item, max value, odd characters, real sample data) breaks tested path | [edge-input](methods/edge-input.md) | [data-first](methods/data-first.md), then [think-first](methods/think-first.md) | [pure-extract](methods/pure-extract.md), [no-special-case](methods/no-special-case.md) |
| Each side passes own tests; combined journey fails | [contract-drift](methods/contract-drift.md) | [data-first](methods/data-first.md) on one real exchange | [plain-fix](methods/plain-fix.md); [easy-change](methods/easy-change.md) when many consumers read field |
| Works, but too slow on host, with real data, or on venue Wi-Fi | [slow-path](methods/slow-path.md) | [estimate-profile](methods/estimate-profile.md) | [plain-fix](methods/plain-fix.md) on largest share only |
| Worked at known earlier revision or rehearsal | [regression](methods/regression.md) | [recent-change](methods/recent-change.md) when history short; bisect (from regression method) when long | revert or [plain-fix](methods/plain-fix.md) |
| Fails silently, returns wrong default, or aborts far from fault | [swallowed-error](methods/swallowed-error.md) | [step-the-path](methods/step-the-path.md) to first handler on path | [plain-fix](methods/plain-fix.md) in handler |
| Works for one person only, or broke after fresh setup | [hidden-step](methods/hidden-step.md) | [step-the-path](methods/step-the-path.md) through written setup | [plain-fix](methods/plain-fix.md) in setup path |

### No row fits

Build loop from reported symptom. Several situations match: go top to bottom, stop at first confirmed cause.

| Situation | Diagnose with |
|---|---|
| Before deep diagnosis, or sure hypothesis died | [check-the-plug](methods/check-the-plug.md) |
| About to read control flow | [data-first](methods/data-first.md) |
| Fails only in some modes, states, orders | [skipped-update](methods/skipped-update.md) |
| Unfamiliar code, or bug depends on state, mode, config | [step-the-path](methods/step-the-path.md) |
| You know the code | [think-first](methods/think-first.md) |
| Two hypotheses died, or 5 minutes without new evidence | [fresh-view](methods/fresh-view.md) |

Fix with matching **Fix shape** methods, [plain-fix](methods/plain-fix.md) last.

Confirmed cause matches no row: add proposed symptom method with same fields as other symptom methods to handoff.

### Fix shape

Apply on top of any row when trigger holds:

| Trigger | Fix with |
|---|---|
| Choosing between fixes | [plain-fix](methods/plain-fix.md) |
| Buggy logic tangled with global state, no test seam | [pure-extract](methods/pure-extract.md) |
| Fix touches many sites or fights structure | [easy-change](methods/easy-change.md) |
| Bug lives in empty, first, last, or null branch | [no-special-case](methods/no-special-case.md) |
| Several callers hit bug | fix in shared function every caller routes through; no per-caller guard |
| No tests around behavior fix must keep | [characterize-first](methods/characterize-first.md) before editing |
| New logic needed inside long tangled function; extraction too big | [sprout-fix](methods/sprout-fix.md) |

## Combining

- Symptom method gives hypothesis; craft method gives move that confirms it. Act on symptom method only after its red check goes red.
- Diagnose methods stop at first confirmed cause. Fix methods stack: shape change first ([easy-change](methods/easy-change.md), [pure-extract](methods/pure-extract.md)), then row's fix methods and any matching Fix shape methods, [plain-fix](methods/plain-fix.md) last.
- Two rows go red: fix one on core journey first, rerun loop; second often disappears.
