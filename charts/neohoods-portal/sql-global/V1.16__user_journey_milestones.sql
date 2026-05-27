-- User onboarding journey milestones (global schema).

CREATE TABLE IF NOT EXISTS global.user_journey_milestones (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    milestone varchar(64) NOT NULL,
    scope varchar(16) NOT NULL CHECK (scope IN ('GLOBAL', 'TENANT')),
    tenant_slug varchar(255),
    achieved_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metadata jsonb,
    synced_to_mautic_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_user_journey_milestones_user_milestone_tenant
    ON global.user_journey_milestones (user_id, milestone, COALESCE(tenant_slug, ''));

CREATE INDEX IF NOT EXISTS idx_user_journey_milestones_user_id
    ON global.user_journey_milestones (user_id);

CREATE INDEX IF NOT EXISTS idx_user_journey_milestones_tenant_slug
    ON global.user_journey_milestones (tenant_slug)
    WHERE tenant_slug IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_user_journey_milestones_milestone_tenant
    ON global.user_journey_milestones (milestone, tenant_slug);

CREATE INDEX IF NOT EXISTS idx_user_journey_milestones_mautic_pending
    ON global.user_journey_milestones (achieved_at)
    WHERE synced_to_mautic_at IS NULL;

CREATE TABLE IF NOT EXISTS global.user_engagement_summary (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    tenant_slug varchar(255),
    last_activity_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_user_engagement_summary_user_tenant
    ON global.user_engagement_summary (user_id, COALESCE(tenant_slug, ''));

CREATE INDEX IF NOT EXISTS idx_user_engagement_summary_user_id
    ON global.user_engagement_summary (user_id);

CREATE INDEX IF NOT EXISTS idx_user_engagement_summary_tenant_last_activity
    ON global.user_engagement_summary (tenant_slug, last_activity_at)
    WHERE tenant_slug IS NOT NULL;
