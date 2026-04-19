## Why this matters

Golden vectors catch canonicalization and hash bugs before they hit staging.

## Scope

- Minimal test: fixed small JSON object → canonical bytes → SHA-256 hex string (and later Ed25519 if key infra ready).
- Run in **Rust** tests; mirror in **TS** test if TS implements canonicalization; **or** Rust-only vectors checked into TS as fixtures.

## Acceptance criteria

- [ ] Vectors committed under `rust/crates/minilab-core/tests/fixtures/` (or agreed path) with README explaining how TS consumes them.
- [ ] CI runs `cargo test` for vector suite; TS side documented if not in CI yet.

## Quality / review

- Optional for M0 **if** issues #1–#3 are covered by manual review — then mark issue **cancelled** with reason. Prefer **not** skipping if publisher and agent are separate processes.

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/implementation`
