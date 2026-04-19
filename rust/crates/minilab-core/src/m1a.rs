//! M1-A allow-listed `event_type` strings for lease and command journal streams.
//!
//! **Must match** `references/migrations/20260418120000_m1a_minilab_agent_command_spine.sql` `CHECK` constraints. Expand only with a new migration + ADR 0005 discipline.

/// `minilab.agent_command_lease_events.event_type`
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
#[non_exhaustive]
pub enum AgentCommandLeaseEventKind {
    Claimed,
    Released,
    Renewed,
    Expired,
    Reclaimed,
}

impl AgentCommandLeaseEventKind {
    #[inline]
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::Claimed => "claimed",
            Self::Released => "released",
            Self::Renewed => "renewed",
            Self::Expired => "expired",
            Self::Reclaimed => "reclaimed",
        }
    }

    #[inline]
    pub fn parse(s: &str) -> Option<Self> {
        Some(match s {
            "claimed" => Self::Claimed,
            "released" => Self::Released,
            "renewed" => Self::Renewed,
            "expired" => Self::Expired,
            "reclaimed" => Self::Reclaimed,
            _ => return None,
        })
    }
}

impl std::fmt::Display for AgentCommandLeaseEventKind {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}

/// `minilab.agent_command_events.event_type` (narrative — not lease authority).
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
#[non_exhaustive]
pub enum AgentCommandJournalEventKind {
    Started,
    Completed,
    Failed,
    CancelRequested,
}

impl AgentCommandJournalEventKind {
    #[inline]
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::Started => "started",
            Self::Completed => "completed",
            Self::Failed => "failed",
            Self::CancelRequested => "cancel_requested",
        }
    }

    #[inline]
    pub fn parse(s: &str) -> Option<Self> {
        Some(match s {
            "started" => Self::Started,
            "completed" => Self::Completed,
            "failed" => Self::Failed,
            "cancel_requested" => Self::CancelRequested,
            _ => return None,
        })
    }
}

impl std::fmt::Display for AgentCommandJournalEventKind {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn lease_round_trip() {
        for k in [
            AgentCommandLeaseEventKind::Claimed,
            AgentCommandLeaseEventKind::Released,
            AgentCommandLeaseEventKind::Renewed,
            AgentCommandLeaseEventKind::Expired,
            AgentCommandLeaseEventKind::Reclaimed,
        ] {
            assert_eq!(AgentCommandLeaseEventKind::parse(k.as_str()), Some(k));
        }
    }

    #[test]
    fn journal_round_trip() {
        for k in [
            AgentCommandJournalEventKind::Started,
            AgentCommandJournalEventKind::Completed,
            AgentCommandJournalEventKind::Failed,
            AgentCommandJournalEventKind::CancelRequested,
        ] {
            assert_eq!(AgentCommandJournalEventKind::parse(k.as_str()), Some(k));
        }
    }
}
