# Read the recent change

**Use when:** worked recently, now fails, history short.

**Move:** Read `git log -p` for affected files since last known-good point before editing anything. Read diff as reviewer; ask of each hunk what it assumes. `git bisect` only when history too long to read.

**Done when:** breaking change named, or every recent change in area ruled out.

**Trap:** jumping to new fix when recent diff already explains failure.

**Source:** Kernighan & Pike, *The Practice of Programming*, 1999, ch. 5 (https://www.cs.princeton.edu/~bwk/tpop.webpage/debugging.html): "Examine the most recent change" and "Read before typing."
