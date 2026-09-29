# Estimate, then profile

**Use when:** something too slow for presentation.

**Move:** Estimate cost on paper from known numbers: calls, round trips, rows, bytes, each times its latency. Then profile real path. Optimize only what profile points to, and do it properly. Estimate and profile disagree: your picture of system is wrong; find out why.

**Done when:** profile names hot spot, fix targets it, new timing measured against baseline.

**Trap:** tuning what looks slow; bottleneck guesses usually wrong. Flip side: do not skip large cheap win on hot path because optimization is "premature".

**Source:** Jeff Dean, LADIS keynote, 2009 (http://iepg.org/2009-11-ietf76/dean-keynote-ladis2009.pdf): "If you don't know what's going on, you can't do decent back-of-the-envelope calculations!" Donald Knuth, 1974 (https://pic.plover.com/knuth-GOTO.pdf): "we should not pass up our opportunities in that critical 3%" … "only after that code has been identified". Pike, 1989: "Measure."
