/** Persisted `agent_commands.status` — ADR 0004 / `minilab_core::AgentCommandStatus`. */
export const AGENT_COMMAND_STATUSES = [
  "pending",
  "leased",
  "running",
  "completed",
  "failed",
  "cancelled",
  "dead_letter",
] as const;

export type AgentCommandStatus = (typeof AGENT_COMMAND_STATUSES)[number];

export function isAgentCommandStatus(s: string): s is AgentCommandStatus {
  return (AGENT_COMMAND_STATUSES as readonly string[]).includes(s);
}
