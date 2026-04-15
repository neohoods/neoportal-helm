CREATE TABLE IF NOT EXISTS global.refresh_sessions (
    id uuid PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    token_hash varchar(128) NOT NULL UNIQUE,
    device_id varchar(255),
    device_name varchar(255),
    platform varchar(50),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_used_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamptz NOT NULL,
    revoked_at timestamptz,
    revoked_reason varchar(255),
    replaced_by_id uuid,
    ip_address varchar(64),
    user_agent varchar(512)
);

CREATE INDEX IF NOT EXISTS idx_refresh_sessions_user_id ON global.refresh_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_refresh_sessions_last_used_at ON global.refresh_sessions(last_used_at);
CREATE INDEX IF NOT EXISTS idx_refresh_sessions_expires_at ON global.refresh_sessions(expires_at);
CREATE INDEX IF NOT EXISTS idx_refresh_sessions_revoked_at ON global.refresh_sessions(revoked_at);
