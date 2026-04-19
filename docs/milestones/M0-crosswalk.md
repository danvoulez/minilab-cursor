# M0 crosswalk — Concept → Rust → TypeScript → DB → Doc

**Gate:** [GATE M0 Crosswalk](https://github.com/danvoulez/minilab-cursor/issues/16).  
**Rule:** empty cells need an owner + issue or `N/A` with reason.

Naming: **DB** uses `snake_case` columns; **JSON/API** should match DB for coordination fields unless a mapping layer is documented.

---

## Manifest & runtime verify

| Concept | Rust | TypeScript | DB / SQL | Doc anchor |
| ------- | ---- | ---------- | -------- | ---------- |
| Inner signed manifest bytes (JCS) | TBD: `minilab_core::manifest` (canonicalize) | TBD: publisher | N/A (bytes on wire) | [ADR 0003](../adr/0003-manifest-signed-bytes-vs-envelope.md) |
| `manifest_hash` (sha256: hex) | TBD | TBD | `manifest_snapshots` / RPC envelope | ADR 0003, README |
| `manifest_sig` (Ed25519) | TBD | TBD (sign only) | envelope | ADR 0003 |
| `signing_pubkey` | TBD | TBD | envelope | ADR 0003 |
| Envelope: `release_id`, `channel`, `schema_version` | TBD | TBD | `manifest_snapshots` / RPC | ADR 0003 |
| Verified snapshot type | TBD: `ManifestSnapshot` | TBD | N/A | [domain §2.2](../minilab-persistence-domain-model.md), ADR 0003 |

---

## AgentCommand lifecycle

**Normative transitions:** [ADR 0004](../adr/0004-agent-command-state-machine.md) · **`command_transition_allowed`:** [`minilab_core`](../../rust/crates/minilab-core/src/command.rs).

| Concept | Rust | TypeScript | DB column / enum | Doc anchor |
| ------- | ---- | ---------- | ---------------- | ---------- |
| Status `pending` | `AgentCommandStatus::Pending` | TBD | `agent_commands.status` | [domain §4](../minilab-persistence-domain-model.md), [ADR 0004](../adr/0004-agent-command-state-machine.md), [minilab-core](../../rust/crates/minilab-core/src/command.rs) |
| Status `leased` | `Leased` | TBD | `status` | same |
| Status `running` | `Running` | TBD | `status` | same |
| Status `completed` | `Completed` | TBD | `status` | same |
| Status `failed` | `Failed` | TBD | `status` | same |
| Status `cancelled` | `Cancelled` | TBD | `status` | same |
| Status `dead_letter` | `DeadLetter` | TBD | `status` | same |
| Lease: `lease_expires_at` | TBD struct field | TBD | `agent_commands.lease_expires_at` | domain §3A |
| Lease: `worker_instance_id` | TBD | TBD | `agent_commands.worker_instance_id` | domain §3A |
| Idempotency | TBD | TBD | `agent_commands.idempotency_key` | domain §3A |

---

## Typed evidence streams (table names)

**Normative:** [ADR 0005](../adr/0005-typed-evidence-event-streams.md) · **Per-stream checklist:** [M0-event-map.md](M0-event-map.md).

| Concept | Rust | TypeScript | DB schema.table | Doc anchor |
| ------- | ---- | ---------- | --------------- | ---------- |
| Installation narrative | TBD enum / row type | TBD | `minilab.installation_events` | [domain §8](../minilab-persistence-domain-model.md), [ADR 0005](../adr/0005-typed-evidence-event-streams.md), [events.rs](../../rust/crates/minilab-core/src/events.rs) |
| Command execution narrative | TBD | TBD | `minilab.agent_command_events` | §8 |
| Lease claim/renew/release | TBD | TBD | `minilab.agent_command_lease_events` | §8, §5.1 |
| Pairing ceremony | TBD | TBD | `minilab.pairing_events` | §8 |
| Credential lifecycle | TBD | TBD | `minilab.agent_credential_events` | §8 |

---

## verify_results & reconciliation

| Concept | Rust | TypeScript | DB | Doc anchor |
| ------- | ---- | ---------- | -- | ---------- |
| Verify attempt (evidence row) | TBD row type | TBD | `minilab.verify_results` | [ADR 0001](../adr/0001-verify-results-semantics.md) |
| Latest summary (authoritative) | TBD | TBD | TBD table / `installations` (decision in M1) | ADR 0001 |
| Desired reconciliation | TBD port types | TBD read | `minilab.host_desired_state` | [ADR 0002](../adr/0002-reconciliation-write-ownership.md) |
| Applied reconciliation | TBD | TBD read | `minilab.host_applied_state` | ADR 0002 |

---

## Pairing / auth (M0 = boundaries + stages; field names M1)

**Normative:** [ADR 0006](../adr/0006-pairing-and-credential-ceremony.md).

| Concept | Rust | TypeScript | DB | Doc anchor |
| ------- | ---- | ---------- | -- | ---------- |
| Ceremony trust boundary + stages | TBD (verifier / ports) | TBD (UX orchestration) | `pairing_sessions`, `minilab.pairing_events`, `agent_credentials`, `minilab.agent_credential_events` | [domain §4](../minilab-persistence-domain-model.md), ADR 0006, [pairing-envelope.md](../../contracts/pairing/pairing-envelope.md) |

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-19 | Initial crosswalk; Rust column filled for `AgentCommandStatus` + stream constants. |
| 2026-04-19 | Linked ADR 0004 (command), ADR 0005 + [M0-event-map.md](M0-event-map.md) (streams). |
| 2026-04-19 | ADR 0006 (pairing / credentials) replaces “ADR TBD” in crosswalk. |
