# Let the machine check

**Use when:** before marking fix done or handing to integration.

**Move:** Run project's existing type checker, linter, static analyzer on changed files; none installed: record that, never install one mid-sprint. Add asserts for assumptions fix relies on, so violated assumption fails loud. Watch new code execute once (trace, print, or debugger); fix under 5 lines that test drives through: test run counts.

**Done when:** checkers clean on changed files, new asserts hold on core journey, you watched fix execute.

**Trap:** trusting it compiles. Your head is a faulty interpreter.

**Source:** John Carmack, "Static Code Analysis", 2011 (https://www.gamedeveloper.com/programming/in-depth-static-code-analysis). Lex Fridman podcast #309, 2022 (https://lexfridman.com/john-carmack/): "the first thing I do after writing code is set a breakpoint and step through the function" (quoted from a transcript).
