# ADR 0006: Pairing and host-scoped credential ceremony

**Status:** Accepted  
**Date:** 2026-04-19

## Context

**Pairing** binds a [Host](../minilab-persistence-domain-model.md) to cryptographic identity and leads to **host-scoped** [AgentCredential](../minilab-persistence-domain-model.md) state. If ceremony stages, reclaim, or verification ownership are vague, implementations smuggle trust through TypeScript, mix conversational UX with evidence, or “revive” dead sessions—violating boundary-first modeling and [Invariant 5 / 6 territory](../minilab-persistence-domain-model.md) (identity and authority).

This ADR fixes **semantic boundaries and persistence roles** for M0. It **does not** invent exhaustive JSON field lists or `event_type` vocabularies; those follow the same discipline as [M0-event-map.md](../milestones/M0-event-map.md) and land in **M1 migrations** + crosswalk.

## Decision

### Trust boundary


| Layer                                                         | Responsibility                                                                                                                                                                             |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Rust** (agent + any server-side verifier in the trust path) | Verify challenges/signatures/proofs; append **trust-bearing** rows to `minilab.pairing_events` and `minilab.agent_credential_events` per [ADR 0005](0005-typed-evidence-event-streams.md). |
| **TypeScript**                                                | UX, session orchestration, inspection; **not** the sole authority for minting verified trust claims that skip durable Rust-verified evidence.                                              |
| **Secrets**                                                   | No raw private keys or shared secrets in operator chat, URLs, or logs. Persist **references** (ids, algorithms, handles)—exact columns in M1.                                              |


### Persistence surfaces (roles)

Aligned to [§3 — Table roles](../minilab-persistence-domain-model.md):


| Surface                                  | Role                              | Notes                                                                                    |
| ---------------------------------------- | --------------------------------- | ---------------------------------------------------------------------------------------- |
| `pairing_sessions` (name per migration)  | **Authoritative** ceremony root   | One row represents **one** pairing attempt’s current stage; scoped to **one** `host_id`. |
| `minilab.pairing_events`                 | **Append-only evidence**          | Narrates the ceremony; `event_type` vocabulary **M1** (not enumerated here).             |
| `agent_credentials` (name per migration) | **Authoritative** credential root | Latest interpretive credential row for a host; scoped to host.                           |
| `minilab.agent_credential_events`        | **Append-only evidence**          | Issuance, rotation, revoke; vocabulary **M1**.                                           |


### Host scope

- Every pairing session and credential **must** be FK-scoped to **exactly one** host aggregate. No ambiguous “floating” credentials.

### Ceremony stages (semantic M0; spellings M1)

Stages describe **intent**; persisted enum strings and transitions are locked when migrations + [M0-crosswalk.md](../milestones/M0-crosswalk.md) are updated on **Acceptance**.

**Indicative lifecycle** (names may map 1:1 to DB or collapse per migration):

1. **initiated** — session row exists; challenge not yet satisfied.
2. **challenging** — host/agent must prove possession; verifier consumes a defined transcript (algorithm in impl spec).
3. **awaiting_operator** — optional human gate; still durable state, not UI-only.
4. **verified** — ceremony crypto succeeded; **credential issuance** may be a **separate** atomic step (must still be evidenced).
5. **failed** — **terminal**; no valid credential from this session; reason in `pairing_events`.
6. **reclaimed** — **terminal**; operator **superseded** this session; host must use a **new** session id to continue.

**Illegal:** silent revive of a **failed** or **reclaimed** session to **verified** without a **new** session row.

### Reclaim / supersede

- **Reclaim** means: close the old session as **reclaimed** (or **failed** with `superseded`-class reason—pick one convention in M1, document in crosswalk), then create a **new** `pairing_sessions` row.
- History is **not** deleted; evidence explains the supersession.

### Challenge semantics (minimum)

- A challenge binds **session identity** (id / nonce) to **host proof**. The **same transcript** is what Rust verifies; TS does not substitute an alternate interpretation as authoritative.

### Credential shape (minimum)

- Credentials are **host-scoped**; rotation and revoke emit **AgentCredentialEvent** rows; summary row follows **Invariant 10** discipline (row vs movie) with events as inspectable history.

### Failure closure

- **failed** or **reclaimed** sessions do not issue half-credentials; partial issuance is **rejected** (rollback or never commit credential row—M1 transaction boundaries).
- Recovery after partition: **durable reread** of session + streams; Realtime is wake-up only ([§8 / Invariant 8](../minilab-persistence-domain-model.md)).

### Terminal outcomes and credential issuance (M0)

**Pairing session** must end in one of these **durable** outcomes:

- **Success path:** ceremony completes; a **host-scoped credential** is issued **only** after completion conditions in this ADR are satisfied—persisted on `agent_credentials` / `minilab.agent_credential_events` with matching evidence.
- **Terminal failure:** session ends **failed**; **no** credential is issued; inspectable reason in `minilab.pairing_events`.
- **Reclaim / supersede:** the superseded session is **terminal** (**reclaimed** or **failed** with superseded-class reason—one convention in M1, documented in crosswalk). A **new** `pairing_sessions` row is the sole locus of continued pairing; **no** overlapping active authority across old and new session ids.

**Credential persistence rule:** **Do not** persist an authoritative `agent_credentials` row (or equivalent material) **before** ceremony **completion conditions** are satisfied—cryptographic verification complete, session stage permits issuance, and required evidence rows recorded. Partial or speculative credential rows ahead of completion are **rejected** (M1 transactions should enforce atomicity).

### Explicitly out of scope (M1+)

- Exact JSON / Protobuf field names for [pairing-envelope.md](../../contracts/pairing/pairing-envelope.md).
- RLS matrices and service-role policies.
- Whether verifier runs **in-process** vs **RPC** on Supabase edge—architecture only, not M0 semantic freeze.

## Authority ordering

- Once **Accepted**, this ADR supersedes informal pairing prose in stubs; on conflict, **update stubs and domain narrative**, not the ADR.
- **`minilab-core`:** add **only** shared, settled literals (e.g. table names already in [`events::tables`](../../rust/crates/minilab-core/src/events.rs))—**no** executor policy, backoff, or ceremony timers in core until ADR + crosswalk say so.

## Consequences

**Positive**

- Rust/TS ownership is explicit; reclaim has a durable story; evidence streams stay separate from chat ([§5.1](../minilab-persistence-domain-model.md)).

**Negative**

- M1 must still deliver concrete `event_type` sets, envelope bytes, and constraints—**by design** to avoid fake early enums.

## Links

- Evidence streams: [ADR 0005](0005-typed-evidence-event-streams.md) · [M0-event-map.md](../milestones/M0-event-map.md)
- Domain: [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md) §2.5, §4 (`PairingSession`, `AgentCredential`), §6 ports
- Ports: [PairingRepository.port.md](../../design/ports/PairingRepository.port.md), [CredentialRepository.port.md](../../design/ports/CredentialRepository.port.md)
- GitHub: [#7](https://github.com/danvoulez/minilab-cursor/issues/7)

## Changelog


| Date       | Change                                                                         |
| ---------- | ------------------------------------------------------------------------------ |
| 2026-04-19 | Proposed: trust boundary, persistence roles, stages, reclaim, failure closure. |
| 2026-04-18 | Accepted — M0 first-pass disposition; terminal/credential issuance hardening ([matrix](../milestones/M0-ADR-outcome-matrix.md)). |
