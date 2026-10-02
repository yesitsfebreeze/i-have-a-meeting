# I Have a Meeting

Meeting soon, project not there yet. Give coding agent deadline and focus. It finds most important free issue, fixes it, verifies it, repeats until time runs out.

## Install

Tell your agent:

```text
Install the skill described in https://github.com/yesitsfebreeze/i-have-a-meeting/blob/main/llms.txt
```

Agent reads [llms.txt](llms.txt), installs `i-have-a-meeting/` folder the way its environment expects.

## Use

In your project:

```text
/i-have-a-meeting Focus on checkout. My meeting is in 30 minutes.
```

Codex: `$i-have-a-meeting`. Focus optional. Default deadline 30 minutes.

## Plan time very, very tightly

Time is the main lever. Never give sub-agents generous time. Restrict them so they work faster: a task gets a third of the time you would normally allow (rule of thumb). Work expands to fill any slot, a tight slot forces the smallest complete fix. Estimate, claim and dispatch with the cut time. Too short for the blocker: split it, do not stretch the clock.

Many agents: give each same focus, deadline, and shared git remote. They claim separate issues through a ledger branch and verify before marking done. Start them with your usual agent tool.

## Persona

Base behavior for every run comes from [preciser](https://github.com/yesitsfebreeze/preciser): reply shape, terse wording, minimal changes, working ethic. Install it next to this skill.

## Methods

[`scripts/coordinator.sh`](i-have-a-meeting/scripts/coordinator.sh) maps a finding to methods with TypeSafe Jev (`TYPESAFE_API_KEY`): priority, which check confirms cause, which methods diagnose, which fix. Without a key, `coordinator.sh --table` prints the routing tables. Agent opens only method files it names.

- **Symptom methods:** stale build, env drift, expired access, missing data, race, edge input, contract drift, slow path, regression, hidden step. Each: usual cause, confirming check, where fix belongs, tempting wrong fix.
- **Craft methods:** how elite programmers prove and fix any bug. Think first, step real path, look at data first, hunt same mistake, and eight more, each with primary source (Carmack, Thompson and Pike, Kernighan, Torvalds, Beck, Knuth, Dean, Muratori, Acton, Brooks).

Diagnosis, regression-test, merge, handoff rules adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).

## Back-to-back sprints in Codex

Install both `i-have-a-meeting/` and `i-have-an-endless-meeting/` into your Codex skills directory, with `preciser` alongside them. Invoke:

```text
$i-have-an-endless-meeting Work on this project's checkout acceptance criteria. One worker at a time, up to 10 minutes each.
```

The parent starts a native goal, reviews each worker's evidence, and dispatches the next sprint immediately after completion or handoff. It stops when the objective is verified, the user stops it, or a deadline/budget prevents further work. You can supply an overall deadline or cycle limit. The 10-minute worker deadline (a third of 30, on purpose) is supervised; native interrupts can wait for pending tools, so this is not a hard process timeout.
