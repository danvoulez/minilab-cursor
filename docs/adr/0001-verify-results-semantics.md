# ADR 0001: `verify_results` semantics — evidence vs authoritative summary

**Status:** Proposed  
**Date:** 2026-04-19

## Context

Verification outcomes are **trust and continuity** data: they explain what the host believed about the manifest (or install surface) at a point in time, support audits, retries, and “what changed since last attempt,” and feed operator inspection. If that data **mixes two persistence roles**—append-only **evidence** and mutable **authoritative “latest” state**—in one table or one row lifecycle without an explicit rule, the host/installation domain turns mushy: history is rewritten, audits lie, RLS and “who may write what” become ambiguous, and Rust/TS/DB can silently diverge on meaning (violates the project’s boundary-first model and [Invariant 9](../minilab-persistence-domain-model.md) in spirit: append-only evidence must stay immutable in meaning).

This risk is load-bearing for production intent: [plan-production.md](../plan-production.md) Phase 0.5 requires a written decision before implementation; [M0-checklist.md](../milestones/M0-checklist.md) tracks an ADR for `verify_results` tied to the domain model.

## Decision

**Adopt two distinct persistence surfaces:**

1. **`verify_results` (append-only evidence):** exactly **one row per immutable verify attempt**. Inserts only; rows are **never** updated to represent “the current verification result.” Semantics match [§3B — Append-only evidence](../minilab-persistence-domain-model.md#b-append-only-evidence) and the `verify_results` table stub in [references/schemas/minilab/evidence/verify_results.table.md](../../references/schemas/minilab/evidence/verify_results.table.md).

2. **Separate authoritative summary (not the same rows):** mutable **“latest verification summary”** for an installation lives in a **different table** dedicated to authoritative installation-scoped state, **or** on an existing authoritative aggregate (e.g. `installations`) **only** if that placement is explicitly owned and documented—**not** as extra mutable columns on `verify_results` and not as upserts that overwrite attempt history.

**Rejected for default design:** a single table serving both “full attempt history” and “current summary” via in-place updates or overloaded columns without a written split.

**Assumptions (explicit):**

- The physical name of the summary surface is **not** fixed by this ADR; the invariant is **role separation**, not a mandated table name.
- A **read-only SQL view** that aggregates “latest attempt” from `verify_results` is acceptable **only** as a **presentation/read-model** if documented as derived and **not** relied on as the sole writable source of “latest” for reconciliation or agent logic unless those writers only insert new attempts and refresh summary elsewhere.
- Event typing (`VerifyResultEvent` or equivalent per-attempt record) remains aligned across Rust, TS, and persistence per Phase 0 contract freeze.

## Consequences

**Positive**

- Clear **one role per table** alignment with [§3 — Table roles](../minilab-persistence-domain-model.md#3-table-roles-every-table-exactly-one).
- Honest **inspection from rows**: full attempt history remains queryable; “current posture” has a single authoritative place to join.
- **RLS and policies** can treat evidence as insert-only for agents/operators as appropriate, and summary updates as a narrower, auditable path.

**Negative / trade-offs**

- Writers must **update two places** in one logical operation (new attempt row + summary update) or use a transactional RPC—**operational burden** that must be implemented deliberately.
- Slightly more schema surface than a naive single-table upsert.

## Implementation notes

**RLS and policies**

- **`verify_results`:** grant **INSERT** (and **SELECT** as needed); **no `UPDATE` policy** for normal application roles unless explicitly risk-accepted. Prefer **no `UPDATE`** on the table at all in migrations for those roles.
- **Summary table (or `installations` fields):** **SELECT/INSERT/UPDATE** as required; changes should be **traceable** if reconciliation requires it.
- Scope both surfaces **host- and installation-aligned** with the same “host agreement” discipline as other Minilab tables (exact FK/column names follow migrations, not this ADR).

**Migration sketch**

- `minilab.verify_results`: PK per attempt (e.g. UUID), **FK to `installations`**, attempt timestamp, outcome, refs to manifest/snapshot, detail payloads—**no** “current” flag that flips on the same row across attempts.
- **Summary** surface: one row per installation (or clear uniqueness); columns only for **latest** interpretive state.
- Optional **view** for operator inspect from `verify_results` only; document as non-authoritative if summary table is canonical for “latest.”
- Legacy dual-role data: one-shot migration + changelog; do not preserve ambiguous rows.

## Links

- Domain model — **§3B and `verify_results` callout:** [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md)
- Plan — **Phase 0.5:** [plan-production.md](../plan-production.md)
- Schema stub: [verify_results.table.md](../../references/schemas/minilab/evidence/verify_results.table.md)
- M0: [M0-checklist.md](../milestones/M0-checklist.md) · GitHub [#8](https://github.com/danvoulez/minilab-cursor/issues/8)

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-19 | Proposed (parallel agent draft, parent merged). |
