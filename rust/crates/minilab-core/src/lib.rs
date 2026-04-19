//! Shared Minilab contracts: command lifecycle, evidence stream names, manifest envelope keys.
//!
//! **Do not duplicate semantics** — see [M0-crosswalk.md](../../../../docs/milestones/M0-crosswalk.md) and [ADRs](../../../../docs/adr/README.md).

pub mod command;
pub mod events;
pub mod manifest_envelope;

pub use command::AgentCommandStatus;
