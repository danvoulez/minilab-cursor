//! Typed evidence stream identifiers — **table names** in schema `minilab`.
//!
//! **Normative:** [ADR 0005](../../../../docs/adr/0005-typed-evidence-event-streams.md) · [M0 event map](../../../../docs/milestones/M0-event-map.md) · **Crosswalk:** [M0-crosswalk.md](../../../../docs/milestones/M0-crosswalk.md) · [domain §8](../../../../docs/minilab-persistence-domain-model.md)

pub mod tables {
    pub const INSTALLATION_EVENTS: &str = "installation_events";
    pub const AGENT_COMMAND_EVENTS: &str = "agent_command_events";
    pub const AGENT_COMMAND_LEASE_EVENTS: &str = "agent_command_lease_events";
    pub const PAIRING_EVENTS: &str = "pairing_events";
    pub const AGENT_CREDENTIAL_EVENTS: &str = "agent_credential_events";
    pub const VERIFY_RESULTS: &str = "verify_results";
}

/// Schema name for Minilab persistence.
pub const MINILAB_SCHEMA: &str = "minilab";
