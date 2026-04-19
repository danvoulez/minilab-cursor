# Port: `ReconciliationRepository`

**Ownership:** single writer for `host_desired_state` and `host_applied_state` (or an explicitly documented split—never fuzzy multi-caller updates).

**Forbidden:** smuggling reconciliation writes through random repositories without going through this port or the documented alternative.

See [ADR 0002](../../docs/adr/0002-reconciliation-write-ownership.md) · [minilab-persistence-domain-model.md](../../docs/minilab-persistence-domain-model.md) §6.
