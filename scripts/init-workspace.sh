#!/usr/bin/env bash
# Idempotent full workspace layout predicted by docs/minilab-persistence-domain-model.md
# and publication tables from the Minilab README. Run: ./scripts/init-workspace.sh
#
# Maintenance policy
# ------------------
# - write_if_missing: safe bootstrap. After first run, edits to stubs are preserved; changing
#   scaffold *text* in this script does not propagate unless you delete the target files.
# - Canonical prose lives in docs/minilab-persistence-domain-model.md; stubs should link there.
# - SYNC_SCAFFOLD_INDEX=1: overwrites *index* READMEs (design/, docs/invariants/, references/schemas/*)
#   so boilerplate headers stay in sync. Does not touch per-table or per-port files.
# - Next evolution: replace placeholder bodies with links to real generated/shared contracts
#   (Rust/TS); retire duplicate prose when code becomes canonical.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Relative links from generated files to the canonical note (path depth differs per folder).
LINK_SCHEMA_MINILAB='[minilab-persistence-domain-model.md](../../../../docs/minilab-persistence-domain-model.md)'
LINK_SCHEMA_PUBLIC='[minilab-persistence-domain-model.md](../../../docs/minilab-persistence-domain-model.md)'
LINK_DESIGN='[minilab-persistence-domain-model.md](../../docs/minilab-persistence-domain-model.md)'
LINK_CONTRACTS='[minilab-persistence-domain-model.md](../docs/minilab-persistence-domain-model.md)'
LINK_DOCS_SUB='[minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md)'
LINK_TS_PKG='[minilab-persistence-domain-model.md](../../../docs/minilab-persistence-domain-model.md)'

mkdir_p() { mkdir -p "$1"; }

write_if_missing() {
  local path="$1"
  shift
  mkdir_p "$(dirname "$path")"
  if [[ ! -f "$path" ]]; then
    printf '%b' "$*" >"$path"
    echo "Created $path"
  else
    echo "Skip existing $path"
  fi
}

# Index / boilerplate READMEs only: refresh when SYNC_SCAFFOLD_INDEX=1.
write_index() {
  local path="$1"
  shift
  mkdir_p "$(dirname "$path")"
  if [[ "${SYNC_SCAFFOLD_INDEX:-}" == "1" ]] || [[ ! -f "$path" ]]; then
    printf '%b' "$*" >"$path"
    echo "Wrote $path"
  else
    echo "Skip index $path (set SYNC_SCAFFOLD_INDEX=1 to refresh boilerplate indexes)"
  fi
}

table_authoritative() {
  write_if_missing "references/schemas/minilab/authoritative/${1}.table.md" \
"# Table: \`${1}\`

- **Aggregate root:** ${2}
- **Role:** authoritative state
- **Notes:** ${3}

See ${LINK_SCHEMA_MINILAB} §3A.
"
}

table_evidence() {
  write_if_missing "references/schemas/minilab/evidence/${1}.table.md" \
"# Table: \`${1}\`

- **Event type:** \`${2}\`
- **Role:** append-only evidence
- **Notes:** ${3}

See ${LINK_SCHEMA_MINILAB} §3B.
"
}

read_model() {
  local slug="$1"
  shift
  write_if_missing "references/schemas/minilab/read_models/${slug}.read_model.md" \
"# Read model: ${slug}

- **Role:** read model / presentation
- **Rebuild from:** $*

See ${LINK_SCHEMA_MINILAB} §3C.
"
}

publication_table() {
  write_if_missing "references/schemas/minilab/publication_truth/${1}.table.md" \
"# Table: \`${1}\` (publication truth)

- **Domain:** publication truth (normalized authoring)
- **Role:** authoritative state (release-scoped publication)
- **Notes:** ${2}

Runtime clients do not traverse these rows for execution truth; see ${LINK_SCHEMA_MINILAB} §3 and §0.2.
"
}

port_stub() {
  write_if_missing "design/ports/${1}.port.md" \
"# Port: \`${1}\`

Repository boundary (contract-shaped, not storage-shaped).

See ${LINK_DESIGN} §6.
"
}

aggregate_stub() {
  write_if_missing "design/aggregates/${1}.aggregate.md" \
"# Aggregate root: ${1}

See ${LINK_DESIGN} §4.
"
}

invariant_stub() {
  local n="$1"
  shift
  write_if_missing "docs/invariants/invariant-$(printf '%02d' "$n").md" \
"# Invariant ${n}

$*

See ${LINK_DOCS_SUB} §5.
"
}

# =============================================================================
#  Root directories
# =============================================================================
for d in \
  docs/invariants \
  docs/domains \
  contracts/manifest \
  contracts/commands \
  contracts/events \
  contracts/grammar \
  contracts/pairing \
  contracts/read_models \
  references/schemas/minilab/authoritative \
  references/schemas/minilab/evidence \
  references/schemas/minilab/read_models \
  references/schemas/minilab/publication_truth \
  references/schemas/public \
  references/migrations \
  design/ports \
  design/aggregates \
  rust/crates/minilab-agent/src \
  rust/crates/minilab-core/src \
  ts/packages/operator-ui \
  ts/packages/grammar \
  ts/packages/publisher \
  ts/packages/read_models \
  ts/packages/supabase_operator; do
  mkdir_p "$d"
done

# =============================================================================
#  Schema stubs — authoritative (§3A)
# =============================================================================
table_authoritative "releases" "Release" "Authoring root for publication truth."
table_authoritative "manifest_snapshots" "ManifestSnapshot" "Runtime contract root; verified snapshot boundary."
table_authoritative "hosts" "Host" "Host identity and operational summary."
table_authoritative "installations" "Installation" "One lifecycle for one payload on one host for one release context."
table_authoritative "agent_threads" "AgentThread" "Durable human/agent coordination root."
table_authoritative "agent_messages" "AgentThread" "Append-only child rows; conversational state, not execution evidence."
table_authoritative "agent_commands" "AgentCommand" "Durable work; lifecycle and lease fields."
table_authoritative "pairing_sessions" "PairingSession" "Pairing ceremony state."
table_authoritative "agent_credentials" "AgentCredential" "Credential lifecycle root."
table_authoritative "host_desired_state" "HostDesiredState" "Reconciliation: intended target."
table_authoritative "host_applied_state" "HostAppliedState" "Reconciliation: applied summary grounded in evidence."

# =============================================================================
#  Schema stubs — publication truth (normalized authoring; not runtime traversal)
# =============================================================================
publication_table "roles" "Release-scoped role definitions for manifest assembly."
publication_table "assignment_rules" "Match rules that assign roles to hosts."
publication_table "payloads" "Payload artifacts referenced by the release."
publication_table "payload_services" "Launchd/service rows attached to payloads."
publication_table "discovery_config" "Discovery block source for manifest.discovery."
publication_table "verify_steps" "Verify step definitions for manifest.verify_steps."
publication_table "secrets_config" "Secrets provider metadata for manifest.secrets."

# =============================================================================
#  Schema stubs — append-only evidence (§3B)
# =============================================================================
table_evidence "installation_events" "InstallationEvent" "Install activity narrative."
table_evidence "verify_results" "VerifyResultEvent (or per-attempt record)" "One row per immutable verify attempt → evidence. A mutable latest-summary column or upserting current state here is authoritative state—use a separate table/view or a written rule. See domain doc §3B callout."
table_evidence "agent_command_events" "AgentCommandEvent" "Command execution narrative."
table_evidence "agent_command_lease_events" "AgentCommandLeaseEvent" "Claim / renew / release evidence."
table_evidence "pairing_events" "PairingEvent" "Pairing ceremony history."
table_evidence "agent_credential_events" "AgentCredentialEvent" "Credential issuance / revoke / rotate history."

# =============================================================================
#  Schema stubs — read models (§3C)
# =============================================================================
read_model "places" "hosts, installations, desired/applied state, command status, verification summaries"
read_model "host_summaries" "hosts, installations, verify_results, recent command state"
read_model "thread_inspect_views" "agent_threads, agent_messages, agent_commands, events"
read_model "command_inspect_views" "agent_commands, agent_command_events, agent_command_lease_events"

# =============================================================================
#  Public RPC edge (thin) — contract roles: runtime bootstrap, command claim–lease
# =============================================================================
write_if_missing "references/schemas/public/rpc_get_current_manifest.md" \
"# \`public.rpc_get_current_manifest(channel)\`

Thin edge: returns current signed manifest envelope for a channel.

See ${LINK_SCHEMA_PUBLIC} §0.2 and project README (runtime bootstrap).
"

write_if_missing "references/schemas/public/rpc_claim_agent_commands.md" \
"# \`public.rpc_claim_agent_commands\` (or equivalent)

Thin edge: durable command claim/lease; exact name lives in main repo migrations.

See ${LINK_SCHEMA_PUBLIC} §0.3 and project README.
"

# =============================================================================
#  Design — repository ports (§6)
# =============================================================================
for p in ReleaseRepository ManifestRepository HostRepository InstallationRepository ThreadRepository CommandRepository PairingRepository CredentialRepository; do
  port_stub "$p"
done

write_if_missing "design/ports/ReconciliationRepository.port.md" \
"# Port: \`ReconciliationRepository\`

**Ownership:** single writer for \`host_desired_state\` and \`host_applied_state\` (or an explicitly documented split—never fuzzy multi-caller updates).

**Forbidden:** smuggling reconciliation writes through random repositories without going through this port or the documented alternative.

See ${LINK_DESIGN} §6.
"

# =============================================================================
#  Design — aggregate roots (§4)
# =============================================================================
for a in Release ManifestSnapshot Host Installation AgentCommand AgentThread PairingSession AgentCredential HostDesiredState HostAppliedState; do
  aggregate_stub "$a"
done

# =============================================================================
#  Docs — invariants (§5)
# =============================================================================
invariant_stub 1 "Runtime clients consume verified manifest snapshots, not publication graph walks."
invariant_stub 2 "Canonicalization, hash, and signature verification fail closed."
invariant_stub 3 "No partial runtime truth is valid."
invariant_stub 4 "Host identity is cryptographic first; hostname/labels are metadata."
invariant_stub 5 "Authority decisions do not rely on hostname alone."
invariant_stub 6 "Commands are durable work with explicit lifecycle."
invariant_stub 7 "Lease history is first-class evidence (dedicated stream)."
invariant_stub 8 "Realtime is wake-up only; recovery via durable reread."
invariant_stub 9 "Append-only evidence is immutable in meaning."
invariant_stub 10 "Installation/command rows summarize; streams explain."
invariant_stub 11 "Places are read models only."
invariant_stub 12 "Read models do not silently become authoritative roots."
invariant_stub 13 "Execution uses typed validated operations, not raw payload semantics alone."
invariant_stub 14 "Execution edge does not depend on UI language or publication traversal."
invariant_stub 15 "Rust and TS may differ in implementation, not in domain meaning."

# =============================================================================
#  Docs — domain one-pagers (§2)
# =============================================================================
write_if_missing "docs/domains/01-publication-truth.md" "# Publication truth\n\nSee ${LINK_DOCS_SUB} §2.1.\n"
write_if_missing "docs/domains/02-runtime-contract.md" "# Runtime contract\n\nSee ${LINK_DOCS_SUB} §2.2.\n"
write_if_missing "docs/domains/03-host-and-installation.md" "# Host and installation truth\n\nSee ${LINK_DOCS_SUB} §2.3.\n"
write_if_missing "docs/domains/04-durable-coordination.md" "# Durable agent coordination\n\nSee ${LINK_DOCS_SUB} §2.4.\n"
write_if_missing "docs/domains/05-security-reconciliation.md" "# Security and reconciliation\n\nSee ${LINK_DOCS_SUB} §2.5.\n"

# =============================================================================
#  Contracts — placeholders until generated/shared artifacts replace prose
# =============================================================================
write_if_missing "contracts/manifest/ManifestSnapshot.md" "# ManifestSnapshot\n\nShared: canonical bytes, \`manifest_hash\`, \`manifest_sig\`, signing pubkey, channel/release linkage.\n\nSee ${LINK_CONTRACTS} §2.2, §4.\n"
write_if_missing "contracts/manifest/signing-envelope.md" "# Signing envelope\n\n**TODO:** single rule for what is inside signed bytes vs envelope metadata (§10).\n\nSee ${LINK_CONTRACTS} §3, project README.\n"
write_if_missing "contracts/commands/AgentCommand.md" "# AgentCommand\n\nLifecycle: pending → leased → running → completed | failed | cancelled | dead_letter.\n\nSee ${LINK_CONTRACTS} §4, §5.\n"
write_if_missing "contracts/commands/state-machine.md" "# Command state machine\n\nDocument transitions and lease fields here or link to generated types.\n\nSee ${LINK_CONTRACTS} §4.\n"
write_if_missing "contracts/events/InstallationEvent.md" "# InstallationEvent\n\nTable: \`minilab.installation_events\`.\n\nSee ${LINK_CONTRACTS} §8.\n"
write_if_missing "contracts/events/AgentCommandEvent.md" "# AgentCommandEvent\n\nTable: \`minilab.agent_command_events\`.\n\nSee ${LINK_CONTRACTS} §8.\n"
write_if_missing "contracts/events/AgentCommandLeaseEvent.md" "# AgentCommandLeaseEvent\n\nTable: \`minilab.agent_command_lease_events\`.\n\nSee ${LINK_CONTRACTS} §8.\n"
write_if_missing "contracts/events/PairingEvent.md" "# PairingEvent\n\nTable: \`minilab.pairing_events\`.\n\nSee ${LINK_CONTRACTS} §8.\n"
write_if_missing "contracts/events/AgentCredentialEvent.md" "# AgentCredentialEvent\n\nTable: \`minilab.agent_credential_events\`.\n\nSee ${LINK_CONTRACTS} §8.\n"
write_if_missing "contracts/grammar/Operation.md" "# Operation\n\nTyped operations after grammar parse; execution edge consumes this, not raw text.\n\nSee ${LINK_CONTRACTS} §7, §9.4.\n"
write_if_missing "contracts/grammar/IntentEnvelope.md" "# IntentEnvelope\n\nOptional durable envelope for NL → grammar bridge.\n\nSee ${LINK_CONTRACTS} §7.\n"
write_if_missing "contracts/pairing/pairing-envelope.md" "# Pairing / auth envelope\n\nTrust-critical shapes shared by Rust (ceremony) and TS (UX).\n\nSee ${LINK_CONTRACTS} §7.\n"
write_if_missing "contracts/read_models/README.md" "# Read-model contracts\n\nTS-side shapes for Places, summaries, inspect views.\n\nSee ${LINK_CONTRACTS} §3C, §7.\n"

# =============================================================================
#  Rust workspace (operational core placeholder)
# =============================================================================
write_if_missing "rust/Cargo.toml" \
"[workspace]
members = [\"crates/minilab-agent\", \"crates/minilab-core\"]
resolver = \"2\"
"
write_if_missing "rust/crates/minilab-agent/Cargo.toml" \
"[package]
name = \"minilab-agent\"
version = \"0.0.0\"
edition = \"2021\"

[lib]
path = \"src/lib.rs\"
"
write_if_missing "rust/crates/minilab-agent/src/lib.rs" \
"//! Host agent: claim/lease/execute, manifest verify, pairing, evidence emission.\n//!\n//! See workspace \`docs/minilab-persistence-domain-model.md\` §7.\n"
write_if_missing "rust/crates/minilab-core/Cargo.toml" \
"[package]
name = \"minilab-core\"
version = \"0.0.0\"
edition = \"2021\"

[lib]
path = \"src/lib.rs\"
"
write_if_missing "rust/crates/minilab-core/src/lib.rs" \
"//! Shared Rust types: crypto verify helpers, command state, event types (as needed).\n//!\n//! See workspace \`docs/minilab-persistence-domain-model.md\` §7.\n"

# =============================================================================
#  TypeScript workspace (human / publisher / grammar placeholder)
# =============================================================================
write_if_missing "ts/package.json" \
'{
  "name": "minilab-ts-workspace",
  "private": true,
  "description": "Placeholder workspace root; wire workspaces when packages are real."
}
'
write_if_missing "ts/packages/operator-ui/README.md" "# operator-ui\n\nHuman interface (Places), operator inspection.\n\nSee ${LINK_TS_PKG} §7.\n"
write_if_missing "ts/packages/grammar/README.md" "# grammar\n\nParse / validate compact grammar → \`Operation\`.\n\nSee ${LINK_TS_PKG} §7.\n"
write_if_missing "ts/packages/publisher/README.md" "# publisher\n\nAssemble publication graph → canonical manifest; publish snapshots.\n\nSee ${LINK_TS_PKG} §7.\n"
write_if_missing "ts/packages/read_models/README.md" "# read_models\n\nTS types for projections and inspect views.\n\nSee ${LINK_TS_PKG} §3C.\n"
write_if_missing "ts/packages/supabase_operator/README.md" "# supabase_operator\n\nOperator-layer Supabase client, RPC wrappers, server read paths.\n\nSee ${LINK_TS_PKG} §6–7.\n"

# =============================================================================
#  Index READMEs (boilerplate — use SYNC_SCAFFOLD_INDEX=1 to refresh)
# =============================================================================
write_index "docs/invariants/README.md" "# Invariants\n\nOne file per invariant; canonical table in [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md) §5.\n"
write_index "docs/domains/README.md" "# Domains\n\nOne-pager per persistence domain; canonical detail in [minilab-persistence-domain-model.md](../minilab-persistence-domain-model.md) §2.\n"
write_index "design/ports/README.md" "# Repository ports\n\nSee [minilab-persistence-domain-model.md](../../docs/minilab-persistence-domain-model.md) §6.\n"
write_index "design/aggregates/README.md" "# Aggregate roots\n\nSee [minilab-persistence-domain-model.md](../../docs/minilab-persistence-domain-model.md) §4.\n"
write_index "references/schemas/minilab/README.md" "# \`minilab\` schema stubs\n\nAuthoritative, publication, evidence, and read-model placeholders. **Not** migrations—link real SQL from [../migrations/README.md](../migrations/README.md).\n"
write_index "references/migrations/README.md" "# Migrations\n\nLink or copy Supabase migration paths from the main Minilab repo when available.\n\nSee [../docs/minilab-persistence-domain-model.md](../docs/minilab-persistence-domain-model.md) §10.\n"
write_index "references/schemas/public/README.md" "# Public RPC edge\n\nThin \`public\` wrappers; runtime and agents call these instead of walking publication tables.\n\n## Stubs in this folder\n\n| File | Role (conceptual) |\n| ---- | ----------------- |\n| \`rpc_get_current_manifest.md\` | Runtime bootstrap / signed fetch edge |\n| \`rpc_claim_agent_commands.md\` | Durable command claim–lease edge |\n\nExact SQL function names live in the main repo migrations. Later, prefer **contract-shaped** names in docs (e.g. “signed manifest fetch”, “command claim”) even if filenames stay RPC-specific for grep-ability.\n"

# =============================================================================
#  Top-level docs / contracts / references pointers
# =============================================================================
write_index "docs/README.md" \
'# Documentation

- [Minilab persistence and domain model](minilab-persistence-domain-model.md)
- [Plan to production](plan-production.md)
- [Production milestones (M0–M8)](milestones-production.md)
- [M0 checklist (GitHub-ready)](milestones/M0-checklist.md)
- [Domains (one-pagers)](domains/README.md)
- [Invariants](invariants/README.md)
'

write_if_missing "contracts/README.md" \
"# Shared contracts

Named placeholders under \`manifest/\`, \`commands/\`, \`events/\`, \`grammar/\`, \`pairing/\`, \`read_models/\`.

See ${LINK_CONTRACTS} §7–8 and §10.
"

write_if_missing "references/README.md" \
"# References

Schema stubs under \`schemas/\`, migration pointers under \`migrations/\`.

See [minilab-persistence-domain-model.md](../docs/minilab-persistence-domain-model.md) §10.
"

echo "Done. Root: $ROOT"
