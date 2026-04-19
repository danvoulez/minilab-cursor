## Why this matters

Naming drift between Rust, TypeScript, SQL, and JSON breaks RLS, codegen, and operator mental models. One typo in `manifest_hash` vs `manifestHash` becomes a production bug.

## Scope

Align **spelling and casing** for at least:

- `ManifestSnapshot` (type name) vs table `manifest_snapshots`
- `manifest_hash`, `manifest_sig`, signing public key field
- `release_id`, `channel`, `schema_version`
- Nested manifest / snapshot payload field names as consumed by verify

## Acceptance criteria

- [ ] **Crosswalk table** (markdown or sheet): *Concept | Rust | TS | JSON/API | DB column (planned)* for every field above.
- [ ] Table checked in under `docs/` (or linked from M0 crosswalk issue) and reviewed by Rust + TS + schema owner.
- [ ] No duplicate synonyms in code (e.g. one canonical `snake_case` in DB and explicit mapping in TS if needed).

## Quality / review

- [Invariant alignment](https://github.com/danvoulez/minilab-cursor/blob/main/docs/minilab-persistence-domain-model.md): runtime contract domain uses singular snapshot semantics.
- [DoD — contract alignment](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

## Dependencies

- Best done **after** issue #1 (signed-bytes scope) so field list is stable.

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
