---
name: i-have-an-endless-meeting
description: Run successive i-have-a-meeting sprints under one persistent Codex goal, with one worker at a time and a tight 10-minute deadline per worker. Use when the user requests endless meeting mode or back-to-back delegated meeting sprints on a project.
---

# I have an endless meeting

Keep this thread as coordinator. Run the existing `i-have-a-meeting` skill in successive workers toward the user's project objective. Invoking this skill requests a persistent goal and sequential delegation. Creating or installing the skill does not start it.

## Start or restore

- Resolve project, objective, and observable completion criteria from the invocation and current conversation. If no project or meaningful objective can be established, ask for those before starting workers. Do not invent an endless backlog.
- Plan time very tightly: give workers a third of the generous time. Default worker deadline: 10 minutes from dispatch. Accept shorter limits; cap longer requested sprint lengths at 10 minutes unless the user explicitly changes this mode's maximum. An optional overall deadline or cycle limit also stops the run. Without either, continue while useful work remains toward the objective, subject to user stop and host budgets.
- Read the installed `i-have-a-meeting` skill and resolve its absolute path for workers. It is a sibling directory in this repository and in the personal Codex skills installation. Load its dependencies when running its workflow.
- Use `get_goal` first. Resume coordination for a matching active goal; do not replace an unrelated unfinished goal. Ask the user to resolve that conflict. Otherwise use `create_goal` with the concrete outcome, verification criteria, and this iteration policy. Set a token budget only if explicitly requested. Follow the goal tools' lifecycle rules.
- Restore the run record and inspect existing agents before dispatching anything. Store coordinator thread ID, objective, cycle number, worker ID, start/deadline in UTC, scope, evidence, and remaining work in `.i-have-a-meeting/endless-<coordinator-thread-id>.json` in the project. Write atomically. Avoid duplicate workers after compaction or resume.

## Dispatch one sprint

Choose the highest-value unfinished, unowned outcome. Use available native subagent tools. Pass the worker the project path, exact skill path, outcome, acceptance checks, absolute deadline, remaining overall time, and prior handoff. Tell it:

> Run i-have-a-meeting for this outcome. Return immediately once verified, or when blocked. Reserve the last five minutes for verification and handoff. Stop substantive work by the supplied deadline. Do not launch workers or start another goal. Keep evidence and remaining work in the coordinator's run record or a dedicated handoff file. Respect the existing permission scope. Do not reset the deadline.

The coordinator does no competing implementation. One implementation worker is active at a time. Do not automatically push, publish, deploy, or send messages because a sprint ended. The underlying meeting skill's existing permission boundaries still apply.

## Supervise and rotate

1. Read the actual clock. Wait for worker completion or user steering in intervals no longer than 60 seconds, shortened near the deadline. Keep progress updates concise and report meaningful changes. Do not end the coordinator turn just to wait.
2. Early completion: inspect the worker's evidence and the changed files or checks needed to assess it. Record the result, choose the next unfinished outcome, and dispatch immediately without waiting for the old deadline. A worker finishing does not complete the parent goal unless the whole objective is verified.
3. Deadline: request handoff during the final five minutes; at the deadline interrupt the worker with the available native interrupt tool. Check worker state and any spawned shell processes before transferring file ownership. An interrupt request is not proof that a pending command stopped. Do not start a replacement editing the same scope until the previous worker and its mutating processes have stopped. Preserve unfinished patches and report them accurately.
4. Prefer a fresh worker when the host can release finished slots. If the host only offers follow-up turns and slots are exhausted, reuse an idle worker with a new bounded assignment and explicit handoff. Disclose reuse; never claim fresh context. If no delegation capacity is available, report the limitation rather than pretending rotation happened.
5. Persist the handoff before the next dispatch. Carry unresolved evidence and ownership forward; do not repeatedly rediscover the same blocker. If no useful independent work remains, follow the native goal tool's blocked-state rules and report what input is required.

## Timing and stopping

The 30 minutes is a supervised deadline, not a guaranteed process kill. Native agent interrupts may wait for a tool call to return. This skill cannot guarantee a hard wall-clock cutoff or keep running while the host is shut down. If the user requires strict termination at exactly 30 minutes, explain that an external watchdog with process ownership is needed; do not claim this skill supplies one.

On user stop, stop dispatching, interrupt the active worker, preserve progress, and honor the requested goal lifecycle action. Never restart after a stop. On an overall deadline, cycle limit, or host budget, stop dispatching and report remaining work; do not mark an unfinished objective complete. Mark the goal complete only when all its acceptance criteria are verified. Do not manufacture work merely to keep the session active.

Report completed outcomes, actual verification, unresolved items, worker/cycle status, and the reason for stopping. On compaction, reload the run record and goal before acting.
