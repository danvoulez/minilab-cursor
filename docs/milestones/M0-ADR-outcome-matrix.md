# ADR outcome matrix — M0 review

**Purpose:** disposition ADRs **0001–0006** with only **three** allowed outcomes:

- **Accept**
- **Accept with edits**
- **Reject**

No softer state. No “looks good for now.” If an ADR carries semantic weight for code, docs, or schema, it needs an explicit decision.

**Related:** [ADR index](../adr/README.md) · [M0 checklist](M0-checklist.md) · [M0 crosswalk](M0-crosswalk.md) · [DoD — authority / gates](../definition-of-done-and-quality-control.md)

---

## Review rules

1. Review in **dependency order** (below), not numeric file order.
2. If an ADR is **Reject**, name the **replacement or rewrite path immediately** (issue, ADR draft owner, or branch)—no silent vacuum.
3. If **Accept with edits**, list **only** edits **required for acceptance**; apply them before stacking new ADRs or deep code on that topic.
4. Once **Accepted**, linked docs and code **converge** to that ADR; they do not compete with it ([authority order](../adr/README.md)).
5. **M0 is not gate-passed** until all six ADRs have a human disposition and accepted ADRs are marked **Accepted** in `docs/adr/README.md`.

---

## Suggested review order

| Order | ADR | Title |
| ----- | --- | ----- |
| 1 | [0003](../adr/0003-manifest-signed-bytes-vs-envelope.md) | Manifest signed bytes vs envelope |
| 2 | [0004](../adr/0004-agent-command-state-machine.md) | Command statuses and transitions |
| 3 | [0005](../adr/0005-typed-evidence-event-streams.md) | Typed event streams and ownership |
| 4 | [0001](../adr/0001-verify-results-semantics.md) | `verify_results` semantics |
| 5 | [0002](../adr/0002-reconciliation-write-ownership.md) | Reconciliation write ownership |
| 6 | [0006](../adr/0006-pairing-and-credential-ceremony.md) | Pairing and credential ceremony |

**Rationale:** trust boundary → work boundary → evidence boundary → verification → reconciliation → host entry ceremony.

---

## Summary table

Fill as you go. `Status` should track the **file** header; `Decision` is the outcome of this pass.

| ADR | Title | Status (in file) | Decision | Reviewer | Notes |
| --- | ----- | ------------------ | -------- | -------- | ----- |
| 0003 | Manifest signed bytes vs envelope | Proposed | | | |
| 0004 | Command statuses and transitions | Proposed | | | |
| 0005 | Typed event streams and ownership | Proposed | | | |
| 0001 | `verify_results` semantics | Proposed | | | |
| 0002 | Reconciliation write ownership | Proposed | | | |
| 0006 | Pairing and credential ceremony | Proposed | | | |

---

## Per-ADR review blocks

Use one block per ADR. **Decision** must be exactly: Accept / Accept with edits / Reject.

---

### ADR 0003 — Manifest signed bytes vs envelope

**File:** [docs/adr/0003-manifest-signed-bytes-vs-envelope.md](../adr/0003-manifest-signed-bytes-vs-envelope.md)

**Decision:** Accept / Accept with edits / Reject

**Why:**

**Required edits before acceptance:** (optional; only if “Accept with edits”)

**Authority impact:**

- Docs to update:
- Rust to update:
- TypeScript to update:
- Migrations / schema to update:

**Follow-up owner:**

---

### ADR 0004 — Command statuses and transitions

**File:** [docs/adr/0004-agent-command-state-machine.md](../adr/0004-agent-command-state-machine.md)

**Decision:** Accept / Accept with edits / Reject

**Why:**

**Required edits before acceptance:**

**Authority impact:**

- Docs to update:
- Rust to update:
- TypeScript to update:
- Migrations / schema to update:

**Follow-up owner:**

---

### ADR 0005 — Typed event streams and ownership

**File:** [docs/adr/0005-typed-evidence-event-streams.md](../adr/0005-typed-evidence-event-streams.md)

**Decision:** Accept / Accept with edits / Reject

**Why:**

**Required edits before acceptance:**

**Authority impact:**

- Docs to update:
- Rust to update:
- TypeScript to update:
- Migrations / schema to update:

**Follow-up owner:**

---

### ADR 0001 — `verify_results` semantics

**File:** [docs/adr/0001-verify-results-semantics.md](../adr/0001-verify-results-semantics.md)

**Decision:** Accept / Accept with edits / Reject

**Why:**

**Required edits before acceptance:**

**Authority impact:**

- Docs to update:
- Rust to update:
- TypeScript to update:
- Migrations / schema to update:

**Follow-up owner:**

---

### ADR 0002 — Reconciliation write ownership

**File:** [docs/adr/0002-reconciliation-write-ownership.md](../adr/0002-reconciliation-write-ownership.md)

**Decision:** Accept / Accept with edits / Reject

**Why:**

**Required edits before acceptance:**

**Authority impact:**

- Docs to update:
- Rust to update:
- TypeScript to update:
- Migrations / schema to update:

**Follow-up owner:**

---

### ADR 0006 — Pairing and credential ceremony

**File:** [docs/adr/0006-pairing-and-credential-ceremony.md](../adr/0006-pairing-and-credential-ceremony.md)

**Decision:** Accept / Accept with edits / Reject

**Why:** (review for ownership boundaries, state transitions, failure closure, reclaim, host scope—not wire fiction)

**Required edits before acceptance:**

**Authority impact:**

- Docs to update:
- Rust to update:
- TypeScript to update:
- Migrations / schema to update:

**Follow-up owner:**

---

## Completion rule

M0 ADR review is **complete** only when:

- all six ADRs have a human **Decision** in the summary table;
- **Accepted** ADRs are marked **Accepted** in each file and in [docs/adr/README.md](../adr/README.md);
- **Accept with edits** items have **tracked edits and owners** (issues or PRs linked);
- **Rejected** ADRs have an **immediate replacement path** named;
- crosswalk and stubs **point at accepted authority**, not limbo.

---

## M0 disposition result (after review)

**M0 disposition result:** Not passed / Conditionally passed / Passed

**Why:**

**Remaining blockers to M0 gate pass:**

---

## Appendix — short text for a GitHub issue comment

Paste below into a tracking issue (e.g. gate / umbrella). Expand in [M0-ADR-outcome-matrix.md](M0-ADR-outcome-matrix.md) in-repo.

```text
ADR outcome matrix — M0 (0001–0006)

Allowed outcomes only: Accept | Accept with edits | Reject

Review order (dependency): 0003 → 0004 → 0005 → 0001 → 0002 → 0006

Full template + per-ADR blocks:
https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-ADR-outcome-matrix.md

M0 not gate-passed until all six have a disposition; Accept with edits = edits tracked before more semantics; Reject = replacement path named same day.
```

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-18 | Initial matrix template: rules, dependency order, summary table, per-ADR blocks, completion rule, GitHub appendix. |
