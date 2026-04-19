# Shared contracts

Named placeholders aligned to [minilab-persistence-domain-model.md](../docs/minilab-persistence-domain-model.md) §7–8 and §10.

| Directory | Contents |
| --------- | -------- |
| `manifest/` | `ManifestSnapshot`, signing envelope rule |
| `commands/` | `AgentCommand`, state machine notes |
| `events/` | One file per typed evidence stream name |
| `grammar/` | `Operation`, `IntentEnvelope` |
| `pairing/` | Pairing / auth envelope |
| `read_models/` | TS read-model shapes |

Replace stubs with generated or hand-maintained types when the main repo is linked.
