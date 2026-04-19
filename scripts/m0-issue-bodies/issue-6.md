## Why this matters

Evidence streams are **typed** and **separate** (no mega-bus). Name drift between `AgentCommandEvent` and `minilab.agent_command_events` breaks inspection and codegen.

## Scope

Align **event type names** and **table names** for:

- `InstallationEvent` → `minilab.installation_events`
- `AgentCommandEvent` → `minilab.agent_command_events`
- `AgentCommandLeaseEvent` → `minilab.agent_command_lease_events`
- `PairingEvent` → `minilab.pairing_events`
- `AgentCredentialEvent` → `minilab.agent_credential_events`

Include **variant naming** strategy (Rust enum variants vs TS union vs DB `event_type` column if any).

## Acceptance criteria

- [ ] Crosswalk: *Event family | Rust enum/module | TS union | Table | Notes* in `docs/`.
- [ ] [contracts/events/*.md](https://github.com/danvoulez/minilab-cursor/tree/main/contracts/events) each point to canonical type definition (one line).
- [ ] Lease events **not** folded into generic command progress text ([domain §5.1](https://github.com/danvoulez/minilab-cursor/blob/main/docs/minilab-persistence-domain-model.md)).

## Quality / review

- [Domain model §8 typed streams](https://github.com/danvoulez/minilab-cursor/blob/main/docs/minilab-persistence-domain-model.md)
- [DoD — evidence](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
