## Why this matters

`verify_results` is **semantically dangerous**: one table cannot silently be both “immutable attempt log” and “current truth” without mush ([domain §3B callout](https://github.com/danvoulez/minilab-cursor/blob/main/docs/minilab-persistence-domain-model.md)).

## Scope

Choose **one** documented model:

- **A)** One row per verify **attempt**, append-only / immutable → **evidence**; “latest pass/fail” is a **derived view** or separate summary row; or  
- **B)** Authoritative **summary** table separate from **attempt** history; or  
- **C)** Another explicit pattern — must state read/write rules.

## Acceptance criteria

- [ ] Short **ADR** in `docs/` (e.g. `docs/adr/0001-verify-results.md`) committed; linked from [evidence stub verify_results](https://github.com/danvoulez/minilab-cursor/blob/main/references/schemas/minilab/evidence/verify_results.table.md) or replaced with link.
- [ ] If immutable attempts: document **no UPDATE** policy or DB enforcement plan.
- [ ] [stub table](https://github.com/danvoulez/minilab-cursor/blob/main/references/schemas/minilab/evidence/verify_results.table.md) updated to match ADR **or** link only to ADR.

## Quality / review

- [DoD — verify_results / persistence](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
