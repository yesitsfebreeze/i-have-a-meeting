# Let the machine check

**Use when:** before marking fix done or handing to integration.

**Move:** Run project's existing type checker, linter, static analyzer on changed files. Add asserts for assumptions fix relies on, so violated assumption fails loud. Step through new code once in debugger or trace.

**Done when:** checkers clean on changed files, new asserts hold on core journey, you watched fix execute.

**Trap:** trusting it compiles. Your head is a faulty interpreter.

**Source:** John Carmack, "Static Code Analysis", 2011 (https://www.gamedeveloper.com/programming/in-depth-static-code-analysis). Lex Fridman podcast #309, 2022 (https://lexfridman.com/john-carmack/): "the first thing I do after writing code is set a breakpoint and step through the function" (quoted from a transcript).
