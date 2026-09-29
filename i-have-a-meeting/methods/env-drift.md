# Env drift

**You see:** works on your machine, fails on presentation host, or reverse.

**Underneath:** same code, different surroundings: env variable or secret, value inlined at build time instead of read at run time, runtime or dependency version, feature flag, base URL, file path, locale or timezone.

**Red check:** list every outside value failing path reads (grep env accessor, config loader, flag client on that path). Print names on both sides, values redacted; diff. Failure should follow differing value when swapped locally.

**Fix at:** environment. Set missing value where host reads it; rebuild when inlined at build time. Add startup check naming missing variable so next drift fails loud.

**Trap:** code fallback hiding missing value (`?? "http://localhost"`). App then runs against wrong target, no error.
