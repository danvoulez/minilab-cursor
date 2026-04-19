//! Envelope **field names** for RPC / storage (not necessarily inside signed inner JSON).
//!
//! **Normative:** [ADR 0003](../../../../docs/adr/0003-manifest-signed-bytes-vs-envelope.md)

pub mod field {
    pub const MANIFEST_HASH: &str = "manifest_hash";
    pub const MANIFEST_SIG: &str = "manifest_sig";
    pub const SIGNING_PUBKEY: &str = "signing_pubkey";
    pub const RELEASE_ID: &str = "release_id";
    pub const CHANNEL: &str = "channel";
    pub const SCHEMA_VERSION: &str = "schema_version";
}
