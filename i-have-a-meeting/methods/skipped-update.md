# Hunt the skipped update

**Use when:** bug appears only in some modes, states, or event orders.

**Move:** Find "skip when not needed" branches on path: early returns, dirty flags, caches, memoization. Disable one at a time, nearest to symptom first, so work runs every time. Bug gone: that shortcut skipped update something else relied on. Fix at one central check, not every caller.

**Done when:** forcing work every time makes red check pass; real fix sits in one place.

**Trap:** adding missing update at the one call site ticket names. Other callers still take shortcut.

**Source:** John Carmack, inlined-code email, 2007, with a 2014 postscript (http://number-none.com/blow/john_carmack_on_inlined_code.html): skipping work in some states "usually skips some other state updating that turns out to be needed elsewhere."
