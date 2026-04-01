-- V1.6: Track async tenant onboarding jobs (copro creation + units + matrix) in global schema.

CREATE TABLE IF NOT EXISTS global.tenant_onboarding_jobs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id uuid NOT NULL UNIQUE,
    tenant_id uuid NULL REFERENCES global.tenants(id) ON DELETE SET NULL,
    slug varchar(255) NULL,
    created_by uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    status varchar(32) NOT NULL,
    current_step varchar(32) NULL,
    error_message text NULL,
    steps text NULL,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS tenant_onboarding_jobs_slug_idx
    ON global.tenant_onboarding_jobs(slug);

CREATE INDEX IF NOT EXISTS tenant_onboarding_jobs_created_by_idx
    ON global.tenant_onboarding_jobs(created_by);

