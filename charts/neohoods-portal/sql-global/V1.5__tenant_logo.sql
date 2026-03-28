-- Super-admin tenant branding: logo bytes served at GET /api/public/tenants/{slug}/logo
CREATE TABLE IF NOT EXISTS global.tenant_logo (
    tenant_id uuid PRIMARY KEY REFERENCES global.tenants(id) ON DELETE CASCADE,
    image_data bytea NOT NULL,
    mime_type varchar(128) NOT NULL,
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
