-- Add global per-tenant UniFi settings table used by /api/system/tenants/:slug/unifi.
CREATE SCHEMA IF NOT EXISTS global;

CREATE TABLE IF NOT EXISTS global.tenant_unifi_config (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    config_json jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id)
);

CREATE INDEX IF NOT EXISTS idx_tenant_unifi_config_tenant_id
    ON global.tenant_unifi_config(tenant_id);
