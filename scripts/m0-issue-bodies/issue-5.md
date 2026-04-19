## Why this matters

`lease_expires_at`, `worker_instance_id`, status strings, and idempotency field names must match across Rust agent, TS enqueue, and M1 migrations.

## Scope

- Crosswalk: **command status** enum values (string or int) identical in Rust, TS, planned `agent_commands.status`, and API payloads.
- Crosswalk: **lease fields** (`lease_expires_at`, `worker_instance_id`, …) — same names and types (timestamps, UUIDs).
- Crosswalk: **idempotency** (`idempotency_key`, attempt counters, `next_attempt_at`, `max_attempts`) if in scope for M0.

## Acceptance criteria

- [ ] Table: *Field | Rust | TS | SQL column | Notes* checked into `docs/` (can be part of [GATE M0 crosswalk](https://github.com/danvoulez/minilab-cursor/issues/16)).
- [ ] Planned M1 migration draft or OpenAPI snippet references same names.
- [ ] No “snake in DB, camel in agent only” without an explicit mapping layer documented.

## Quality / review

- [Domain model §3A agent_commands](https://github.com/danvoulez/minilab-cursor/blob/main/docs/minilab-persistence-domain-model.md)
- [DoD — contract alignment](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

## Dependencies

- Depends on issue #4 (state set frozen).

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
