## Why this matters

Stub-only rules are how architecture **evaporates**. This gate proves SPEC matches reality.

## Scope

Search the repo for:

- `TODO` / `FIXME` / “define contract” on **manifest**, **command states**, **events**, **pairing** without a link to a type, ADR, or migration path.
- Orphan **contracts/** prose that still duplicates canonical types.

## Acceptance criteria

- [ ] `rg` (or `git grep`) command and **output** (empty or explained exceptions) pasted on this issue or linked CI log.
- [ ] Exceptions list is **explicit** (file + reason + owner to clear by M1).
- [ ] [contracts/](https://github.com/danvoulez/minilab-cursor/tree/main/contracts) stubs are link-only per issue #12.

## Quality / review

- [M0 gate in milestones](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones-production.md#m0--freeze-shared-contracts)
- [DoD — merge blockers](https://github.com/danvoulez/minilab-cursor/blob/main/docs/definition-of-done-and-quality-control.md)

## Suggested command

```bash
git grep -nEi 'TODO|FIXME|define contract' -- contracts/ docs/ design/ references/ || true
```

(Refine patterns as needed; document false positives.)

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Blocks closing M0** until complete.

**Labels:** `milestone/M0` `type/gate`
