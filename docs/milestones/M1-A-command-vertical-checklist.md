# M1-A — First durable command heartbeat

**Milestone home:** [M1 — production-shaped schema](../milestones-production.md#m1--production-shaped-schema-and-rls) · **M0:** semantics **frozen** ([matrix](M0-ADR-outcome-matrix.md) Passed; [ADRs 0001–0006](../adr/README.md)).

**Intent:** ship **one** end-to-end durable command path before widening M1 surface area. Meaning is closed; this is **shipping** work.

---

## Goal

Prove the coordination spine: **command row → claim/lease → lease evidence → typed execution → command evidence → inspectable trail** against **real** migrations and DB (staging or Postgres equivalent).

---

## Vertical slice (acceptance)

| Step | Requirement | Authority |
| ---- | ----------- | --------- |
| 1 | Command **persisted**; `agent_commands.status` and lifecycle fields match [ADR 0004](../adr/0004-agent-command-state-machine.md) + crosswalk ([M0-crosswalk](M0-crosswalk.md)). | ADR 0004 |
| 2 | Agent **claims** atomically (`pending` → `leased`); [`command_transition_allowed`](../../rust/crates/minilab-core/src/command.rs) respected in code path. | ADR 0004 |
| 3 | **Lease event** `INSERT` into `minilab.agent_command_lease_events` (append-only). | ADR 0005, [M0-event-map](M0-event-map.md) |
| 4 | Executor enters `running`, runs a **typed** operation stub (no execution from raw chat text). | [Invariant 13](../invariants/invariant-13.md), ADR 0004 |
| 5 | **Command event** `INSERT` into `minilab.agent_command_events` for lifecycle narrative (not lease authority—[§5.1](../minilab-persistence-domain-model.md)). | ADR 0005 |
| 6 | Command reaches a **terminal** state per ADR 0004; operator or SQL can read **row + both streams** and reconcile the story. | — |

**Done when:** automated test **or** documented demo run hits steps 1–6 against DB with **applied** migrations (not in-memory-only).

---

## Track 1 — TypeScript convergence (parallel)

Stop TS from lagging **Accepted** semantics (names and meanings, not full feature parity):

| Area | Align to |
| ---- | -------- |
| Command statuses | `AgentCommandStatus` strings / ADR 0004 |
| Stream / table names | ADR 0005, `minilab_core::events::tables` |
| Manifest envelope keys | ADR 0003, `manifest_envelope` |
| Pairing/credential (labels only if surfaced) | ADR 0006 boundaries |

---

## Track 2 — M1 migrations (minimum for M1-A)

- `minilab.agent_commands` with status CHECK / enum + lease + idempotency columns per crosswalk.
- `minilab.agent_command_lease_events` and `minilab.agent_command_events` with PK, `occurred_at`, FK to command, **`event_type`** with initial small allowed set (ADR 0005: vocab authority moves to migrations—expand deliberately).
- Document agent vs operator **RLS** or service-role path (minimal acceptable if explicitly gated).

---

## Track 3 — Rust agent + operator read path

- Implement or extend [CommandRepository.port](../../design/ports/CommandRepository.port.md): claim, transitions, event appends.
- Agent binary / library path executes the slice (claim → run → complete/fail).
- **Optional for M1-A:** operator UI **read-only** detail for one `command_id` (or SQL recipe in docs).

---

## Explicitly out of scope (defer to later M1/M2 work)

- Full manifest verify, publication graph, pairing ceremony, reconciliation writes, all five evidence families beyond this command’s lease + command rows.
- Production gate sign-off ([DoD](../definition-of-done-and-quality-control.md) milestone rules)—M1-A is a **slice**, not full M1 gate.

---

## Changelog

| Date       | Change                                              |
| ---------- | --------------------------------------------------- |
| 2026-04-18 | Initial M1-A checklist: command vertical + tracks. |
