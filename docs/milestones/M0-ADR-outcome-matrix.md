# ADR outcome matrix — M0 review

**Disposition snapshot (first pass):** filled **2026-04-18** from a structured draft review; **Reviewer** column **ChatGPT (draft)** records the drafting source. **Confirm** each decision against the full ADR text. **Program M0 gate** remains **conditionally passed** until TypeScript contract convergence and M1 migration-backed `event_type` enforcement ([disposition result](#m0-disposition-result-after-review) below).

ADR headers in-repo are **Accepted** for 0001–0006 as of the same date; **0005** and **0006** include hardening edits applied in-repo before acceptance.

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
5. **ADR disposition** (this matrix + `Accepted` in each file) is necessary but **not sufficient** for full **M0 program gate pass**—see [disposition result](#m0-disposition-result-after-review) for TS/M1 blockers.

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
| 0005 | Typed event streams and ownership | Accepted | Accept with edits | ChatGPT (draft) | Stream split + ownership right; M0 vs M1 `event_type` authority made explicit in ADR (edits applied). |
| 0001 | `verify_results` semantics | Accepted | Accept | ChatGPT (draft) | Immutable attempts + separate summary surface. |
| 0002 | Reconciliation write ownership | Accepted | Accept | ChatGPT (draft) | Single-owner default until a written split exists. |
| 0006 | Pairing and credential ceremony | Accepted | Accept with edits | ChatGPT (draft) | Boundary + ceremony shape for M0; terminal/credential rules hardened in ADR (edits applied). |

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

**Decision:** **Accept with edits** (edits **applied** in ADR: **M0 scope vs M1 (`event_type` authority)**)

**Why:** Five streams, table alignment, append-only discipline, ownership defaults, correlation principle, no mega-bus—correct shape. **`event_type` vocabularies** deliberately M1; ADR now states explicitly that silence does **not** authorize improvising literals—M1 migrations + [M0-event-map.md](M0-event-map.md) own vocabulary authority.

**Required edits before acceptance:** Done in ADR body (M0 vs M1 section).

**Authority impact:**

- **Docs:** `Accepted`; event stubs point here.
- **Rust:** `minilab_core::events` = stream/table constants only, not fake variants ([rustdoc](../../rust/crates/minilab-core/src/events.rs)).
- **TypeScript:** stream names + ownership assumptions converge.
- **Migrations / schema:** M1 = `event_type` vocabularies + constraints.

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

**Decision:** **Accept with edits** (edits **applied** in ADR: **Terminal outcomes and credential issuance**)

**Why:** Rust/TS trust boundary, persistence roles, host scope, reclaim = new session + terminal old, challenge transcript invariant, no half-credentials, honest deferrals—real M0 artifact. Hardening: explicit **terminal outcomes** (success + credential, terminal failure without credential, reclaim invalidates prior active session) and **credential persistence rule** (no authoritative credential row before completion conditions).

**Required edits before acceptance:** Done in ADR body (terminal + persistence rule block).

**Authority impact:**

- **Docs:** `Accepted`; index + crosswalk.
- **Rust:** pairing runtime aligns to terminal / issuance rules.
- **TypeScript:** bootstrap UX reflects stages and closures.
- **Migrations / schema:** M1 lifecycle + event typing as needed.

**Follow-up owner:** Pairing / security owner.

---

## Completion rule

M0 **ADR disposition** is **complete** when:

- all six ADRs have a **Decision** in the summary table;
- **Accepted** ADRs are marked **Accepted** in each file and in [docs/adr/README.md](../adr/README.md);
- **Accept with edits** items have edits **in the ADR** (or tracked PR) before `Accepted`;
- **Rejected** ADRs have an **immediate replacement path** named;
- crosswalk and stubs **point at accepted authority**.

**Program M0 gate** may still require TS convergence and M1 enforcement—see below.

---

## M0 disposition result (after review)

**M0 disposition result:** **Conditionally passed** (ADR constitutional set accepted; integration gate not fully closed).

**Why:** Trust, command lifecycle, verify semantics, reconciliation ownership, stream boundaries, and pairing/credential **boundaries** are now narrow and **Accepted** in-repo. **0005** / **0006** hardening edits are applied.

**Remaining blockers to full M0 gate pass:**

- **TypeScript** convergence on accepted contract names and semantics.
- **M1:** migration-backed **`event_type`** vocabulary and schema enforcement.
- Optional: human **re-confirmation** that each ADR file still matches this matrix after any later edits.

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

**First-pass disposition summary (paste after review):**

```text
Completed first-pass M0 ADR disposition using docs/milestones/M0-ADR-outcome-matrix.md.

Draft decisions recorded there (summary):
- 0003 Accept
- 0004 Accept
- 0005 Accept with edits (M0 vs M1 event_type authority — edits in ADR)
- 0001 Accept
- 0002 Accept
- 0006 Accept with edits (terminal / credential issuance — edits in ADR)

M0 program gate: conditionally passed — ADRs 0001–0006 marked Accepted in repo; remaining work: TS convergence + M1 migration-backed event_type enforcement.

https://github.com/danvoulez/minilab-cursor/blob/main/docs/milestones/M0-ADR-outcome-matrix.md
```

---

## Changelog

| Date | Change |
| ---- | ------ |
| 2026-04-18 | Initial matrix template: rules, dependency order, summary table, per-ADR blocks, completion rule, GitHub appendix. |
| 2026-04-18 | Optional two-pass cadence (0003–0005, then 0001–0002–0006); appendix text aligned to gate notice. |
| 2026-04-18 | First-pass disposition fill-in; 0005/0006 hardening applied in ADRs; all six Accepted in files + index; conditional program gate called out. |
