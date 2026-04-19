/** Schema `minilab` — ADR 0005 / `minilab_core::events`. */
export const MINILAB_SCHEMA = "minilab" as const;

/** Table name segment only (no schema prefix). */
export const MINILAB_TABLES = {
  INSTALLATION_EVENTS: "installation_events",
  AGENT_COMMAND_EVENTS: "agent_command_events",
  AGENT_COMMAND_LEASE_EVENTS: "agent_command_lease_events",
  PAIRING_EVENTS: "pairing_events",
  AGENT_CREDENTIAL_EVENTS: "agent_credential_events",
  VERIFY_RESULTS: "verify_results",
} as const;

/** M1-A migration adds `agent_commands` (not in core consts yet). */
export const M1A_AGENT_COMMANDS = "agent_commands" as const;
