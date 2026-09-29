# Split the check

**Use when:** swarm mode, and two or more agents fail on, claim, or fix same large failing check.

**Move:** Split check into parts that fail independently: per file, module, journey step, or random subset checked against known-good oracle (last good build, reference implementation). One claim per part. Make each part print few lines, `ERROR <reason>` on one line, detail to log file. Offer fast sampled mode so agents without clock sense do not burn time on full runs.

**Done when:** each active claim names a distinct failing part; agents stop overwriting each other.

**Trap:** everyone fixing first bug of same check, then overwriting each other's fixes.

**Source:** Nicholas Carlini, "Building a C compiler with a team of parallel Claudes", Anthropic, 2026 (https://www.anthropic.com/engineering/building-c-compiler): on one kernel build "every agent would hit the same bug, fix that bug, and then overwrite each other's changes"; fixed by using GCC as oracle for a subset of files. Harness should "print a few lines of output and log all important information to a file"; "Claude can't tell time"; `--fast` runs "a 1% or 10% random sample". One team's report, not a study.
