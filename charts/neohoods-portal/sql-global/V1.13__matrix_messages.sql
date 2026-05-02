CREATE TABLE IF NOT EXISTS global.matrix_messages (
    event_id varchar(255) NOT NULL PRIMARY KEY,
    room_id varchar(512) NOT NULL,
    sender varchar(512),
    event_type varchar(128) NOT NULL,
    payload jsonb NOT NULL,
    status varchar(32) NOT NULL DEFAULT 'pending',
    origin_server_ts bigint,
    received_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_direct_message boolean NOT NULL DEFAULT false,
    last_error text
);

CREATE INDEX IF NOT EXISTS idx_global_matrix_messages_status_received
    ON global.matrix_messages (status, received_at);

CREATE INDEX IF NOT EXISTS idx_global_matrix_messages_room_status
    ON global.matrix_messages (room_id, status);

COMMENT ON TABLE global.matrix_messages IS 'Matrix sync ingest (global). Pre-routing worker forwards to tenant.matrix_messages.';
