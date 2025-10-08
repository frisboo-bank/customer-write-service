-- +goose Up
CREATE TABLE events (
    stream_id uuid NOT NULL,
    stream_name text NOT NULL,
    stream_version int NOT NULL CHECK (stream_version > 0),
    event_id uuid NOT NULL DEFAULT gen_random_uuid(),
    event_name text NOT NULL,
    event_data bytea NOT NULL,
    event_metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (stream_id, stream_name, stream_version, created_at)
);

CREATE INDEX idx_events_event_name ON events(event_name);

CREATE TABLE snapshots (
    stream_id uuid NOT NULL,
    stream_name text NOT NULL,
    stream_version int NOT NULL CHECK (stream_version > 0),
    snapshot_id uuid NOT NULL DEFAULT gen_random_uuid(),
    snapshot_name text NOT NULL,
    snapshot_data bytea NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (stream_id, stream_name, stream_version)
);

CREATE TABLE inbox (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    subject text NOT NULL,
    data bytea NOT NULL,
    metadata bytea NOT NULL,
    sent_at timestamptz NOT NULL,
    received_at timestamptz NOT NULL
);

CREATE TABLE outbox (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    subject text NOT NULL,
    data bytea NOT NULL,
    metadata bytea NOT NULL,
    sent_at timestamptz NOT NULL DEFAULT now(),
    published_at timestamptz NULL
);

CREATE INDEX idx_outbox_unpublished ON outbox(published_at) WHERE published_at IS NULL;

CREATE TABLE sagas (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL UNIQUE,
    data bytea NOT NULL,
    step int NOT NULL CHECK (step >= 0),
    done bool NOT NULL DEFAULT false,
    compensating bool NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Triggers
CREATE TRIGGER trg_snapshots_row_metadata
BEFORE UPDATE ON snapshots
FOR EACH ROW EXECUTE FUNCTION set_row_metadata();

CREATE TRIGGER trg_sagas_row_metadata
BEFORE UPDATE ON sagas
FOR EACH ROW EXECUTE FUNCTION set_row_metadata();

-- RLS
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE inbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE outbox ENABLE ROW LEVEL SECURITY;
ALTER TABLE sagas ENABLE ROW LEVEL SECURITY;

-- Partitions
-- +goose StatementBegin
-- DO $$
-- DECLARE
--     next_month date := date_trunc('month', now())::date + interval '6 month';
--     part_end date := next_month + interval '1 month';
-- BEGIN
--     EXECUTE format(
--         'CREATE TABLE IF NOT EXISTS %I_%s PARTITION OF %I FOR VALUES FROM (%L) TO (%L);',
--         'events', to_char(next_month,'YYYYMM'), 'events', next_month, part_end
--     );
-- END $$;
-- +goose StatementEnd

-- +goose Down
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS snapshots;
DROP TABLE IF EXISTS inbox;
DROP TABLE IF EXISTS outbox;
DROP TABLE IF EXISTS sagas;
