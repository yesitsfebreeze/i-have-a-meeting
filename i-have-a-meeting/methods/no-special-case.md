# Remove the special case

**Use when:** bug lives in edge-case branch: empty, first, last, null.

**Move:** Ask whether different representation makes edge case normal case, like pointer-to-pointer removing head-of-list branch or sentinel removing empty check. Apply only when diff is no larger than patching branch.

**Done when:** special branch gone and edge input takes normal path, or branch patched because rewrite was bigger.

**Trap:** rewriting data structure an hour before deadline. Change not small: patch branch.

**Source:** Linus Torvalds, TED, 2016 (https://www.ted.com/talks/linus_torvalds_the_mind_behind_linux): "sometimes you can see a problem in a different way and rewrite it so that a special case goes away and becomes the normal case. And that's good code."
