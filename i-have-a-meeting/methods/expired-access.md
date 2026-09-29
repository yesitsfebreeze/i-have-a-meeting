# Expired access

**You see:** outside service returns 401, 403, 429, quota or billing error, often for feature that worked last week.

**Underneath:** grant with lifetime ran out: token, OAuth session, API key, trial, free-tier quota, sandbox mode, or allowed origin or redirect URL no longer covers presentation host. Code fine; permission around it changed.

**Red check:** call service directly from presentation host with same credential (one `curl`, key from environment). Read error body; it usually names cause: expired, revoked, rate limited, origin not allowed.

**Fix at:** grant. Renew, rotate, extend, or add presentation origin to allowed list. Usually needs human in dashboard: give exact click path, then rerun direct call.

**Trap:** retry loops or longer timeouts. Turn clear refusal into slow silent failure.
