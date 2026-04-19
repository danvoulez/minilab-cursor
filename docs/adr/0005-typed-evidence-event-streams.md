# ADR 0005: Typed evidence streams — families, tables, ownership

**Status:** Proposed  
**Date:** 2026-04-19

## Context

Minilab treats **append-only evidence** as first-class and **typed** (no mega-bus). The domain model lists five coordination/security streams ([§8](../minilab-persistence-domain-model.md#8-typed-event-streams-no-mega-bus)). Without a single map of **logical family → physical table → write ownership → correlation keys**, Rust and TS drift (`AgentCommandEvent` vs `agent_command_events`), and lease narrative gets smuggled into generic progress text—violating [§5.1](../minilab-persistence-domain-model.md#51-messages-vs-execution-evidence).

Table name constants today live in [`minilab_core::events::tables`](../../rust/crates/minilab-core/src/events.rs).

## Decision

### Stream families (M0)

Exactly these **five** append-only evidence families; **no** generic `minilab.events` catch-all.

| Logical family (doc / API name) | PostgreSQL table | `minilab_core::events::tables` const |
| -------------------------------- | ---------------- | ------------------------------------- |
| `InstallationEvent` | `minilab.installation_events` | `INSTALLATION_EVENTS` |
| `AgentCommandEvent` | `minilab.agent_command_events` | `AGENT_COMMAND_EVENTS` |
| `AgentCommandLeaseEvent` | `minilab.agent_command_lease_events` | `AGENT_COMMAND_LEASE_EVENTS` |
| `PairingEvent` | `minilab.pairing_events` | `PAIRING_EVENTS` |
| `AgentCredentialEvent` | `minilab.agent_credential_events` | `AGENT_CREDENTIAL_EVENTS` |

**Rule:** Rust `SCREAMING_SNAKE_CASE` const values are the **table name only** (no schema prefix); schema is always [`MINILAB_SCHEMA`](../../rust/crates/minilab-core/src/events.rs) (`minilab`).

### Rows are append-only evidence

- Writers **INSERT**; they do not **UPDATE** event rows to change meaning. Corrections are new rows (or separate ADR if compensating events are introduced).
- **`event_type`** (or equivalent discriminator column in M1) is a **stable snake_case string** per family. The allowed vocabulary per table is documented in [M0-event-map.md](../milestones/M0-event-map.md); migrations may add `CHECK` constraints.

### Write ownership (default)

| Stream | Primary appender | Notes |
| ------ | ---------------- | ----- |
| `installation_events` | Rust (installer / verify path) | TS inspection reads. |
| `agent_command_events` | Rust (executor) | TS does **not** narrate execution here. |
| `agent_command_lease_events` | Rust (claim / renew / release) | **Lease authority** must be inspectable separately from command progress. |
| `pairing_events` | Rust for trust-bearing steps; TS only where explicitly schema-allowed | Exact split of variants is M1; M0 locks **table** and **ownership principle**. |
| `agent_credential_events` | Rust for trust-bearing lifecycle | Same as pairing. |

Operator/UI-initiated actions that must be durable **without** going through Rust are **out of scope** for M0 unless listed in the event map with an explicit exception; default is **Rust-owned** evidence for trust paths.

### Correlation

Every stream carries enough foreign keys to **reconstruct the story** joined to its aggregate (installation, command, pairing session, credential). Minimum keys per family are in [M0-event-map.md](../milestones/M0-event-map.md); migrations are authoritative for `NOT NULL` / FK.

### Naming alignment

- **DB:** `snake_case` tables and columns.
- **Rust:** PascalCase type names for families; `event_type` strings remain `snake_case`.
- **TypeScript:** PascalCase interfaces / unions mirroring Rust **semantics**; literal strings match DB.

## Authority ordering

- Once **Accepted**, this ADR + [M0-event-map.md](../milestones/M0-event-map.md) supersede informal mentions in stubs.
- New families or merged streams require a **new ADR**.

## Consequences

**Positive**

- Inspection and codegen have stable anchors; lease history stays separate from command narrative.

**Negative**

- More tables than a single event log—operational cost accepted for clarity.

## Links

- Detailed map + per-stream columns: [M0-event-map.md](../milestones/M0-event-map.md)
- Crosswalk: [M0-crosswalk.md](../milestones/M0-crosswalk.md)
- Domain §8: [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md)
- GitHub: [#6](https://github.com/danvoulez/minilab-cursor/issues/6)

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-19 | Proposed: five streams, ownership defaults, naming, correlation discipline. |
