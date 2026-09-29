# Finish right first

**Use when:** starting any iteration, especially with several workers.

**Move:** Walk ledger and open branches from nearest done to newest: integrating, verified but unmerged, working near done, then new. Moving item closer to done beats starting one. Stage where items pile up (integration, review, human step) is constraint; spend iteration there.

**Done when:** nothing waits in a later stage you could move.

**Trap:** new fix while verified patches sit unmerged. More fixes upstream of jammed integration add zero value toward vision.

**Source:** Jason Yip, "It's Not Just Standing Up", Walk the Board (https://martinfowler.com/articles/itsNotJustStandingUp.html): walk items "from end of process to start of process". Goldratt, *The Goal*, 1984: "An hour lost at a bottleneck is an hour lost for the total system" (wording from secondary sources).
