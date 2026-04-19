# M0 — GitHub-ready checklist

Companion to [M0 in milestones-production.md](../milestones-production.md#m0--freeze-shared-contracts). Use issue titles verbatim or prefix with `M0:`.

**Live tracker (GitHub):** [M0 milestone](https://github.com/danvoulez/minilab-cursor/milestone/1) · repo [danvoulez/minilab-cursor](https://github.com/danvoulez/minilab-cursor).

**Re-enrich issue bodies** (acceptance criteria, links, gates) from this repo after editing templates:

`./scripts/enrich-m0-github-issues.sh`

Bodies live in [`scripts/m0-issue-bodies/`](../../scripts/m0-issue-bodies/).

**Labels (suggested):** `milestone/M0`, `type/contract`, `type/implementation`, `type/gate`.

---

## Contract issues

_Define shape, names, and links; remove ambiguity._

- [ ] **[M0] ManifestSnapshot: document field-level contract** (what is in the signed manifest body vs RPC envelope metadata; link from [signing-envelope.md](../../contracts/manifest/signing-envelope.md) to canonical doc).
- [ ] **[M0] ManifestSnapshot: name map** (`ManifestSnapshot`, `manifest_hash`, `manifest_sig`, channel/release ids — same spelling in Rust, TS, docs, and intended DB columns).
- [ ] **[M0] Canonical bytes rule** (JCS / RFC 8785 or chosen equivalent; pointer to shared implementation or library; no “two canonicalizers”).
- [ ] **[M0] AgentCommand: state machine** (states: pending, leased, running, completed, failed, cancelled, dead_letter — exhaustive enum; illegal transitions rejected).
- [ ] **[M0] AgentCommand: name map** (state names and lease fields identical in Rust, TS, docs, M1 migration draft).
- [ ] **[M0] Typed events: name map** — `InstallationEvent`, `AgentCommandEvent`, `AgentCommandLeaseEvent`, `PairingEvent`, `AgentCredentialEvent` (Rust + TS + docs; DB table names `minilab.*` aligned).
- [ ] **[M0] Pairing / auth envelope** (session, challenge, credential reference shapes; trust boundary called out: Rust verifies, TS orchestrates UX).
- [ ] **[M0] verify_results: ADR or decision doc** (immutable attempt rows only vs separate authoritative summary; references [domain model §3B](../minilab-persistence-domain-model.md)).
- [ ] **[M0] Reconciliation: ownership decision** (single `ReconciliationRepository` vs explicit split; update [ReconciliationRepository.port.md](../../design/ports/ReconciliationRepository.port.md) if needed).

---

## Implementation issues

_Build artifacts that replace placeholder prose._

- [ ] **[M0] Rust: `minilab-core` exports contract types** (manifest verify inputs, command state, event enums as applicable).
- [ ] **[M0] TS: shared types package or codegen** (same shapes as Rust for manifest envelope, command state, events; or single JSON Schema + generators).
- [ ] **[M0] Replace SPEC `contracts/` stubs** with links to canonical paths (one line each: “Source of truth: …”).
- [ ] **[M0] Update [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md)** — “Contract sources” subsection under §7 or appendix: paths to Rust module(s), TS package(s), decision docs.
- [ ] **[M0] Optional: contract conformance test** (minimal: round-trip or golden vector for canonical hash of a tiny manifest fragment).

---

## Gate issues

_Cannot close M0 until all pass._

- [ ] **[GATE M0] Stub audit:** `rg` / search — no remaining “TODO: define contract” on manifest, command states, events, or pairing without a link to a real type or doc.
- [ ] **[GATE M0] Crosswalk table** in repo (e.g. `docs/milestones/M0-crosswalk.md` or section in this file): columns **Concept | Rust | TS | DB (planned) | Doc anchor** for manifest, each command state, each event type, pairing envelope.
- [ ] **[GATE M0] Review:** Rust + TS + schema/docs owners sign off that **names and meanings match** (short checklist comment on a tracking issue or PR).

---

## Minimal order (suggested)

1. Signed bytes vs envelope + canonicalization (blocks manifest types).  
2. `ManifestSnapshot` + hash/sig verify inputs in Rust/TS.  
3. `AgentCommand` states + lease field names.  
4. Event enums + pairing envelope.  
5. `verify_results` + reconciliation decisions.  
6. Stub replacement + crosswalk + gate review.

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-18 | Initial M0 GitHub-style checklist. |
