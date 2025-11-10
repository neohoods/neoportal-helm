-- Users
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('8cf28343-7b32-4365-8c04-305f342a2cee', 'john_doe', 'quentincastel86+john@gmail.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'John', 'Doe', '123', '123 Main St', 'Anytown', '12345', 'USA', 'c8bef2b9-7415-4358-a733-6e9d035b48b4', '', false, true, false, 'TENANT');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('c4e8c95e-682b-440d-b6d5-6297f0d13633', 'jane_smith', 'jane.smith@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Jane', 'Smith', '456', '456 Elm St', 'Othertown', '67890', 'USA', 'dedf209d-fcb4-44aa-bd36-858deddebec8', '', true, true, false, 'OWNER');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('c5c180f1-bd25-443e-8f8a-924ddf13f971', 'alice_jones', 'alice.jones@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Alice', 'Jones', '789', '789 Oak St', 'Somewhere', '54321', 'Canada', '1098c7ed-e4f3-499e-bab5-518576abc11d', '', false, false, true, 'LANDLORD');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('593e726d-14b1-477e-967c-72bec8478a45', 'bob_brown', 'bob.brown@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Bob', 'Brown', '101', '101 Pine St', 'Nowhere', '98765', 'Mexico', '3c16693f-be08-4ba0-bcae-cc8a85f9812f', '', false, true, false, 'TENANT');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('331f5b7e-3acd-4e91-b64d-9fee522b5f31', 'emily_davis', 'emily.davis@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Emily', 'Davis', '202', '202 Cedar St', 'Anothertown', '24680', 'Germany', 'de', 'https://example.com/avatars/emily_davis.jpg', true, true, false, 'SYNDIC');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('56f91978-04c8-4142-93e4-706c5d23dacf', 'michael_wilson', 'michael.wilson@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Michael', 'Wilson', '303', '303 Birch St', 'Somecity', '13579', 'Spain', '983b9f2d-15ef-40a3-ab4b-11d6659a0b48', '', false, true, false, 'CONTRACTOR');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('d4562dfd-2d98-4db0-9937-33fccd90599a', 'olivia_martinez', 'olivia.martinez@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Olivia', 'Martinez', '404', '404 Maple St', 'Anothercity', '24680', 'France', '9af21a21-c281-4b33-b525-7ee7e453a583', '', false, true, false, 'EXTERNAL');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('a42d1145-cb3a-4088-a9f8-eba1310a9e80', 'david_lee', 'david.lee@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'David', 'Lee', '505', '505 Oak St', 'Somewhere', '12345', 'China', 'zh', '', false, true, false, 'COMMERCIAL_PROPERTY_OWNER');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('26be1301-4121-4497-80d1-e448fdef0532', 'sophia_garcia', 'sophia.garcia@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Sophia', 'Garcia', '606', '606 Pine St', 'Nowhere', '67890', 'Spain', 'b0b14828-1d0a-45b5-9eec-2f869b79c644', '', false, true, false, 'GUEST');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('f336a25e-7bed-4f44-a360-f758aecd7d09', 'charlie_rodriguez', 'charlie.rodriguez@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Charlie', 'Rodriguez', '707', '707 Cedar St', 'Anothertown', '54321', 'Mexico', '0e33f250-6bf6-4a8d-9f43-e1d72778a6e7', '', false, true, false, 'TENANT');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('f71c870e-9daa-4991-accd-61f3c3c14fa2', 'demo', 'quentin.castel@neohoods.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Me', 'Me', '808', '808 Birch St', 'Somewhere', '12345', 'USA', '7d37d680-c8da-4729-9cde-c883ed119a6d', 'https://mdbcdn.b-cdn.net/img/new/avatars/2.webp', true, true, false, 'ADMIN');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('1968032b-4a3f-4044-bbf3-947b0c96f7a0', 'ava_walker', 'ava.walker@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Ava', 'Walker', '909', '909 Cedar St', 'Anothertown', '67890', 'USA', '07395080-bd18-4ecd-9978-fa7188f06707', '', false, true, false, 'OWNER');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('ce5578e6-87cf-44a0-877e-87c264dd281c', 'noah_turner', 'noah.turner@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Noah', 'Turner', '1010', '1010 Pine St', 'Nowhere', '54321', 'USA', '888451e7-ec79-42fd-8746-f3629fe7ef8d', '', false, true, false, 'TENANT');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('a668f324-debb-4cf0-a543-10a8ce7ed8e2', 'mia_hall', 'mia.hall@example.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Mia', 'Hall', '1111', '1111 Oak St', 'Somewhere', '12345', 'USA', '26e85b52-9b3c-4692-b9f0-3551d8e07607', '', false, true, false, 'LANDLORD');
INSERT INTO users (id, username, email, password, first_name, last_name, flat_number, street_address, city, postal_code, country, preferred_language, avatar_url, profile_sharing_consent, is_email_verified, disabled, user_type) VALUES ('ff25a41d-a417-416c-9feb-dd61a7fcb2d6', 'qcastel', 'quentincastel86@gmail.com', '$2a$10$FZLU/ajV2PZmD9cXiZqNMuruo592lNW13uKcICG5oEBdnfYNbej1e', 'Quentin', 'Castel', '', '119 route des oriolleres', 'Mignaloux-Beauvoir', '86550', 'France', 'cfbfbd43-7f04-4722-937c-bb25332a0a34', '', true, true, false, 'ADMIN');

-- User Properties removed - concept has been replaced by Units

-- Units
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440100', 'Appartement 808', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440101', 'Famille Castel', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440102', 'Appartement 123', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440103', 'Appartement 456', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440104', 'Appartement 789', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440105', 'Appartement 909', 'FLAT', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
-- Garages for testing
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440106', 'Garage A1', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440107', 'Garage B2', 'GARAGE', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440108', 'Place Parking 12', 'PARKING', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');
INSERT INTO units (id, name, type, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440109', 'Place Parking 34', 'PARKING', '2024-01-10 10:00:00+00', '2024-01-10 10:00:00+00');

-- Unit Members
-- User 'me' (demo) is admin of multiple units
-- User 'me' is also a member of other units
-- Additional members for testing
-- Appartement 808: add Jane Smith and Emily Davis as members
-- Famille Castel: add John Doe as member
-- Appartement 789: add Bob Brown as member
-- Garage and Parking members (for testing related units feature)
-- Garage A1: owned by user 'me' (PROPRIETAIRE) - linked to Appartement 808
-- Garage B2: owned by Jane Smith (PROPRIETAIRE) - linked to Appartement 456
-- Place Parking 12: owned by Ava Walker (PROPRIETAIRE) - linked to Appartement 909
-- Place Parking 34: owned by user 'me' (PROPRIETAIRE) - linked to Famille Castel

-- Applications
INSERT INTO applications (id, name, url, icon, help_text, disabled) VALUES ('550e8400-e29b-41d4-a716-446655440002', 'Chat', 'https://chat.example.com', '/assets/applications/chat.png', 'Join community discussions and real-time chat', false);
INSERT INTO applications (id, name, url, icon, help_text, disabled) VALUES ('550e8400-e29b-41d4-a716-446655440004', 'Space', '/spaces', '/assets/applications/space.png', 'Book shared spaces and view availability', false);
INSERT INTO applications (id, name, url, icon, help_text, disabled) VALUES ('550e8400-e29b-41d4-a716-446655440005', 'Directory', '/hub/directory', '/assets/applications/directory.png', 'Directory of the community', false);

-- Community Information
INSERT INTO infos (id, next_ag_date, rules_url) VALUES ('00000000-0000-0000-0000-000000000001', '2025-10-13 10:00:00+00', 'https://community.example.com/rules');

-- Delegates

-- Contact Numbers
-- Syndic contact
INSERT INTO contact_numbers (id, info_id, contact_type, type, description, availability, response_time, name, phone_number, email) VALUES 
('550e8400-e29b-41d4-a716-446655440010', '00000000-0000-0000-0000-000000000001', 'syndic', 'Responsable', 'Responsable du syndic', 'Lun-Ven 9h-17h', '3cb7f468-2a39-41fc-893b-bcdb930aae31', 'Melle DUCRUET Julie', '04.79.33.91.56', 'jducruet@savoisienne.com'),
('550e8400-e29b-41d4-a716-446655440011', '00000000-0000-0000-0000-000000000001', 'syndic', 'Comptable', 'Comptable du syndic', 'Lun-Ven 9h-17h', '6c276191-15f4-40c0-89f1-24790d426b5d', 'Mme ANDRIES Annabelle', '04.79.33.91.56', 'aandries@savoisienne.com'),

-- Emergency contacts
-- Contacts de réparation d'urgence

-- Announcements
INSERT INTO announcements (id, title, content, created_at, updated_at, category) VALUES ('550e8400-e29b-41d4-a716-446655440030', 'Welcome to NeoHoods Community Portal', 'We are excited to announce the launch of our new community portal! This platform will help us stay connected and manage our community better. Please explore the features and let us know your feedback.', '2024-01-15 10:00:00+00', '2024-01-15 10:00:00+00', 'COMMUNITY_EVENT');
INSERT INTO announcements (id, title, content, created_at, updated_at, category) VALUES ('550e8400-e29b-41d4-a716-446655440031', 'Elevator Maintenance - Building A', 'The elevator in Building A will be under maintenance from January 20th to January 22nd. Please use the stairs during this period. We apologize for any inconvenience.', '2024-01-18 14:30:00+00', '2024-01-18 14:30:00+00', 'MAINTENANCE_NOTICE');
INSERT INTO announcements (id, title, content, created_at, updated_at, category) VALUES ('550e8400-e29b-41d4-a716-446655440032', 'Community BBQ This Saturday', 'Join us for a community BBQ this Saturday at 6 PM in the central courtyard! Meet your neighbors, enjoy great food, and have fun. Drinks and grilling supplies will be provided.', '2024-01-20 09:15:00+00', '2024-01-20 09:15:00+00', 'SOCIAL_GATHERING');
INSERT INTO announcements (id, title, content, created_at, updated_at, category) VALUES ('550e8400-e29b-41d4-a716-446655440033', 'Lost Cat - Fluffy (Orange Tabby)', 'Have you seen Fluffy? She is an orange tabby cat with white paws, went missing from Building B on January 19th. Very friendly and responds to her name. Please contact Marie at marie.dupont@example.com if found.', '2024-01-21 16:45:00+00', '2024-01-21 16:45:00+00', 'LOST_AND_FOUND');
INSERT INTO announcements (id, title, content, created_at, updated_at, category) VALUES ('550e8400-e29b-41d4-a716-446655440034', 'Security Reminder: Lock Your Doors', 'Please remember to always lock your doors and close windows when leaving your apartment. There have been reports of suspicious activity in the neighborhood. Report any unusual behavior to security immediately.', '2024-01-22 11:20:00+00', '2024-01-22 11:20:00+00', 'SAFETY_ALERT');

-- Custom Pages
INSERT INTO custom_pages (id, ref, page_order, position, title, content) VALUES ('550e8400-e29b-41d4-a716-446655440040', 'privacy-policy', 1, 'FOOTER_LINKS', 'Politique de Confidentialité', '<p>Cette politique de confidentialité explique comment NeoHoods collecte, utilise et protège vos informations personnelles lorsque vous utilisez notre portail communautaire.</p><h2>Informations que nous collectons</h2><p>Nous collectons les informations que vous nous fournissez directement, par exemple lorsque vous créez un compte, mettez à jour votre profil ou nous contactez pour obtenir de l''aide.</p><h2>Comment nous utilisons vos informations</h2><p>Nous utilisons les informations collectées pour fournir, maintenir et améliorer nos services, communiquer avec vous et assurer la sécurité de notre plateforme.</p><h2>Vos droits RGPD</h2><p>Conformément au RGPD, vous disposez du droit d''accès, de rectification, d''effacement, de portabilité et d''opposition concernant vos données personnelles. Pour exercer ces droits, contactez-nous à privacy@neohoods.com</p>');
INSERT INTO custom_pages (id, ref, page_order, position, title, content) VALUES ('550e8400-e29b-41d4-a716-446655440041', 'terms-of-service', 2, 'FOOTER_LINKS', 'Conditions d''Utilisation', '<p>Bienvenue sur NeoHoods ! Ces conditions d''utilisation définissent les règles et réglementations pour l''utilisation de notre portail communautaire.</p><h2>Acceptation des Conditions</h2><p>En accédant et en utilisant ce service, vous acceptez et convenez d''être lié par les termes et dispositions de cet accord.</p><h2>Licence d''Utilisation</h2><p>L''autorisation est accordée d''accéder temporairement aux matériaux sur NeoHoods uniquement pour un usage personnel et non commercial.</p><h2>Utilisation Responsable</h2><p>Vous vous engagez à utiliser la plateforme de manière respectueuse envers les autres résidents et à respecter les règles de la communauté.</p>');
INSERT INTO custom_pages (id, ref, page_order, position, title, content) VALUES ('550e8400-e29b-41d4-a716-446655440043', 'copyright-notice', 1, 'COPYRIGHT', 'Mentions Légales', '<p>&copy; 2024 Portail Communautaire NeoHoods. Tous droits réservés. Cette plateforme et son contenu sont protégés par les lois sur le droit d''auteur et autres lois de propriété intellectuelle.</p>');
INSERT INTO custom_pages (id, ref, page_order, position, title, content) VALUES ('550e8400-e29b-41d4-a716-446655440044', 'help-contact', 1, 'FOOTER_HELP', 'Support', '<h2>Contact Support</h2><p>Si vous avez besoin d''aide avec le portail communautaire, n''hésitez pas à nous contacter :</p><ul><li><strong>Email :</strong> support@neohoods.com</li><li><strong>Heures d''ouverture :</strong> Lundi-Vendredi, 9h - 17h</li></ul><p>Pour les questions urgentes de la communauté, veuillez contacter votre gestionnaire d''immeuble ou utiliser les contacts d''urgence dans la section Infos.</p>');

-- Email Templates
INSERT INTO email_templates (id, type, name, subject, content, is_active, created_at, updated_at, created_by, description) VALUES ('550e8400-e29b-41d4-a716-446655440060', 'WELCOME', 'Welcome Email - Default', 'Welcome to {{appName}}!', '<h1>Welcome {{username}}!</h1><p>Thank you for joining {{appName}}! We are excited to have you as part of our community.</p><p>You can now start exploring all the features and connect with other members.</p><p>If you have any questions or need assistance, please don''t hesitate to contact our support team.</p><p>Best regards,<br>The {{appName}} Team</p>', true, '2024-01-10 14:30:00+00', '2024-01-10 14:30:00+00', 'f71c870e-9daa-4991-accd-61f3c3c14fa2', 'Default welcome email sent to new users after registration');

-- Newsletters
INSERT INTO newsletters (id, subject, content, status, created_at, updated_at, scheduled_at, sent_at, created_by, recipient_count) VALUES ('550e8400-e29b-41d4-a716-446655440050', 'Your Monthly Community Update - December 2024', '<h2>Welcome to our December Newsletter!</h2><p>This month has been full of exciting community events and updates. Here are the highlights:</p><ul><li>New playground equipment installed in the central courtyard</li><li>Holiday decorations contest winners announced</li><li>Upcoming maintenance schedule for January</li></ul><p>Thank you for being part of our wonderful community!</p>', 'SENT', '2024-12-01 10:00:00+00', '2024-12-01 10:00:00+00', '2024-12-01 12:00:00+00', '2024-12-01 12:00:00+00', 'f71c870e-9daa-4991-accd-61f3c3c14fa2', 150);

INSERT INTO newsletters (id, subject, content, status, created_at, updated_at, scheduled_at, sent_at, created_by, recipient_count) VALUES ('550e8400-e29b-41d4-a716-446655440051', 'Important Safety Information for the Holidays', '<h2>Holiday Safety Tips</h2><p>As we approach the holiday season, here are some important safety reminders to keep our community safe:</p><ul><li>Ensure all holiday decorations are fire-safe</li><li>Keep emergency exits clear of decorations</li><li>Be cautious with candles and open flames</li><li>Report any suspicious activity to security</li></ul><p>Have a safe and happy holiday season!</p>', 'SENT', '2024-12-15 09:00:00+00', '2024-12-15 09:30:00+00', '2024-12-20 08:00:00+00', null, 'f71c870e-9daa-4991-accd-61f3c3c14fa2', null);

INSERT INTO newsletters (id, subject, content, status, created_at, updated_at, scheduled_at, sent_at, created_by, recipient_count) VALUES ('550e8400-e29b-41d4-a716-446655440052', 'Join Us for New Year Celebrations!', '<h2>New Year Events</h2><p>We are excited to announce our New Year community events. Join us for:</p><ul><li>New Year''s Eve community party in the main hall</li><li>Children''s countdown at 8 PM</li><li>Adult celebration until midnight</li><li>Complimentary refreshments and entertainment</li></ul><p>RSVP by December 28th. Looking forward to celebrating with you!</p>', 'DRAFT', '2024-12-18 14:00:00+00', '2024-12-18 16:00:00+00', null, null, 'f71c870e-9daa-4991-accd-61f3c3c14fa2', null);

-- Default Settings
INSERT INTO settings (id, is_registration_enabled) VALUES ('00000000-0000-0000-0000-000000000001', false);

INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('8cf28343-7b32-4365-8c04-305f342a2cee', true, true);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('c4e8c95e-682b-440d-b6d5-6297f0d13633', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('c5c180f1-bd25-443e-8f8a-924ddf13f971', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('593e726d-14b1-477e-967c-72bec8478a45', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('331f5b7e-3acd-4e91-b64d-9fee522b5f31', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('56f91978-04c8-4142-93e4-706c5d23dacf', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('d4562dfd-2d98-4db0-9937-33fccd90599a', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('a42d1145-cb3a-4088-a9f8-eba1310a9e80', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('26be1301-4121-4497-80d1-e448fdef0532', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('f336a25e-7bed-4f44-a360-f758aecd7d09', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('f71c870e-9daa-4991-accd-61f3c3c14fa2', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('1968032b-4a3f-4044-bbf3-947b0c96f7a0', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('ce5578e6-87cf-44a0-877e-87c264dd281c', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('a668f324-debb-4cf0-a543-10a8ce7ed8e2', false, false);
INSERT INTO notification_settings (user_id, enable_notifications, newsletter_enabled) VALUES ('ff25a41d-a417-416c-9feb-dd61a7fcb2d6', true, true);

-- Notifications
INSERT INTO notifications (
                id, user_id, author, date, type, already_read, payload
            ) VALUES (
                '200103cd-f279-4503-af50-fcc6decd74f6', 'f71c870e-9daa-4991-accd-61f3c3c14fa2', 'Platform', '2024-11-21T00:00:00Z',
                'ADMIN_NEW_USER', false, '{"newUserType": "TENANT", "newUserEmail": "quentincastel86+john@gmail.com", "newUserLastName": "Doe", "newUserUsername": "john_doe", "newUserFirstName": "John", "newUserId": "8cf28343-7b32-4365-8c04-305f342a2cee"}'
                
            );

-- Help Categories and Articles
INSERT INTO help_categories (id, name, icon, display_order) VALUES ('a970dc49-aca8-4508-8182-0bb3e3de8c1d', 'Chat & Communication', '@tui.message-circle', 1);
INSERT INTO help_categories (id, name, icon, display_order) VALUES ('fea9e75b-966f-4062-aa9c-5319fdb570bb', 'Application', '@tui.smartphone', 2);
INSERT INTO help_categories (id, name, icon, display_order) VALUES ('1740c794-eedc-4396-9680-4bc9b85e6948', 'Confidentialité & RGPD', '@tui.lock', 3);
-- Chat & Communication
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('f346a7fd-086c-4226-8f7b-6b80f93657cb', 'Comment utiliser le chat', '<p>Le chat de Neohoods est une plateforme interactive permettant aux résidents de communiquer en temps réel. Vous pouvez :</p><ul><li>Envoyer des messages instantanés à vos voisins</li><li>Partager des photos et documents</li><li>Créer des groupes thématiques (sécurité, covoiturage, etc.)</li><li>Recevoir des notifications push</li></ul><p>Pour accéder au chat, cliquez sur l''icône message dans le menu principal.</p>', 1, 'a970dc49-aca8-4508-8182-0bb3e3de8c1d');
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('1ec1014f-2f04-4ccf-94b6-dbdcccb5cf07', 'Créer des groupes de discussion', '<p>Vous pouvez créer des groupes de discussion pour organiser les conversations par thème :</p><ul><li>Général : discussions générales de la résidence</li><li>Sécurité : alertes et informations de sécurité</li><li>Covoiturage : organisation des trajets</li><li>Événements : annonces d''événements</li><li>Entraide : demandes d''aide entre voisins</li></ul><p>Pour créer un groupe, allez dans le chat et cliquez sur "Nouveau groupe".</p>', 2, 'a970dc49-aca8-4508-8182-0bb3e3de8c1d');
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('20bcbfb7-3501-4ba1-857c-ee96da866b76', 'Notifications et alertes', '<p>Configurez vos notifications pour ne rien manquer :</p><ul><li>Messages directs : recevez une notification pour chaque message privé</li><li>Mentions : soyez alerté quand quelqu''un vous mentionne</li><li>Groupes : choisissez quels groupes vous notifient</li><li>Heures silencieuses : définissez des créneaux sans notification</li></ul><p>Accédez aux paramètres de notification dans votre profil.</p>', 3, 'a970dc49-aca8-4508-8182-0bb3e3de8c1d');
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('a305befe-ba64-4195-b953-08aa0f10ff7d', 'Télécharger l''application mobile', '<p>L''application Neohoods est disponible sur :</p><ul><li><strong>iOS</strong> : App Store (recherchez "Neohoods")</li><li><strong>Android</strong> : Google Play Store</li></ul><p>L''app mobile offre :</p><ul><li>Accès au chat en temps réel</li><li>Notifications push</li><li>Accès hors ligne aux informations importantes</li><li>Interface optimisée pour mobile</li></ul><p>Vous pouvez également utiliser la version web depuis votre navigateur.</p>', 1, 'fea9e75b-966f-4062-aa9c-5319fdb570bb');
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('41d46d5c-89e9-409a-8109-72e713d527f9', 'Vidéos et tutoriels', '<p>Des vidéos explicatives sont disponibles pour vous aider :</p><ul><li><strong>Tutoriel d''installation</strong> : Comment télécharger et installer l''app</li><li><strong>Premiers pas</strong> : Navigation et fonctionnalités de base</li><li><strong>Utilisation du chat</strong> : Envoyer des messages, créer des groupes</li><li><strong>Paramètres</strong> : Personnaliser votre expérience</li></ul><p>Accédez aux vidéos depuis le menu "Aide" dans l''application ou consultez notre chaîne YouTube.</p>', 2, 'fea9e75b-966f-4062-aa9c-5319fdb570bb');
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('23848756-188a-489e-98fd-afd7a9780935', 'Résolution des problèmes techniques', '<p>Si vous rencontrez des problèmes :</p><ul><li><strong>App qui ne se lance pas</strong> : Vérifiez votre connexion internet et redémarrez l''app</li><li><strong>Messages qui ne s''envoient pas</strong> : Vérifiez votre connexion et réessayez</li><li><strong>Notifications qui ne fonctionnent pas</strong> : Vérifiez les paramètres de notification de votre appareil</li><li><strong>App qui plante</strong> : Fermez l''app et relancez-la</li></ul><p>Si le problème persiste, contactez le support technique.</p>', 3, 'fea9e75b-966f-4062-aa9c-5319fdb570bb');
-- Confidentialité & RGPD
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('c3f455e6-fee0-4f5b-8e07-442ab503d30a', 'Supprimer votre compte', '<p>Conformément au RGPD, vous avez le droit de demander la suppression de vos données personnelles.</p><p><strong>Pour supprimer votre compte :</strong></p><ol><li>Envoyez un email à <strong>privacy@neohoods.com</strong></li><li>Indiquez clairement votre demande de suppression</li><li>Précisez votre nom d''utilisateur ou email associé</li></ol><p>Nous traiterons votre demande dans un délai d''un mois maximum, comme stipulé par le RGPD.</p><p><strong>Attention :</strong> La suppression de votre compte entraînera la suppression définitive de toutes vos données (messages, photos, etc.). Assurez-vous de sauvegarder toute information importante avant de procéder.</p>', 1, '1740c794-eedc-4396-9680-4bc9b85e6948');
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('dede4596-466e-46cd-b79f-72733eb2a34a', 'Vos droits RGPD', '<p>Conformément au Règlement Général sur la Protection des Données (RGPD), vous disposez des droits suivants :</p><ul><li><strong>Droit d''accès</strong> : Demander une copie de vos données</li><li><strong>Droit de rectification</strong> : Corriger des données inexactes</li><li><strong>Droit à l''effacement</strong> : Demander la suppression de vos données</li><li><strong>Droit à la portabilité</strong> : Récupérer vos données dans un format lisible</li><li><strong>Droit d''opposition</strong> : Vous opposer au traitement de vos données</li></ul><p>Pour exercer ces droits, contactez-nous à <strong>privacy@neohoods.com</strong></p>', 2, '1740c794-eedc-4396-9680-4bc9b85e6948');
INSERT INTO help_articles (id, title, content, display_order, category_id) VALUES ('2bcc98b6-f2dd-4994-a58a-d693decb65ba', 'Protection de vos données', '<p>Nous nous engageons à protéger vos données personnelles :</p><ul><li><strong>Chiffrement</strong> : Toutes les communications sont chiffrées</li><li><strong>Stockage sécurisé</strong> : Vos données sont stockées sur des serveurs sécurisés</li><li><strong>Accès limité</strong> : Seuls les employés autorisés peuvent accéder à vos données</li><li><strong>Audit régulier</strong> : Nous effectuons des audits de sécurité réguliers</li></ul><p>Nous ne vendons jamais vos données à des tiers et ne les utilisons que pour fournir nos services.</p>', 3, '1740c794-eedc-4396-9680-4bc9b85e6948');

-- Digital Locks (TTLock types)
INSERT INTO digital_locks (id, name, type, status, created_at, updated_at) VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'Serrure Entrée Principale', 'TTLOCK', 'ACTIVE', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440002', 'Serrure Salle Communale', 'TTLOCK', 'ACTIVE', '2024-01-10 09:00:00+00', '2024-01-15 11:15:00+00'),
('550e8400-e29b-41d4-a716-446655440003', 'Serrure Parking', 'TTLOCK', 'INACTIVE', '2024-01-10 09:00:00+00', '2024-01-14 16:45:00+00'),
('550e8400-e29b-41d4-a716-446655440004', 'Serrure Bureau', 'TTLOCK', 'ERROR', '2024-01-10 09:00:00+00', '2024-01-13 14:20:00+00');

-- TTLock Configurations
INSERT INTO ttlock_configs (digital_lock_id, device_id, location, battery_level, signal_strength, last_seen, created_at, updated_at) VALUES 
('550e8400-e29b-41d4-a716-446655440001', 'ttlock-001', 'Entrée principale', 85, 90, '2024-01-15T10:30:00+00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440002', 'ttlock-002', 'Salle communale', 92, 85, '2024-01-15T11:15:00+00', '2024-01-10 09:00:00+00', '2024-01-15 11:15:00+00'),
('550e8400-e29b-41d4-a716-446655440003', 'ttlock-003', 'Parking', 45, 70, '2024-01-14T16:45:00+00', '2024-01-10 09:00:00+00', '2024-01-14 16:45:00+00'),
('550e8400-e29b-41d4-a716-446655440004', 'ttlock-004', 'Bureau', 15, 60, '2024-01-13T14:20:00+00', '2024-01-10 09:00:00+00', '2024-01-13 14:20:00+00');

-- Digital Locks (migrated from ttlock_devices + additional types)
INSERT INTO digital_locks (id, name, type, status, created_at, updated_at) VALUES 
('550e8400-e29b-41d4-a716-446655440005', 'Serrure NUKI Parking', 'NUKI', 'INACTIVE', '2024-01-10 09:00:00+00', '2024-01-14 16:45:00+00');
-- Nuki Configuration
INSERT INTO nuki_configs (digital_lock_id, device_id, token, battery_level, last_seen, created_at, updated_at) VALUES 
('550e8400-e29b-41d4-a716-446655440005', 'nuki-001', 'nuki-token-789', 45, '2024-01-14T16:45:00+00', '2024-01-10 09:00:00+00', '2024-01-14 16:45:00+00');

-- Spaces (from spaces.json - Terre de Laya)
INSERT INTO spaces (id, name, description, instructions, type, status, tenant_price, owner_price, cleaning_fee, deposit, currency, min_duration_days, max_duration_days, requires_apartment_access, max_annual_reservations, used_annual_reservations, allowed_hours_start, allowed_hours_end, digital_lock_id, access_code_enabled, enable_notifications, cleaning_enabled, cleaning_email, cleaning_notifications_enabled, cleaning_calendar_enabled, cleaning_days_after_checkout, cleaning_hour, created_at, updated_at) VALUES 
-- Parking spaces (10 places)
('550e8400-e29b-41d4-a716-446655440101', 'Place de parking N°7', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°7 est située au niveau -1 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440102', 'Place de parking N°23', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°23 est située au niveau -1 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440103', 'Place de parking N°45', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°45 est située au niveau -2 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440104', 'Place de parking N°67', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°67 est située au niveau -2 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440105', 'Place de parking N°89', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°89 est située au niveau -2 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440106', 'Place de parking N°102', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°102 est située au niveau -3 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440107', 'Place de parking N°34', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°34 est située au niveau -1 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440108', 'Place de parking N°56', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°56 est située au niveau -2 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440109', 'Place de parking N°78', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°78 est située au niveau -2 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
('550e8400-e29b-41d4-a716-446655440110', 'Place de parking N°91', 'Place de parking pour véhicule léger. Réservation gratuite à la journée, maximum 15 jours consécutifs. Aucun frais de réservation.', 'La place N°91 est située au niveau -3 du parking souterrain. Accès par le portail principal avec votre badge ou code d''accès temporaire.', 'PARKING', 'ACTIVE', 0.00, 0.00, 0.00, 0.00, 'EUR', 1, 15, false, 0, 0, '00:00', '23:59', '550e8400-e29b-41d4-a716-446655440003', false, false, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
-- Chambre d'hôte
('550e8400-e29b-41d4-a716-446655440111', 'Chambre d''hôte', 'Chambre d''hôte confortable pour 2 voyageurs maximum. Équipement complet avec literie, électroménager et décoration. Réservée exclusivement aux résidents de Terre de Laya.', 'La chambre d''hôte est située au 1er étage. Vous recevrez un code d''accès temporaire par email 24h avant votre arrivée. Accès 24h/24 avec votre code personnel. Nettoyage inclus les lundis et mardis.', 'GUEST_ROOM', 'ACTIVE', 10.00, 0.00, 50.00, 0.00, 'EUR', 2, 7, true, 7, 0, '15:00', '11:00', '550e8400-e29b-41d4-a716-446655440001', true, true, true, 'quentin.castel.neohoods+cleaning@gmail.com', true, true, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
-- Salle commune
('550e8400-e29b-41d4-a716-446655440112', 'Salle commune', 'Salle commune équipée pour événements et réunions. Mobilier complet avec tables, chaises, 2 bureaux de co-working, réfrigérateur, imprimante et vidéoprojecteur. Idéale pour les résidents de Terre de Laya.', 'La salle commune est située au rez-de-chaussée. Vous recevrez un code d''accès temporaire par email 24h avant votre réservation. Accès de 8h à 20h. Nettoyage par les participants après utilisation.', 'COMMON_ROOM', 'ACTIVE', 20.00, 10.00, 0.00, 0.00, 'EUR', 1, 1, false, 0, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440002', true, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-15 10:30:00+00'),
-- Bureaux coworking
('550e8400-e29b-41d4-a716-446655440113', 'Bureau coworking A', 'Bureau de coworking individuel équipé pour le télétravail. Espace calme et fonctionnel avec bureau, chaise ergonomique, connexion internet et éclairage optimal. Idéal pour les résidents de Terre de Laya.', 'Le bureau coworking A est situé dans la salle commune. Vous recevrez un code d''accès temporaire par email 24h avant votre réservation. Accès de 8h à 20h. Nettoyage par l''utilisateur après utilisation.', 'COWORKING', 'ACTIVE', 8.00, 4.00, 0.00, 0.00, 'EUR', 1, 5, false, 0, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440004', true, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-13 14:20:00+00'),
('550e8400-e29b-41d4-a716-446655440114', 'Bureau coworking B', 'Bureau de coworking individuel équipé pour le télétravail. Espace calme et fonctionnel avec bureau, chaise ergonomique, connexion internet et éclairage optimal. Idéal pour les résidents de Terre de Laya.', 'Le bureau coworking B est situé dans la salle commune. Vous recevrez un code d''accès temporaire par email 24h avant votre réservation. Accès de 8h à 20h. Nettoyage par l''utilisateur après utilisation.', 'COWORKING', 'ACTIVE', 8.00, 4.00, 0.00, 0.00, 'EUR', 1, 5, false, 0, 0, '08:00', '20:00', '550e8400-e29b-41d4-a716-446655440004', true, true, false, NULL, false, false, 0, '10:00', '2024-01-10 09:00:00+00', '2024-01-13 14:20:00+00');

-- Space Images (from spaces.json - Terre de Laya)
-- Using external URLs for test data (easier than binary data in SQL)
INSERT INTO space_images (id, space_id, url, alt_text, is_primary, order_index, created_at, updated_at) VALUES 
-- Parking images (all use parking.jpeg)
('550e8400-e29b-41d4-a716-446655440201', '550e8400-e29b-41d4-a716-446655440101', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°7', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440202', '550e8400-e29b-41d4-a716-446655440102', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°23', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655440103', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°45', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440204', '550e8400-e29b-41d4-a716-446655440104', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°67', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440205', '550e8400-e29b-41d4-a716-446655440105', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°89', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440206', '550e8400-e29b-41d4-a716-446655440106', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°102', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440207', '550e8400-e29b-41d4-a716-446655440107', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°34', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440208', '550e8400-e29b-41d4-a716-446655440108', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°56', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440209', '550e8400-e29b-41d4-a716-446655440109', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°78', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
('550e8400-e29b-41d4-a716-446655440210', '550e8400-e29b-41d4-a716-446655440110', 'https://local.portal.neohoods.com:4200/assets/spaces/parking.jpg', 'Place de parking N°91', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
-- Chambre d'hôte image
('550e8400-e29b-41d4-a716-446655440211', '550e8400-e29b-41d4-a716-446655440111', 'https://local.portal.neohoods.com:4200/assets/spaces/chambre-dhotes.jpg', 'Chambre d''hôte', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
-- Salle commune image
('550e8400-e29b-41d4-a716-446655440212', '550e8400-e29b-41d4-a716-446655440112', 'https://local.portal.neohoods.com:4200/assets/spaces/common-space.jpg', 'Salle commune', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),
-- Coworking images
('550e8400-e29b-41d4-a716-446655440213', '550e8400-e29b-41d4-a716-446655440113', 'https://local.portal.neohoods.com:4200/assets/spaces/coworking.jpg', 'Bureau coworking A', true, 0, '2024-01-10 09:00:00+00', '2024-01-10 09:00:00+00'),

-- Space Allowed Days (from spaces.json - Terre de Laya)
INSERT INTO space_allowed_days (space_id, day_of_week) VALUES 
-- Parking spaces (all days)
('550e8400-e29b-41d4-a716-446655440101', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440101', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440101', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440101', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440101', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440101', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440101', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440102', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440102', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440102', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440102', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440102', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440102', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440102', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440103', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440103', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440103', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440103', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440103', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440103', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440103', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440104', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440104', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440104', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440104', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440104', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440104', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440104', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440105', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440105', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440105', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440105', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440105', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440105', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440105', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440106', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440106', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440106', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440106', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440106', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440106', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440106', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440107', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440107', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440107', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440107', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440107', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440107', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440107', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440108', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440108', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440108', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440108', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440108', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440108', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440108', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440109', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440109', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440109', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440109', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440109', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440109', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440109', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440110', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440110', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440110', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440110', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440110', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440110', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440110', 'SUNDAY'),
-- Chambre d'hôte (all days)
('550e8400-e29b-41d4-a716-446655440111', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440111', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440111', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440111', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440111', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440111', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440111', 'SUNDAY'),
-- Salle commune (Wednesday, Saturday, Sunday only)
('550e8400-e29b-41d4-a716-446655440112', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440112', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440112', 'SUNDAY'),
-- Coworking spaces (all days)
('550e8400-e29b-41d4-a716-446655440113', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440113', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440113', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440113', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440113', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440113', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440113', 'SUNDAY'),
('550e8400-e29b-41d4-a716-446655440114', 'MONDAY'),
('550e8400-e29b-41d4-a716-446655440114', 'TUESDAY'),
('550e8400-e29b-41d4-a716-446655440114', 'WEDNESDAY'),
('550e8400-e29b-41d4-a716-446655440114', 'THURSDAY'),
('550e8400-e29b-41d4-a716-446655440114', 'FRIDAY'),
('550e8400-e29b-41d4-a716-446655440114', 'SATURDAY'),
('550e8400-e29b-41d4-a716-446655440114', 'SUNDAY');

-- Space Shared With (logique simple: salle commune partage avec 2 bureaux coworking)
INSERT INTO space_shared_with (space_id, shared_space_id) VALUES 
-- Salle commune partage avec bureau coworking A
('550e8400-e29b-41d4-a716-446655440112', '550e8400-e29b-41d4-a716-446655440113'),
-- Salle commune partage avec bureau coworking B
('550e8400-e29b-41d4-a716-446655440112', '550e8400-e29b-41d4-a716-446655440114'),
-- Bureau coworking A partage avec salle commune (bidirectionnel)
('550e8400-e29b-41d4-a716-446655440113', '550e8400-e29b-41d4-a716-446655440112'),
-- Bureau coworking B partage avec salle commune (bidirectionnel)

INSERT INTO reservations (id, space_id, user_id, start_date, end_date, status, total_price, stripe_payment_intent_id, stripe_session_id, payment_status, created_at, updated_at) VALUES
('51ca670a-58a6-4429-bd7e-059e850efe04', '550e8400-e29b-41d4-a716-446655440101', 'a668f324-debb-4cf0-a543-10a8ce7ed8e2', '2025-06-30', '2025-07-03', 'CANCELLED', 0.00, 'pi_1899120580', 'cs_1288075750', 'SUCCEEDED', '2025-06-17 00:00:00+00', '2025-06-17 00:00:00+00'),
('f2b0a88b-1f38-4bf9-bce6-a63d9643f804', '550e8400-e29b-41d4-a716-446655440101', '56f91978-04c8-4142-93e4-706c5d23dacf', '2024-07-25', '2024-08-07', 'CONFIRMED', 0.00, NULL, NULL, 'PENDING', '2024-07-23 00:00:00+00', '2024-07-23 00:00:00+00'),
('22669934-7b5f-4714-988c-33a177c9ba25', '550e8400-e29b-41d4-a716-446655440101', '56f91978-04c8-4142-93e4-706c5d23dacf', '2025-10-06', '2025-10-21', 'CONFIRMED', 0.00, 'pi_5623089761', 'cs_1378758501', 'SUCCEEDED', '2025-09-18 00:00:00+00', '2025-09-18 00:00:00+00'),
('6114348c-d9e8-4468-8732-78e098d698f3', '550e8400-e29b-41d4-a716-446655440101', 'd4562dfd-2d98-4db0-9937-33fccd90599a', '2024-04-11', '2024-04-26', 'EXPIRED', 0.00, 'pi_2653442541', 'cs_3110522358', 'SUCCEEDED', '2024-03-27 00:00:00+00', '2024-03-27 00:00:00+00'),
('a1ef040c-8d5b-4fec-9908-593cf9375160', '550e8400-e29b-41d4-a716-446655440101', '331f5b7e-3acd-4e91-b64d-9fee522b5f31', '2024-04-01', '2024-04-05', 'CONFIRMED', 0.00, 'pi_2456584320', 'cs_9247789244', 'SUCCEEDED', '2024-03-28 00:00:00+00', '2024-03-28 00:00:00+00'),
('26975c85-908d-4c4f-92af-812801d6151d', '550e8400-e29b-41d4-a716-446655440101', 'c5c180f1-bd25-443e-8f8a-924ddf13f971', '2025-10-31', '2025-11-01', 'CONFIRMED', 0.00, NULL, NULL, 'PENDING', '2025-10-05 00:00:00+00', '2025-10-05 00:00:00+00'),
('a47bc4b7-eef0-4502-8857-bf7e77aceb5e', '550e8400-e29b-41d4-a716-446655440101', 'd4562dfd-2d98-4db0-9937-33fccd90599a', '2024-02-08', '2024-02-10', 'CONFIRMED', 0.00, NULL, NULL, 'FAILED', '2024-01-21 00:00:00+00', '2024-01-21 00:00:00+00'),
('0eeabaff-51ae-46f7-9bb4-072635d318a8', '550e8400-e29b-41d4-a716-446655440111', 'a668f324-debb-4cf0-a543-10a8ce7ed8e2', '2024-01-17', '2024-01-24', 'CONFIRMED', 490.00, 'pi_7720915465', 'cs_8787864037', 'SUCCEEDED', '2023-12-27 00:00:00+00', '2023-12-27 00:00:00+00'),
('0837c450-429c-403a-8ea8-a04b52e88304', '550e8400-e29b-41d4-a716-446655440112', 'f336a25e-7bed-4f44-a360-f758aecd7d09', '2025-01-02', '2025-01-03', 'CONFIRMED', 20.00, 'pi_1241215090', 'cs_6824429005', 'SUCCEEDED', '2024-12-08 00:00:00+00', '2024-12-08 00:00:00+00'),

-- Sample Access Codes (generated)
INSERT INTO access_codes (id, reservation_id, code, expires_at, digital_lock_id, digital_lock_code_id, is_active, created_at, updated_at) VALUES
('e62f4c58-9a3f-43a8-a3bb-b6f77cebb144', 'f2b0a88b-1f38-4bf9-bce6-a63d9643f804', '322913', '2024-08-08 00:00:00+00', '550e8400-e29b-41d4-a716-446655440001', 'lock-code-9999', true, '2024-07-23 00:00:00+00', '2024-07-23 00:00:00+00'),
('5ef84736-6f78-435a-812a-8bb89b64629f', '22669934-7b5f-4714-988c-33a177c9ba25', '320097', '2025-10-22 00:00:00+00', '550e8400-e29b-41d4-a716-446655440004', 'lock-code-7157', true, '2025-09-18 00:00:00+00', '2025-09-18 00:00:00+00'),
('2f778503-c96a-4072-a2a5-b5354e76ec9b', 'a1ef040c-8d5b-4fec-9908-593cf9375160', '207687', '2024-04-06 00:00:00+00', '550e8400-e29b-41d4-a716-446655440003', 'lock-code-8281', true, '2024-03-28 00:00:00+00', '2024-03-28 00:00:00+00'),
('fbce356c-56fd-4ea0-a157-4eaf5d236a49', '26975c85-908d-4c4f-92af-812801d6151d', '807790', '2025-11-02 00:00:00+00', '550e8400-e29b-41d4-a716-446655440004', 'lock-code-5202', true, '2025-10-05 00:00:00+00', '2025-10-05 00:00:00+00'),
('8bea17da-6768-4b8b-a472-465c3b67e740', 'a47bc4b7-eef0-4502-8857-bf7e77aceb5e', '585338', '2024-02-11 00:00:00+00', '550e8400-e29b-41d4-a716-446655440003', 'lock-code-9844', true, '2024-01-21 00:00:00+00', '2024-01-21 00:00:00+00'),

('93d00c72-f3ea-480a-b9e2-29770781827f', '0eeabaff-51ae-46f7-9bb4-072635d318a8', '401108', '2024-01-25 00:00:00+00', '550e8400-e29b-41d4-a716-446655440001', 'lock-code-8601', true, '2023-12-27 00:00:00+00', '2023-12-27 00:00:00+00'),
('7041e17e-1ada-4b27-85b4-590e9746029c', '0837c450-429c-403a-8ea8-a04b52e88304', '602506', '2025-01-04 00:00:00+00', '550e8400-e29b-41d4-a716-446655440002', 'lock-code-7281', true, '2024-12-08 00:00:00+00', '2024-12-08 00:00:00+00'),
('6f139c24-a969-4538-9a66-3313dd449099', '0f946bf7-f73d-4d80-90ae-68b3c3c70911', '572748', '2024-03-16 00:00:00+00', '550e8400-e29b-41d4-a716-446655440002', 'lock-code-5108', true, '2024-03-07 00:00:00+00', '2024-03-07 00:00:00+00'),

-- Sample Reservation Feedback (generated)
INSERT INTO reservation_feedback (id, reservation_id, user_id, rating, comment, cleanliness, communication, value, submitted_at) VALUES

-- Space Settings (default platform fee configuration)
INSERT INTO space_settings (id, platform_fee_percentage, platform_fixed_fee, created_at, updated_at) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', 2.00, 0.25, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Update existing reservations with default platform fees (2% + 0.25€)
-- This ensures historical data has consistent platform fee amounts
UPDATE reservations 
SET 
    platform_fee_amount = ROUND((total_price - COALESCE(s.cleaning_fee, 0)) * 0.02, 2),
    platform_fixed_fee_amount = 0.25
FROM spaces s
WHERE reservations.space_id = s.id 
    AND reservations.platform_fee_amount IS NULL;

-- Set primary_unit_id for existing users who have at least one unit
-- Uses the first unit (by joined_at, or unit_id if joined_at is the same) as primary
UPDATE users
SET primary_unit_id = (
    SELECT um.unit_id
    FROM unit_members um
    WHERE um.user_id = users.id
    ORDER BY um.joined_at ASC, um.unit_id ASC
    LIMIT 1
)
WHERE primary_unit_id IS NULL
AND EXISTS (
    SELECT 1 FROM unit_members um WHERE um.user_id = users.id
);

