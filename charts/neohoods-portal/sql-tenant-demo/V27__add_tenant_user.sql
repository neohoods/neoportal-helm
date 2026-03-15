-- Tenant-user link: global user id + role for this tenant (Phase 2+).
CREATE TABLE IF NOT EXISTS tenant_user (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    global_user_id uuid NOT NULL,
    role varchar(255) NOT NULL,
    matrix_user_id varchar(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (global_user_id)
);
CREATE INDEX IF NOT EXISTS idx_tenant_user_global_user_id ON tenant_user(global_user_id);
