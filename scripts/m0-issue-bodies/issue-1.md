## Why this matters

Runtime clients and the publisher must hash and sign **the same byte sequence**. If “signed payload” vs “RPC envelope” is ambiguous, you get silent drift: verify passes in one place and fails in another, or worse, weak verification.

## Scope

- Document the **signed manifest body** (exact JSON object or subtree that is canonicalized and hashed).
- Document the **RPC / storage envelope** (metadata returned with the snapshot: e.g. `release_id`, `channel`, `manifest_hash`, `manifest_sig`, `signing_pubkey`, `schema_version`, and how they relate to the signed bytes).
- State explicitly: **which octets** `manifest_sig` covers.

## Acceptance criteria

- [ ] One canonical doc (ADR or `docs/` page) is the **single** reference; [contracts/manifest/signing-envelope.md](https://github.com/danvoulez/minilab-cursor/blob/main/contracts/manifest/signing-envelope.md) links to it in one line (no duplicate prose).
- [ ] Doc lists field names and whether each is **inside** or **outside** the signed bytes.
- [ ] **Failure mode:** mismatch between recomputed hash and `manifest_hash` → reject entire snapshot (fail closed).
- [ ] Rust manifest-verify owner and TS publish/verify owner **acknowledge** the doc (comment or PR review).

## Quality / review

- Cross-check with [minilab-persistence-domain-model.md §2.2 / runtime contract](https://github.com/danvoulez/minilab-cursor/blob/main/docs/minilab-persistence-domain-model.md) and project README manifest section.
- [DoD & QC — contract alignment](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

## Dependencies

- Blocks a shared `ManifestSnapshot` type and golden tests until decided.

---

**Milestone:** [M0 — Freeze shared contracts](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
