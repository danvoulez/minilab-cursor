## Why this matters

Two different “canonical JSON” implementations → different hashes → valid signatures rejected or false negatives. This must be **impossible** by construction (one library, or verified interop).

## Scope

- Choose rule: **RFC 8785 (JCS)** or one exact equivalent documented in prose.
- Specify **UTF-8** encoding, **key sorting**, **number/string** rules, and **rejection** of non-canonical input at verify time if applicable.
- Identify **shared** implementation: Rust crate + TS package or single spec + conformance vectors.

## Acceptance criteria

- [ ] Written rule references RFC or exact algorithm; no hand-wavy “sort keys.”
- [ ] **One** canonicalization path for publisher assembly and agent verify (same code, or **golden test vectors** checked in both languages).
- [ ] At least **one** golden vector in repo: input object → canonical bytes → hex SHA-256 (and later Ed25519 sign/verify in tests if keys available).
- [ ] Explicit statement: **two canonicalizers in production = defect.**

## Quality / review

- [Plan production — Phase 0.1 / manifest](https://github.com/danvoulez/minilab-cursor/blob/main/docs/plan-production.md)
- [DoD — contract alignment](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

## Dependencies

- Tightly coupled to issue #1 (what bytes are signed).

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
