## Why this matters

Informal “LGTM” without explicit ownership allows silent semantic drift.

## Scope

Formal sign-off that **names and meanings** match across:

- **Rust** (minilab-core / agent consumers)
- **TypeScript** (shared types / publisher)
- **Schema / docs** (migrations not required for M0, but **planned** column names must match crosswalk)

## Acceptance criteria

- [ ] Comment on this issue (or linked PR) from **three** roles: `@rust-owner`, `@ts-owner`, `@schema-docs-owner` (substitute real GitHub handles).
- [ ] Each confirms: reviewed **M0-crosswalk** (#16) and **ADR**s for manifest bytes (#1), verify_results (#8), reconciliation (#9).
- [ ] No open **P0** objections; P1s documented as follow-ups with issues.

## Quality / review

- [M0 milestone gate](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones-production.md#m0--freeze-shared-contracts)
- [DoD — milestone done](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

## Dependencies

- **Last** gate to close; depends on #15 and #16 and material progress on #1–#14.

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1)

**Labels:** `milestone/M0` `type/gate`
