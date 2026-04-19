## Why this matters

Leasing, retries, and UI honesty depend on a **single** command lifecycle. Ambiguous states → double execution or stuck commands.

## Scope

- Define **exhaustive** enum: `pending`, `leased`, `running`, `completed`, `failed`, `cancelled`, `dead_letter` (adjust only if domain model is updated everywhere).
- Document **legal transitions** (state machine diagram or table).
- Define behavior for: claim, renew lease, complete, fail, cancel, max attempts → dead_letter.

## Acceptance criteria

- [ ] Machine documented in `docs/` or ADR; linked from [contracts/commands/state-machine.md](https://github.com/danvoulez/minilab-cursor/blob/main/contracts/commands/state-machine.md).
- [ ] Illegal transitions: **reject** at DB (constraint) or application layer with explicit error — no silent coercions.
- [ ] Aligns with [domain model — AgentCommand / coordination](https://github.com/danvoulez/minilab-cursor/blob/main/docs/minilab-persistence-domain-model.md) and lease evidence stream.

## Quality / review

- Executor must only run work from states where lease is valid (document which).
- [DoD — execution boundary](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md): typed ops + lifecycle consistency.

## Dependencies

- Feeds issue #5 (name map for states and lease fields).

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
