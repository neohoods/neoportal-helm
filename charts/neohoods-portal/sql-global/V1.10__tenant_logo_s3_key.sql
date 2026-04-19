ALTER TABLE global.tenant_logo
    ADD COLUMN IF NOT EXISTS s3_key VARCHAR(768);

ALTER TABLE global.tenant_logo DROP CONSTRAINT IF EXISTS chk_tenant_logo_storage;

ALTER TABLE global.tenant_logo ALTER COLUMN image_data DROP NOT NULL;

ALTER TABLE global.tenant_logo ADD CONSTRAINT chk_tenant_logo_storage CHECK (
    (
        image_data IS NOT NULL
        AND (s3_key IS NULL OR TRIM(s3_key) = '')
    )
    OR (
        image_data IS NULL
        AND s3_key IS NOT NULL
        AND TRIM(s3_key) <> ''
    )
);
