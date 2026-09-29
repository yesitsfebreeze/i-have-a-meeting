# Slow path

**You see:** feature works but takes seconds on presentation host, with real data, or on venue Wi-Fi.

**Underneath:** cost grows with something small locally: rows (N+1 queries, missing index, unbounded list), round trips (serial requests on slow network), payload size (large images or bundles), cold starts (serverless or sleeping free tier).

**Red check:** measure before changing anything. Time slow step on presentation host or with production-sized data; split time: server, database, network, client render. Biggest share is target. Record baseline number.

**Fix at:** largest share only. Batch queries, add index, paginate list, parallelize independent requests, or warm instance before presentation. Measure again against baseline.

**Trap:** loading spinner. Makes wait visible on projector, not shorter.
