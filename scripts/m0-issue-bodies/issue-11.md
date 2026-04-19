## Why this matters

Operators and publisher code must serialize the **same** shapes as Rust verifies; TS-only hand types rot.

## Scope

- Add shared TS package (e.g. `packages/contracts`) **or** JSON Schema + `json-schema-to-ts` / openapi generator — pick one approach and document it.
- Cover manifest envelope fields, command state, and event unions from M0 crosswalk.

## Acceptance criteria

- [ ] Package builds under `ts/` workspace (or documented path); exported types used by at least one consumer (publisher stub or UI types import).
- [ ] **Single source** documented: “TS types generated from X” or “hand-maintained parity tested by Y.”
- [ ] CI or script: optional `diff` check against Rust JSON samples if feasible; if not, document manual parity checklist for M0 gate.

## Quality / review

- [Milestones M0 outputs](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones-production.md)
- [DoD — contract alignment](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

## Dependencies

- Rust types (#10) and name maps (#2, #5, #6) should be aligned before “done.”

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/implementation`
