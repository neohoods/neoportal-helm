-- Tenant demo (db_name = schema name for search_path routing)
INSERT INTO global.tenants (id, slug, name, disabled, db_name)
VALUES ('a0000000-0000-0000-0000-000000000002', 'demo', 'Demo', false, 'demo')
ON CONFLICT (slug) DO NOTHING;

-- Create schema for tenant demo (used by TenantDataSourceProvider search_path)
CREATE SCHEMA IF NOT EXISTS demo;

-- Superadmins: SSO only (password NULL)
INSERT INTO global.users (id, username, email, password, first_name, last_name, preferred_language, is_email_verified, disabled, is_super_admin)
VALUES
  ('c0000000-0000-0000-0000-000000000001', 'qcastel', 'quentin.castel@neohoods.com', NULL, 'Quentin', 'Castel', 'fr', true, false, true),
  ('c0000000-0000-0000-0000-000000000002', 'gsurault', 'geoffroy.surault@neohoods.com', NULL, 'Geoffroy', 'Surault', 'fr', true, false, true)
ON CONFLICT (id) DO NOTHING;

UPDATE global.users SET is_super_admin = true WHERE email IN ('quentin.castel@neohoods.com', 'geoffroy.surault@neohoods.com');

-- Demo tenant: 4 users (SSO only, password NULL)
INSERT INTO global.users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, is_email_verified, disabled)
VALUES
  ('b1000001-0000-4000-8000-000000000001', 'demo', 'demo@demo.example.com', NULL, 'Demo', 'Admin', '1', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false),
  ('b1000001-0000-4000-8000-000000000002', 'demo_marie', 'marie.dubois@demo.example.com', NULL, 'Marie', 'Dubois', '2', '2 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false),
  ('b1000001-0000-4000-8000-000000000003', 'demo_pierre', 'pierre.martin@demo.example.com', NULL, 'Pierre', 'Martin', '3', '3 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false),
  ('b1000001-0000-4000-8000-000000000004', 'demo_lea', 'lea.bernard@demo.example.com', NULL, 'Léa', 'Bernard', '4', '4 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false)
ON CONFLICT (id) DO NOTHING;

-- Link superadmins + demo users to tenant demo
INSERT INTO global.user_tenants (user_id, tenant_id, role)
SELECT u.id, t.id, CASE WHEN u.username IN ('qcastel', 'gsurault', 'demo') THEN 'ADMIN' ELSE 'HUB' END
FROM global.users u
CROSS JOIN (SELECT id FROM global.tenants WHERE slug = 'demo') t
WHERE u.id IN (
  'c0000000-0000-0000-0000-000000000001',
  'c0000000-0000-0000-0000-000000000002',
  'b1000001-0000-4000-8000-000000000001',
  'b1000001-0000-4000-8000-000000000002',
  'b1000001-0000-4000-8000-000000000003',
  'b1000001-0000-4000-8000-000000000004'
)
ON CONFLICT (user_id, tenant_id) DO NOTHING;

-- System settings
INSERT INTO global.system_settings (id, registration_enabled, maintenance_mode, usage_conditions_version)
VALUES ('b0000000-0000-0000-0000-000000000001', false, false, '1')
ON CONFLICT (id) DO NOTHING;
