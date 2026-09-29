# Plain and specific fix

**Use when:** choosing between fixes.

**Move:** Pick fix handling common case with simplest algorithm and no new abstraction: brute force, one specific function, typed out plainly. Generalize only once second real case exists.

**Done when:** reviewer can check fix by reading it once.

**Trap:** clever or general fix under pressure. Harder to verify; you debug it live.

**Source:** Rob Pike, "Notes on Programming in C", 1989 (http://doc.cat-v.org/bell_labs/pikestyle): "Fancy algorithms are buggier than simple ones." Casey Muratori, "Semantic Compression", 2014 (https://caseymuratori.com/blog_0015): "make your code usable before you try to make it reusable". Acton, 2014: "Solve for the most common case first, Not the most generic."
