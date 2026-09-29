# Sprout fix

**Use when:** fix adds new logic inside long, untested, tangled function, and extracting old logic is too big.

**Move:** Write new logic as new small function (sprout) or wrap old function (rename old; new one calls it plus new step). Test new function alone. Add one call in old code.

**Done when:** new function tested alone; old code changed by one call; journey passes.

**Trap:** sprout duplicating logic already in old function: two sources of truth. Moving existing buggy logic out is [pure-extract](pure-extract.md).

**Source:** Michael Feathers, *Working Effectively with Legacy Code*, 2004, ch. 6 "I Don't Have Much Time and I Have to Change It": Sprout Method, Wrap Method.
