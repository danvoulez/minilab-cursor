# ManifestSnapshot

Shared: canonical bytes, `manifest_hash`, `manifest_sig`, signing pubkey, channel/release linkage.

**Normative signing (Accepted):** [ADR 0003 — manifest signed bytes vs envelope](../../docs/adr/0003-manifest-signed-bytes-vs-envelope.md).

**Rust:** [`minilab_core::manifest_envelope`](../../rust/crates/minilab-core/src/manifest_envelope.rs) (envelope JSON field-name constants; inner snapshot shape is defined elsewhere).

See [minilab-persistence-domain-model.md](../../docs/minilab-persistence-domain-model.md) §2.2, §4.
