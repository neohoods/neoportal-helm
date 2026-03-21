-- Matrix OAuth tokens for the portal bot (instance-wide). JPA uses the default datasource
-- (public schema) when no tenant slug is set — e.g. GET /api/admin/matrix-bot/status.
-- Per-tenant copies also exist in tenant Flyway baselines; this table fixes missing relation on global.
-- Kept in sync with neoportal-app/platform-api/.../db/migration/V33__matrix_bot_tokens_global.sql

CREATE TABLE IF NOT EXISTS matrix_bot_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    access_token VARCHAR(2048) NOT NULL,
    refresh_token VARCHAR(2048) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_matrix_bot_tokens_created_at ON matrix_bot_tokens(created_at DESC);
