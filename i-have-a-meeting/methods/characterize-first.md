# Characterize first

**Use when:** fix touches code with no tests around behavior you must keep.

**Move:** Before editing, run code on 2 to 5 real inputs near change; pin actual outputs as tests, whatever they are. Then fix. Only reported case's output may change.

**Done when:** characterization tests pass before and after, except one case fix means to change.

**Trap:** writing expected values from what code "should" do. That flags behavior nobody asked you to change.

**Source:** Michael Feathers, *Working Effectively with Legacy Code*, 2004, ch. 13, Characterization Tests.
