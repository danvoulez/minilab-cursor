-- M1-A: first durable command vertical (docs/milestones/M1-A-command-vertical-checklist.md)
-- Supabase/Postgres: apply via supabase db push / psql. event_type CHECK lists must match minilab_core::m1a.

CREATE SCHEMA IF NOT EXISTS minilab;

CREATE TABLE minilab.agent_commands (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id uuid NOT NULL,
    installation_id uuid,
    status text NOT NULL CHECK (
        status IN (
            'pending',
            'leased',
            'running',
            'completed',
            'failed',
            'cancelled',
            'dead_letter'
        )
    ),
    lease_expires_at timestamptz,
    worker_instance_id text,
    idempotency_key text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX agent_commands_host_idempotency_uq
    ON minilab.agent_commands (host_id, idempotency_key)
    WHERE idempotency_key IS NOT NULL;

CREATE INDEX agent_commands_host_status_idx
    ON minilab.agent_commands (host_id, status)
    WHERE status IN ('pending', 'leased', 'running');

CREATE TABLE minilab.agent_command_lease_events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    command_id uuid NOT NULL REFERENCES minilab.agent_commands (id) ON DELETE CASCADE,
    occurred_at timestamptz NOT NULL DEFAULT now(),
    event_type text NOT NULL CHECK (
        event_type IN ('claimed', 'released', 'renewed', 'expired', 'reclaimed')
    ),
    worker_instance_id text,
    metadata jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX agent_command_lease_events_command_id_idx
    ON minilab.agent_command_lease_events (command_id, occurred_at);

CREATE TABLE minilab.agent_command_events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    command_id uuid NOT NULL REFERENCES minilab.agent_commands (id) ON DELETE CASCADE,
    occurred_at timestamptz NOT NULL DEFAULT now(),
    event_type text NOT NULL CHECK (
        event_type IN ('started', 'completed', 'failed', 'cancel_requested')
    ),
    payload jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX agent_command_events_command_id_idx
    ON minilab.agent_command_events (command_id, occurred_at);

COMMENT ON SCHEMA minilab IS 'M1-A agent command spine; expand in later migrations.';
COMMENT ON TABLE minilab.agent_commands IS 'Durable work; lifecycle ADR 0004.';
COMMENT ON TABLE minilab.agent_command_lease_events IS 'Lease authority evidence ADR 0005.';
COMMENT ON TABLE minilab.agent_command_events IS 'Command narrative evidence ADR 0005 / domain §5.1.';
