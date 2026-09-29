# Hunt the same mistake

**Use when:** right after fix verified.

**Move:** Name mistake pattern, not line. Search codebase for other copies and every caller of changed function. Fix siblings on core journey; list others in handoff.

**Done when:** pattern searched; each copy fixed or recorded.

**Trap:** calling it done when ticket's path passes. Audience may click sibling path.

**Source:** Kernighan & Pike, 1999, ch. 5: "Don't make the same mistake twice." Mike Acton, CppCon 2014: "Where there is one, there are many." Carmack, "Static Code Analysis", 2011 (https://www.gamedeveloper.com/programming/in-depth-static-code-analysis): "any class of error that is syntactically legal probably exists there." Google SRE Workbook, "Postmortem Culture" (https://sre.google/workbook/postmortem-culture/): "trying to change human behavior is less reliable than changing automated systems and processes"; turn pattern into check where one exists.
