## Why this matters

Pairing is the **trust boundary** for host identity and credentials. Ambiguous envelopes → wrong host claims work or weak verification.

## Scope

- Document **pairing session** identifiers, **challenge/response** shapes, and **credential** material references (not raw secrets in issues).
- Clear split: **Rust** verifies cryptographic steps and persists trust evidence; **TypeScript** drives operator UX and calls APIs — **same semantic contract**.

## Acceptance criteria

- [ ] **M0:** [ADR 0006 — Pairing and credential ceremony](https://github.com/danvoulez/minilab-cursor/blob/main/docs/adr/0006-pairing-and-credential-ceremony.md) **Accepted** (trust boundary, stages, reclaim, persistence roles).
- [ ] **M1+:** ADR or doc: message shapes (field names, required/optional), error codes for failed pairing — concrete envelope bytes.
- [ ] [contracts/pairing/pairing-envelope.md](https://github.com/danvoulez/minilab-cursor/blob/main/contracts/pairing/pairing-envelope.md) links to canonical doc.
- [ ] Maps to tables `pairing_sessions`, `pairing_events`, `agent_credentials`, `agent_credential_events` (planned names) in a short table.

## Quality / review

- [Plan production — pairing / trust](https://github.com/danvoulez/minilab-cursor/blob/main/docs/plan-production.md) · [M5 milestone](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones-production.md) (later implementation; M0 = contracts only).
- [DoD — trust boundaries](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md): TS is not executor.

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
