-- Read-model index: avoid scanning every tenant schema for GET /tenants pending state.
CREATE TABLE IF NOT EXISTS global.user_tenant_join_requests_index (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    global_user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    tenant_slug varchar(255) NOT NULL,
    tenant_join_request_id uuid NOT NULL,
    status varchar(50) NOT NULL,
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (global_user_id, tenant_slug)
);

CREATE INDEX IF NOT EXISTS idx_utjri_user_status
    ON global.user_tenant_join_requests_index(global_user_id, status);

CREATE INDEX IF NOT EXISTS idx_utjri_tenant_status
    ON global.user_tenant_join_requests_index(tenant_slug, status);
