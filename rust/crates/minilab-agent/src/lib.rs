//! Host agent: claim/lease/execute, manifest verify, pairing, evidence emission.
//!
//! See workspace `docs/minilab-persistence-domain-model.md` §7.
//! Contracts: `minilab-core` (e.g. [`minilab_core::AgentCommandStatus`], [`minilab_core::command_transition_allowed`]).

pub use minilab_core::{command_transition_allowed, AgentCommandStatus};
