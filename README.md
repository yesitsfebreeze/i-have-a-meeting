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

Many agents: give each same focus, deadline, shared coordination location. They claim separate issues and verify before marking done. Start them with your usual agent tool.

## Persona

[`styles/persona.md`](i-have-a-meeting/styles/persona.md) is base behavior for every run. Three layers: reply shape from [i-have-adhd](https://github.com/ayghri/i-have-adhd) (next action first, numbered steps, state restated), terse wording from [caveman](https://github.com/JuliusBrussee/caveman), minimal changes from [ponytail](https://github.com/DietrichGebert/ponytail). All MIT. No need to install them separately.

## Methods

[`COORDINATOR.md`](i-have-a-meeting/COORDINATOR.md) maps symptom to methods: which check confirms cause, which methods diagnose, which fix. Agent opens only files its row names.

- **Symptom methods:** stale build, env drift, expired access, missing data, race, edge input, contract drift, slow path, regression, hidden step. Each: usual cause, confirming check, where fix belongs, tempting wrong fix.
- **Craft methods:** how elite programmers prove and fix any bug. Think first, step real path, look at data first, hunt same mistake, and eight more, each with primary source (Carmack, Thompson and Pike, Kernighan, Torvalds, Beck, Knuth, Dean, Muratori, Acton, Brooks).

Diagnosis, regression-test, merge, handoff rules adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
