# M0 — Typed evidence event map

**Normative ADR:** [ADR 0005 — Typed evidence streams](../adr/0005-typed-evidence-event-streams.md)  
**Crosswalk:** [M0-crosswalk.md](M0-crosswalk.md)  
**Rust (table names):** [`minilab_core::events`](../../rust/crates/minilab-core/src/events.rs)

This document is the **per-stream field and vocabulary checklist** for M0/M1. **Migrations** are the source of truth for `NOT NULL`, FK targets, and `CHECK` constraints; this file must stay aligned when migrations land.

---

## Shared columns (target shape)

Every stream should converge on:

| Column | Type (sketch) | Notes |
| ------ | ------------- | ----- |
| `id` | `uuid` PK | Append identity. |
| `occurred_at` | `timestamptz` | Server-side ordering; not “logical” command time unless defined. |
| `event_type` | `text` | `snake_case`; per-stream vocabulary below. M1 may use enum types + cast. |
| Correlation FKs | see per-stream | Enough to join to authoritative aggregates. |

Optional cross-cutting columns (M1+): `correlation_id`, `causation_event_id`—only with an ADR if introduced.

---

## `minilab.installation_events`

| Field | M0 note |
| ----- | ------- |
| Correlation | **Required:** `installation_id`; **expected:** `host_id` where available. |
| Primary writer | Rust installer / verify executor. |
| `event_type` vocabulary | **TBD** in M1 (examples: `verify_started`, `verify_succeeded`—final names in migration). |

---

## `minilab.agent_command_events`

| Field | M0 note |
| ----- | ------- |
| Correlation | **Required:** `command_id`; **expected:** `host_id`, `installation_id` / `thread_id` as applicable to the command kind. |
| Primary writer | Rust executor. |
| `event_type` vocabulary | **TBD** in M1; must **not** duplicate lease claims (those go to lease stream). |

---

## `minilab.agent_command_lease_events`

| Field | M0 note |
| ----- | ------- |
| Correlation | **Required:** `command_id`; **expected:** `worker_instance_id` for claim/renew. |
| Primary writer | Rust claim / lease path. |
| `event_type` vocabulary | **TBD** in M1 (e.g. `claimed`, `renewed`, `expired`, `released`, `reclaimed`). |

---

## `minilab.pairing_events`

| Field | M0 note |
| ----- | ------- |
| Correlation | **Required:** `pairing_session_id`; **expected:** `host_id`. |
| Writers | Rust for trust-bearing transitions; TS only where schema explicitly allows UX-only evidence. |
| `event_type` vocabulary | **TBD** in M1 (pairing ADR / contract to follow). |

---

## `minilab.agent_credential_events`

| Field | M0 note |
| ----- | ------- |
| Correlation | **Required:** `agent_credential_id` (name per migration); **expected:** `host_id`. |
| Primary writer | Rust credential lifecycle. |
| `event_type` vocabulary | **TBD** in M1. |

---

## TypeScript / codegen

Shared TS unions and literals: **TBD** (M0 issue: package or JSON Schema). Until then, treat this file + ADR 0005 as the naming contract.

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-19 | Initial map: per-stream correlation + ownership; vocabularies deferred to M1 migrations. |
