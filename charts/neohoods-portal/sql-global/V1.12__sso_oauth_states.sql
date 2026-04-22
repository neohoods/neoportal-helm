CREATE TABLE IF NOT EXISTS global.sso_oauth_states (
    id uuid PRIMARY KEY,
    state_hash varchar(128) NOT NULL UNIQUE,
    code_verifier varchar(255) NOT NULL,
    client_context varchar(32),
    redirect_uri varchar(1024),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamptz NOT NULL,
    consumed_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_sso_oauth_states_expires_at ON global.sso_oauth_states(expires_at);
CREATE INDEX IF NOT EXISTS idx_sso_oauth_states_consumed_at ON global.sso_oauth_states(consumed_at);
