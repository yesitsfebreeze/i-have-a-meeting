# Stop the line

**Use when:** presentation version or its shared checks go red, or a check that passed now fails.

**Move:** Drop own pick. Red base is issue zero for whoever sees it first; claim ledger id `red-<short sha>`. Cause not obvious within 5 minutes: revert breaking commit or switch to last good build, within existing permissions, after saving evidence (failing commit, logs, repro) in ledger for root-cause pass; no permission: propose revert. Fix forward only when obvious.

**Done when:** presentation version passes every earlier verified check at recorded revision.

**Trap:** fixing own issue on red base. Every later "verified" result stands on broken line and proves nothing. Rollback nobody ran can fail too: confirm revert passes checks before calling line green.

**Source:** Toyota, Toyota Production System, jidoka (https://global.toyota/en/company/vision-and-philosophy/production-system/): operator "can stop the line by pulling the stop cord". Martin Fowler, "Continuous Integration", Fix Broken Builds Immediately (https://martinfowler.com/articles/continuousIntegration.html): "nobody has a higher priority task than fixing the build"; "the best way to fix the build is to revert the faulty commit". Google SRE Book, "Managing Incidents" (https://sre.google/sre-book/managing-incidents/): "Stop the bleeding, restore service, and preserve the evidence for root-causing"; "Emergency Response" (https://sre.google/sre-book/emergency-response/): untested rollback procedures "were flawed, which lengthened the outage".
