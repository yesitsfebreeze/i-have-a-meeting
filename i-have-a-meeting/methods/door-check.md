# Door check

**Use when:** fix or mitigation deletes or migrates data, sends email, payment, or webhook, rotates shared secret, force-pushes, or deploys publicly.

**Move:** Two-way door (code, flag, config, revertable in a minute): decide alone, fast. One-way door: stop and ask human, or pick reversible route (flag off, additive migration, dry run).

**Done when:** one-way change has explicit human go-ahead or was swapped for reversible one.

**Trap:** stalling on two-way doors, or calling destructive migration "just a fix" under deadline.

**Source:** Jeff Bezos, 2015 letter to shareholders (https://www.sec.gov/Archives/edgar/data/1018724/000119312516530910/d168744dex991.htm): "one-way doors" vs "two-way doors"; "Type 2 decisions can and should be made quickly".
