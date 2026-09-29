# Look at the data first

**Use when:** about to read control flow to understand failure.

**Move:** Dump real input, output, intermediate payloads of failing path: request and response bodies, rows, config, schema. Compare each with shape code expects. First mismatch usually names bug. Then query for other records with same defect.

**Done when:** you can point at exact field or value that differs, and know how many records share it.

**Trap:** reading code to guess data shape. Data cheaper to look at, cannot be wrong about itself.

**Source:** Fred Brooks, *The Mythical Man-Month*, 1975, ch. 9: "Show me your tables, and I won't usually need your flowcharts." Linus Torvalds, git list, 2006 (https://lwn.net/Articles/193245/): "Good programmers worry about data structures and their relationships." Mike Acton, CppCon 2014: "If you don't understand the data you don't understand the problem." and "Where there is one, there are many."
