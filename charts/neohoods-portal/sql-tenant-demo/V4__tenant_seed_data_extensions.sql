-- Tenant demo fake data (aligned with V1__tenant_baseline + global users b1000001-*).
-- Applied at runtime for slug=demo only (DemoTenantDataService). Idempotent where possible.
-- Source of truth for edits: keep in sync with neoportal-helm/charts/neohoods-portal/sql-tenant-demo/V2__tenant_seed_data.sql
--
-- Business dates are shifted so each seed/reset aligns to UTC "today": offset = today - 2026-05-14
-- (calendar snapshot the historical seed was designed around). Use _demo_seed_ctx.day_offset
-- in expressions below. Schema Flyway drop clears temp tables; each connection recreates them.

CREATE TEMP TABLE IF NOT EXISTS _demo_seed_ctx (day_offset int NOT NULL);
TRUNCATE _demo_seed_ctx;
INSERT INTO _demo_seed_ctx (day_offset)
VALUES ((((CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date - DATE '2026-05-14'))::int);

INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, is_email_verified, disabled, status, user_type, is_board_member, primary_unit_id)
VALUES
  ('b1000001-0000-4000-8000-000000000001', 'demo', 'demo@demo.example.com', '', 'Demo', 'Admin', 'Syndic', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'ADMIN', false, NULL),
  ('b1000001-0000-4000-8000-000000000002', 'demo_alice', 'alice.anderson@demo.example.com', '', 'Alice', 'Anderson', '1', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'OWNER', true, NULL),
  ('b1000001-0000-4000-8000-000000000003', 'demo_bob', 'bob.bernard@demo.example.com', '', 'Bob', 'Bernard', '1', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL),
  ('b1000001-0000-4000-8000-000000000004', 'demo_charlie', 'charlie.clerc@demo.example.com', '', 'Charlie', 'Clerc', '2', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'LANDLORD', false, NULL),
  ('b1000001-0000-4000-8000-000000000005', 'demo_diana', 'diana.dupont@demo.example.com', '', 'Diana', 'Dupont', '2', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL),
  ('b1000001-0000-4000-8000-000000000006', 'demo_eric', 'eric.etienne@demo.example.com', '', 'Eric', 'Étienne', '3', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'OWNER', true, NULL),
  ('b1000001-0000-4000-8000-000000000007', 'demo_frank', 'frank.faure@demo.example.com', '', 'Frank', 'Faure', '3', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL),
  ('b1000001-0000-4000-8000-000000000008', 'demo_grace', 'grace.garnier@demo.example.com', '', 'Grace', 'Garnier', '4', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'OWNER', true, NULL),
  ('b1000001-0000-4000-8000-000000000009', 'demo_henry', 'henry.hubert@demo.example.com', '', 'Henry', 'Hubert', '4', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL),
  ('b1000001-0000-4000-8000-000000000010', 'demo_ivan', 'ivan.ibarra@demo.example.com', '', 'Ivan', 'Ibarra', '5', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'LANDLORD', false, NULL),
  ('b1000001-0000-4000-8000-000000000011', 'demo_julia', 'julia.joly@demo.example.com', '', 'Julia', 'Joly', '5', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL),
  ('b1000001-0000-4000-8000-000000000012', 'demo_kate', 'kate.klein@demo.example.com', '', 'Kate', 'Klein', '5', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL),
  ('b1000001-0000-4000-8000-000000000013', 'demo_iris', 'iris.iniesta@demo.example.com', '', 'Iris', 'Iniesta', '2', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL),
  ('b1000001-0000-4000-8000-000000000014', 'demo_lea', 'lea.lambert@demo.example.com', '', 'Léa', 'Lambert', '2', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'OWNER', false, NULL),
  ('b1000001-0000-4000-8000-000000000015', 'demo_mila', 'mila.morel@demo.example.com', '', 'Mila', 'Morel', 'G8', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'LANDLORD', false, NULL),
  ('b1000001-0000-4000-8000-000000000016', 'demo_nina', 'nina.nguyen@demo.example.com', '', 'Nina', 'Nguyen', '5', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'OWNER', true, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO units (id, name, type, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440100', 'Appart 1', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440101', 'Appart 2', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440102', 'Appart 3', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440103', 'Appart 4', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440104', 'Appart 5', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440301', 'Garage 1', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440302', 'Garage 2', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440303', 'Garage 3', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440304', 'Garage 4', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440305', 'Garage 5', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440306', 'Garage 6', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440307', 'Garage 7', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440401', 'Parking lot 1', 'PARKING', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440402', 'Parking lot 2', 'PARKING', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440403', 'Parking lot 3', 'PARKING', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440404', 'Parking lot 4', 'PARKING', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440405', 'Parking lot 5', 'PARKING', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440406', 'Parking lot 6', 'PARKING', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO unit_members (id, unit_id, user_id, role, residence_role, joined_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440200', '550e8400-e29b-41d4-a716-446655440100', 'b1000001-0000-4000-8000-000000000001', 'ADMIN', 'PROPRIETAIRE', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440201', '550e8400-e29b-41d4-a716-446655440100', 'b1000001-0000-4000-8000-000000000002', 'ADMIN', 'PROPRIETAIRE', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440202', '550e8400-e29b-41d4-a716-446655440100', 'b1000001-0000-4000-8000-000000000003', 'MEMBER', 'TENANT', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655440101', 'b1000001-0000-4000-8000-000000000014', 'ADMIN', 'PROPRIETAIRE', '2024-01-11 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440204', '550e8400-e29b-41d4-a716-446655440101', 'b1000001-0000-4000-8000-000000000004', 'MEMBER', 'BAILLEUR', '2024-01-11 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440205', '550e8400-e29b-41d4-a716-446655440101', 'b1000001-0000-4000-8000-000000000005', 'MEMBER', 'TENANT', '2024-01-12 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440206', '550e8400-e29b-41d4-a716-446655440101', 'b1000001-0000-4000-8000-000000000013', 'MEMBER', 'TENANT', '2024-01-13 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440250', '550e8400-e29b-41d4-a716-446655440102', 'b1000001-0000-4000-8000-000000000006', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440251', '550e8400-e29b-41d4-a716-446655440102', 'b1000001-0000-4000-8000-000000000007', 'MEMBER', 'TENANT', '2024-02-02 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440252', '550e8400-e29b-41d4-a716-446655440103', 'b1000001-0000-4000-8000-000000000008', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440253', '550e8400-e29b-41d4-a716-446655440103', 'b1000001-0000-4000-8000-000000000009', 'MEMBER', 'TENANT', '2024-02-15 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440254', '550e8400-e29b-41d4-a716-446655440104', 'b1000001-0000-4000-8000-000000000016', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440255', '550e8400-e29b-41d4-a716-446655440104', 'b1000001-0000-4000-8000-000000000010', 'MEMBER', 'BAILLEUR', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440256', '550e8400-e29b-41d4-a716-446655440104', 'b1000001-0000-4000-8000-000000000011', 'MEMBER', 'TENANT', '2024-03-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440257', '550e8400-e29b-41d4-a716-446655440104', 'b1000001-0000-4000-8000-000000000012', 'MEMBER', 'TENANT', '2024-03-02 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440258', '550e8400-e29b-41d4-a716-446655440301', 'b1000001-0000-4000-8000-000000000002', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440259', '550e8400-e29b-41d4-a716-446655440302', 'b1000001-0000-4000-8000-000000000014', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-44665544025a', '550e8400-e29b-41d4-a716-446655440303', 'b1000001-0000-4000-8000-000000000006', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-44665544025b', '550e8400-e29b-41d4-a716-446655440304', 'b1000001-0000-4000-8000-000000000008', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-44665544025c', '550e8400-e29b-41d4-a716-446655440305', 'b1000001-0000-4000-8000-000000000016', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-44665544025d', '550e8400-e29b-41d4-a716-446655440306', 'b1000001-0000-4000-8000-000000000001', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-44665544025e', '550e8400-e29b-41d4-a716-446655440307', 'b1000001-0000-4000-8000-000000000015', 'ADMIN', 'BAILLEUR', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-44665544025f', '550e8400-e29b-41d4-a716-446655440401', 'b1000001-0000-4000-8000-000000000002', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440260', '550e8400-e29b-41d4-a716-446655440402', 'b1000001-0000-4000-8000-000000000014', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440261', '550e8400-e29b-41d4-a716-446655440403', 'b1000001-0000-4000-8000-000000000006', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440262', '550e8400-e29b-41d4-a716-446655440404', 'b1000001-0000-4000-8000-000000000008', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440263', '550e8400-e29b-41d4-a716-446655440405', 'b1000001-0000-4000-8000-000000000016', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440264', '550e8400-e29b-41d4-a716-446655440406', 'b1000001-0000-4000-8000-000000000001', 'ADMIN', 'PROPRIETAIRE', '2024-02-01 10:00:00+00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO infos (id, next_ag_date, rules_url, emails_enabled, wifi_name, wifi_password) VALUES
  ('00000000-0000-0000-0000-000000000001', ('2026-11-28 18:30:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'https://demo.example.com/reglement', true, 'wifi_residence_demo', 'neohoods-demo')
ON CONFLICT (id) DO UPDATE SET
  next_ag_date = EXCLUDED.next_ag_date,
  rules_url = EXCLUDED.rules_url,
  emails_enabled = EXCLUDED.emails_enabled,
  wifi_name = EXCLUDED.wifi_name,
  wifi_password = EXCLUDED.wifi_password;

INSERT INTO delegates (id, info_id, building, first_name, last_name, email, matrix_user) VALUES
  ('550e8400-e29b-41d4-a716-446655440010', '00000000-0000-0000-0000-000000000001', 'Résidence Demo', 'Alice', 'Anderson', 'alice.anderson@demo.example.com', NULL),
  ('550e8400-e29b-41d4-a716-446655440011', '00000000-0000-0000-0000-000000000001', 'Résidence Demo', 'Eric', 'Étienne', 'eric.etienne@demo.example.com', NULL),
  ('550e8400-e29b-41d4-a716-446655440012', '00000000-0000-0000-0000-000000000001', 'Résidence Demo', 'Grace', 'Garnier', 'grace.garnier@demo.example.com', NULL),
  ('550e8400-e29b-41d4-a716-446655440013', '00000000-0000-0000-0000-000000000001', 'Résidence Demo', 'Nina', 'Nguyen', 'nina.nguyen@demo.example.com', NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO contact_numbers (id, info_id, contact_type, type, description, availability, response_time, name, phone_number, email, office_hours, address, responsibility, metadata, qr_code_url) VALUES
  ('550e8400-e29b-41d4-a716-446655440010', '00000000-0000-0000-0000-000000000001', 'syndic', 'Cabinet', 'Syndic principal (démo)', 'Lun–Ven 9h–18h', '24h', 'Cabinet NeoHoods Demo', '01.23.45.67.89', 'syndic@demo.example.com', '9h–12h / 14h–17h', '1 Place Demo — bureau A', NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440026', '00000000-0000-0000-0000-000000000001', 'syndic', 'Gestionnaire', 'Gestionnaire de copropriété', 'Lun–Ven 9h–17h', '48h', 'Mme Gestion Demo', '01.23.45.67.90', 'gestion@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440027', '00000000-0000-0000-0000-000000000001', 'syndic', 'Comptabilité', 'Relances et appels de fonds (fictif)', 'Mar–Jeu 10h–16h', '72h', 'Service compta syndic', '01.23.45.67.91', 'compta@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440021', '00000000-0000-0000-0000-000000000001', 'emergency', 'Urgences vitales', 'Samu / Pompiers / Police', '24h/24', 'Immédiat', '15 / 17 / 18', '15', NULL, NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440028', '00000000-0000-0000-0000-000000000001', 'emergency', 'Ascenseur', 'Maintenance ascenseurs Otis (fictif)', '24h/24', '2h', 'Otis Service Demo', '08.00.11.22.33', 'ascenseur.otis@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440029', '00000000-0000-0000-0000-000000000001', 'emergency', 'Chauffage / VMC / adoucisseur', 'Dépannage chaufferie et traitement d''eau', 'Lun–Dim', '4h', 'Thermo & Air Demo', '01.44.55.66.77', 'chauffage.vmc@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-44665544002a', '00000000-0000-0000-0000-000000000001', 'emergency', 'Portail & parking', 'Motorisation portail et accès parking', 'Lun–Sam 8h–20h', '3h', 'Accès Park Demo', '01.88.99.00.11', 'parking.portail@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440022', '00000000-0000-0000-0000-000000000001', 'maintenance', 'Gardiennage', 'Accueil et ronde nocturne (démo)', 'Lun–Dim 18h–8h', '15 min', 'Poste gardien', '01.98.76.54.32', 'gardien@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440023', '00000000-0000-0000-0000-000000000001', 'maintenance', 'Chauffage', 'Dépannage chaufferie (fictif)', 'Lun–Ven 8h–18h', '4h', 'Thermo Demo', '01.11.22.33.44', 'chauffage@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440024', '00000000-0000-0000-0000-000000000001', 'maintenance', 'Ascenseur', 'Entretien ascenseurs', 'Lun–Ven 9h–17h', '2h', 'LiftCare Demo', '01.55.66.77.88', 'ascenseur@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-446655440025', '00000000-0000-0000-0000-000000000001', 'maintenance', 'Ménage parties communes', 'Prestataire espaces partagés', 'Lun–Sam 7h–12h', '24h', 'LIMPIA Demo', '01.44.33.22.11', 'limpiaplus@demo.example.com', NULL, NULL, NULL, NULL, NULL),
  ('550e8400-e29b-41d4-a716-44665544002b', '00000000-0000-0000-0000-000000000001', 'maintenance', 'Relevés & chaufferie', 'ISTA — relevés et entretien (fictif)', 'Lun–Ven 8h–17h', '48h', 'ISTA France Demo', '01.77.66.55.44', 'contact-residence@ista-demo.example.com', NULL, NULL, 'Relevés individuels et maintenance chaufferie', NULL, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO announcements (id, title, content, summary, created_at, updated_at, category) VALUES
  ('550e8400-e29b-41d4-a716-446655440030', 'Bienvenue sur Demo', 'Environnement de démonstration NeoHoods : plusieurs appartements, garages, places de parking, chambre d''hôtes, salle commune, bureaux coworking, gym et nombreuses réservations fictives. Idéal pour présenter le portail et le mode TV.', NULL, '2024-01-15 10:00:00+00', ('2026-05-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'COMMUNITY_EVENT'),
  ('550e8400-e29b-41d4-a716-446655440031', 'Fête des voisins (cour intérieure)', 'Rendez-vous cour intérieure à partir de 18 h 30. Apéritif offert par le conseil syndical (données fictives). Merci de confirmer votre présence via le portail.', 'Grillades et musique', ('2026-04-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'SOCIAL_GATHERING'),
  ('550e8400-e29b-41d4-a716-446655440032', 'Collecte des encombrants', 'Dépôt autorisé sur deux jours consécutifs en début d''année, de 9 h à 17 h devant le local technique (liste des objets refusés jointe au PDF). Dates fictives recalculées à chaque reset démo.', 'Voir PDF', ('2026-01-05 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-01-05 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'MAINTENANCE_NOTICE'),
  ('550e8400-e29b-41d4-a716-446655440033', 'Règlement de bonne conduite', 'Version condensée du règlement intérieur : bruit, parties communes, animaux et stationnement (document PDF joint).', 'PDF règlement', ('2025-09-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-09-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'OTHER'),
  ('550e8400-e29b-41d4-a716-446655440034', 'Écrans d''information résidence', 'Visuels affichés sur les écrans TV du hall : actualités copropriété et rappels pratiques (image jointe).', 'Mode TV', ('2026-01-10 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-01-10 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'COMMUNITY_EVENT'),
  ('550e8400-e29b-41d4-a716-446655440035', 'Test ascenseur B (matinée)', 'Intervention programmée de 9 h à 12 h. Privilégier l''escalier (démo).', NULL, ('2026-02-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-02-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'MAINTENANCE_NOTICE'),
  ('550e8400-e29b-41d4-a716-446655440036', 'Objet trouvé : parapluie noir', 'Déposé au syndic fictif. Contact via le portail.', NULL, ('2026-03-15 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-03-15 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'LOST_AND_FOUND'),
  ('550e8400-e29b-41d4-a716-446655440037', 'Rappel sécurité incendie', 'Ne bloquez pas les issues de secours. Vérifier les extincteurs dans les cages d''escalier (données de démonstration).', NULL, ('2025-11-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-11-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'SAFETY_ALERT'),
  ('550e8400-e29b-41d4-a716-446655440038', 'Travaux façade — printemps', 'Échafaudages côté rue sur une période de printemps (dates fictives, recalculées au reset démo). Stationnement interdit devant l''entrée principale pendant la durée des travaux.', NULL, ('2026-03-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-03-01 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'MAINTENANCE_NOTICE'),
  ('550e8400-e29b-41d4-a716-446655440039', 'Portes palières : fermeture automatique', 'Merci de vérifier que les portes se referment bien après passage (sécurité collective).', NULL, ('2026-04-20 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-20 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'SAFETY_ALERT'),
  ('550e8400-e29b-41d4-a716-446655440040', 'Compost & déchets verts', 'Nouveau bac compost en cour intérieure (calendrier de collecte fictif).', 'Tri', ('2026-02-10 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-02-10 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'MAINTENANCE_NOTICE'),
  ('550e8400-e29b-41d4-a716-446655440041', 'Partenariat services résidents', 'Présentation partenaire Horizon (logo joint) — offre démo sans valeur contractuelle.', NULL, ('2026-03-05 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-03-05 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'OTHER'),
  ('550e8400-e29b-41d4-a716-446655440042', 'Coursives : dépôt temporaire interdit', 'Rappel : aucun dépôt sur les coursives plus de 24 h (démonstration).', NULL, ('2026-03-22 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-03-22 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'SAFETY_ALERT'),
  ('550e8400-e29b-41d4-a716-446655440043', 'AG — ordre du jour indicatif', 'Projets de résolutions et budget prévisionnel (texte factice pour la démo).', NULL, ('2026-04-05 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-05 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'OTHER'),
  ('550e8400-e29b-41d4-a716-446655440044', 'Club lecture & café voisinage', 'Inscription ouverte au hall (événement convivial fictif).', 'Café livres', ('2026-05-02 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-02 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'SOCIAL_GATHERING')
ON CONFLICT (id) DO NOTHING;

INSERT INTO custom_pages (id, ref, page_order, position, title, content) VALUES
  ('550e8400-e29b-41d4-a716-446655440040', 'privacy-policy', 1, 'FOOTER_LINKS', 'Politique de Confidentialité', '<p>Politique de confidentialité Demo.</p>'),
  ('550e8400-e29b-41d4-a716-446655440041', 'terms-of-service', 2, 'FOOTER_LINKS', 'Conditions d''Utilisation', '<p>Conditions d''utilisation Demo.</p>'),
  ('550e8400-e29b-41d4-a716-446655440043', 'copyright-notice', 1, 'COPYRIGHT', 'Mentions Légales', '<p>&copy; 2024 NeoHoods Demo.</p>'),
  ('550e8400-e29b-41d4-a716-446655440044', 'help-contact', 1, 'FOOTER_HELP', 'Support', '<p>Contact : support@neohoods.com</p>')
ON CONFLICT (id) DO NOTHING;

INSERT INTO email_templates (id, type, name, subject, content, is_active, created_at, updated_at, created_by, description) VALUES
  ('550e8400-e29b-41d4-a716-446655440060', 'WELCOME', 'Welcome Email - Default', 'Welcome to {{appName}}!', '<p>Thank you for joining {{appName}}.</p>', true, '2024-01-10 14:30:00+00', '2024-01-10 14:30:00+00', 'b1000001-0000-4000-8000-000000000001', 'Default welcome email')
ON CONFLICT (id) DO NOTHING;

INSERT INTO settings (id, is_registration_enabled) VALUES ('00000000-0000-0000-0000-000000000001', false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES
  ('b1000001-0000-4000-8000-000000000001', true, false),
  ('b1000001-0000-4000-8000-000000000002', true, false),
  ('b1000001-0000-4000-8000-000000000003', false, false),
  ('b1000001-0000-4000-8000-000000000004', false, false),
  ('b1000001-0000-4000-8000-000000000005', true, true),
  ('b1000001-0000-4000-8000-000000000006', true, true),
  ('b1000001-0000-4000-8000-000000000007', true, false),
  ('b1000001-0000-4000-8000-000000000008', true, false),
  ('b1000001-0000-4000-8000-000000000009', false, false),
  ('b1000001-0000-4000-8000-000000000010', true, false),
  ('b1000001-0000-4000-8000-000000000011', true, false),
  ('b1000001-0000-4000-8000-000000000012', true, false),
  ('b1000001-0000-4000-8000-000000000013', true, false),
  ('b1000001-0000-4000-8000-000000000015', true, false),
  ('b1000001-0000-4000-8000-000000000016', true, true)
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO help_categories (id, name, icon, display_order) VALUES ('a970dc49-aca8-4508-8182-0bb3e3de8c1d', 'Demo', '@tui.message-circle', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES
  ('f346a7fd-086c-4226-8f7b-6b80f93657cb', 'Comment utiliser Demo', '<p>Ce tenant demo couvre les principaux types d''espaces : chambre d''hôtes, salle commune, coworking (bureaux A et B), gym (abonnements), parkings.</p>', 1, 'a970dc49-aca8-4508-8182-0bb3e3de8c1d')
ON CONFLICT (id) DO NOTHING;

INSERT INTO unifi_door_controllers (id, controller_id, name, model, last_seen, created_at, updated_at) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'main-controller', 'Contrôleur Demo', 'UD-Pro', NOW(), '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (controller_id) DO UPDATE SET name = EXCLUDED.name, model = EXCLUDED.model, updated_at = EXCLUDED.updated_at;

INSERT INTO unifi_doors (id, door_controller_id, door_id, name, description, last_seen, created_at, updated_at) VALUES
  ('b0000000-0000-0000-0000-000000000010', 'b0000000-0000-0000-0000-000000000001', 'door-1', 'Chambre d''hôtes', 'Porte de la chambre d''hôtes', NOW(), '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('b0000000-0000-0000-0000-000000000011', 'b0000000-0000-0000-0000-000000000001', 'door-2', 'Salle commune', 'Porte de la salle commune', NOW(), '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (door_controller_id, door_id) DO NOTHING;

INSERT INTO digital_door_credentials (id, unifi_door_controller_id, type, name, origin, label, code, vigik_badge_number, unit_id, activation_date, expiration_date, reservation_id, digital_lock_id, digital_lock_code_id, is_active, physical_credential_token, last_synced_at, sync_status, used_at, regenerated_at, regenerated_by, created_at, updated_at) VALUES
  ('a0000000-0000-0000-0000-000000000100', 'b0000000-0000-0000-0000-000000000001', 'CODE', 'Code temporaire Demo', 'MANUAL', 'Accès temporaire', '123456', NULL, NULL, ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '1 year'), ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '2 years'), NULL, NULL, NULL, true, NULL, NOW(), 'PENDING', NULL, NULL, NULL, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO digital_locks (id, name, type, status, unifi_door_controller_id, unifi_door_id, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'Porte chambre d''hôtes', 'UNIFI', 'ACTIVE', 'b0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000010', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440002', 'Porte Salle commune', 'UNIFI', 'ACTIVE', 'b0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000011', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO spaces (id, name, description, instructions, location, type, status, tenant_price, owner_price, cleaning_fee, deposit, currency, min_duration_days, max_duration_days, capacity, max_annual_reservations, used_annual_reservations, allowed_hours_start, allowed_hours_end, digital_lock_id, access_code_enabled, enable_notifications, cleaning_enabled, cleaning_days_after_checkout, cleaning_hour, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440111', 'Chambre d''hôtes', 'Chambre d''hôtes de démonstration pour deux personnes maximum. Literie, kitchenette équipée et rangements : idéal pour présenter une location courte durée type invités ou famille (données fictives NeoHoods).', 'La chambre se trouve au rez-de-chaussée du bâtiment principal. Vous recevez un code d''accès temporaire par e-mail au plus tard 24 h avant l''arrivée. Arrivée à partir de 15 h, départ au plus tard à 11 h. Ménage de fin de séjour selon la grille tarifaire.', 'Bâtiment principal, rez-de-chaussée', 'GUEST_ROOM', 'ACTIVE', 45.00, 0.00, 30.00, 0.00, 'EUR', 1, 5, 2, 12, 0, '15:00', '11:00', '550e8400-e29b-41d4-a716-446655440001', true, true, true, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440112', 'Salle commune', 'Salle commune équipée pour réunions de copropriété et moments conviviaux. Mobilier modulable, kitchenette et accès Wi-Fi résident (jeu de données démo).', 'La salle est au rez-de-chaussée, à côté des bureaux coworking. Réservez à l''avance : un code d''accès vous est envoyé par e-mail. Accès de 8 h à 20 h ; merci de remettre les tables en configuration d''origine et de vider les corbeilles en fin d''utilisation.', 'Bâtiment principal, rez-de-chaussée', 'COMMON_ROOM', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 1, NULL, 0, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440002', true, true, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440113', 'Bureau A', 'Bureau de coworking individuel pour télétravail. Poste ergonomique, prises, éclairage et Wi-Fi résident : espace calme pour se concentrer (démo NeoHoods).', 'Le bureau A est situé dans la salle commune. Vous recevez un code d''accès temporaire par e-mail 24 h avant votre créneau. Accès de 8 h à 20 h ; laissez le poste rangé et les surfaces propres en fin de réservation.', 'Bâtiment principal, salle commune — poste A', 'COWORKING', 'ACTIVE', 10.00, 10.00, 0.00, 0.00, 'EUR', 1, 5, 1, 10, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440002', true, true, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440114', 'Bureau B', 'Bureau de coworking individuel pour télétravail. Même équipement que le poste A (bureau, chaise, prises, Wi-Fi) avec tarif démo différencié.', 'Le bureau B est situé dans la salle commune. Code d''accès par e-mail 24 h avant le créneau. Accès 8 h–20 h ; respectez le calme des autres résidents et libérez le poste à l''heure prévue.', 'Bâtiment principal, salle commune — poste B', 'COWORKING', 'ACTIVE', 12.00, 12.00, 0.00, 0.00, 'EUR', 1, 5, 1, 10, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440002', true, true, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440116', 'Parking A', 'Place de parking couverte niveau -1 pour véhicule léger. Réservation à la journée jusqu''à 30 jours consécutifs (démo tarifaire).', 'La place A est située au sous-sol -1, allée principale. Accès par le portail du parking avec le code reçu par e-mail après réservation. Respectez le gabarit et la signalétique interne.', 'Sous-sol -1, allée A', 'PARKING', 'ACTIVE', 5.00, 0.00, 0.00, 0.00, 'EUR', 1, 30, 1, 0, 0, '00:00', '23:59', NULL, false, true, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440117', 'Parking B', 'Place de parking extérieure pour véhicule léger. Idéale pour présenter une seconde option de créneau et de tarif en démo.', 'La place B se trouve sur l''aire extérieure réservée aux résidents. Même modalité de réservation que les autres places : code ou badge selon configuration de la résidence (fictif).', 'Extérieur, aire résidents', 'PARKING', 'ACTIVE', 5.00, 0.00, 0.00, 0.00, 'EUR', 1, 30, 1, 0, 0, '00:00', '23:59', NULL, false, true, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440118', 'Parking C', 'Place couverte avec emplacement pour borne de recharge (véhicule compatible). Tarif démo légèrement supérieur pour illustrer la différenciation.', 'Sous-sol -1, zone équipée. Vérifiez la compatibilité de votre câble et respectez la charge maximale affichée sur la borne fictive. Libérez la place à la fin du créneau réservé.', 'Sous-sol -1, zone recharge', 'PARKING', 'ACTIVE', 6.00, 0.00, 0.00, 0.00, 'EUR', 1, 30, 1, 0, 0, '00:00', '23:59', NULL, false, true, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO spaces (id, name, description, instructions, location, type, status, tenant_price, owner_price, cleaning_fee, deposit, currency, min_duration_days, max_duration_days, capacity, max_annual_reservations, used_annual_reservations, allowed_hours_start, allowed_hours_end, digital_lock_id, access_code_enabled, enable_notifications, cleaning_enabled, cleaning_days_after_checkout, cleaning_hour, gym_settings, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440115', 'Salle de gym', 'Salle de sport de démonstration : tapis, renforcement et cardio léger. Permet de tester réservation à la journée et abonnements (Stripe en mode démo).', 'La salle se trouve au sous-sol. Réservez un créneau ou souscrivez un abonnement en ligne selon les options affichées. Respectez le matériel et les horaires d''ouverture ; aucune responsabilité sur les données d''entraînement fictives.', 'Sous-sol, local sport', 'GYM', 'ACTIVE', 12.00, 12.00, 0.00, 0.00, 'EUR', 1, 1, NULL, 0, 0, '06:00', '22:00', NULL, false, false, false, 0, '10:00', '{"subscriptionEnabled":true,"subscriptionOnly":false,"allowedSubscriptionDurations":["WEEK","MONTH"],"subscriptionTenantPrices":{"WEEK":15,"MONTH":45},"subscriptionOwnerPrices":{"WEEK":10,"MONTH":30}}'::jsonb, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO cleaning_companies (id, company_name, contact_first_name, contact_last_name, contact_email, contact_phone, created_at, updated_at) VALUES
  ('cc000000-0000-0000-0000-000000000001', 'Ménage Résidence Demo SAS', 'Camille', 'Dupuis', 'menage-residence-demo@example.com', '01.99.88.77.66', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

INSERT INTO cleaning_company_notification_emails (cleaning_company_id, email) VALUES
  ('cc000000-0000-0000-0000-000000000001', 'menage-residence-demo@example.com')
ON CONFLICT (cleaning_company_id, email) DO NOTHING;

UPDATE spaces SET cleaning_company_id = 'cc000000-0000-0000-0000-000000000001', cleaning_enabled = true
WHERE id IN (
  '550e8400-e29b-41d4-a716-446655440111',
  '550e8400-e29b-41d4-a716-446655440112',
  '550e8400-e29b-41d4-a716-446655440113',
  '550e8400-e29b-41d4-a716-446655440114',
  '550e8400-e29b-41d4-a716-446655440115'
);

-- Règlement utilisateur (aligné sur Flyway tenant V9 ; idempotent si colonnes déjà présentes)
ALTER TABLE spaces ADD COLUMN IF NOT EXISTS user_regulations_general_rules TEXT;
ALTER TABLE spaces ADD COLUMN IF NOT EXISTS user_regulations_safety_instructions TEXT;
ALTER TABLE spaces ADD COLUMN IF NOT EXISTS user_regulations_prohibited_items TEXT;
ALTER TABLE spaces ADD COLUMN IF NOT EXISTS user_regulations_additional_terms TEXT;

UPDATE spaces SET
    user_regulations_general_rules = 'Occupation limitée aux comptes du tenant Demo et à la capacité affichée (2 personnes maximum pour la chambre d''hôtes). Arrivée à partir de 15 h 00, départ au plus tard à 11 h 00. Merci de respecter le calme des parties communes.',
    user_regulations_safety_instructions = 'Ne pas obstruer les issues de secours. En cas d''urgence : 18 (pompiers), 17 (police). Signalez tout incident matériel au contact syndic figurant dans l''app (données fictives).',
    user_regulations_prohibited_items = 'Tabac et vapoteuses, bougies non surveillées, appareils de cuisson externes, animaux (sauf assistance validée), nuisances sonores après 22 h.',
    user_regulations_additional_terms = 'Les tarifs et cautions sont factices. Toute annulation tardive peut être simulée dans l''interface à des fins de test. Ne partagez pas vos codes d''accès avec des tiers.'
WHERE id = '550e8400-e29b-41d4-a716-446655440111';

UPDATE spaces SET
    user_regulations_general_rules = 'La salle est réservable par les résidents pour réunions et événements associatifs. Effectif conforme à la réservation et aux affichages de l''app (démo). Remettre le mobilier en configuration d''origine en fin d''utilisation.',
    user_regulations_safety_instructions = 'Respecter la capacité d''accueil. Issues de secours vers escaliers et sorties de secours signalées dans le plan de la résidence (fictif).',
    user_regulations_prohibited_items = 'Flammes nues, fumée (y compris vape), denrées très odorantes sans couvercle, revente d''alcool, travaux bruyants hors plage autorisée.',
    user_regulations_additional_terms = 'Le réservataire est responsable du bon déroulement du créneau. Tout dépassement d''horaire ou dégradation peut être refacturé dans le cadre de la démo.'
WHERE id = '550e8400-e29b-41d4-a716-446655440112';

UPDATE spaces SET
    user_regulations_general_rules = 'Un seul créneau actif par bureau. Connexion Wi-Fi réservée à un usage professionnel raisonnable (pas de contenus illégaux).',
    user_regulations_safety_instructions = 'Surveillez vos effets personnels ; les données de démo ne couvrent aucune assurance réelle. Ne bloquez pas les chemins d''évacuation.',
    user_regulations_prohibited_items = 'Appareils chauffants ou de cuisson, volume sonore excessif en visioconférence sans casque, occupation du poste au-delà de l''heure de fin.',
    user_regulations_additional_terms = 'Ne pas déplacer le mobilier hors du périmètre du poste. Tout dommage peut être simulé côté interface pour les tests.'
WHERE id = '550e8400-e29b-41d4-a716-446655440113';

UPDATE spaces SET
    user_regulations_general_rules = 'Mêmes règles que le bureau A : respect des créneaux, propreté du poste, téléphone en mode silencieux. Priorité au calme pour le télétravail de tous.',
    user_regulations_safety_instructions = 'Identiques au bureau A : dégagement des issues, effets personnels sous votre responsabilité, signalement de tout incident matériel.',
    user_regulations_prohibited_items = 'Identiques au bureau A : pas d''équipement chauffant ou de cuisson, usage raisonnable du matériel partagé.',
    user_regulations_additional_terms = 'En cas de réservation groupée, un référent unique peut être désigné pour l''état des lieux en fin de créneau (démo).'
WHERE id = '550e8400-e29b-41d4-a716-446655440114';

UPDATE spaces SET
    user_regulations_general_rules = 'La salle de sport est réservée aux résidents du tenant Demo. Respect des créneaux et du nombre de personnes affiché (capacité démo).',
    user_regulations_safety_instructions = 'Échauffement recommandé ; arrêtez en cas de douleur. Matériel à remettre en place après usage. Numéros d''urgence affichés sur la porte (fictifs).',
    user_regulations_prohibited_items = 'Travail sans échauffement excessif, charges non prévues, usage de la salle hors horaires d''ouverture, denrées ou verre brisé près des tapis.',
    user_regulations_additional_terms = 'Abonnements et pass journée sont des montants de démonstration. Aucun encaissement réel n''est effectué hors configuration Stripe de test.'
WHERE id = '550e8400-e29b-41d4-a716-446655440115';

UPDATE spaces SET
    user_regulations_general_rules = 'Les places sont attribuées selon les créneaux réservés. Un seul véhicule par place et par réservation.',
    user_regulations_safety_instructions = 'Respectez les sens de circulation du parking (schéma fictif). Allumez vos feux dans les rampes ; priorité aux piétons sur les trottoirs.',
    user_regulations_prohibited_items = 'Stockage de matériaux, réparations mécaniques salissantes, véhicules non assurés ou non immatriculés (données de test).',
    user_regulations_additional_terms = 'La résidence décline toute responsabilité pour vol ou dégradation dans le cadre de la démo. Libérez la place à l''heure de fin de créneau.'
WHERE id IN ('550e8400-e29b-41d4-a716-446655440116', '550e8400-e29b-41d4-a716-446655440117', '550e8400-e29b-41d4-a716-446655440118');

INSERT INTO space_images (id, space_id, url, alt_text, is_primary, order_index, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440211', '550e8400-e29b-41d4-a716-446655440111', '/assets/spaces/chambre-dhotes.jpg', 'Chambre d''hôtes', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440212', '550e8400-e29b-41d4-a716-446655440112', '/assets/spaces/common-space.jpg', 'Salle commune', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440213', '550e8400-e29b-41d4-a716-446655440113', '/assets/spaces/coworking.jpg', 'Bureau A', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440214', '550e8400-e29b-41d4-a716-446655440114', '/assets/spaces/coworking.jpg', 'Bureau B', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440215', '550e8400-e29b-41d4-a716-446655440115', '/assets/spaces/gym.jpg', 'Salle de gym', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440216', '550e8400-e29b-41d4-a716-446655440116', '/assets/spaces/parking.jpg', 'Parking A', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440217', '550e8400-e29b-41d4-a716-446655440117', '/assets/spaces/parking.jpg', 'Parking B', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440218', '550e8400-e29b-41d4-a716-446655440118', '/assets/spaces/parking.jpg', 'Parking C', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO space_allowed_days (space_id, day_of_week) VALUES
  ('550e8400-e29b-41d4-a716-446655440111', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440112', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440113', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440114', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440115', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440116', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440117', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440118', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'SUNDAY')
ON CONFLICT (space_id, day_of_week) DO NOTHING;

INSERT INTO reservations (id, space_id, user_id, unit_id, start_date, end_date, status, total_price, stripe_payment_intent_id, stripe_session_id, payment_status, created_at, updated_at) VALUES
  ('018ad10a-26f4-4e59-9d02-b6c2c4d576b2', '550e8400-e29b-41d4-a716-446655440112', 'b1000001-0000-4000-8000-000000000001', NULL, ('2026-01-15'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-01-15'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 0.00, 'pi_demo1', 'cs_demo1', 'SUCCEEDED', ('2026-01-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-01-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('5d384a1a-da20-488f-8865-b3862d651fc3', '550e8400-e29b-41d4-a716-446655440111', 'b1000001-0000-4000-8000-000000000002', '550e8400-e29b-41d4-a716-446655440100', ('2026-02-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-02-03'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 120.00, 'pi_demo2', 'cs_demo2', 'SUCCEEDED', ('2026-01-20 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-01-20 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000210', '550e8400-e29b-41d4-a716-446655440113', 'b1000001-0000-4000-8000-000000000006', '550e8400-e29b-41d4-a716-446655440102', ('2025-11-10'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2025-11-12'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 20.00, 'pi_demo210', 'cs_demo210', 'SUCCEEDED', ('2025-11-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-11-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000211', '550e8400-e29b-41d4-a716-446655440114', 'b1000001-0000-4000-8000-000000000007', '550e8400-e29b-41d4-a716-446655440103', ('2025-12-05'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2025-12-09'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 48.00, 'pi_demo211', 'cs_demo211', 'SUCCEEDED', ('2025-12-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-12-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000212', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000015', NULL, ('2026-03-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-03-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 12.00, 'pi_demo212', 'cs_demo212', 'SUCCEEDED', ('2026-02-28 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-02-28 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000213', '550e8400-e29b-41d4-a716-446655440116', 'b1000001-0000-4000-8000-000000000008', '550e8400-e29b-41d4-a716-446655440304', ('2026-04-12'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-14'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 10.00, 'pi_demo213', 'cs_demo213', 'SUCCEEDED', ('2026-04-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000214', '550e8400-e29b-41d4-a716-446655440117', 'b1000001-0000-4000-8000-000000000009', '550e8400-e29b-41d4-a716-446655440305', ('2026-05-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-05-05'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 20.00, 'pi_demo214', 'cs_demo214', 'SUCCEEDED', ('2026-04-25 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-25 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000215', '550e8400-e29b-41d4-a716-446655440118', 'b1000001-0000-4000-8000-000000000001', '550e8400-e29b-41d4-a716-446655440406', ('2026-05-20'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-05-22'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 12.00, 'pi_demo215', 'cs_demo215', 'SUCCEEDED', ('2026-05-10 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-10 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000216', '550e8400-e29b-41d4-a716-446655440111', 'b1000001-0000-4000-8000-000000000010', NULL, ('2025-10-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2025-10-03'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 90.00, 'pi_demo216', 'cs_demo216', 'SUCCEEDED', ('2025-09-20 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-09-20 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000217', '550e8400-e29b-41d4-a716-446655440112', 'b1000001-0000-4000-8000-000000000011', NULL, ('2026-06-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-06-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 0.00, 'pi_demo217', 'cs_demo217', 'SUCCEEDED', ('2026-05-15 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-15 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000218', '550e8400-e29b-41d4-a716-446655440113', 'b1000001-0000-4000-8000-000000000012', '550e8400-e29b-41d4-a716-446655440401', ('2026-01-08'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-01-10'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 20.00, 'pi_demo218', 'cs_demo218', 'SUCCEEDED', ('2026-01-02 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-01-02 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000219', '550e8400-e29b-41d4-a716-446655440114', 'b1000001-0000-4000-8000-000000000013', '550e8400-e29b-41d4-a716-446655440402', ('2026-02-14'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-02-18'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 48.00, 'pi_demo219', 'cs_demo219', 'SUCCEEDED', ('2026-02-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-02-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-00000000021a', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000014', NULL, ('2026-04-10'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-10'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 12.00, 'pi_demo21a', 'cs_demo21a', 'SUCCEEDED', ('2026-04-09 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-09 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-00000000021b', '550e8400-e29b-41d4-a716-446655440111', 'b1000001-0000-4000-8000-000000000003', '550e8400-e29b-41d4-a716-446655440101', ('2026-07-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-07-04'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 135.00, 'pi_demo21b', 'cs_demo21b', 'SUCCEEDED', ('2026-06-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-06-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-00000000021c', '550e8400-e29b-41d4-a716-446655440112', 'b1000001-0000-4000-8000-000000000004', NULL, ('2025-08-20'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2025-08-20'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 0.00, 'pi_demo21c', 'cs_demo21c', 'SUCCEEDED', ('2025-08-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-08-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-00000000021d', '550e8400-e29b-41d4-a716-446655440113', 'b1000001-0000-4000-8000-000000000002', '550e8400-e29b-41d4-a716-446655440100', ('2026-08-10'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-08-12'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 20.00, 'pi_demo21d', 'cs_demo21d', 'SUCCEEDED', ('2026-08-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-08-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-00000000021e', '550e8400-e29b-41d4-a716-446655440114', 'b1000001-0000-4000-8000-000000000001', NULL, ('2026-09-01'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-09-05'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 48.00, 'pi_demo21e', 'cs_demo21e', 'SUCCEEDED', ('2026-08-20 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-08-20 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'))
ON CONFLICT (id) DO NOTHING;

-- Volume CA admin : réservations factices additionnelles (toujours ancrées _demo_seed_ctx).
INSERT INTO reservations (id, space_id, user_id, unit_id, start_date, end_date, status, total_price, stripe_payment_intent_id, stripe_session_id, payment_status, created_at, updated_at) VALUES
  ('c1d00000-0000-4000-8000-000000000001', '550e8400-e29b-41d4-a716-446655440111', 'b1000001-0000-4000-8000-000000000006', '550e8400-e29b-41d4-a716-446655440102', ('2026-04-10'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-12'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_01', 'cs_c1_01', 'SUCCEEDED', ('2026-04-09 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-12 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-000000000002', '550e8400-e29b-41d4-a716-446655440112', 'b1000001-0000-4000-8000-000000000006', NULL, ('2026-04-14'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-14'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_02', 'cs_c1_02', 'SUCCEEDED', ('2026-04-14 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-14 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-000000000003', '550e8400-e29b-41d4-a716-446655440113', 'b1000001-0000-4000-8000-000000000006', '550e8400-e29b-41d4-a716-446655440102', ('2026-04-16'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-16'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_03', 'cs_c1_03', 'SUCCEEDED', ('2026-04-16 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-16 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-000000000004', '550e8400-e29b-41d4-a716-446655440114', 'b1000001-0000-4000-8000-000000000002', '550e8400-e29b-41d4-a716-446655440100', ('2026-04-18'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-19'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_04', 'cs_c1_04', 'SUCCEEDED', ('2026-04-18 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-19 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-000000000005', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000008', NULL, ('2026-04-20'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-20'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_05', 'cs_c1_05', 'SUCCEEDED', ('2026-04-20 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-20 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-000000000006', '550e8400-e29b-41d4-a716-446655440116', 'b1000001-0000-4000-8000-000000000016', '550e8400-e29b-41d4-a716-446655440405', ('2026-04-22'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-25'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_06', 'cs_c1_06', 'SUCCEEDED', ('2026-04-22 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-25 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-000000000007', '550e8400-e29b-41d4-a716-446655440117', 'b1000001-0000-4000-8000-000000000011', NULL, ('2026-04-26'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-04-28'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_07', 'cs_c1_07', 'SUCCEEDED', ('2026-04-26 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-28 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-000000000008', '550e8400-e29b-41d4-a716-446655440118', 'b1000001-0000-4000-8000-000000000012', NULL, ('2026-04-30'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-05-02'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_08', 'cs_c1_08', 'SUCCEEDED', ('2026-04-30 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-02 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-000000000009', '550e8400-e29b-41d4-a716-446655440111', 'b1000001-0000-4000-8000-000000000003', '550e8400-e29b-41d4-a716-446655440101', ('2026-05-04'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-05-06'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_09', 'cs_c1_09', 'SUCCEEDED', ('2026-05-04 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-06 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-00000000000a', '550e8400-e29b-41d4-a716-446655440112', 'b1000001-0000-4000-8000-000000000014', NULL, ('2026-05-08'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-05-08'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_0a', 'cs_c1_0a', 'SUCCEEDED', ('2026-05-08 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-08 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-00000000000b', '550e8400-e29b-41d4-a716-446655440113', 'b1000001-0000-4000-8000-000000000007', '550e8400-e29b-41d4-a716-446655440102', ('2026-05-10'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-05-12'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_0b', 'cs_c1_0b', 'SUCCEEDED', ('2026-05-10 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-12 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-00000000000c', '550e8400-e29b-41d4-a716-446655440114', 'b1000001-0000-4000-8000-000000000013', '550e8400-e29b-41d4-a716-446655440101', ('2026-05-14'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-05-15'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_0c', 'cs_c1_0c', 'SUCCEEDED', ('2026-05-14 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-15 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('c1d00000-0000-4000-8000-00000000000d', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000009', NULL, ('2026-05-16'::date + (SELECT day_offset FROM _demo_seed_ctx)), ('2026-05-16'::date + (SELECT day_offset FROM _demo_seed_ctx)), 'CONFIRMED', 98.00, 'pi_c1_0d', 'cs_c1_0d', 'SUCCEEDED', ('2026-05-16 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-05-16 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'))
ON CONFLICT (id) DO NOTHING;


INSERT INTO space_settings (id, platform_fee_percentage, platform_fixed_fee, created_at, updated_at)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 2.00, 0.25, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (id) DO NOTHING;

UPDATE reservations
SET platform_fee_amount = ROUND((total_price - COALESCE(s.cleaning_fee, 0)) * 0.02, 2), platform_fixed_fee_amount = 0.25
FROM spaces s
WHERE reservations.space_id = s.id AND reservations.platform_fee_amount IS NULL;

INSERT INTO reservation_audit_log (id, reservation_id, event_type, old_value, new_value, log_message, performed_by, created_at) VALUES
  ('e0000000-0000-4000-8000-000000000001', '5d384a1a-da20-488f-8865-b3862d651fc3', 'STATUS_CHANGE', 'PENDING', 'CONFIRMED', 'Confirmation après paiement (démo).', 'b1000001-0000-4000-8000-000000000001', ('2026-01-20 09:05:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('e0000000-0000-4000-8000-000000000002', '5d384a1a-da20-488f-8865-b3862d651fc3', 'CODE_GENERATED', NULL, '****', 'Code d''accès généré (démo).', 'b1000001-0000-4000-8000-000000000001', ('2026-01-20 09:06:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('e0000000-0000-4000-8000-000000000003', '5d384a1a-da20-488f-8865-b3862d651fc3', 'PAYMENT_RECEIVED', 'UNPAID', 'SUCCEEDED', 'Paiement Stripe reçu (environnement test).', 'SYSTEM', ('2026-01-20 09:04:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('e0000000-0000-4000-8000-000000000004', 'b0000000-0000-4000-8000-000000000210', 'STATUS_CHANGE', 'PENDING', 'CONFIRMED', 'Réservation coworking confirmée.', 'b1000001-0000-4000-8000-000000000001', ('2025-11-01 08:30:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('e0000000-0000-4000-8000-000000000005', 'b0000000-0000-4000-8000-000000000215', 'CODE_GENERATED', NULL, '****', 'Code parking syndic (démo).', 'b1000001-0000-4000-8000-000000000001', ('2026-05-10 11:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('e0000000-0000-4000-8000-000000000006', 'c1d00000-0000-4000-8000-000000000001', 'PAYMENT_RECEIVED', 'PENDING', 'SUCCEEDED', 'Paiement lot factice CA admin.', 'SYSTEM', ('2026-04-09 10:15:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'))
ON CONFLICT (id) DO NOTHING;

-- Gym: exactement 6 abonnements ACTIVE (utilisateurs distincts), fenêtre centrée sur la date du seed.
INSERT INTO space_gym_subscriptions (id, space_id, user_id, duration, start_date, end_date, status, total_price, stripe_payment_intent_id, stripe_session_id, created_at, updated_at) VALUES
  ('b0000000-0000-4000-8000-000000000301', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000002', 'MONTH', (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date + (SELECT day_offset FROM _demo_seed_ctx)), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '1 month - 1 day')::date + (SELECT day_offset FROM _demo_seed_ctx)), 'ACTIVE', 45.00, 'pi_gym301', 'cs_gym301', (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000302', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000003', 'WEEK', ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date - 7 + (SELECT day_offset FROM _demo_seed_ctx)), ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date + 7 + (SELECT day_offset FROM _demo_seed_ctx)), 'ACTIVE', 15.00, 'pi_gym302', 'cs_gym302', ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '8 days'), ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '8 days')),
  ('b0000000-0000-4000-8000-000000000303', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000006', 'MONTH', (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date - 32 + (SELECT day_offset FROM _demo_seed_ctx)), (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date + 120 + (SELECT day_offset FROM _demo_seed_ctx)), 'ACTIVE', 45.00, 'pi_gym303', 'cs_gym303', (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '32 days' + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '32 days' + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000304', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000008', 'MONTH', (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date + (SELECT day_offset FROM _demo_seed_ctx)), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '2 month - 1 day')::date + (SELECT day_offset FROM _demo_seed_ctx)), 'ACTIVE', 45.00, 'pi_gym304', 'cs_gym304', (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000305', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000011', 'MONTH', (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date + (SELECT day_offset FROM _demo_seed_ctx)), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '1 month - 1 day')::date + (SELECT day_offset FROM _demo_seed_ctx)), 'ACTIVE', 45.00, 'pi_gym305', 'cs_gym305', (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), (date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('b0000000-0000-4000-8000-000000000306', '550e8400-e29b-41d4-a716-446655440115', 'b1000001-0000-4000-8000-000000000012', 'WEEK', ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date - 2 + (SELECT day_offset FROM _demo_seed_ctx)), ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::date + 5 + (SELECT day_offset FROM _demo_seed_ctx)), 'ACTIVE', 15.00, 'pi_gym306', 'cs_gym306', ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '3 days'), ((CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '3 days'))
ON CONFLICT (id) DO NOTHING;

INSERT INTO announcement_attachments (id, announcement_id, s3_key, original_filename, content_type, byte_size) VALUES
  ('aa000000-0000-0000-0000-000000000001', '550e8400-e29b-41d4-a716-446655440034', 'announcements/seed/aa001_ecrans-en-cours.jpg', 'ecrans-en-cours.jpg', 'image/jpeg', 0),
  ('aa000000-0000-0000-0000-000000000002', '550e8400-e29b-41d4-a716-446655440031', 'announcements/seed/aa002_fetes-voisin-2026.jpg', 'fetes-voisin-2026.jpg', 'image/jpeg', 0),
  ('aa000000-0000-0000-0000-000000000003', '550e8400-e29b-41d4-a716-446655440032', 'announcements/seed/aa003_encombrants.pdf', '15.01.26 Note encombrants.pdf', 'application/pdf', 0),
  ('aa000000-0000-0000-0000-000000000004', '550e8400-e29b-41d4-a716-446655440033', 'announcements/seed/aa004_reglement.pdf', 'Regle_bien_vivre_compresse.pdf', 'application/pdf', 0),
  ('aa000000-0000-0000-0000-000000000005', '550e8400-e29b-41d4-a716-446655440041', 'announcements/seed/aa005_horizon-logo.png', 'horizon-logo.png', 'image/png', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO incidents (id, title, description, status, priority, visibility, impact_level, location_scope, location_ref, owner_id, created_by, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440501', 'Fuite d''eau cage A', 'Infiltration plafond palier 3 (données fictives).', 'OPEN', 'URGENT', 'EVERYONE', 'HIGH', 'COMMON_AREA', 'Palier 3', NULL, 'b1000001-0000-4000-8000-000000000001', ('2025-10-05 09:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-10-06 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('550e8400-e29b-41d4-a716-446655440502', 'Ascenseur B — arrêt intempestif', 'Cabine bloquée entre 2e et 3e (prestataire Otis notifié, démo).', 'WAITING_EXTERNAL', 'HIGH', 'EVERYONE', 'HIGH', 'BUILDING', 'Ascenseur B', NULL, 'b1000001-0000-4000-8000-000000000002', ('2025-11-12 14:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-11-13 08:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('550e8400-e29b-41d4-a716-446655440503', 'Portail parking — ouverture lente', 'Vérification motorisation et cellules photoélectriques.', 'WAITING_INTERNAL', 'MEDIUM', 'EVERYONE', 'MEDIUM', 'GARAGE', 'Accès parking', 'b1000001-0000-4000-8000-000000000016', 'b1000001-0000-4000-8000-000000000016', ('2025-12-01 11:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2025-12-02 09:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('550e8400-e29b-41d4-a716-446655440504', 'VMC cuisine — Appart 5', 'Bruit anormal et débit faible (lot loué, démo).', 'OPEN', 'MEDIUM', 'OWNER', 'MEDIUM', 'UNIT', 'Appart 5', 'b1000001-0000-4000-8000-000000000010', 'b1000001-0000-4000-8000-000000000011', ('2026-01-20 08:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-01-21 09:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('550e8400-e29b-41d4-a716-446655440505', 'Nuisances sonores soirée', 'Signalement voisins 4e étage (données fictives).', 'OPEN', 'LOW', 'BOARD_MEMBER', 'LOW', 'BUILDING', 'Palier 4', NULL, 'b1000001-0000-4000-8000-000000000006', ('2026-03-10 21:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-03-11 08:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('550e8400-e29b-41d4-a716-446655440506', 'Caméra hall — angle à ajuster', 'Champ de vision partiellement occulté par décoration provisoire.', 'RESOLVED', 'LOW', 'EVERYONE', 'LOW', 'COMMON_AREA', 'Hall principal', NULL, 'b1000001-0000-4000-8000-000000000001', ('2026-04-02 10:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-04-05 16:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'))
ON CONFLICT (id) DO NOTHING;

INSERT INTO newsletters (id, subject, content, status, created_at, updated_at, sent_at, created_by, recipient_count, audience_type) VALUES
  ('550e8400-e29b-41d4-a716-446655440601', ('Newsletter démo — ' || to_char((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '4 months' + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day', 'YYYY-MM')), '<p>Actualités factices du mois (démo NeoHoods).</p>', 'SENT', ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '4 months' + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '4 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '4 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'b1000001-0000-4000-8000-000000000001', 42, 'ALL'),
  ('550e8400-e29b-41d4-a716-446655440602', ('Newsletter démo — ' || to_char((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '3 months' + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day', 'YYYY-MM')), '<p>Chaufferie et vie du bâtiment (fictif).</p>', 'SENT', ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '3 months' + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '3 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '3 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'b1000001-0000-4000-8000-000000000001', 43, 'ALL'),
  ('550e8400-e29b-41d4-a716-446655440603', ('Newsletter démo — ' || to_char((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '2 months' + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day', 'YYYY-MM')), '<p>Rappel collecte et espaces réservables (démo).</p>', 'SENT', ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '2 months' + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '2 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '2 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'b1000001-0000-4000-8000-000000000001', 44, 'ALL'),
  ('550e8400-e29b-41d4-a716-446655440604', ('Newsletter démo — ' || to_char((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '1 month' + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day', 'YYYY-MM')), '<p>Travaux façade et stationnement (fictif).</p>', 'SENT', ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '1 month' + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '1 month' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '1 month' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'b1000001-0000-4000-8000-000000000001', 45, 'ALL'),
  ('550e8400-e29b-41d4-a716-446655440605', ('Newsletter démo — ' || to_char((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day', 'YYYY-MM')), '<p>Conseil syndical et projets (démonstration).</p>', 'SENT', ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '4 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'b1000001-0000-4000-8000-000000000001', 46, 'ALL')
ON CONFLICT (id) DO NOTHING;

INSERT INTO newsletter_logs (id, newsletter_id, user_id, user_email, status, sent_at, created_at) VALUES
  ('f1000000-0000-4000-8000-000000000001', '550e8400-e29b-41d4-a716-446655440603', 'b1000001-0000-4000-8000-000000000002', 'alice.anderson@demo.example.com', 'SENT', ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '2 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '2 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('f1000000-0000-4000-8000-000000000002', '550e8400-e29b-41d4-a716-446655440603', 'b1000001-0000-4000-8000-000000000006', 'eric.etienne@demo.example.com', 'SENT', ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '2 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - interval '2 months' + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day')),
  ('f1000000-0000-4000-8000-000000000003', '550e8400-e29b-41d4-a716-446655440605', 'b1000001-0000-4000-8000-000000000016', 'nina.nguyen@demo.example.com', 'SENT', ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ((date_trunc('month', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + interval '5 days') + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'))
ON CONFLICT (id) DO NOTHING;

UPDATE users
SET primary_unit_id = (
  SELECT um.unit_id FROM unit_members um
  WHERE um.user_id = users.id
  ORDER BY um.joined_at ASC, um.unit_id ASC
  LIMIT 1
)
WHERE primary_unit_id IS NULL
AND EXISTS (SELECT 1 FROM unit_members um WHERE um.user_id = users.id);

INSERT INTO tv_info (type, enabled, display_duration_seconds) VALUES
  ('ANNOUNCEMENT', true, 10), ('WELCOME', true, 10), ('STATIC', true, 10), ('SPACE', true, 10)
ON CONFLICT (type) DO NOTHING;

INSERT INTO tv_info_welcome (display_days, enabled)
SELECT 7, true
WHERE NOT EXISTS (SELECT 1 FROM tv_info_welcome);

INSERT INTO tv_info_static (content_type, display_days, enabled) VALUES
  ('ELEMENT_PROMO', 30, true), ('PORTAL_PROMO', 30, true), ('ALFRED_PROMO', 30, true)
ON CONFLICT (content_type) DO UPDATE SET
  display_days = EXCLUDED.display_days,
  enabled = EXCLUDED.enabled;

INSERT INTO tv_info_spaces (display_days, show_calendar, show_rules, show_stats, show_essential_info, enabled)
SELECT 7, true, true, false, true, true
WHERE NOT EXISTS (SELECT 1 FROM tv_info_spaces);

INSERT INTO tv_slide_designs (name, background_type, background_value, corner_element_type, corner_element_position, icon_position, enabled) VALUES
  ('default', 'GRADIENT', 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', 'LEAVES', 'top-left,top-right', 'TOP_LEFT', true)
ON CONFLICT (name) DO NOTHING;

-- 5 diapos TV : une par annonce avec pièce jointe seed (aa001–aa005).
INSERT INTO tv_info_announcements (announcement_id, tv_enabled, display_days, start_date, end_date, tv_attachment_id, tv_pdf_page) VALUES
  ('550e8400-e29b-41d4-a716-446655440031', true, 10, ('2026-04-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-12-31 23:59:59+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'aa000000-0000-0000-0000-000000000002', NULL),
  ('550e8400-e29b-41d4-a716-446655440032', true, 10, ('2026-01-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-12-31 23:59:59+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'aa000000-0000-0000-0000-000000000003', 1),
  ('550e8400-e29b-41d4-a716-446655440033', true, 10, ('2025-09-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-12-31 23:59:59+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'aa000000-0000-0000-0000-000000000004', 1),
  ('550e8400-e29b-41d4-a716-446655440034', true, 10, ('2026-01-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-12-31 23:59:59+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'aa000000-0000-0000-0000-000000000001', NULL),
  ('550e8400-e29b-41d4-a716-446655440041', true, 10, ('2026-03-01 00:00:00+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), ('2026-12-31 23:59:59+00'::timestamptz + (SELECT day_offset FROM _demo_seed_ctx) * interval '1 day'), 'aa000000-0000-0000-0000-000000000005', NULL)
ON CONFLICT (announcement_id) DO UPDATE SET
  tv_enabled = EXCLUDED.tv_enabled,
  display_days = EXCLUDED.display_days,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date,
  tv_attachment_id = EXCLUDED.tv_attachment_id,
  tv_pdf_page = EXCLUDED.tv_pdf_page,
  updated_at = CURRENT_TIMESTAMP;

-- Activity sample rows: classpath db/tenant-seed/demo/data-demo-activity-events.sql (see DemoTenantDataService).

