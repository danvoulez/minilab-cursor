export * from "./agentCommandStatus.js";
export * from "./commandEventType.js";
export * from "./leaseEventType.js";
export * from "./tables.js";

/** M1-A checklist step ids — mirror `minilab_agent::M1A_VERTICAL_STEPS`. */
export const M1A_VERTICAL_STEPS = [
  "1_persist_command",
  "2_claim_lease",
  "3_append_lease_event",
  "4_typed_execute",
  "5_append_command_event",
  "6_terminal_inspectable",
] as const;
