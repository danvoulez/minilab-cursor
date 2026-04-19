//! M1-A durable command vertical — contract alignment for the first heartbeat.
//!
//! Checklist: [`M1-A-command-vertical-checklist.md`](../../../../docs/milestones/M1-A-command-vertical-checklist.md).  
//! SQL: `references/migrations/20260418120000_m1a_minilab_agent_command_spine.sql`.
//!
//! This module does **not** run SQL; it re-exports types and documents the ordered steps an executor must implement.

pub use minilab_core::{
    command_transition_allowed, AgentCommandJournalEventKind, AgentCommandLeaseEventKind,
    AgentCommandStatus,
};

/// Labels for the six acceptance steps (stable for tests and operator runbooks).
pub const M1A_VERTICAL_STEPS: [&str; 6] = [
    "1_persist_command",
    "2_claim_lease",
    "3_append_lease_event",
    "4_typed_execute",
    "5_append_command_event",
    "6_terminal_inspectable",
];
