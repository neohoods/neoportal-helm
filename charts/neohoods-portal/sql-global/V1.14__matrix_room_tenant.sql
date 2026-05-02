CREATE TABLE IF NOT EXISTS global.matrix_room_tenant (
    room_id varchar(512) NOT NULL PRIMARY KEY,
    tenant_slug varchar(255) NOT NULL,
    is_dm boolean NOT NULL DEFAULT true,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_global_matrix_room_tenant_slug
    ON global.matrix_room_tenant (tenant_slug);

COMMENT ON TABLE global.matrix_room_tenant IS 'Matrix room to copro mapping for assistant routing (DM memory etc.).';
