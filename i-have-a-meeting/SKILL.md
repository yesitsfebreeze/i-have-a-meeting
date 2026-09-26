---
name: i-have-a-meeting
description: Find, claim, and fix the highest-priority unowned launch blocker before an imminent product presentation, optionally guided by a focus prompt. Use for a deadline-driven launch sprint with one or many agents.
---

# I have a meeting

We have a product presentation in 30 minutes. Make the product measurably closer to launch before that deadline. Find the single most pressing issue that is not already being worked on, own it, resolve it, verify it, and reassess. Continue while useful work fits in the remaining time.

Your unit of progress is a launch requirement that now passes on the shared presentation version. Activity, commits, and fixes that exist only in an isolated branch do not establish readiness.

## Accept a focus prompt

Treat text supplied with the invocation as the sprint input, including any focus, deadline, requirements, and constraints. Accept natural language directly; no special argument syntax is required. For example: `$i-have-a-meeting Focus on onboarding through the first successful project creation.` If no focus is supplied, use the agreed launch requirements and presentation journey.

Record the user's focus verbatim in the shared sprint record and derive observable completion checks from it. Every worker must receive that prompt or read it from shared state before selecting work. Later workers inherit the existing focus and deadline; they must not silently replace either. Apply explicit user changes to the shared record and reassess affected claims and checks.

Prioritize issues within the focus and prerequisites needed to make it work. Keep unrelated launch failures visible without diverting into them unless they block the focus or the user changes scope. A focus prompt does not make other launch requirements pass or authorize unrelated actions.

## Establish the finish line

Read the repository instructions and existing launch brief, acceptance criteria, demo flow, issue tracker, and current work state. Spend roughly the first two minutes establishing enough context to act; avoid a repository-wide audit unless it is necessary to identify a blocker.

All agents must use one shared sprint record containing:

- An absolute meeting deadline, including timezone. Use the supplied deadline; otherwise the first agent records now plus 30 minutes. Later arrivals inherit it. Never restart the clock on a new task or agent invocation.
- The supplied focus prompt and its completion checks.
- The product's launch requirements and the specific user journey to present, with observable pass/fail checks. Keep presentation readiness and production launch readiness distinct when their requirements differ.
- The integration branch or checkout and, if applicable, the environment that will actually be presented.
- Current requirement states: verified, failing, or unknown, with evidence and the revision/environment checked.
- Work ownership, dependencies, and integration status.

Reuse an existing coordination system when available. Otherwise use the shared local coordination protocol below. The first agent records a concise provisional launch brief from repository evidence; subsequent agents reuse it. If the intended product or launch target cannot be inferred, ask one focused question and continue only work independent of the answer. Do not invent a product or silently reduce the launch bar to whatever currently passes.

When the user explicitly makes a skill, document, or improvement workflow the target, define observable checks for that artifact and exercise it on isolated examples. Application code and a Git repository are not prerequisites for that kind of trial. Distinguish format validation, behavioral trials, and concurrent-load testing in the evidence; passing one does not establish the others.

## Pick the single most pressing available issue

Inspect current failures, the actual demo journey, relevant code, and available issues. An issue does not need a ticket to be real. Describe the concrete failure and the launch requirement it blocks before editing.

Check active agents, claims, open PRs, branches/worktrees, and existing in-progress work where accessible. An absent claim alone is not evidence that nobody is working on it. Treat unaccounted-for overlapping changes as occupied until ownership is resolved.

Exclude completed work, actively owned work, and tasks whose unresolved dependencies prevent useful independent progress. Rank what remains in this order:

1. Failures that make the agreed launch or core presentation journey impossible, or expose a concrete unacceptable failure such as data loss on that journey.
2. Prerequisites that unblock several other necessary fixes or unblock their integration.
3. Remaining required launch behavior, ordered by user impact.
4. Presentation polish only when the required behavior is already working and the polish materially affects the presentation.

Within the same priority, prefer the smallest change with the highest likelihood of being implemented, verified, and integrated before the deadline. Include verification and integration in the estimate. Avoid choosing easy cosmetic work while an actionable launch blocker remains.

If the most important blocker is too large, identify a bounded prerequisite or a smaller complete fix that genuinely advances it. Do not conceal the failure with hardcoded success, disabled checks, or undisclosed mock behavior. Report any blocker that cannot realistically be resolved in time.

Before starting, state briefly: **issue → launch impact → ownership → completion check → estimated time**. Claim exactly one issue. If another agent wins that claim, immediately select the next candidate.

## Coordinate without duplicating work

Claims must reserve both the issue and the expected edit scope. Different issue titles can still represent the same underlying failure or conflicting edits.

Use the existing system's atomic ownership mechanism if it has one. A comment saying “I'm on it” or an ordinary Markdown edit is not an atomic claim.

For agents sharing a filesystem without a coordination system:

1. Use a single shared directory. Honor an explicitly supplied coordination location first. Otherwise, in Git, resolve the absolute `git rev-parse --git-common-dir` and use its `i-have-a-meeting/` subdirectory, which is shared across linked worktrees. Without Git, use `.i-have-a-meeting/` in the shared project root. Store the shared record in `sprint.json` unless the project already has a different format. Keep runtime state in the target project or coordination service, never in the installed skill directory. Separate clones or hosts need an explicitly shared directory or service; clone-local files do not coordinate them.
2. Use atomic directory creation of `state.lock` as a short exclusive lock around sprint initialization and every claim/state update. Inside the lock, reread current state, check issue and edit-scope conflicts, then write the update. Release only the lock you acquired, even on error. Never hold this metadata lock while coding, testing, or waiting for another agent.
3. Record a unique owner/session ID, stable issue ID, affected requirement, edit scope, branch/worktree, start and last-update times, completion check, and status. Use statuses such as `claimed`, `working`, `blocked`, `ready-to-integrate`, `integrating`, and `done`. Preserve other agents' records.
4. Update ownership at milestones and roughly every two minutes during longer work. An old timestamp is a reason to investigate, not permission to steal work. Reclaim a task or abandoned lock only after confirming its owner has stopped or obtaining an explicit handoff. If ownership cannot be resolved, choose independent work.
5. Recheck ownership before edits and integration. Expand a claim's edit scope under the same lock before touching additional files; resolve collisions first.

Prefer separate worktrees or isolated checkouts for concurrent implementation. Agents sharing a checkout must have nonoverlapping edit scopes and must serialize shared Git index/branch operations. Isolate mutable test resources too, including ports, test databases, and generated files.

If reliable coordination is unavailable, continue independent read-only diagnosis and report the missing coordination mechanism. Do not launch concurrent conflicting edits. This skill is a worker protocol; it does not provision slots, run an orchestrator, or create additional agents by itself.

## Fix, verify, and integrate

Make the smallest complete change that satisfies the claimed completion check. Avoid speculative refactors, new dependencies, and unrelated improvements. Use existing project patterns and commands.

Reproduce the failure when practical, then run the relevant verification after the change. For a user-facing blocker, exercise the affected user journey; compilation alone does not show that the journey works. Run required project checks and record actual results. Keep failed, skipped, and unavailable checks visible.

Prepare a reviewable patch or commit and integrate through the repository's authorized workflow. Keep ownership while the fix awaits integration. Use one integrator or a separate exclusive integration lock so concurrent agents cannot overwrite the shared presentation version. Reconcile against its latest revision, run the applicable checks on the combined result, and only then mark the issue `done`. Release the integration lock after the operation; do not hold the metadata lock throughout it.

The deadline does not expand permission to push, merge, deploy, or modify external systems. When an integration action requires authorization that is missing, leave a verified patch with exact handoff instructions and mark it `ready-to-integrate`. Continue with other independent work if time permits. Do not count the pending patch as a resolved launch blocker.

If blocked by access, a decision, or another agent, record the evidence and smallest needed unblock. Explicitly hand off or release the claim when moving on, retaining the patch and overlap information so the next agent can resume safely. Avoid repeated retries with no new evidence.

## Reassess against launch

After every completed issue or material discovery, reread the shared state and current presentation version. Independently ask: “What still prevents the agreed launch, and what is the most important unowned issue I can resolve now?”

Report readiness using requirement counts and named blockers: for example, `4/6 launch checks verified; checkout failing; deployment unknown; 8 minutes remain`. Include the revision and environment when relevant. Do not invent a percentage or treat unknown checks as passing. Existing evidence must be reconsidered when a change invalidates it.

Take the next highest-priority available issue while time permits. When all implementation work is owned, look for an independent verification gap, integration blocker, or useful investigation. Do not duplicate another owner's fix to stay busy. If there is no useful unowned work, report that state and yield.

Reserve the final five minutes for integration, checks, and presentation handoff. Start no new implementation during that window unless it is a small essential repair that can be verified before the deadline. Read the actual clock at each task boundary and before long operations; bound waits and test runs by the remaining time.

At the deadline, stop starting or expanding changes. Preserve unfinished work separately from the presentation version, release or hand off your claims, and report honestly. A ready presentation does not establish production launch readiness unless the production requirements also pass.

## Final handoff

Keep the report short:

- **Resolved:** issue and observable improvement, with patch/commit or file links.
- **Verified:** checks actually run, results, and revision/environment.
- **Launch distance:** verified/total requirements, remaining failures and unknowns, and current owners.
- **Presentation:** version or URL to use, shortest demonstration path, and any limitation or pending integration.

Optimize for verified launch progress per minute. More agents help only while useful independent work exceeds coordination and integration overhead.
