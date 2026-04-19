# ADR 0002: Reconciliation write ownership (`host_desired_state` / `host_applied_state`)

**Status:** Accepted  
**Date:** 2026-04-19

## Context

Minilab treats **security and reconciliation** as a distinct persistence domain. Two authoritative tables carry reconciliation truth:


| Table                | Aggregate          | Role                                                                       |
| -------------------- | ------------------ | -------------------------------------------------------------------------- |
| `host_desired_state` | `HostDesiredState` | Persisted **intended target** for reconciliation.                          |
| `host_applied_state` | `HostAppliedState` | Persisted **applied-state summary** grounded in host/install **evidence**. |


Drift and operator trust depend on **clear ownership of writes**. Related artifacts:

- [ReconciliationRepository.port.md](../../design/ports/ReconciliationRepository.port.md)
- [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md)
- [plan-production.md](../plan-production.md) Phase 0.6
- [definition-of-done-and-quality-control.md](../definition-of-done-and-quality-control.md)

Phase **0.6** requires: **one port** for writes **or** an **explicitly documented split**—never fuzzy multi-caller updates.

## Decision

### 1. Default: single `ReconciliationRepository` port

All **authoritative mutations** to `host_desired_state` and `host_applied_state` go through the **`ReconciliationRepository`** port (contract-shaped name, not a storage vendor).

### 2. Mapping


| Concern         | Table                | Notes                                       |
| --------------- | -------------------- | ------------------------------------------- |
| Desired target  | `host_desired_state` | Intent for convergence; explicitly owned.   |
| Applied summary | `host_applied_state` | Summary grounded in evidence, not UI vibes. |


Reads may exist elsewhere for inspection; **writes** stay behind this port by default.

### 3. Forbidden

- Multiple writers updating the same reconciliation rows without a single reviewable ownership story.
- Partial patches from unrelated features or scattered Supabase updates from the operator app.
- Smuggling writes through `HostRepository`, `InstallationRepository`, or ad hoc clients—see port **Forbidden** line.

### 4. When a split is allowed (non-default)

Allowed **only** when **all** are written in SPEC or linked canonical docs:

1. **Exact write surfaces** — which component mutates which table, which operations/RPCs.
2. **Ordering / consistency** — how desired vs applied may diverge and converge.
3. **Evidence linkage** — how `host_applied_state` stays grounded in install/verify/command/lease narratives.
4. **Audit story** — trace every mutation to documented code path(s).
5. **Drift checks** — how review/CI block new bypasses.

Until that exists, the **default single port** applies.

### 5. Rust vs TypeScript

- **Rust** may implement `ReconciliationRepository` and perform authoritative reads/writes for reconciliation as part of host-grounded execution (typed paths only).
- **TypeScript** may read for operator/drift UI and **enqueue** work; it **must not** become a trusted executor or introduce fuzzy direct writes to these tables. Any server-side RPC for operator intent must still satisfy **§4** above.

**Shared meaning:** Rust and TS may differ in implementation, not in domain meaning ([§7.1](../minilab-persistence-domain-model.md)).

## Consequences

**Positive:** Inspectable mutations; tables keep distinct roles; aligns Phase 0.6, port stub, and DoD.

**Negative:** No “quick JSON patch from UI” without the owned API; a documented split adds documentation debt.

## Links

- [ReconciliationRepository.port.md](../../design/ports/ReconciliationRepository.port.md)
- [plan-production.md](../plan-production.md)
- GitHub [#9](https://github.com/danvoulez/minilab-cursor/issues/9)

## Changelog


| Date       | Change                                          |
| ---------- | ----------------------------------------------- |
| 2026-04-19 | Proposed (parallel agent draft, parent merged). |
| 2026-04-18 | Accepted — M0 first-pass disposition ([matrix](../milestones/M0-ADR-outcome-matrix.md)). |
