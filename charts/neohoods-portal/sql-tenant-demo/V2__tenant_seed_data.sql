-- Tenant demo seed data (ex-V2; former V2__data_demo.sql)
-- Source lineage: neoportal-app/db/postgres/tenant/data-demo.sql
-- Adapted for full tenant users table (id, username, email, password, ...). SSO placeholder for password.

INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, is_email_verified, disabled, status, user_type, is_board_member, primary_unit_id)
VALUES
  ('b1000001-0000-4000-8000-000000000001', 'demo', 'demo@demo.example.com', '', 'Demo', 'Admin', '1', '1 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'ADMIN', false, NULL),
  ('b1000001-0000-4000-8000-000000000002', 'demo_marie', 'marie.dubois@demo.example.com', '', 'Marie', 'Dubois', '2', '2 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'OWNER', false, NULL),
  ('b1000001-0000-4000-8000-000000000003', 'demo_pierre', 'pierre.martin@demo.example.com', '', 'Pierre', 'Martin', '3', '3 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL),
  ('b1000001-0000-4000-8000-000000000004', 'demo_lea', 'lea.bernard@demo.example.com', '', 'Léa', 'Bernard', '4', '4 Place Demo', 'Ville Demo', '69000', 'France', 'fr', true, false, 'ACTIVE', 'TENANT', false, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO units (id, name, type, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440100', 'Appart 1', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440101', 'Appart 2', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');

INSERT INTO unit_members (id, unit_id, user_id, role, residence_role, joined_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440200', '550e8400-e29b-41d4-a716-446655440100', 'b1000001-0000-4000-8000-000000000001', 'ADMIN', 'PROPRIETAIRE', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440201', '550e8400-e29b-41d4-a716-446655440100', 'b1000001-0000-4000-8000-000000000002', 'MEMBER', 'TENANT', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440202', '550e8400-e29b-41d4-a716-446655440101', 'b1000001-0000-4000-8000-000000000003', 'ADMIN', 'PROPRIETAIRE', '2024-01-10 10:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655440101', 'b1000001-0000-4000-8000-000000000004', 'MEMBER', 'TENANT', '2024-01-10 10:00:00+00');

INSERT INTO infos (id, next_ag_date, rules_url, emails_enabled) VALUES ('00000000-0000-0000-0000-000000000001', '2025-06-01 10:00:00+00', 'https://demo.example.com/reglement', true);

INSERT INTO delegates (id, info_id, building, first_name, last_name, email, matrix_user) VALUES
  ('550e8400-e29b-41d4-a716-446655440010', '00000000-0000-0000-0000-000000000001', 'Résidence Demo', 'Jean', 'Demo', 'jean.demo@demo.example.com', '@jeandemo:matrix.org');

INSERT INTO contact_numbers (id, info_id, contact_type, type, description, availability, response_time, name, phone_number, email, responsibility, metadata, qr_code_url) VALUES
  ('550e8400-e29b-41d4-a716-446655440010', '00000000-0000-0000-0000-000000000001', 'syndic', 'Responsable', 'Syndic Demo', 'Lun-Ven 9h-17h', '24h', 'M. Demo Syndic', '01.23.45.67.89', 'syndic@demo.example.com', NULL, NULL, NULL);

INSERT INTO announcements (id, title, content, summary, created_at, updated_at, category) VALUES
  ('550e8400-e29b-41d4-a716-446655440030', 'Bienvenue sur Demo', 'Environnement de démonstration NeoHoods : chambre d''hôtes, salle commune, deux bureaux coworking, gym, trois places de parking. Données fictives.', NULL, '2024-01-15 10:00:00+00', '2024-01-15 10:00:00+00', 'COMMUNITY_EVENT');

INSERT INTO custom_pages (id, ref, page_order, position, title, content) VALUES
  ('550e8400-e29b-41d4-a716-446655440040', 'privacy-policy', 1, 'FOOTER_LINKS', 'Politique de Confidentialité', '<p>Politique de confidentialité Demo.</p>'),
  ('550e8400-e29b-41d4-a716-446655440041', 'terms-of-service', 2, 'FOOTER_LINKS', 'Conditions d''Utilisation', '<p>Conditions d''utilisation Demo.</p>'),
  ('550e8400-e29b-41d4-a716-446655440043', 'copyright-notice', 1, 'COPYRIGHT', 'Mentions Légales', '<p>&copy; 2024 NeoHoods Demo.</p>'),
  ('550e8400-e29b-41d4-a716-446655440044', 'help-contact', 1, 'FOOTER_HELP', 'Support', '<p>Contact : support@neohoods.com</p>');

INSERT INTO email_templates (id, type, name, subject, content, is_active, created_at, updated_at, created_by, description) VALUES
  ('550e8400-e29b-41d4-a716-446655440060', 'WELCOME', 'Welcome Email - Default', 'Welcome to {{appName}}!', '<p>Thank you for joining {{appName}}.</p>', true, '2024-01-10 14:30:00+00', '2024-01-10 14:30:00+00', 'b1000001-0000-4000-8000-000000000001', 'Default welcome email');

INSERT INTO settings (id, is_registration_enabled) VALUES ('00000000-0000-0000-0000-000000000001', false);

INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES
  ('b1000001-0000-4000-8000-000000000001', true, false),
  ('b1000001-0000-4000-8000-000000000002', true, false),
  ('b1000001-0000-4000-8000-000000000003', false, false),
  ('b1000001-0000-4000-8000-000000000004', false, false)
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO help_categories (id, name, icon, display_order) VALUES ('a970dc49-aca8-4508-8182-0bb3e3de8c1d', 'Demo', '@tui.message-circle', 1);
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES
  ('f346a7fd-086c-4226-8f7b-6b80f93657cb', 'Comment utiliser Demo', '<p>Ce tenant demo couvre les principaux types d''espaces : chambre d''hôtes, salle commune, coworking (bureaux A et B), gym (abonnements), parkings.</p>', 1, 'a970dc49-aca8-4508-8182-0bb3e3de8c1d');

INSERT INTO unifi_door_controllers (id, controller_id, name, model, last_seen, created_at, updated_at) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'main-controller', 'Contrôleur Demo', 'UD-Pro', NOW(), '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (controller_id) DO UPDATE SET name = EXCLUDED.name, model = EXCLUDED.model, updated_at = EXCLUDED.updated_at;

INSERT INTO unifi_doors (id, door_controller_id, door_id, name, description, last_seen, created_at, updated_at) VALUES
  ('b0000000-0000-0000-0000-000000000010', 'b0000000-0000-0000-0000-000000000001', 'door-1', 'Chambre d''hôtes', 'Porte de la chambre d''hôtes', NOW(), '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('b0000000-0000-0000-0000-000000000011', 'b0000000-0000-0000-0000-000000000001', 'door-2', 'Salle commune', 'Porte de la salle commune', NOW(), '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT (door_controller_id, door_id) DO NOTHING;

INSERT INTO digital_door_credentials (id, unifi_door_controller_id, type, name, origin, label, code, vigik_badge_number, unit_id, activation_date, expiration_date, reservation_id, digital_lock_id, digital_lock_code_id, is_active, physical_credential_token, last_synced_at, sync_status, used_at, regenerated_at, regenerated_by, created_at, updated_at) VALUES
  ('a0000000-0000-0000-0000-000000000100', 'b0000000-0000-0000-0000-000000000001', 'CODE', 'Code temporaire Demo', 'MANUAL', 'Accès temporaire', '123456', NULL, NULL, '2024-01-01 00:00:00+00', '2025-12-31 23:59:59+00', NULL, NULL, NULL, true, NULL, NOW(), 'PENDING', NULL, NULL, NULL, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00')
ON CONFLICT DO NOTHING;

INSERT INTO digital_locks (id, name, type, status, unifi_door_controller_id, unifi_door_id, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'Porte chambre d''hôtes', 'UNIFI', 'ACTIVE', 'b0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000010', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440002', 'Porte Salle commune', 'UNIFI', 'ACTIVE', 'b0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000011', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00');

INSERT INTO spaces (id, name, description, instructions, location, type, status, tenant_price, owner_price, cleaning_fee, deposit, currency, min_duration_days, max_duration_days, capacity, max_annual_reservations, used_annual_reservations, allowed_hours_start, allowed_hours_end, digital_lock_id, access_code_enabled, enable_notifications, cleaning_enabled, cleaning_email, cleaning_notifications_enabled, cleaning_calendar_enabled, cleaning_days_after_checkout, cleaning_hour, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440111', 'Chambre d''hôtes', 'Chambre d''hôtes de démonstration pour deux personnes maximum. Literie, kitchenette équipée et rangements : idéal pour présenter une location courte durée type invités ou famille (données fictives NeoHoods).', 'La chambre se trouve au rez-de-chaussée du bâtiment principal. Vous recevez un code d''accès temporaire par e-mail au plus tard 24 h avant l''arrivée. Arrivée à partir de 15 h, départ au plus tard à 11 h. Ménage de fin de séjour selon la grille tarifaire.', 'Bâtiment principal, rez-de-chaussée', 'GUEST_ROOM', 'ACTIVE', 45.00, 0.00, 30.00, 0.00, 'EUR', 1, 5, 2, 12, 0, '15:00', '11:00', '550e8400-e29b-41d4-a716-446655440001', true, true, true, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440112', 'Salle commune', 'Salle commune équipée pour réunions de copropriété et moments conviviaux. Mobilier modulable, kitchenette et accès Wi-Fi résident (jeu de données démo).', 'La salle est au rez-de-chaussée, à côté des bureaux coworking. Réservez à l''avance : un code d''accès vous est envoyé par e-mail. Accès de 8 h à 20 h ; merci de remettre les tables en configuration d''origine et de vider les corbeilles en fin d''utilisation.', 'Bâtiment principal, rez-de-chaussée', 'COMMON_ROOM', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 1, NULL, 0, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440002', true, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440113', 'Bureau A', 'Bureau de coworking individuel pour télétravail. Poste ergonomique, prises, éclairage et Wi-Fi résident : espace calme pour se concentrer (démo NeoHoods).', 'Le bureau A est situé dans la salle commune. Vous recevez un code d''accès temporaire par e-mail 24 h avant votre créneau. Accès de 8 h à 20 h ; laissez le poste rangé et les surfaces propres en fin de réservation.', 'Bâtiment principal, salle commune — poste A', 'COWORKING', 'ACTIVE', 10.00, 10.00, 0.00, 0.00, 'EUR', 1, 5, 1, 10, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440002', true, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440114', 'Bureau B', 'Bureau de coworking individuel pour télétravail. Même équipement que le poste A (bureau, chaise, prises, Wi-Fi) avec tarif démo différencié.', 'Le bureau B est situé dans la salle commune. Code d''accès par e-mail 24 h avant le créneau. Accès 8 h–20 h ; respectez le calme des autres résidents et libérez le poste à l''heure prévue.', 'Bâtiment principal, salle commune — poste B', 'COWORKING', 'ACTIVE', 12.00, 12.00, 0.00, 0.00, 'EUR', 1, 5, 1, 10, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440002', true, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440116', 'Parking A', 'Place de parking couverte niveau -1 pour véhicule léger. Réservation à la journée jusqu''à 30 jours consécutifs (démo tarifaire).', 'La place A est située au sous-sol -1, allée principale. Accès par le portail du parking avec le code reçu par e-mail après réservation. Respectez le gabarit et la signalétique interne.', 'Sous-sol -1, allée A', 'PARKING', 'ACTIVE', 5.00, 0.00, 0.00, 0.00, 'EUR', 1, 30, 1, 0, 0, '00:00', '23:59', NULL, false, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440117', 'Parking B', 'Place de parking extérieure pour véhicule léger. Idéale pour présenter une seconde option de créneau et de tarif en démo.', 'La place B se trouve sur l''aire extérieure réservée aux résidents. Même modalité de réservation que les autres places : code ou badge selon configuration de la résidence (fictif).', 'Extérieur, aire résidents', 'PARKING', 'ACTIVE', 5.00, 0.00, 0.00, 0.00, 'EUR', 1, 30, 1, 0, 0, '00:00', '23:59', NULL, false, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
  ('550e8400-e29b-41d4-a716-446655440118', 'Parking C', 'Place couverte avec emplacement pour borne de recharge (véhicule compatible). Tarif démo légèrement supérieur pour illustrer la différenciation.', 'Sous-sol -1, zone équipée. Vérifiez la compatibilité de votre câble et respectez la charge maximale affichée sur la borne fictive. Libérez la place à la fin du créneau réservé.', 'Sous-sol -1, zone recharge', 'PARKING', 'ACTIVE', 6.00, 0.00, 0.00, 0.00, 'EUR', 1, 30, 1, 0, 0, '00:00', '23:59', NULL, false, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00');

INSERT INTO spaces (id, name, description, instructions, location, type, status, tenant_price, owner_price, cleaning_fee, deposit, currency, min_duration_days, max_duration_days, capacity, max_annual_reservations, used_annual_reservations, allowed_hours_start, allowed_hours_end, digital_lock_id, access_code_enabled, enable_notifications, cleaning_enabled, cleaning_email, cleaning_notifications_enabled, cleaning_calendar_enabled, cleaning_days_after_checkout, cleaning_hour, gym_settings, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440115', 'Salle de gym', 'Salle de sport de démonstration : tapis, renforcement et cardio léger. Permet de tester réservation à la journée et abonnements (Stripe en mode démo).', 'La salle se trouve au sous-sol. Réservez un créneau ou souscrivez un abonnement en ligne selon les options affichées. Respectez le matériel et les horaires d''ouverture ; aucune responsabilité sur les données d''entraînement fictives.', 'Sous-sol, local sport', 'GYM', 'ACTIVE', 12.00, 12.00, 0.00, 0.00, 'EUR', 1, 1, NULL, 0, 0, '06:00', '22:00', NULL, false, false, false, NULL, false, false, 0, '10:00', '{"subscriptionEnabled":true,"subscriptionOnly":false,"allowedSubscriptionDurations":["WEEK","MONTH"],"subscriptionTenantPrices":{"WEEK":15,"MONTH":45},"subscriptionOwnerPrices":{"WEEK":10,"MONTH":30}}'::jsonb, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00');

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
    user_regulations_general_rules = 'La salle de sport est réservée aux résidents du tenant Demo. Respect des créneaux et des règles affichées dans l''application (démo).',
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
  ('550e8400-e29b-41d4-a716-446655440218', '550e8400-e29b-41d4-a716-446655440118', '/assets/spaces/parking.jpg', 'Parking C', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00');

INSERT INTO space_allowed_days (space_id, day_of_week) VALUES
  ('550e8400-e29b-41d4-a716-446655440111', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440111', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440112', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440112', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440113', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440113', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440114', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440114', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440115', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440115', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440116', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440116', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440117', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440117', 'SUNDAY'),
  ('550e8400-e29b-41d4-a716-446655440118', 'MONDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'TUESDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'WEDNESDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'THURSDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'FRIDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'SATURDAY'), ('550e8400-e29b-41d4-a716-446655440118', 'SUNDAY');

INSERT INTO reservations (id, space_id, user_id, start_date, end_date, status, total_price, stripe_payment_intent_id, stripe_session_id, payment_status, created_at, updated_at) VALUES
  ('018ad10a-26f4-4e59-9d02-b6c2c4d576b2', '550e8400-e29b-41d4-a716-446655440112', 'b1000001-0000-4000-8000-000000000001', '2026-01-15', '2026-01-15', 'CONFIRMED', 0.00, 'pi_demo1', 'cs_demo1', 'SUCCEEDED', '2026-01-01 00:00:00+00', '2026-01-01 00:00:00+00'),
  ('5d384a1a-da20-488f-8865-b3862d651fc3', '550e8400-e29b-41d4-a716-446655440111', 'b1000001-0000-4000-8000-000000000002', '2026-02-01', '2026-02-03', 'CONFIRMED', 120.00, 'pi_demo2', 'cs_demo2', 'SUCCEEDED', '2026-01-20 00:00:00+00', '2026-01-20 00:00:00+00');

INSERT INTO space_settings (id, platform_fee_percentage, platform_fixed_fee, created_at, updated_at)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 2.00, 0.25, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

UPDATE reservations
SET platform_fee_amount = ROUND((total_price - COALESCE(s.cleaning_fee, 0)) * 0.02, 2), platform_fixed_fee_amount = 0.25
FROM spaces s
WHERE reservations.space_id = s.id AND reservations.platform_fee_amount IS NULL;

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
  ('ANNOUNCEMENT', true, 10), ('WELCOME', true, 10), ('STATIC', true, 10), ('SPACE', true, 10);
INSERT INTO tv_info_welcome (display_days, enabled) VALUES (7, true);
INSERT INTO tv_info_static (content_type, display_days, enabled) VALUES
  ('ELEMENT_PROMO', 30, true), ('PORTAL_PROMO', 30, true), ('ALFRED_PROMO', 30, true);
INSERT INTO tv_info_spaces (display_days, show_calendar, show_rules, show_stats, show_essential_info, enabled)
VALUES (7, true, true, false, true, true);
INSERT INTO tv_slide_designs (name, background_type, background_value, corner_element_type, corner_element_position, icon_position, enabled) VALUES
  ('default', 'GRADIENT', 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', 'LEAVES', 'top-left,top-right', 'TOP_LEFT', true);

INSERT INTO tv_info_announcements (announcement_id, tv_enabled, display_days, start_date, end_date) VALUES
  ('550e8400-e29b-41d4-a716-446655440030', true, 7, '2025-01-01 00:00:00+00', '2026-12-31 23:59:59+00');
