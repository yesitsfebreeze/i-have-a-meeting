# Think first

**Use when:** you know code even a little and loop is red.

**Move:** Before adding tools, take 2–5 minutes, timed, to explain how observed state could arise. Reason backward from bad state to steps that must have led there. Write story down; one print or breakpoint checks least-sure step.

**Done when:** probe confirms or kills written story. Killed: next story starts from what probe showed.

**Trap:** diving straight into failing line. Fixes local symptom, leaves higher-level mistake that caused it. Unfamiliar code: reasoning is guesswork; use [step-the-path](step-the-path.md).

**Source:** Rob Pike on Ken Thompson, InformIT, 2012 (https://www.informit.com/articles/article.aspx?p=1941206): "If you think about the bug first, how the bug came to be, you often find and correct a higher-level problem." Kernighan & Pike, *The Practice of Programming*, 1999, ch. 5: "Reason back from the state of the crashed program."
