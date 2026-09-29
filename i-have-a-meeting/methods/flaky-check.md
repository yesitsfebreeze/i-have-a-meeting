# Flaky check

**You see:** check passes and fails on same code with no change in between.

**Underneath:** usually async wait (fixed sleep or missing wait for condition), then concurrency, then test-order dependency. Sometimes a real bug in code under test, not in test.

**Red check:** rerun same revision N times (20 or more); both outcomes appear. Then rerun in shuffled order and on slower host or throttled CPU; failure rate shifts with suspected cause.

**Fix at:** cause named by red check. Replace fixed sleep with explicit wait on condition; isolate shared state between tests; fix code under test when race lives there (see race). Fixed when N reruns pass, including shuffled order and slow host.

**Trap:** rerun until green, or skip test. One green rerun proves nothing; a skipped check hides a real bug about as often as a test bug.

**Source:** Qingzhou Luo et al., "An Empirical Analysis of Flaky Tests", FSE 2014 (https://dl.acm.org/doi/10.1145/2635868.2635920): of 161 flaky fixes, async wait 45%, concurrency 20%, test-order dependency 12%; 24% of fixes changed code under test. Later studies (Lam et al. ICST 2019; Gruber et al. ICST 2021) find order dependency far more common, so treat split as prior, not rule. John Micco, "Flaky Tests at Google and How We Mitigate Them", 2016 (https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html): flaky means "both a passing and a failing result with the same code".
