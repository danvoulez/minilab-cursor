# ADR 0003: Manifest signed bytes vs signing envelope

**Status:** Proposed  
**Date:** 2026-04-19

## Context

Runtime consumers must consume **one verified snapshot**, not publication-graph walks. That requires an exact split between (a) **bytes that are canonicalized and hashed** and (b) **metadata** carried in RPC/storage for correlation and policy.

Without a single rule, publisher and agent drift; verification weakens. This ADR is the normative rule deferred to by [contracts/manifest/signing-envelope.md](../../contracts/manifest/signing-envelope.md).

**Related:** [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md) §2.2, §4, §5 inv. 2–3; [plan-production.md](../plan-production.md) Phase 0.1; project README (JCS, `manifest_hash`, `manifest_sig` over canonical bytes).

## Decision

### Inner manifest object (signing payload)

1. The publisher **MUST** assemble one JSON **object** (the **inner manifest**) from publication truth for the given `schema_version` (roles, assignment rules, payloads, discovery, verify steps, secrets, etc., per manifest schema).
2. The publisher **MUST** serialize that object to **canonical JSON bytes** using **RFC 8785 (JCS)** or a byte-for-byte equivalent proven on **shared CI test vectors** with every other producer/consumer.
3. The publisher **MUST** compute
  `manifest_hash = "sha256:" + SHA256(canonical_bytes).hex()`  
   (or the exact string format already fixed in README/contracts—**one** format; consumers **MUST** parse equality the same way).
4. The publisher **MUST** compute
  `manifest_sig = Ed25519_sign(signing_private_key, canonical_bytes)`  
   i.e. signature is over the **same canonical byte sequence** that was hashed, **not** over the hex `manifest_hash` string unless a future ADR changes that uniformly (default **forbidden**).

### Signing / transport envelope (not mixed into canonical bytes for signing)

These fields accompany the snapshot for **storage, RPC, and policy**. They **MUST NOT** be merged into the inner JSON object for hashing/signing unless the manifest schema explicitly includes them **inside** the inner object (and then they must not also contradict envelope copies).

Envelope **MUST** include at least:


| Field            | Role                                                                   |
| ---------------- | ---------------------------------------------------------------------- |
| `manifest_hash`  | Digest of canonical inner bytes; primary identity check.               |
| `manifest_sig`   | Ed25519 signature over `canonical_bytes`.                              |
| `signing_pubkey` | Key for verification / trust policy.                                   |
| `release_id`     | Correlation to publication rows (not a substitute for crypto binding). |
| `channel`        | e.g. `stable`.                                                         |
| `schema_version` | Manifest JSON schema / verification rules version.                     |


Other envelope-only fields (DB id, `created_at`, tooling metadata) **MUST NOT** be treated as signed because they appear beside the manifest in a row.

### Two canonicalizers forbidden

There **MUST NOT** be two different canonicalization implementations in active use for the same `schema_version` without a coordinated version bump and migration. One normative rule; one vector suite; Rust and TS **MUST** match.

### MUST / MUST NOT summary


| Topic        | Rule                                                                                                                                                                                           |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Inner object | Sole value whose canonical bytes are SHA256’d and Ed25519-signed.                                                                                                                              |
| Envelope     | `manifest_hash`, `manifest_sig`, `signing_pubkey`, `release_id`, `channel`, `schema_version` are transport/metadata unless duplicated **inside** inner object by schema with no contradiction. |
| Signing      | **MUST NOT** sign HTTP headers, DB row metadata, or envelope-only fields as defined here.                                                                                                      |
| Verification | **MUST** fail closed on any mismatch (below).                                                                                                                                                  |


## Fail-closed verification

Consumers **MUST** reject the entire snapshot (no partial trust) if any step fails:

1. Parse inner manifest JSON per `schema_version`; semantic validation fails → **reject**.
2. Recompute canonical bytes (JCS / equivalent); failure → **reject**.
3. Recompute SHA256; compare to `manifest_hash` (per agreed string format); mismatch → **reject**.
4. Resolve `signing_pubkey` against trust policy; unacceptable → **reject**.
5. Verify `manifest_sig` over **canonical_bytes**; failure → **reject**.
6. Any redundant digest/signature copies in the transport **MUST** agree; inconsistency → **reject**.
7. Only after success may execution paths use the manifest.

## Consequences

**Positive:** Clear integrity vs routing boundary; Rust/TS can duplicate code paths without diverging in **meaning**.

**Negative:** Envelope fields are not cryptographically bound unless also inside the inner object; strict fail-closed may surface publisher mistakes—mitigate with preflight and CI vectors.

## Compliance

Implementations **MUST** conform to this ADR. Stubs under `contracts/manifest/` **SHOULD** link here until generated types embed the same semantics.

## References

- RFC 8785 (JCS)
- [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md)
- [plan-production.md](../plan-production.md)
- GitHub [#1](https://github.com/danvoulez/minilab-cursor/issues/1) · [#3](https://github.com/danvoulez/minilab-cursor/issues/3)

## Changelog


| Date       | Change                                                                 |
| ---------- | ---------------------------------------------------------------------- |
| 2026-04-19 | Proposed (parallel agent draft; signing = canonical bytes per README). |
