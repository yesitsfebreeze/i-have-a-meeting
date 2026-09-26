# Checkout skill comparison

This is a small controlled behavioral evaluation of `i-have-a-meeting`, not a general coding benchmark. It compares three independent baseline workers with three workers given a frozen copy of the skill. Each pair starts from identical code, requirements, public smoke tests, and ownership constraints.

## Sample project

The Python checkout service has four broken acceptance requirements: quantities, percentage discounts, shipping eligibility, and exact payment. `LAUNCH.md` defines the expected behavior. An inventory bug is already owned, and an unrelated CSV bug is outside the requested focus. Five public smoke tests pass initially despite the defects.

The external evaluator tests 69 cases grouped into four requirements, including boundary conditions and composed checkout behavior. A requirement passes only if every case in its group passes. It also checks that the original tests, brief, instructions, inventory module, and reporting module are unchanged. These checks support this fixture's stated behavior; they cannot prove arbitrary correctness.

## Protocol fixed before collecting results

1. Make six isolated copies of `fixture/` outside the development workspace. Freeze the skill file and record its SHA-256.
2. Run three pairs of fresh agents, with the two conditions in each pair started close together. Use the same inherited model configuration and a ten-minute budget per agent. Baseline workers do not load workflow skills. Treatment workers load only the frozen meeting skill. Both receive the same focus and stop after completing it.
3. Do not let workers read other trial directories or `evaluate.py`. Each writes `HANDOFF.md` containing actual clock readings, verification, and remaining blockers.
4. After completion, independently run `evaluate.py` and the project's public plus worker-added tests. Preserve final source, handoff, and evaluator output.
5. Report every trial, including failures. Do not change the skill or fixture between conditions to improve the score.

Primary accuracy measure: independently passing requirements out of four. Secondary measures: cases passed out of 69, unchanged owned/out-of-scope files and original tests, public-test results, and truthful handoff about unresolved inventory/reporting requirements.

Throughput measure: independently passing requirements divided by elapsed minutes from each worker's first to final clock reading. This includes reading, coordination, editing, testing, and any other workflow work between those readings; it excludes startup and work after the final reading. Clock endpoints are worker-recorded, not an instrumented runtime benchmark. Report individual runs and group medians. The sample is too small for a general performance claim. Shared host contention, run order, model variance, and the small task remain confounders. Tokens and cost are not measured.

## Reproduce the acceptance evaluation

Use Python 3, with no third-party dependencies. Run the fixture's smoke tests from its directory:

```sh
cd evaluations/checkout/fixture
python3 -m unittest discover -s tests -v
```

From the distribution root, evaluate a completed isolated checkout:

```sh
python3 evaluations/checkout/evaluate.py /absolute/path/to/worker-checkout
```

The unmodified fixture scores zero of four requirements and 27 of 69 individual cases. To repeat the agent comparison, create new identical fixture copies and follow the protocol above. The evaluator prints results as JSON; inspect `requirements_passed` and `preserved_files`. Its exit code indicates execution success, not acceptance success.

## Recorded results

Read [REPORT.md](REPORT.md) for all six outcomes and limitations. Recompute the group summary from the collected JSON with:

```sh
python3 evaluations/checkout/summarize.py
```

To collect a new completed checkout, choose a new destination and supply elapsed seconds from the worker's recorded first/final clocks:

```sh
python3 evaluations/checkout/collect.py /absolute/path/to/checkout /absolute/path/to/new-results --elapsed-seconds 60
```

The collector reruns the independent evaluator and the project's tests, then snapshots the checkout. It refuses to overwrite an existing result directory. Preserve all trials rather than selecting successful ones.
