# Shrink the repro

**Use when:** failing input, test, or config is large and cause unclear.

**Move:** Passing variant exists: isolate difference between pass and fail; apply half of it, keep whichever half still flips result, repeat. No passing variant: delete chunks of failing case while it still fails. Prefer isolation under deadline; it needs far fewer runs.

**Done when:** difference down to one change, or removing any remaining element makes failure vanish.

**Trap:** full minimization can take quadratic runs; timebox it. Not halfway-breaker or bisect: those split history, this splits input.

**Source:** Andreas Zeller & Ralf Hildebrandt, "Simplifying and Isolating Failure-Inducing Input", IEEE TSE 28(2), 2002 (https://doi.org/10.1109/32.988498): isolation "much more efficient than simplification"; worked example isolates cause in 7 tests versus 26 to minimize (one example, not a general rate).
