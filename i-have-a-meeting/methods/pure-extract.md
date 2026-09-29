# Extract a pure function

**Use when:** buggy logic tangled with global state, no seam reaches it.

**Move:** Move finicky computation into function taking everything it reads as arguments, returning result with no side effects. Old call site becomes thin wrapper. Test function with plain input/output cases from failing data.

**Done when:** small test of extracted function fails for reported case, passes after fix, and wrapper still drives real journey.

**Trap:** extracting more than failing logic. Seam for one test, not refactor.

**Source:** John Carmack, "Functional Programming in C++", 2012 (https://www.gamedeveloper.com/programming/in-depth-functional-programming-in-c-): "Whenever I come across a finicky looking bit of code now, I split it out into a separate pure function and write tests for it. Frighteningly, I often find something wrong."
