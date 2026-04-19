# SPEC

Workspace for Minilab **canonical design artifacts** and **named placeholders** that mirror the persistence/domain model.

- [Persistence and domain model](docs/minilab-persistence-domain-model.md)
- [Plan to production](docs/plan-production.md)
- [Production milestones M0–M8](docs/milestones-production.md)
- [M0 execution checklist](docs/milestones/M0-checklist.md)

## Generate layout

Idempotent (skips existing per-stub files):

```bash
./scripts/init-workspace.sh
```

Refresh **index** READMEs only (design/, `docs/invariants/`, `references/schemas/*/README.md`) from the script without deleting the whole tree:

```bash
SYNC_SCAFFOLD_INDEX=1 ./scripts/init-workspace.sh
```

To pick up new text for a **single** stub (e.g. `design/ports/ReconciliationRepository.port.md`), delete that file and re-run. To regenerate many stubs, remove the relevant folders first, then run the script.

## Top-level map

| Path | Purpose |
| ---- | ------- |
| `docs/` | Domain model, domain one-pagers, per-invariant files |
| `design/aggregates/` | One file per aggregate root |
| `design/ports/` | One file per repository port |
| `contracts/` | Manifest, commands, events, grammar, pairing, read-model contract stubs |
| `references/schemas/minilab/` | Table stubs: `authoritative/`, `publication_truth/`, `evidence/`, `read_models/` |
| `references/schemas/public/` | Thin RPC edge stubs |
| `references/migrations/` | Link real Supabase migrations here when wired |
| `rust/` | Workspace + `minilab-agent`, `minilab-core` placeholders (`cargo check` clean) |
| `ts/packages/` | `operator-ui`, `grammar`, `publisher`, `read_models`, `supabase_operator` |
| `scripts/` | `init-workspace.sh` |
