# Definition of Done (DoD) and quality control

Canonical bar for **when work is actually finished** and **how to review it** so Minilab does not drift into “architecture fanfic” or mushy boundaries.

**Related:** [plan-production.md](plan-production.md) · [milestones-production.md](milestones-production.md) · [minilab-persistence-domain-model.md](minilab-persistence-domain-model.md) · [invariants](invariants/README.md)

---

## 1. Definition of Done — by scope

### 1.1 Milestone (always)

A milestone is **done** only when:

- Its **gate** in [milestones-production.md](milestones-production.md) passes **on real infrastructure** (staging or production-shaped environment), not only on a developer laptop with mocks.
- **Owners** have signed off on the gate issue(s) (or equivalent documented approval).
- **No important rule exists only in a stub** — see [plan-production.md § SPEC exit criterion](plan-production.md#spec-workspace-exit-criterion).

**Not sufficient:** “code merged,” “UI demo works,” “tests pass locally” without the gate.

---

### 1.2 Pull request / deliverable (default DoD)

A PR (or shippable chunk) is **done** when all of the following hold:

| Criterion | Check |
| --------- | ----- |
| **Contract alignment** | Rust names, TS names, and (if touched) DB/migration names match for the same concept; or a single crosswalk row was updated. No duplicate conflicting definitions. |
| **Executable schema** | If persistence changed, **migrations** (or applied SQL) are updated; `references/schemas/*.md` stubs are updated **or** explicitly link to the migration file path. **Migrations are truth**, not markdown stubs. |
| **Execution boundary** | No new path executes host work from **raw** payload or freeform text without **typed, validated** operations at the Rust executor edge. |
| **Trust boundaries** | TypeScript **does not** gain new “trusted executor” responsibilities (no secret control plane). Publishing, enqueue, and inspection only. |
| **Evidence** | Command lifecycle changes include **inspectable** updates: command rows and/or **append-only** event (and **lease**) streams per domain model. |
| **Realtime** | No new logic assumes Realtime **delivery**; recovery remains **durable reread**. |
| **Docs** | [minilab-persistence-domain-model.md](minilab-persistence-domain-model.md) or linked canonical doc updated if a **contract** or **invariant** changed. |
| **Tests** | Automated tests or **documented manual gate steps** for the change; critical paths (verify manifest, claim/lease, idempotency) must not regress silently. |

---

### 1.3 Production (program-level)

**Production** is defined only as in [plan-production.md — Definition of production](plan-production.md#definition-of-production). Until that full list holds against **real** Supabase, migrations, Rust agent, and operator surface, the program remains **pre-production** regardless of milestone counts.

---

## 2. Quality control (how we review)

### 2.1 Contract and semantics

- [ ] **Single meaning:** Same enum/state/event names and semantics in Rust, TS, and docs (use M0 crosswalk or equivalent).
- [ ] **Signed manifest:** Canonical bytes, hash, and signature rules are **one** documented rule; verify **fails closed**.
- [ ] **`verify_results`:** Table role is explicit (evidence vs summary); no mixed semantics without a written rule ([§3B](minilab-persistence-domain-model.md)).
- [ ] **Reconciliation:** Desired/applied writes go through **one** port or a **documented** split — not ad hoc updates.

### 2.2 Persistence and RLS

- [ ] **Migrations** are reviewed as the **source of truth** for schema; stubs in `references/schemas/` are secondary.
- [ ] **Constraints:** Idempotency, host/thread/command agreement, FKs where required by the domain model.
- [ ] **RLS:** New paths do not widen access without explicit decision; host-scoped credentials are the long-term target.

### 2.3 Runtime and agent

- [ ] **Claim/lease:** Leases expire and recover correctly; **lease events** reflect authority, not only generic progress text.
- [ ] **Idempotency:** Retries and duplicate client ids do not create duplicate side effects.
- [ ] **lab256:** Changes do not introduce **required** dependency on the laptop for core coordination or execution.

### 2.4 Operator surface (TypeScript)

- [ ] **Truth from rows:** UI does not imply state that is not in persisted data (+ defined projections).
- [ ] **Places:** Remain **projection-only**; no new backend “place” sovereignty.

### 2.5 Observability and continuity

- [ ] **Correlation:** Logs use command id / host id where applicable; logs **do not** replace append-only evidence.
- [ ] **Restore story:** For data-touching work, consider impact on **commands, events, lease history, manifest snapshots** (operational memory).

---

## 3. Blockers — merge / milestone close

**Do not merge or close a milestone** if:

1. A **gate** in [milestones-production.md](milestones-production.md) is unmet.  
2. **Contract crosswalk** is broken (Rust/TS/DB/docs disagree) for any type touched.  
3. A **new execution path** bypasses typed operations.  
4. **Realtime** is assumed for correctness.  
5. **Publication tables** are read at runtime for “current world truth” instead of a **verified manifest snapshot**.  
6. **Important rules** exist only in SPEC stubs with no link to code or migrations.

---

## 4. Roles (optional RACI-style)

| Activity | Primary | Must consult |
| -------- | ------- | ------------ |
| Contract / enum change | Rust + TS owners | Schema/docs |
| Migration / RLS | Schema owner | Auth, agent |
| Manifest / publish | Publisher owner | Signing, agent verify |
| Gate sign-off | Milestone owner | All listed owners for that milestone |

Fill names in [milestones-production.md](milestones-production.md) owner slots when capacity is known.

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-19 | Initial DoD + QC: milestone/PR/production scopes, review checklists, blockers. |
