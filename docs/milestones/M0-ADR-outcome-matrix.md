# ADR outcome matrix — M0 review

**Disposition snapshot:** **2026-04-18** — all six ADRs **Accepted**; **M0 semantics gate: Passed** ([disposition result](#m0-disposition-result-after-review)). **Reviewer** column **ChatGPT (draft)** records the drafting source for the original pass.

**Post-M0 work** (not blocking M0 closure): TypeScript package alignment to Accepted ADRs; **M1** migrations with **`event_type`** enforcement and schema materialization.

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
5. After **Passed**, this matrix is the historical record; **new** normative changes require a new ADR or ADR amendment—not silent stub edits.

---

## Practical review cadence (optional)

Same **dependency order** as below; split across two sessions to reduce cognitive load:

| Pass | ADRs | Focus |
| ---- | ---- | ----- |
| **1** | 0003 → 0004 → 0005 | Structural core: signed manifest boundary, command lifecycle, evidence streams. |
| **2** | 0001 → 0002 → 0006 | Verify semantics, reconciliation ownership, pairing/credential ceremony. |

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

| ADR | Title | Status (in file) | Decision | Reviewer | Notes |
| --- | ----- | ---------------- | -------- | -------- | ----- |
| 0003 | Manifest signed bytes vs envelope | Accepted | Accept | ChatGPT (draft) | Core trust boundary explicit and sharp enough. |
| 0004 | Command statuses and transitions | Accepted | Accept | ChatGPT (draft) | Lifecycle narrow, exhaustive for M0; avoids semantic backsliding. |
| 0005 | Typed event streams and ownership | Accepted | Accept | ChatGPT (draft) | Stream split + ownership; M0 vs M1 `event_type` authority explicit in ADR. |
| 0001 | `verify_results` semantics | Accepted | Accept | ChatGPT (draft) | Immutable attempts + separate summary surface. |
| 0002 | Reconciliation write ownership | Accepted | Accept | ChatGPT (draft) | Single-owner default until a written split exists. |
| 0006 | Pairing and credential ceremony | Accepted | Accept | ChatGPT (draft) | Boundary + ceremony shape; terminal/credential rules in ADR. |

---

## Per-ADR review blocks

---

### ADR 0003 — Manifest signed bytes vs envelope

**File:** [docs/adr/0003-manifest-signed-bytes-vs-envelope.md](../adr/0003-manifest-signed-bytes-vs-envelope.md)

**Decision:** **Accept**

**Why:** Trust-boundary ADR for M0: signing over **canonical inner JSON bytes**; **fixed** SHA256 string format for `manifest_hash`; **one** canonicalizer; verification **fail-closed**; no ambiguous hash-vs-bytes reading.

**Required edits before acceptance:** None (confirm file text matches terminology throughout).

**Authority impact:**

- **Docs:** `Accepted` in [README](../adr/README.md); domain / crosswalk point here.
- **Rust:** align verify helpers to this ADR.
- **TypeScript:** publish-side preflight + signing mirror; same terms.
- **Migrations / schema:** none directly from this ADR.

**Follow-up owner:** Architecture / runtime boundary owner.

---

### ADR 0004 — Command statuses and transitions

**File:** [docs/adr/0004-agent-command-state-machine.md](../adr/0004-agent-command-state-machine.md)

**Decision:** **Accept**

**Why:** No `pending` → `running` / `pending` → `completed`; terminals explicit; lease expiry returns to claimable work; retry defaults to **new** command row; no `failed` → `pending` resurrection; authority order explicit. [`command_transition_allowed`](../../rust/crates/minilab-core/src/command.rs) as pure matrix expression is a good concrete check.

**Required edits before acceptance:** None (rendered markdown + code comments consistent).

**Authority impact:**

- **Docs:** `Accepted`; crosswalk treats command lifecycle as frozen.
- **Rust:** `minilab-core` / `minilab-agent` references non-provisional.
- **TypeScript:** command state names + operator views converge to matrix.
- **Migrations / schema:** M1 constraints reflect statuses / events.

**Follow-up owner:** Durable coordination / agent runtime owner.

---

### ADR 0005 — Typed event streams and ownership

**File:** [docs/adr/0005-typed-evidence-event-streams.md](../adr/0005-typed-evidence-event-streams.md)

**Decision:** **Accept**

**Why:** Five streams, table alignment, append-only discipline, ownership defaults, correlation principle, no mega-bus—correct shape. **`event_type` vocabularies** are **M1**; ADR states that silence does **not** authorize improvising literals—M1 migrations + [M0-event-map.md](M0-event-map.md) own vocabulary authority (**M0 scope vs M1** section in ADR).

**Authority impact:**

- **Docs:** `Accepted`; event stubs point here.
- **Rust:** `minilab_core::events` = stream/table constants only, not fake variants ([rustdoc](../../rust/crates/minilab-core/src/events.rs)).
- **TypeScript (post-M0):** align stream names + ownership assumptions to ADR.
- **Migrations / schema (M1):** `event_type` vocabularies + constraints.

**Follow-up owner:** Evidence / event-contract owner.

---

### ADR 0001 — `verify_results` semantics

**File:** [docs/adr/0001-verify-results-semantics.md](../adr/0001-verify-results-semantics.md)

**Decision:** **Accept**

**Why:** Correct split for a high-risk table: **immutable** `verify_results` attempts vs **separate** authoritative summary surface; no double-duty mush.

**Required edits before acceptance:** None (immutable attempts vs latest-summary distinction clear).

**Authority impact:**

- **Docs:** `Accepted` in index + domain references.
- **Rust:** writers/readers separate attempt evidence from summary reads.
- **TypeScript:** operator UI must not treat attempts as summary rows.
- **Migrations / schema:** M1 keeps split explicit if summary surface is materialized.

**Follow-up owner:** Verification / host-install truth owner.

---

### ADR 0002 — Reconciliation write ownership

**File:** [docs/adr/0002-reconciliation-write-ownership.md](../adr/0002-reconciliation-write-ownership.md)

**Decision:** **Accept**

**Why:** Default **single** `ReconciliationRepository` (or equivalent single owner); split only when **fully specified** in writing—right constitutional posture for M0.

**Required edits before acceptance:** None (MUST / ownership language renders cleanly).

**Authority impact:**

- **Docs:** `Accepted`; default reconciliation ownership everywhere.
- **Rust:** write paths name this boundary.
- **TypeScript:** no casual writes to desired/applied outside the port.
- **Migrations / schema:** none immediately; M1 may add enforcement helpers.

**Follow-up owner:** Reconciliation / runtime owner.

---

### ADR 0006 — Pairing and credential ceremony

**File:** [docs/adr/0006-pairing-and-credential-ceremony.md](../adr/0006-pairing-and-credential-ceremony.md)

**Decision:** **Accept**

**Why:** Rust/TS trust boundary, persistence roles, host scope, reclaim = new session + terminal old, challenge transcript invariant, no half-credentials, honest deferrals. **Terminal outcomes and credential issuance** block in ADR makes failure/success/reclaim and “no credential before completion” unmistakable.

**Authority impact:**

- **Docs:** `Accepted`; index + crosswalk.
- **Rust:** pairing runtime aligns to terminal / issuance rules.
- **TypeScript (post-M0):** bootstrap UX reflects stages and closures.
- **Migrations / schema (M1):** lifecycle + event typing as needed.

**Follow-up owner:** Pairing / security owner.

---

## Completion rule

M0 **ADR disposition** was **complete** when:

- all six ADRs had a **Decision** in the summary table;
- **Accepted** ADRs were marked **Accepted** in each file and in [docs/adr/README.md](../adr/README.md);
- crosswalk and stubs **point at accepted authority**.

For **future** milestones: **Accept with edits** requires edits in the ADR before `Accepted`; **Reject** requires an immediate replacement path.

---

## M0 disposition result (after review)

**M0 disposition result:** **Passed**

**Why:** ADRs **0001–0006** are **Accepted** and are the canonical semantics for signing, `verify_results`, reconciliation ownership, command lifecycle, typed evidence streams, and pairing/credential ceremony. **M0** closes the **specification / meaning** layer; implementation and language-level convergence follow in **post-M0** work.

**Post-M0 (tracked under M1+ and TS workstreams, not M0 blockers):**

- **TypeScript:** contract/package alignment to Accepted ADRs and [M0 crosswalk](M0-crosswalk.md).
- **M1 migrations:** **`event_type`** vocabulary, `CHECK`/enum enforcement, pairing/credential lifecycle constraints, full schema materialization.

---

## Appendix — short text for a GitHub issue comment

**Kickoff (process):**

```text
M0 ADR review runs from docs/milestones/M0-ADR-outcome-matrix.md as the single source of truth.

Review order (dependency-first): 0003 → 0004 → 0005 → 0001 → 0002 → 0006.
(Optional two-pass: 0003–0005 first, then 0001–0002–0006 — see matrix.)

Only three outcomes: Accept | Accept with edits | Reject.

Full template: https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-ADR-outcome-matrix.md
```

**Disposition summary (M0 closed):**

```text
M0 ADR disposition complete — docs/milestones/M0-ADR-outcome-matrix.md

All Accept: 0003, 0004, 0005, 0001, 0002, 0006 (ADRs Accepted in repo).

M0 semantics gate: Passed. Post-M0: TS contract alignment; M1 event_type + schema enforcement.

https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-ADR-outcome-matrix.md
```

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-18 | Initial matrix template: rules, dependency order, summary table, per-ADR blocks, completion rule, GitHub appendix. |
| 2026-04-18 | Optional two-pass cadence (0003–0005, then 0001–0002–0006); appendix text aligned to gate notice. |
| 2026-04-18 | First-pass disposition fill-in; 0005/0006 hardening applied in ADRs; all six Accepted in files + index; conditional program gate called out. |
| 2026-04-18 | M0 **Passed**: matrix + disposition; 0005/0006 decisions **Accept**; TS/M1 called post-M0. |
