# Contract drift

**You see:** each side passes own tests; combined journey fails: undefined fields, 400 or 422, silently empty UI.

**Underneath:** shared contract changed on one side only: field renamed, type or unit changed (cents vs dollars, seconds vs milliseconds, string vs number), required field or enum value added, API version moved. Mocks on other side still encode old shape, so its tests stay green.

**Red check:** capture one real exchange across seam on failing journey (request and response, redacted). Compare field by field with what consumer reads. First mismatch is the drift.

**Fix at:** contract owner. Align side that departed, or update both together. Replace stale mock data with captured real exchange so test goes red on drift.

**Trap:** translation shim in consumer. Hides drift for this screen, leaves every other consumer broken.
