## Why this matters

One table prevents “same concept, four names” from slipping into production.

## Scope

Create `docs/milestones/M0-crosswalk.md` (or equivalent path) with columns:

**Concept | Rust (type/path) | TS (type/path) | DB / planned table.column | Doc / ADR anchor**

Minimum rows:

- Manifest snapshot / hash / sig / channel / release linkage
- Each **command state** from issue #4
- Each **event family** from issue #6
- Pairing envelope (reference to ADR)
- `verify_results` model (reference to ADR #8)

## Acceptance criteria

- [ ] File merged to `main`; linked from [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md).
- [ ] Empty cells have **owner + target date** or “N/A” with reason.
- [ ] Reviewed by Rust + TS + schema/docs (see issue #17).

## Quality / review

- [M0 gate — name match](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones-production.md#m0--freeze-shared-contracts)

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Blocks closing M0** until complete.

**Labels:** `milestone/M0` `type/gate`
