# Public RPC edge

Thin `public` wrappers; runtime and agents call these instead of walking publication tables.

## Stubs in this folder

| File | Role (conceptual) |
| ---- | ----------------- |
| `rpc_get_current_manifest.md` | Runtime bootstrap / signed fetch edge |
| `rpc_claim_agent_commands.md` | Durable command claim–lease edge |

Exact SQL function names live in the main repo migrations. Later, prefer **contract-shaped** names in docs (e.g. “signed manifest fetch”, “command claim”) even if filenames stay RPC-specific for grep-ability.
