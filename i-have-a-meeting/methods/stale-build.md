# Stale build

**You see:** fix passes locally; presentation version still shows old behavior.

**Underneath:** screen not running changed code. Something between commit and audience serves older copy: wrong branch deployed, build or dependency cache, CDN, service worker, browser cache, second instance still behind load balancer.

**Red check:** put revision marker beside symptom. Read revision presentation version actually serves (build ID, `/version` endpoint, commit in startup logs, asset hash); compare with commit holding fix. Different: this cause. Same: fix is wrong; back to loop.

**Fix at:** delivery path. Ship fixed revision, clear the one cache serving old copy, read marker again.

**Trap:** changing code again. Path that never reaches screen ignores every edit; prove delivery first.
