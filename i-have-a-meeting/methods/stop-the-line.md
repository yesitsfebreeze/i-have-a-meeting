# Stop the line

**Use when:** presentation version or its shared checks go red, or a check that passed now fails.

**Move:** Drop own pick. Red base is issue zero for whoever sees it first; claim ledger id `red-<short sha>`. Cause not obvious within 5 minutes: revert breaking commit, within existing permissions; no permission: propose revert. Fix forward only when obvious.

**Done when:** presentation version passes every earlier verified check at recorded revision.

**Trap:** fixing own issue on red base. Every later "verified" result stands on broken line and proves nothing.

**Source:** Toyota, Toyota Production System, jidoka (https://global.toyota/en/company/vision-and-philosophy/production-system/): operator "can stop the line by pulling the stop cord". Martin Fowler, "Continuous Integration", Fix Broken Builds Immediately (https://martinfowler.com/articles/continuousIntegration.html): "nobody has a higher priority task than fixing the build"; "the best way to fix the build is to revert the faulty commit".
