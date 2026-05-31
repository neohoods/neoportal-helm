-- Demo personas for Mautic activation campaign (tenant "demo").
-- Idempotent: safe on dev/prod — only affects @demo.example.com users that exist.
-- (Moved from V1.17 which was already applied as an empty migration on dev/prod.)

DO $$
BEGIN
    CREATE TEMP TABLE _demo_mautic_persona_emails (email text PRIMARY KEY) ON COMMIT DROP;
    INSERT INTO _demo_mautic_persona_emails (email) VALUES
        ('alice.anderson@demo.example.com'),
        ('bob.bernard@demo.example.com'),
        ('charlie.clerc@demo.example.com'),
        ('diana.dupont@demo.example.com'),
        ('eric.etienne@demo.example.com');

    DELETE FROM global.user_journey_milestones m
    USING global.users u, _demo_mautic_persona_emails p
    WHERE m.user_id = u.id AND u.email = p.email;

    -- Alice: nouveau inscrit
    INSERT INTO global.user_journey_milestones (id, user_id, milestone, scope, tenant_slug, achieved_at, metadata, synced_to_mautic_at, created_at)
    SELECT gen_random_uuid(), u.id, m.milestone, m.scope, m.tenant_slug, m.achieved_at, '{}'::jsonb, NULL, now()
    FROM global.users u
    CROSS JOIN (VALUES
        ('member_of_copro', 'GLOBAL', NULL::varchar, now() - interval '2 days'),
        ('copro_joined', 'TENANT', 'demo', now() - interval '2 days')
    ) AS m(milestone, scope, tenant_slug, achieved_at)
    WHERE u.email = 'alice.anderson@demo.example.com';

    -- Bob: parcours en cours
    INSERT INTO global.user_journey_milestones (id, user_id, milestone, scope, tenant_slug, achieved_at, metadata, synced_to_mautic_at, created_at)
    SELECT gen_random_uuid(), u.id, m.milestone, m.scope, m.tenant_slug, m.achieved_at, '{}'::jsonb, NULL, now()
    FROM global.users u
    CROSS JOIN (VALUES
        ('member_of_copro', 'GLOBAL', NULL::varchar, now() - interval '5 days'),
        ('copro_joined', 'TENANT', 'demo', now() - interval '5 days'),
        ('mobile_app_used', 'GLOBAL', NULL::varchar, now() - interval '4 days'),
        ('matrix_account_ready', 'TENANT', 'demo', now() - interval '3 days')
    ) AS m(milestone, scope, tenant_slug, achieved_at)
    WHERE u.email = 'bob.bernard@demo.example.com';

    -- Charlie: activé via réservation
    INSERT INTO global.user_journey_milestones (id, user_id, milestone, scope, tenant_slug, achieved_at, metadata, synced_to_mautic_at, created_at)
    SELECT gen_random_uuid(), u.id, m.milestone, m.scope, m.tenant_slug, m.achieved_at, '{}'::jsonb, NULL, now()
    FROM global.users u
    CROSS JOIN (VALUES
        ('member_of_copro', 'GLOBAL', NULL::varchar, now() - interval '7 days'),
        ('copro_joined', 'TENANT', 'demo', now() - interval '7 days'),
        ('mobile_app_used', 'GLOBAL', NULL::varchar, now() - interval '6 days'),
        ('matrix_account_ready', 'TENANT', 'demo', now() - interval '5 days'),
        ('first_space_booking', 'TENANT', 'demo', now() - interval '1 day')
    ) AS m(milestone, scope, tenant_slug, achieved_at)
    WHERE u.email = 'charlie.clerc@demo.example.com';

    -- Diana: activée via Alfred
    INSERT INTO global.user_journey_milestones (id, user_id, milestone, scope, tenant_slug, achieved_at, metadata, synced_to_mautic_at, created_at)
    SELECT gen_random_uuid(), u.id, m.milestone, m.scope, m.tenant_slug, m.achieved_at, '{}'::jsonb, NULL, now()
    FROM global.users u
    CROSS JOIN (VALUES
        ('member_of_copro', 'GLOBAL', NULL::varchar, now() - interval '6 days'),
        ('copro_joined', 'TENANT', 'demo', now() - interval '6 days'),
        ('alfred_message_sent', 'TENANT', 'demo', now() - interval '12 hours')
    ) AS m(milestone, scope, tenant_slug, achieved_at)
    WHERE u.email = 'diana.dupont@demo.example.com';

    -- Eric: activé via incident
    INSERT INTO global.user_journey_milestones (id, user_id, milestone, scope, tenant_slug, achieved_at, metadata, synced_to_mautic_at, created_at)
    SELECT gen_random_uuid(), u.id, m.milestone, m.scope, m.tenant_slug, m.achieved_at, '{}'::jsonb, NULL, now()
    FROM global.users u
    CROSS JOIN (VALUES
        ('member_of_copro', 'GLOBAL', NULL::varchar, now() - interval '8 days'),
        ('copro_joined', 'TENANT', 'demo', now() - interval '8 days'),
        ('incident_declared', 'TENANT', 'demo', now() - interval '6 hours')
    ) AS m(milestone, scope, tenant_slug, achieved_at)
    WHERE u.email = 'eric.etienne@demo.example.com';

    -- Queue Mautic sync for campaign-relevant milestones (demo personas + any pending).
    UPDATE global.user_journey_milestones
    SET synced_to_mautic_at = NULL
    WHERE milestone IN (
        'copro_joined', 'member_of_copro',
        'mobile_app_used', 'matrix_account_ready',
        'first_space_booking', 'alfred_message_sent', 'incident_declared'
    )
    AND user_id IN (
        SELECT u.id FROM global.users u
        JOIN _demo_mautic_persona_emails p ON p.email = u.email
    );
END $$;
