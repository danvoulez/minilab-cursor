# AgentCommand

Lifecycle: pending → leased → running → completed | failed | cancelled | dead_letter.

**Rust:** [`minilab_core::command::AgentCommandStatus`](../../rust/crates/minilab-core/src/command.rs), [`command_transition_allowed`](../../rust/crates/minilab-core/src/command.rs) — string values must match the database enum / check constraint in M1 migrations.

**Transitions (Accepted):** [ADR 0004](../../docs/adr/0004-agent-command-state-machine.md) · [state-machine.md](state-machine.md).

See [minilab-persistence-domain-model.md](../../docs/minilab-persistence-domain-model.md) §4, §5. [M0 crosswalk](../../docs/milestones/M0-crosswalk.md).
