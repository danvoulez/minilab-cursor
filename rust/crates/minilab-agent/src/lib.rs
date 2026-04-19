//! Host agent: claim/lease/execute, manifest verify, pairing, evidence emission.
//!
//! See workspace `docs/minilab-persistence-domain-model.md` §7.
//! Contracts: `minilab-core` (e.g. [`minilab_core::AgentCommandStatus`], [`minilab_core::command_transition_allowed`]).
//! **M1-A slice:** [`command_spine`](command_spine).

pub mod command_spine;

pub use command_spine::{
    command_transition_allowed, AgentCommandJournalEventKind, AgentCommandLeaseEventKind,
    AgentCommandStatus, M1A_VERTICAL_STEPS,
};
