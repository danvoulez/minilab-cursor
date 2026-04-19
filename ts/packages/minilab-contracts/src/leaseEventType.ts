/** `minilab.agent_command_lease_events.event_type` — must match M1-A migration CHECK + Rust `AgentCommandLeaseEventKind`. */
export const AGENT_COMMAND_LEASE_EVENT_TYPES = [
  "claimed",
  "released",
  "renewed",
  "expired",
  "reclaimed",
] as const;

export type AgentCommandLeaseEventType =
  (typeof AGENT_COMMAND_LEASE_EVENT_TYPES)[number];

export function isLeaseEventType(s: string): s is AgentCommandLeaseEventType {
  return (AGENT_COMMAND_LEASE_EVENT_TYPES as readonly string[]).includes(s);
}
