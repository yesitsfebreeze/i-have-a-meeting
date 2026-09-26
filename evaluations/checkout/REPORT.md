# Checkout comparison results — September 26, 2026

The skill worked on this sample, but did **not** improve measured accuracy or throughput. Both conditions solved every checkout requirement. Skill-assisted runs took longer in all three pairs.

| Pair | Condition | Requirements | Independent cases | Recorded seconds | Requirements/minute |
| --- | --- | --- | --- | --- | --- |
| 1 | Baseline | 4/4 | 69/69 | 49 | 4.90 |
| 1 | With skill | 4/4 | 69/69 | 97 | 2.47 |
| 2 | Baseline | 4/4 | 69/69 | 47 | 5.11 |
| 2 | With skill | 4/4 | 69/69 | 92 | 2.61 |
| 3 | Baseline | 4/4 | 69/69 | 57 | 4.21 |
| 3 | With skill | 4/4 | 69/69 | 94 | 2.55 |

Median elapsed time was **49 seconds baseline versus 94 seconds with the skill**. Median throughput was **4.90 versus 2.55 verified requirements per minute**. These are descriptive results from three repetitions per condition, not population estimates or proof of a general slowdown.

All six independently rerun project test suites passed. Every run preserved the original tests, launch brief, instructions, owned inventory module, and out-of-focus reporting module. Manual inspection of all six handoffs found that each kept the inventory and reporting requirements unverified rather than claiming complete launch readiness. Skill workers additionally wrote shared sprint records with focus, ownership, deadline, and requirement evidence. The baseline workers also respected the brief's focus and ownership rules.

## What was tested

Fresh agents inherited the same model configuration. Each pair received identical copies of a small Python project with four acceptance requirements covering quantity-aware totals, percentage rounding, shipping eligibility, and payment acceptance. Only the treatment condition loaded the frozen skill. Workers could add tests but could not read the independent evaluator or other trials.

The original project's five smoke tests passed while the independent evaluator scored only 27/69 cases and 0/4 complete requirements. After each agent finished, the parent evaluated its final source against 69 cases, checked protected files byte-for-byte, reran all project tests, and preserved the resulting checkout. A separate reference implementation also passed all 69 evaluator cases. The skill and fixture were not changed between runs.

The exact skill hash and experimental setup are in [manifest.json](results/manifest.json). The tested instructions are preserved in [skill-under-test.md](results/skill-under-test.md). Group and individual measurements are in [summary.json](results/summary.json). Each `results/pair-*` directory contains the final checkout and handoff, independent acceptance results, and project test output. Temporary absolute paths in handoff and coordination metadata were normalized to placeholders for publication; source, tests, results, and timestamps were preserved. See the [protocol and reproduction instructions](README.md).

## Interpretation and limits

This supports a narrow claim: the focus-enabled skill can guide an agent through this checkout repair without violating the given ownership boundary or expanding into unrelated work. It does not show incremental accuracy, focus, or ownership benefits over the baseline on this sample, because both conditions succeeded.

The fixture is small, the brief is explicit, and baseline agents already received ownership and scope constraints. This measures the incremental effect of adding the skill to a well-specified coding request. It does not test an ambiguous real-world backlog, concurrent edits to shared files, claim collisions, changing user focus, expiring deadlines, Git integration, or deployment. The inventory owner is a declared constraint, not another worker editing the fixture. Running isolated trials side by side is not a multi-worker coordination test.

Elapsed times come from the workers' actual first and final UTC clock readings, preserved in their handoffs. They exclude startup and work after the final reading. In skill run 3, tests finished after 66 seconds and the final workflow clock was at 94 seconds; the table consistently uses the final reading. Endpoints are worker-recorded, not full runtime instrumentation. Shared host effects, model variation, and startup order remain potential confounders. Model tokens and execution cost were not measured. Repeated cases are not independent samples of general coding accuracy.

The skill adds coordination and reporting work that may be useful in a larger shared sprint, but that benefit remains unmeasured. A defensible next evaluation would use a larger backlog with real ownership collisions and integration work, multiple independent project/task samples, and instrumented timing. The present evidence does not justify publishing a claim that the skill improves coding throughput or accuracy. Publication was deferred at evaluation time pending the user's decision.
