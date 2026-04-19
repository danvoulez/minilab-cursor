# AgentCommand

Lifecycle: pending → leased → running → completed | failed | cancelled | dead_letter.

**Rust:** [`minilab_core::command::AgentCommandStatus`](../../rust/crates/minilab-core/src/command.rs) — string values must match the database enum / check constraint in M1 migrations.

See [minilab-persistence-domain-model.md](../../docs/minilab-persistence-domain-model.md) §4, §5. [M0 crosswalk](../../docs/milestones/M0-crosswalk.md).
