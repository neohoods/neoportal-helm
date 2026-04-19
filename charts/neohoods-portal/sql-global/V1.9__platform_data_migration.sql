-- Tracks Java application data migrations (DB→S3, etc.).
CREATE TABLE IF NOT EXISTS global.platform_data_migration (
    migration_id VARCHAR(128) NOT NULL,
    tenant_slug VARCHAR(255) NOT NULL,
    applied_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (migration_id, tenant_slug)
);

CREATE INDEX IF NOT EXISTS idx_platform_data_migration_slug ON global.platform_data_migration (tenant_slug);
