# Regression

**You see:** worked yesterday, at last rehearsal, or before merge; now does not.

**Underneath:** known-good and known-bad revisions exist; one change between them broke journey. Finding it is mechanical once loop is red.

**Red check:** confirm good revision really good: run loop on it. Then `git bisect run <loop command>` between good and bad. Loop depends on data or deployment: bisect deploy history or dependency lockfile same way.

**Fix at:** breaking change. Read its intent from commit and claim before touching it. Correct repair will not verify before deadline: propose reverting that one change, record as unresolved.

**Trap:** fixing forward on guess. Bisect finds change in handful of runs; guessing burns time left.
