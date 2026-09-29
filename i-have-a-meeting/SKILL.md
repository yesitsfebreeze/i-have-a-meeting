---
name: i-have-a-meeting
description: Deadline push toward a project's vision or briefing before a meeting, presentation, or launch. Finds the vision (warns when none exists), picks the one most valuable unowned blocker, reproduces it with a failing check, fixes it at root cause, verifies it on the presentation version, and repeats until time runs out, then reports what works, what is left, and which paths to avoid. Use when the user has a meeting or presentation soon, says something must work "by 3pm" or "in 30 minutes", or asks to move a project toward its vision against a deadline. Takes an optional focus and deadline (default 30 minutes). Works for one agent or a swarm coordinating through a git ledger.
argument-hint: "[focus] [deadline, e.g. 'checkout, meeting in 45 minutes']"
---

# I have a meeting

Loop until deadline:

1. Find most important unowned issue.
2. Claim it.
3. Fix it.
4. Verify on presentation version.
5. Integrate, reassess, repeat.

Progress counts only when requirement passes on shared presentation version. [scripts/coordinator.sh](scripts/coordinator.sh) maps finding to methods: `coordinator.sh "<finding>"` with `TYPESAFE_API_KEY`, else `coordinator.sh --table` and route by hand. Open only method files it names.

Base behavior for every reply and every change in this run: the Toni persona from [preciser](https://github.com/yesitsfebreeze/preciser) (shape, words, build, ethic). Not already active as output style: load `preciser` skill first.

## Set the finish line

1. Read focus, deadline, requirements, constraints from invocation. Default: vision checks from step 2, deadline 30 minutes after invocation.
2. **Find the vision.** Spend about 2 minutes searching for what project works toward: briefing, vision, roadmap, spec, PRD, README goals, pinned issues, milestones, project instructions, recent plans. Record path. Several: invocation focus picks; else newest. None found: warn user in first reply ("No vision or briefing found; working toward inferred goal: ..."), infer provisional goal from issues and current work, label it inferred in every report. Vague request ("make it better"): infer goal and proceed. Ask one focused question only when two plausible goals need incompatible work; keep doing independent work meanwhile. Never invent target or lower acceptance criteria.
3. Turn vision into observable checks for focus. Note own deadline (absolute, with timezone), presentation branch and environment. Per check: verified, failing, or unknown, with revision and evidence.
4. Shared state is git only: ledger (see **Shared sprint**) plus presentation branch. Never reset clock or focus. Apply explicit user changes, reassess affected claims and checks. Stay inside focus and its prerequisites; keep unrelated blockers visible.

Target is skill, document, or workflow: test observable behavior on isolated examples; no app or Git repository needed. Report format, behavior, and concurrency results separately.

## Pick and claim one issue

Inspect failures, core journey from vision, code, agents, claims, PRs, branches, worktrees. Tickets optional; missing claim does not prove issue free. Unexplained overlapping work counts as taken.

Red presentation version preempts everything: [stop-the-line](methods/stop-the-line.md). Then move work nearest done: [finish-right-first](methods/finish-right-first.md). Skip done, owned, dependency-blocked work. Priority:

1. Broken core journey or unacceptable failure, including data loss.
2. Prerequisite that unblocks several fixes or integration.
3. Required behavior, by user impact.
4. Polish, only after required behavior works.

Rank candidates with `scripts/coordinator.sh "<issue>"`; name vision check it breaks in text ("breaks presentation step 3: ..."). It returns priority level above and pick methods that apply. Your evidence overrides it.

Same tier: [value-per-minute](methods/value-per-minute.md). Pick smallest complete fix likely verified and integrated before deadline. Split oversized blocker into useful prerequisites; report what cannot fit.

One-way change (data, sends, secrets, public deploy, force-push): [door-check](methods/door-check.md). At half estimate: [halfway-breaker](methods/halfway-breaker.md). State issue, impact, owner, completion check, estimate in minutes. Claim with estimate; claimed scope overlapping yours counts as taken.

## Shared sprint

Workers know each other only through git. Existing atomic coordination system wins. Otherwise ledger: file `LEDGER` on orphan branch `ledger` of shared remote, driven by [scripts/ledger.sh](scripts/ledger.sh). Script never touches worktree or index.

- **Line:** `id agent scope started deadline status`, tab-separated, one per event. Last line per id wins. Status `claimed`, `done`, or `released`. `done` is final.
- **Free:** no line, `released`, or `claimed` past deadline plus 5 minutes grace. Expired, but owner's branch got commits in last 10 minutes: still taken.
- **Look:** `ledger.sh init` once (no-op when branch exists), then `ledger.sh read`. Fetches only `ledger` ref; never pull. Never trust `raw.githubusercontent.com` (cached).
- **Claim:** research, then `ledger.sh claim <id> <agent> <scope> <minutes>`; deadline is now plus estimate. Script rereads tip, checks id free, pushes with `--force-with-lease` on tip it read. Exit 0 won. Exit 2 taken: pick another issue. Exit 3 remote unreachable or retries spent: report, continue read-only. Lease rejected: script rereads and retries. Scope overlap is not checked by script; compare scopes in `read` first.
- **Before edit and integration:** `ledger.sh mine <id> <agent>`. Not yours: stop, keep patch, pick another.
- **End:** `ledger.sh done` after integration verified; `ledger.sh release` when handing off or out of time.
- **Isolation:** own branch or clone per worker. Isolate mutable test resources too.
- **GitHub:** protect `ledger` against force-push and deletion; lease pushes still work.

Single worker, no shared remote: skip ledger; keep sprint record in untracked `.i-have-a-meeting/SPRINT`. Fix on own branch; after verify, integrate by local fast-forward merge onto presentation branch (never push). Several workers without shared remote or push right: report gap, continue read-only diagnosis. Skill does not start workers or provision slots.

## Diagnose

1. **Build red loop.** No theory before loop. One command (failing test, curl, CLI fixture diff, headless browser script, replayed payload, throwaway harness) that drives real code path and asserts exact reported symptom. Run it; record command and output.
2. **Make it fast and deterministic.** Seconds, not minutes. Pin time and seed; isolate files and network. Flaky: loop or stress trigger to raise rate. Slow: measure baseline first.
3. **Shrink.** Cut inputs and steps until each remaining part matters.
4. **Route.** Run `scripts/coordinator.sh` on reduced symptom, run its red check. Red: top hypothesis. Green: row ruled out; try next row or its No row line. Diagnose with named methods until cause confirmed; fix in its Fix order; close with its Close methods. Treat its pick as hypothesis; red checks decide.
5. **Probe.** Rank 3–5 falsifiable hypotheses ("if X, changing Y makes it pass"). Cheapest high-ranked first, one variable per probe.

No loop fits time left: say so, list what was tried, ask for access, captured artifact, or human to drive reproduction. Tag temporary logs with unique prefix (`[DEBUG-a4f2]`) so one grep removes them.

## Fix and verify

1. **Shape.** Take fix methods from coordinator row plus coordinator **Fix shape** table. Project patterns, smallest complete fix. No speculative refactors, dependencies, unrelated improvements.
2. **Regression test.** Seam reaches real failure: turn reduced reproduction into test, watch fail, fix, watch pass. Test too shallow to show real failure is not evidence; record missing seam instead. Expected values come from requirement or known-good example, never recomputed the way code does.
3. **Verify.** Rerun original loop, walk affected user journey, run required checks. Record actual outcomes, including failed, skipped, unavailable. Remove fix: original loop must go red; restore: green. Clear bytecode and build caches first (`python3 -B`, clean build), else stale cache keeps check falsely green.
4. **Close.** Run coordinator closing methods. Remove debug tags and throwaway files. State confirmed cause.

Out of time:

- Core journey blocked, cause will not fit: mitigate first, label patch temporary, keep issue open until cause confirmed.
- Fix will not verify, presentation version worked at earlier recorded revision: revert regressing change over risky patch, within existing permissions; no permission: propose revert.

## Integrate

- Keep ownership through integration. One integrator, or claim ledger id `integrate` for each merge. Reconcile with latest presentation revision; verify combined result before `done`.
- Conflict: read commits and claims behind each side. Keep both intents where they fit; presentation goal wins where not. Never invent new behavior. Rerun checks on merged result. Release integration lock after; keep metadata lock short.
- Follow existing permissions for push, merge, deploy, external changes; single worker's local fast-forward merge needs none. Authorization missing: leave verified patch plus exact handoff marked `ready-to-integrate`; still unresolved.
- Other blockers: record evidence and smallest unblock. Moving on: hand off or release claim explicitly, keep patches and overlap info.

## Repeat and hand off

- After each completion or real discovery: reread shared state and presentation version, drop stale evidence, pick next important free issue. Implementation owned elsewhere: take independent verification or integration gaps. Nothing useful left: report and yield.
- Read actual clock at task boundaries and before long operations. Bound waits and tests by time left.
- Last 5 minutes: integration, verification, handoff only. Start only small essential repairs that finish in time.
- Deadline: stop starting or expanding changes. Keep unfinished work separate. Release or hand off claims. Run `scripts/rotate.sh --apply` once: it drops meeting state older than 3 days beyond the newest 5 per dir, removes merged clean idle worktrees (never forced), and dead session scratchpads. Dry run without `--apply`.
- Handoff: reproduction command, remaining ranked hypotheses, what was ruled out. Link patches, commits, issues; do not restate them.

## Report

First line: shortest path through vision that works now, or one action user must take before meeting. Then:

- **Resolved:** observable changes, patch, commit, file links.
- **Verified:** actual checks, outcomes, revision, environment.
- **Remaining:** verified/total requirements, failures, unknowns, owners, minutes left.
- **Presentation:** version or URL, path that works, paths to avoid, limitations, pending integration. Presentation-ready is not production-ready unless production checks pass.

No preamble, no recap prose, no closing offer. Last line: one next action doable in under 2 minutes.
