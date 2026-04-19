//! [`AgentCommand`] lifecycle — authoritative enum for persisted `agent_commands.status`.
//!
//! **Normative transitions:** [ADR 0004](../../../../docs/adr/0004-agent-command-state-machine.md) · **Crosswalk:** [M0-crosswalk.md](../../../../docs/milestones/M0-crosswalk.md) · strings **must** match DB text enum / check constraint in M1 migrations.

/// Command row lifecycle (`agent_commands.status` in PostgreSQL).
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
#[non_exhaustive]
pub enum AgentCommandStatus {
    Pending,
    Leased,
    Running,
    Completed,
    Failed,
    Cancelled,
    DeadLetter,
}

impl AgentCommandStatus {
    /// Canonical persistence / API string (snake_case).
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::Pending => "pending",
            Self::Leased => "leased",
            Self::Running => "running",
            Self::Completed => "completed",
            Self::Failed => "failed",
            Self::Cancelled => "cancelled",
            Self::DeadLetter => "dead_letter",
        }
    }

    /// Parse from DB / API. Fails on unknown values (forward-compatible: add variants later).
    pub fn parse(s: &str) -> Option<Self> {
        Some(match s {
            "pending" => Self::Pending,
            "leased" => Self::Leased,
            "running" => Self::Running,
            "completed" => Self::Completed,
            "failed" => Self::Failed,
            "cancelled" => Self::Cancelled,
            "dead_letter" => Self::DeadLetter,
            _ => return None,
        })
    }

    /// Terminal states — no outbound transitions except idempotent self-replay.
    #[inline]
    pub const fn is_terminal(self) -> bool {
        matches!(
            self,
            Self::Completed | Self::Failed | Self::Cancelled | Self::DeadLetter
        )
    }
}

/// Whether `from → to` is allowed per [ADR 0004](../../../../docs/adr/0004-agent-command-state-machine.md).
///
/// `from == to` is allowed (idempotent replay). From any terminal state, only self is allowed.
#[inline]
pub fn command_transition_allowed(from: AgentCommandStatus, to: AgentCommandStatus) -> bool {
    if from == to {
        return true;
    }
    if from.is_terminal() {
        return false;
    }
    matches!(
        (from, to),
        (
            AgentCommandStatus::Pending,
            AgentCommandStatus::Leased
                | AgentCommandStatus::Cancelled
                | AgentCommandStatus::DeadLetter
                | AgentCommandStatus::Failed
        ) | (
            AgentCommandStatus::Leased,
            AgentCommandStatus::Pending
                | AgentCommandStatus::Running
                | AgentCommandStatus::Cancelled
                | AgentCommandStatus::DeadLetter
                | AgentCommandStatus::Failed
        ) | (
            AgentCommandStatus::Running,
            AgentCommandStatus::Completed
                | AgentCommandStatus::Failed
                | AgentCommandStatus::Cancelled
                | AgentCommandStatus::DeadLetter
        )
    )
}

impl std::fmt::Display for AgentCommandStatus {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn round_trip_str() {
        for s in [
            AgentCommandStatus::Pending,
            AgentCommandStatus::Leased,
            AgentCommandStatus::Running,
            AgentCommandStatus::Completed,
            AgentCommandStatus::Failed,
            AgentCommandStatus::Cancelled,
            AgentCommandStatus::DeadLetter,
        ] {
            assert_eq!(AgentCommandStatus::parse(s.as_str()), Some(s));
        }
    }

    #[test]
    fn transition_matrix_samples() {
        use AgentCommandStatus::*;
        assert!(command_transition_allowed(Pending, Leased));
        assert!(command_transition_allowed(Leased, Pending));
        assert!(command_transition_allowed(Leased, Running));
        assert!(command_transition_allowed(Running, Completed));
        assert!(!command_transition_allowed(Pending, Running));
        assert!(!command_transition_allowed(Pending, Completed));
        assert!(!command_transition_allowed(Running, Pending));
        assert!(!command_transition_allowed(Failed, Pending));
        assert!(command_transition_allowed(Failed, Failed));
    }
}
