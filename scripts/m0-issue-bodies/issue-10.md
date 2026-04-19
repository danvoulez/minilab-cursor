## Why this matters

Rust is the **operational core**; without shared types in `minilab-core`, the agent and verify logic diverge from TS and DB.

## Scope

- Expose **manifest verify** input/output types (or thin structs) needed by the agent.
- Expose **command status** enum and **lease-related** field accessors as agreed in issues #4–#5.
- Expose **event** enums or type modules as agreed in issue #6 (can be minimal stubs with `#[non_exhaustive]` if needed).

## Acceptance criteria

- [ ] `rust/crates/minilab-core` (or agreed crate) compiles; types are **used** by `minilab-agent` or a small example binary.
- [ ] Public API documented in rustdoc with **one line** pointing to canonical markdown spec per type family.
- [ ] No duplicate competing definitions in other Rust crates.

## Quality / review

- [Plan production — Phase 0](https://github.com/danvoulez/minilab-cursor/blob/main/docs/plan-production.md) · [M0 milestone outputs](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones-production.md)
- [DoD — PR checklist](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

## Dependencies

- Contract issues #1–#7 should be far enough along that names are stable.

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/implementation`
