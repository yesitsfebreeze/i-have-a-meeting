# Race

**You see:** fails on first load, fast click, or only sometimes; refresh or second try fixes it.

**Underneath:** two things finish in order code assumed impossible: missing `await`, state read before fetch or hydration completes, two requests where older answer lands last, listener attached after event fired, cache warmed by previous run.

**Red check:** make rare order usual. Loop trigger from cold start 20–50 times, add artificial delay to step suspected to finish first, or throttle network. Failure rate should jump once suspected order is forced.

**Fix at:** ordering. Await dependency, cancel or ignore stale responses, gate action until data ready, or attach listener before trigger.

**Trap:** `sleep` or longer timeout. Moves window, does not close it; projector laptops and venue Wi-Fi are slower than your machine.
