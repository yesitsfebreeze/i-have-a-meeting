# Missing data

**You see:** empty lists, "not found", blank charts, or errors on presentation host; local copy looks full.

**Underneath:** code expects data presentation database lacks: migrations not run there, seed or fixture data only local, presentation account missing records or role, or host points at different database than you think.

**Red check:** query presentation store for exact records failing screen needs (presentation user, role, rows view lists); check which migrations ran. Missing rows or pending migrations: this cause.

**Fix at:** data. Run pending migrations and idempotent seed for presentation account and records against presentation store. Keep seed in repo so next reset reruns it.

**Trap:** hardcoding presentation records in view. Search, counts, detail pages read same store and disagree with screen live.
