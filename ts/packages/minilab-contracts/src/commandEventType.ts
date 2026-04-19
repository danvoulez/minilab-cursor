/** `minilab.agent_command_events.event_type` — M1-A journal allow-list + Rust `AgentCommandJournalEventKind`. */
export const AGENT_COMMAND_JOURNAL_EVENT_TYPES = [
  "started",
  "completed",
  "failed",
  "cancel_requested",
] as const;

export type AgentCommandJournalEventType =
  (typeof AGENT_COMMAND_JOURNAL_EVENT_TYPES)[number];

export function isCommandJournalEventType(
  s: string,
): s is AgentCommandJournalEventType {
  return (AGENT_COMMAND_JOURNAL_EVENT_TYPES as readonly string[]).includes(s);
}
