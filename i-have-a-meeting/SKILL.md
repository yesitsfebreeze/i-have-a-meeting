---
name: i-have-a-meeting
description: Fix the highest-priority unowned launch blockers before a presentation deadline, with an optional focus area. For one or many agents.
---

# I have a meeting

**Find → claim → fix → verify → integrate → reassess.** Count progress only when a requirement passes on the shared presentation version.

## Set the finish line

- Accept natural-language focus, deadline, requirements, and constraints after the invocation. Default: existing launch requirements and a deadline 30 minutes from the first worker's start.
- Spend roughly two minutes reading project instructions, launch/demo requirements, issues, and current work. Infer a provisional brief from evidence; if the target is unclear, ask one focused question and continue independent work. Never invent the target or lower acceptance criteria.
- Reuse one shared sprint record: verbatim focus; absolute deadline with timezone; observable launch/demo checks; presentation branch/checkout/environment; verified/failing/unknown states with revision and evidence; ownership, dependencies, and integration status.
- Workers inherit that record before selecting work. Never reset the clock or focus. Apply explicit user changes and reassess affected claims/checks. Work within the focus and its prerequisites; keep unrelated blockers visible.
- For skill/document/workflow targets, test observable behavior on isolated examples; no application or Git repository is required. Distinguish format, behavioral, and concurrency evidence.

## Pick and claim one issue

Inspect failures, the demo journey, code, agents, claims, PRs, and branches/worktrees. Tickets are optional; an absent claim does not prove availability. Treat unexplained overlapping work as occupied.

Exclude completed, owned, and dependency-blocked work. Prioritize:
1. Broken core journeys or unacceptable failures, including data loss.
2. Prerequisites unblocking multiple fixes or integration.
3. Required behavior by user impact.
4. Meaningful polish only after required behavior works.

Prefer the smallest complete fix likely to be verified and integrated before the deadline. Split oversized blockers into useful prerequisites; report what cannot fit. Never substitute mocks, hardcoded success, or disabled checks.

State **issue → impact → owner → completion check → time estimate**. Atomically claim the issue and edit scope; if taken, choose another.

## Coordinate

Use the existing atomic coordination system. Otherwise:

- Shared location: explicit location first; otherwise absolute Git common directory plus `i-have-a-meeting/`, or project-root `.i-have-a-meeting/` without Git. Use `sprint.json` unless another format exists. Never store runtime state in the installed skill. Separate clones/hosts need an explicitly shared filesystem/service.
- Atomically create `state.lock` for initialization and every state update. Under lock, reread state, check issue/scope conflicts, preserve other records, and write. Always release only your own lock; never hold it during coding, testing, or waiting. Comments are not atomic claims.
- Claims record unique owner/session, stable issue ID, requirement, edit scope, branch/worktree, start/update times, completion check, and status: `claimed`, `working`, `blocked`, `ready-to-integrate`, `integrating`, or `done`.
- Update at milestones and roughly every two minutes. Recheck ownership before edits/integration; reserve expanded scope under lock first. Reclaim stale work/locks only after confirmed owner exit or explicit handoff; otherwise choose independent work.
- Prefer isolated worktrees. Shared checkouts require nonoverlapping edits and serialized Git index/branch operations. Isolate mutable test resources too.

Without reliable coordination, report the gap and continue independent read-only diagnosis. This skill does not start workers or provision slots.

## Fix and verify

Use project patterns for the smallest complete fix; avoid speculative refactors, dependencies, or unrelated improvements. Reproduce the failure when practical, exercise the affected user journey, and run required checks. Record actual outcomes, including failed, skipped, or unavailable checks; compilation alone is insufficient.

Keep ownership through integration. Use one integrator or a separate integration lock, reconcile with the latest presentation revision, and verify the combined result before marking `done`. Release the integration lock afterward; keep the metadata lock short.

Follow existing permissions for pushes, merges, deployments, and external changes. If authorization is missing, leave a verified patch and exact handoff marked `ready-to-integrate`; it is still unresolved. For other blockers, record evidence and the smallest unblock; explicitly hand off/release the claim when moving on, preserving patches and overlap information. Do not retry without new evidence.

## Repeat and hand off

After each completion or material discovery, reread shared state and the presentation version. Invalidate stale evidence and select the next important available issue. If implementation is owned, investigate independent verification/integration gaps. If nothing useful is available, report and yield.

Read the actual clock at task boundaries and before long operations; bound waits/tests by remaining time. Reserve the final five minutes for integration, verification, and handoff; only start small essential repairs that can finish in time. At the deadline, stop starting/expanding changes, preserve unfinished work separately, and release or hand off claims.

Report briefly:
- **Resolved:** observable changes and patch/commit/file links.
- **Verified:** actual checks, outcomes, revision, and environment.
- **Remaining:** verified/total requirements, failures, unknowns, owners, and time left. Never count unknowns as passing or invent progress percentages.
- **Presentation:** version/URL, shortest demo path, limitations, and pending integration. Presentation readiness is not production readiness unless production checks pass.
