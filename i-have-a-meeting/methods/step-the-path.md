# Step the real path

**Use when:** code unfamiliar, or bug depends on state, mode, configuration.

**Move:** Run one failing request from entry point under debugger or full trace; step into each call, not over. List every function that ran and every branch skipped; compare with what you believed would run.

**Done when:** list of what actually executes on failing path, plus first place it departs from belief.

**Trap:** stepping over calls you "always skip"; bug usually sits in assumed state. One request only, never whole system.

**Source:** John Carmack, inlined-code email, 2007 (http://number-none.com/blow/john_carmack_on_inlined_code.html): "Most bugs are a result of the execution state not being exactly what you think it is." Lex Fridman podcast #309, 2022: "your head is a faulty interpreter" (quoted from a transcript).
