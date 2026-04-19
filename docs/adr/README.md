# Architecture Decision Records (ADRs)

Normative decisions that lock semantics for M0+ contract freeze. **Accepted** ADRs are the default authority for their topic ([review discipline](#authority-order-review-discipline)).

**M0 disposition:** [ADR outcome matrix (0001–0006)](../milestones/M0-ADR-outcome-matrix.md) — first-pass fill-in 2026-04-18; **program gate** may still be conditionally passed until TS + M1 enforcement catch up (see matrix disposition result).

| ADR | Topic | Status |
| --- | ----- | ------ |
| [0001](0001-verify-results-semantics.md) | `verify_results`: evidence vs summary | Accepted |
| [0002](0002-reconciliation-write-ownership.md) | Reconciliation write ownership | Accepted |
| [0003](0003-manifest-signed-bytes-vs-envelope.md) | Signed manifest bytes vs envelope | Accepted |
| [0004](0004-agent-command-state-machine.md) | `AgentCommand` lifecycle + lease + transitions | Accepted |
| [0005](0005-typed-evidence-event-streams.md) | Typed evidence streams (five families) | Accepted |
| [0006](0006-pairing-and-credential-ceremony.md) | Pairing + host-scoped credential ceremony | Accepted |

### Authority order (review discipline)

1. **Accepted ADR** wins over older informal prose in stubs or secondary docs—update the prose, not the accepted decision.
2. **`Proposed` ADR + merged code:** treat as **debt**—either promote the ADR to **Accepted** with disposition + edits (see matrix) or revert/adjust code that assumes it.
3. **`minilab-core`:** only **settled** shared types and pure contract helpers (see [M0-checklist.md](../milestones/M0-checklist.md)); they must match the ADR + crosswalk or the PR is not contract-clean.

**Process:** [M0-ADR-outcome-matrix.md](../milestones/M0-ADR-outcome-matrix.md) · [definition-of-done-and-quality-control.md](../definition-of-done-and-quality-control.md) · [M0-checklist.md](../milestones/M0-checklist.md).
