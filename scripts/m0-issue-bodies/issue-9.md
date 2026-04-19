## Why this matters

`host_desired_state` / `host_applied_state` become mush if every package writes them ad hoc. One **port** or an **explicit split** must own writes.

## Scope

- Decide: **`ReconciliationRepository` only** (single module/crate boundary) **or** documented split (e.g. desired via operator-only port, applied via agent-only port).
- Document **forbidden** patterns (random Supabase updates from UI helpers).

## Acceptance criteria

- [ ] Decision in `docs/` (short ADR) or update [ReconciliationRepository.port.md](https://github.com/danvoulez/minilab-cursor/blob/main/design/ports/ReconciliationRepository.port.md) with final rule + link to ADR.
- [ ] If split: list **exact** entry points (file paths or crate modules) allowed to touch each table.
- [ ] Schema/docs owners acknowledge.

## Quality / review

- [Domain model — reconciliation / security domain](https://github.com/danvoulez/minilab-cursor/blob/main/docs/minilab-persistence-domain-model.md)
- [DoD — reconciliation](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/contract`
