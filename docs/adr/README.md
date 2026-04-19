# Architecture Decision Records (ADRs)

Normative decisions that lock semantics for M0+ contract freeze. **Status `Proposed`** means ready for review; flip to **Accepted** after gate sign-off.

| ADR | Topic | Status |
| --- | ----- | ------ |
| [0001](0001-verify-results-semantics.md) | `verify_results`: evidence vs summary | Proposed |
| [0002](0002-reconciliation-write-ownership.md) | Reconciliation write ownership | Proposed |
| [0003](0003-manifest-signed-bytes-vs-envelope.md) | Signed manifest bytes vs envelope | Proposed |
| [0004](0004-agent-command-state-machine.md) | `AgentCommand` lifecycle + lease + transitions | Proposed |
| [0005](0005-typed-evidence-event-streams.md) | Typed evidence streams (five families) | Proposed |
| [0006](0006-pairing-and-credential-ceremony.md) | Pairing + host-scoped credential ceremony | Proposed |

### Authority order (review discipline)

1. **Accepted ADR** wins over older informal prose in stubs or secondary docs—update the prose, not the accepted decision.
2. **`Proposed` ADR + merged code:** treat as **debt**—either promote the ADR to **Accepted** with gate sign-off or revert/adjust code that assumes it.
3. **`minilab-core`:** only **settled** shared types and pure contract helpers (see [M0-checklist.md](../milestones/M0-checklist.md)); they must match the ADR + crosswalk or the PR is not contract-clean.

**Process:** See [definition-of-done-and-quality-control.md](../definition-of-done-and-quality-control.md) and [M0-checklist.md](../milestones/M0-checklist.md).
