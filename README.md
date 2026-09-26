# I Have a Meeting

A deadline-driven improvement loop for coding agents:

**Find → claim → fix → verify → integrate → reassess.**

Give your coding agent a deadline and an optional focus area. It chooses the most important available blocker, claims it, makes a bounded fix, verifies the result, integrates it through your project's workflow, and repeats while time remains.

Use it before a demo, during a focused bug-fixing session, or when several agents need to work toward the same finish line. The deliverable is verified progress on the version you will present.

**Status: experimental.** Packaging checks pass. In a six-run sample-project comparison, both conditions passed every acceptance check, while the skill-assisted runs took longer. Improved coding throughput or accuracy has not been demonstrated. This is a Markdown instruction protocol; results depend on the agent, task, tools, and execution environment.

## What it does

- Accepts a natural-language focus area, such as onboarding, checkout, or a failing development workflow.
- Turns the focus and launch requirements into observable completion checks.
- Prioritizes impactful blockers and their prerequisites, with one issue claimed per worker.
- Coordinates ownership of issues and edit scopes through shared sprint state.
- Requires verification and integration before counting a blocker as resolved.
- Preserves a shared deadline and reserves the final five minutes for integration and handoff.
- Reports resolved work, checks actually run, remaining blockers, and the presentation version.

It supplies worker instructions. Your agent host starts workers and provides tools and permissions; the skill does not provision agents, enforce locks automatically, or increase concurrency limits.

## Install

The portable package is [`i-have-a-meeting/SKILL.md`](i-have-a-meeting/SKILL.md). It is self-contained Markdown following the Agent Skills folder format. The original `i-have-a-meeting.md` path is a local symlink to that canonical file.

For Codex, copy the `i-have-a-meeting` directory into the target project's `.agents/skills/` to share it with that project's agents, or into `~/.agents/skills/` for personal use. These are the locations documented in [OpenAI's skill guide](https://learn.chatgpt.com/docs/build-skills). Use your agent's documented skill directory for other hosts.

For a new personal installation:

```sh
git clone https://github.com/yesitsfebreeze/i-have-a-meeting.git
cd i-have-a-meeting
mkdir -p "$HOME/.agents/skills"
cp -R -i i-have-a-meeting "$HOME/.agents/skills/"
```

For a shared project installation, copy that same directory into the target repository's `.agents/skills/` and include it in the repository through your usual workflow. Each worker must have that directory available in its own checkout. Check for an existing installation before updating it.

### Install through llms.txt

Give an agent the local path to [`llms.txt`](llms.txt), or a published URL, and say:

> Read this llms.txt and install i-have-a-meeting into this project's skill directory. Verify the installed contents match the linked source.

The published entry point is [llms.txt on GitHub](https://raw.githubusercontent.com/yesitsfebreeze/i-have-a-meeting/main/llms.txt). An agent can resolve its relative links to fetch the complete package. Pin the URL to a commit instead of `main` when all workers must receive exactly the same version.

## Run

For a quick start, invoke the skill in your target repository:

```text
$i-have-a-meeting Focus on onboarding through the first successful project creation.
```

No special argument syntax is required. Without an explicit deadline, the first worker records a deadline 30 minutes from the start; later workers inherit it. Without a focus area, workers use the agreed launch requirements and presentation journey.

For a specific demo, supply the finish line:

```text
$i-have-a-meeting
Focus on: <journey, subsystem, or problem to improve>.
Our meeting is at <absolute date, time, and timezone>.
Launch means: <observable requirements>.
The presentation version is: <branch, checkout, or environment>.
Use the existing shared sprint state; claim one unowned issue at a time.
```

For workers that cannot discover skills, explicitly ask them to read and follow the canonical Markdown file.

For example, a focused checkout session could use:

```text
$i-have-a-meeting
Focus on checkout from the cart through order confirmation.
Our meeting is in 30 minutes; record one absolute deadline for all workers.
Success means a test customer can complete a sandbox purchase,
see the correct total, and receive exactly one order confirmation.
Use the existing integration checkout as the presentation version.
```

State any required tools or environment constraints in that input. The reusable skill is independent of a particular product or toolset. A focus narrows work selection; it does not mark unrelated launch requirements as passing.

The final handoff identifies what changed, what was verified, which requirements remain failing or unknown, and what version to present.

## Use with multiple workers

Start workers through your existing agent host or orchestration system. Give every worker the same:

- Target project and focus prompt.
- Absolute deadline, including timezone.
- Observable requirements and presentation version.
- Shared coordination location or service.

Workers read shared state before selecting work and claim both an issue and its expected edit scope. Later arrivals inherit the focus and deadline. Supply focus changes explicitly so workers can reassess their claims without starting a new sprint.

Installation distributes instructions. Runtime ownership belongs to the target project, never to the installed skill directory. Linked Git worktrees share the Git common directory's `i-have-a-meeting/` state. Agents in separate clones or on separate machines need a shared coordination location with atomic operations, or an existing coordination service.

Use isolated worktrees, nonoverlapping work claims, and serialized integration. Start with a small worker count and measure verified requirements completed per minute before increasing it. This package supplies instructions; it does not provide an orchestration service or guarantee correctness under concurrent execution.

## Verification and limitations

Run the portable distribution checks with Python 3:

```sh
python3 -m unittest discover -s tests -v
```

These checks verify the canonical Markdown alias and an HTTP installation through `llms.txt`, including linked resources and byte-for-byte copying. They do not execute a coding agent or measure its performance.

Local trial records from September 26, 2026 describe three earlier behavioral smoke tests:

| Trial | Recorded observation |
| --- | --- |
| Improvement loop | A worker completed two sequential fixes, passed five fixture tests, preserved another worker's task, and reported two of three requirements verified. |
| Expired deadline | A worker made no source changes or commits and preserved unresolved failures. |
| Portable installation | A worker installed through `llms.txt`, verified byte equality, then completed two fixes while preserving the owned blocker. |

Those trials predate the optional focus-area update. Their local artifacts live under `.i-have-a-meeting/trials/` and are excluded from the distributable package. They are limited observations, not independently reproducible benchmark results bundled with this release.

A subsequent comparison tested the current focus-enabled skill on a sample checkout project: three baseline runs and three skill-assisted runs, using identical starting code and 69 independent acceptance cases. Both conditions passed 69/69 cases in every run and preserved ownership and focus. Median recorded time was **49 seconds without the skill and 94 seconds with it**. The skill worked on this sample but added overhead without improving measured correctness. See the [complete report, fixture, and saved results](evaluations/checkout/REPORT.md).

These are small-sample observations with worker-recorded timing, not a general performance guarantee. Real concurrent ownership conflicts and integration remain untested. Coordination is only as reliable as the workers' execution of the protocol. More workers can add conflicts and overhead; start small.

To evaluate whether it helps your project, compare the same agent, tools, task starting points, worker count, and time budget with and without the skill. Use independent acceptance checks and repeated trials. Measure verified, integrated requirements per minute, acceptance-check pass rate, regressions, duplicate work, integration conflicts, and token or execution cost. Report failures and unfinished work in both groups. Passing package checks alone is not evidence of improved coding performance.
