# Table: `verify_results`

- **Event type:** `VerifyResultEvent (or per-attempt record)`
- **Role:** append-only evidence
- **Notes:** One row per immutable verify attempt → evidence. A mutable latest-summary column or upserting current state here is authoritative state—use a separate table/view or a written rule. See domain doc §3B callout.

See [ADR 0001 (Accepted)](../../../../docs/adr/0001-verify-results-semantics.md) · [minilab-persistence-domain-model.md](../../../../docs/minilab-persistence-domain-model.md) §3B.
