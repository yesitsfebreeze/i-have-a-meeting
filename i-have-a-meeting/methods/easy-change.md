# Make the change easy

**Use when:** fix would touch many sites or fight current structure.

**Move:** First make change that alters no behavior and turns fix into one small edit; verify alone, all checks green. Then make small fix as separate change; verify that too.

**Done when:** two separate verified changes: no-behavior preparation, then fix.

**Trap:** preparation and fix in one diff. Goes red, cannot tell which half broke it. Under deadline, keep preparation to minimum fix needs.

**Source:** Kent Beck, 2012 (https://x.com/KentBeck/status/250733358307500032): "for each desired change, make the change easy (warning: this may be hard), then make the easy change". Beck, "Make It Run, Make It Right", 2021 (https://newsletter.kentbeck.com/p/make-it-run-make-it-right-ii): one kind of change at a time.
