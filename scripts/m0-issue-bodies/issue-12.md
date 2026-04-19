## Why this matters

SPEC `contracts/` stubs must not hold **competing** prose once code is canonical; they become navigation only.

## Scope

- For each file under [contracts/](https://github.com/danvoulez/minilab-cursor/tree/main/contracts): replace body with **one** “Source of truth:” line (path to Rust module, TS package, or ADR).
- Remove duplicated field lists from stubs **after** canonical doc exists.

## Acceptance criteria

- [ ] Every file under `contracts/manifest`, `contracts/commands`, `contracts/events`, `contracts/grammar`, `contracts/pairing`, `contracts/read_models` points to a real artifact or open issue (no orphan TODO paragraphs).
- [ ] `contracts/README.md` explains the “link only” rule and links [SPEC exit criterion](https://github.com/danvoulez/minilab-cursor/blob/main/docs/plan-production.md#spec-workspace-exit-criterion).

## Quality / review

- [GATE M0 stub audit](https://github.com/danvoulez/minilab-cursor/issues/15) should pass after this + contract docs exist.

---

**Milestone:** [M0](https://github.com/danvoulez/minilab-cursor/milestone/1) · **Checklist:** [M0-checklist.md](https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-checklist.md)

**Labels:** `milestone/M0` `type/implementation`
