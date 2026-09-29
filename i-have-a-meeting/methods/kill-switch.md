# Kill switch

**Use when:** non-vital feature on or near demo path breaks, and its fix will not verify before deadline.

**Move:** Turn feature off through existing flag or config; none exists: hide its entry point in one small reversible change. Only features no vision check needs; required behavior stays failing and gets fixed or reported. Verify exact flag configuration that will be presented, plus fallback with switch flipped back.

**Done when:** demo path passes with switch off on presentation version; switch, reason, and removal step recorded in ledger and listed under limitations.

**Trap:** hiding required behavior and calling it passing. Also flag left behind: every switch is debt.

**Source:** Pete Hodgson, "Feature Toggles", martinfowler.com, 2017 (https://martinfowler.com/articles/feature-toggles.html): Ops Toggles let operators "disable a Recommendations panel on our home page which is relatively expensive to generate"; "most important to test the toggle configuration which you expect to become live in production … also wise to test the fall-back configuration"; teams "view their Feature Toggles as inventory which comes with a carrying cost".
