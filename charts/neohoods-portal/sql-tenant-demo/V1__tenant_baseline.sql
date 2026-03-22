-- Squashed baseline (ex-V1…V32): user_id is writable; sync_users_id_user_id trigger aligns id/user_id (ex-V31/V32).
CREATE TABLE "users" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "user_id" uuid NOT NULL UNIQUE,
    "username" varchar(255) NOT NULL UNIQUE,
    "email" varchar(255) NOT NULL UNIQUE,
    "password" varchar(255) NOT NULL,
    "first_name" varchar(255),
    "last_name" varchar(255),
    "flat_number" varchar(255),
    "street_address" varchar(255),
    "city" varchar(255),
    "postal_code" varchar(255),
    "country" varchar(255),
    "preferred_language" varchar(255),
    "avatar_url" varchar(255),
    "phone_number" varchar(255),
    "profile_sharing_consent" boolean NOT NULL DEFAULT false,
    "created_at" timestamp DEFAULT CURRENT_TIMESTAMP,
    "is_email_verified" boolean NOT NULL DEFAULT false,
    "disabled" boolean NOT NULL DEFAULT false,
    "status" varchar(255) NOT NULL DEFAULT 'WAITING_FOR_EMAIL' CHECK (status IN ('WAITING_FOR_EMAIL', 'ACTIVE', 'INACTIVE')),
    "user_type" varchar(255) CHECK (user_type IN ('ADMIN', 'OWNER', 'LANDLORD', 'TENANT', 'SYNDIC', 'EXTERNAL', 'CONTRACTOR', 'COMMERCIAL_PROPERTY_OWNER', 'GUEST', 'PROPERTY_MANAGEMENT')),
    "matrix_user_id" varchar(255),
    "is_board_member" boolean NOT NULL DEFAULT false,
    "usage_conditions_accepted_version" varchar(255),
    "usage_conditions_accepted_at" timestamp with time zone,
    "usage_conditions_rejected_at" timestamp with time zone,
    "deleted_at" timestamp with time zone,
    "anonymized_at" timestamp with time zone,
    "anonymized_email_hash" varchar(128),
    "disabled_by_admin" boolean NOT NULL DEFAULT false
);



CREATE TABLE "help_categories" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "display_order" integer,
    "icon" varchar(255),
    "name" varchar(255)
);

CREATE TABLE "help_articles" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "content" varchar(4000),
    "display_order" integer,
    "title" varchar(255),
    "category_id" uuid REFERENCES help_categories(id)
);

CREATE TABLE "notifications" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "user_id" uuid REFERENCES users(id),
    "already_read" boolean NOT NULL,
    "author" varchar(255),
    "date" timestamp(6) with time zone,
    "payload" jsonb,
    "type" varchar(255) CHECK (type IN (
        'ADMIN_NEW_USER',
        'NEW_ANNOUNCEMENT',
        'RESERVATION',
        'UNIT_INVITATION',
        'UNIT_JOIN_REQUEST',
        'TENANT_JOIN_REQUEST'
    ))
);


CREATE TABLE settings (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "is_registration_enabled" BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE "notification_settings" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "user_id" uuid REFERENCES users(id) NOT NULL UNIQUE,
    "enable_notifications" boolean NOT NULL DEFAULT true,
    "newsletter_enabled" boolean NOT NULL DEFAULT true
);

CREATE TABLE "user_devices" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "user_id" uuid REFERENCES users(id) NOT NULL,
    "device_id" varchar(255) NOT NULL,
    "push_token" text,
    "platform" varchar(50),
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "last_used_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE ("user_id", "device_id")
);

CREATE TABLE "user_roles" (
    "user_id" uuid REFERENCES users(id),
    "role" varchar(255)
);

CREATE TABLE IF NOT EXISTS tenant_user (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    global_user_id uuid NOT NULL,
    role varchar(255) NOT NULL,
    matrix_user_id varchar(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (global_user_id)
);
CREATE INDEX IF NOT EXISTS idx_tenant_user_global_user_id ON tenant_user(global_user_id);

CREATE TABLE "infos" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "next_ag_date" timestamp with time zone,
    "rules_url" varchar(255),
    "emails_enabled" boolean NOT NULL DEFAULT true
);

CREATE TABLE "delegates" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "info_id" uuid REFERENCES infos(id) ON DELETE CASCADE,
    "building" varchar(255),
    "first_name" varchar(255),
    "last_name" varchar(255),
    "email" varchar(255),
    "matrix_user" varchar(255)
);

CREATE TABLE "contact_numbers" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "info_id" uuid REFERENCES infos(id) ON DELETE CASCADE,
    "contact_type" varchar(50) CHECK (contact_type IN ('syndic', 'emergency', 'maintenance')),
    "type" varchar(255),
    "description" text,
    "availability" varchar(255),
    "response_time" varchar(255),
    "name" varchar(255),
    "phone_number" varchar(255),
    "email" varchar(255),
    "office_hours" varchar(255),
    "address" text,
    "responsibility" text,
    "metadata" text,
    "qr_code_url" varchar(500)
);

CREATE TABLE "announcements" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "title" varchar(255) NOT NULL,
    "content" text NOT NULL,
    "summary" text,
    "created_at" timestamp with time zone NOT NULL,
    "updated_at" timestamp with time zone NOT NULL,
    "category" varchar(50) NOT NULL CHECK (category IN ('COMMUNITY_EVENT', 'LOST_AND_FOUND', 'SAFETY_ALERT', 'MAINTENANCE_NOTICE', 'SOCIAL_GATHERING', 'OTHER')) DEFAULT 'OTHER'
);

CREATE TABLE "custom_pages" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "ref" varchar(255) NOT NULL UNIQUE,
    "page_order" integer,
    "position" varchar(50) NOT NULL CHECK (position IN ('FOOTER_LINKS', 'COPYRIGHT', 'FOOTER_HELP')),
    "title" varchar(255) NOT NULL,
    "content" text NOT NULL
);

CREATE TABLE "newsletters" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "subject" varchar(255) NOT NULL,
    "content" text,
    "status" varchar(50) NOT NULL CHECK (status IN ('DRAFT', 'SCHEDULED', 'SENDING', 'SENT', 'CANCELLED', 'FAILED')) DEFAULT 'DRAFT',
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "scheduled_at" timestamp with time zone,
    "sent_at" timestamp with time zone,
    "created_by" uuid NOT NULL,
    "recipient_count" integer,
    "audience_type" varchar(50) NOT NULL DEFAULT 'ALL' CHECK (audience_type IN ('ALL', 'USER_TYPES', 'SPECIFIC_USERS')),
    "audience_user_types" jsonb,
    "audience_user_ids" jsonb,
    "audience_exclude_user_ids" jsonb,
    FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE CASCADE
);

CREATE TABLE "newsletter_logs" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "newsletter_id" uuid NOT NULL,
    "user_id" uuid NOT NULL,
    "user_email" varchar(255) NOT NULL,
    "status" varchar(50) NOT NULL CHECK (status IN ('PENDING', 'SENT', 'FAILED', 'BOUNCED', 'SKIPPED')) DEFAULT 'PENDING',
    "sent_at" timestamp with time zone,
    "error_message" text,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("newsletter_id") REFERENCES "newsletters"("id") ON DELETE CASCADE,
    FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);

CREATE INDEX "idx_newsletter_logs_newsletter_id" ON "newsletter_logs"("newsletter_id");
CREATE INDEX "idx_newsletter_logs_user_id" ON "newsletter_logs"("user_id");
CREATE INDEX "idx_newsletter_logs_status" ON "newsletter_logs"("status");
CREATE INDEX "idx_newsletter_logs_created_at" ON "newsletter_logs"("created_at");

CREATE TABLE "email_templates" (
    "id" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "type" varchar(50) NOT NULL CHECK (type IN ('WELCOME')),
    "name" varchar(255) NOT NULL,
    "subject" varchar(255) NOT NULL,
    "content" text,
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "created_by" uuid NOT NULL,
    "description" text,
    FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE CASCADE
);

CREATE INDEX "idx_email_templates_type" ON "email_templates"("type");
CREATE INDEX "idx_email_templates_is_active" ON "email_templates"("is_active");
CREATE INDEX "idx_email_templates_created_at" ON "email_templates"("created_at");

-- Function for updated_at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- UniFi Door Controllers (V3.11)
-- Note: API key is NOT stored here - it comes from application.yml (K8s secrets)
CREATE TABLE IF NOT EXISTS unifi_door_controllers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    controller_id VARCHAR(255) NOT NULL UNIQUE, -- Logical ID from application.yml (e.g., "main-controller")
    name VARCHAR(255), -- Name comes from config (application.yml), not stored in DB
    model VARCHAR(50) NOT NULL DEFAULT 'UD-Pro',
    last_seen TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_unifi_door_controllers_controller_id ON unifi_door_controllers(controller_id);
CREATE INDEX idx_unifi_door_controllers_model ON unifi_door_controllers(model);

-- UniFi Doors (V3.11)
CREATE TABLE IF NOT EXISTS unifi_doors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    door_controller_id UUID NOT NULL REFERENCES unifi_door_controllers(id) ON DELETE CASCADE,
    door_id VARCHAR(255) NOT NULL, -- UniFi door ID (e.g., "door-1", "door-2")
    name VARCHAR(255) NOT NULL,
    description TEXT,
    last_seen TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(door_controller_id, door_id)
);

CREATE INDEX idx_unifi_doors_door_controller_id ON unifi_doors(door_controller_id);
CREATE INDEX idx_unifi_doors_door_id ON unifi_doors(door_id);

-- Create triggers for updated_at (UniFi tables)
CREATE TRIGGER update_unifi_door_controllers_updated_at 
    BEFORE UPDATE ON unifi_door_controllers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_unifi_doors_updated_at 
    BEFORE UPDATE ON unifi_doors
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Digital Locks (migrated from V7__Create_digital_locks_table.sql)
CREATE TABLE digital_locks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(20) NOT NULL DEFAULT 'UNIFI' CHECK (type IN ('UNIFI')),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE', 'ERROR')),
    unifi_door_controller_id UUID REFERENCES unifi_door_controllers(id) ON DELETE SET NULL,
    unifi_door_id UUID REFERENCES unifi_doors(id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_digital_lock_type ON digital_locks(type);
CREATE INDEX idx_digital_lock_status ON digital_locks(status);

-- Spaces (migrated from V1__Create_spaces_tables.sql)
CREATE TABLE spaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    instructions TEXT,
    location TEXT,
    location_plan_image_id UUID,
    type VARCHAR(50) NOT NULL CHECK (type IN ('GUEST_ROOM', 'COMMON_ROOM', 'COWORKING', 'PARKING')),
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE', 'DISABLED')),
    tenant_price DECIMAL(10,2) NOT NULL,
    owner_price DECIMAL(10,2),
    cleaning_fee DECIMAL(10,2),
    deposit DECIMAL(10,2),
    currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
    min_duration_days INTEGER NOT NULL DEFAULT 1,
    max_duration_days INTEGER NOT NULL DEFAULT 365,
    capacity INTEGER,
    max_annual_reservations INTEGER NOT NULL DEFAULT 0,
    used_annual_reservations INTEGER NOT NULL DEFAULT 0,
    allowed_hours_start VARCHAR(5) DEFAULT '08:00',
    allowed_hours_end VARCHAR(5) DEFAULT '20:00',
    digital_lock_id UUID REFERENCES digital_locks(id) ON DELETE SET NULL,
    access_code_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    enable_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    cleaning_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    cleaning_email VARCHAR(255),
    cleaning_notifications_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    cleaning_calendar_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    cleaning_days_after_checkout INTEGER NOT NULL DEFAULT 0,
    cleaning_hour VARCHAR(5) DEFAULT '10:00',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_spaces_status ON spaces(status);
CREATE INDEX idx_spaces_type ON spaces(type);
CREATE INDEX idx_spaces_type_status ON spaces(type, status);
CREATE INDEX idx_spaces_digital_lock_id ON spaces(digital_lock_id);

-- Space Images (migrated from V1__Create_spaces_tables.sql)
CREATE TABLE space_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    url VARCHAR(500), -- Optional for external images
    image_data BYTEA, -- Binary data for images stored in DB
    mime_type VARCHAR(100), -- MIME type (image/jpeg, image/png, etc.)
    file_name VARCHAR(255), -- Original filename
    file_size INTEGER, -- File size in bytes
    alt_text VARCHAR(255),
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    order_index INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- Ensure either url or image_data is provided
    CONSTRAINT chk_space_images_data CHECK (
        (url IS NOT NULL AND image_data IS NULL) OR 
        (url IS NULL AND image_data IS NOT NULL)
    )
);

CREATE INDEX idx_space_images_space_id ON space_images(space_id);
CREATE INDEX idx_space_images_primary ON space_images(space_id, is_primary);

-- FK for location plan image (must be added after space_images exists)
ALTER TABLE spaces ADD CONSTRAINT fk_spaces_location_plan_image
    FOREIGN KEY (location_plan_image_id) REFERENCES space_images(id) ON DELETE SET NULL;

-- Space Shared With (espaces qui partagent le même espace physique)
CREATE TABLE space_shared_with (
    space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    shared_space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    PRIMARY KEY (space_id, shared_space_id)
);

CREATE INDEX idx_space_shared_with_space_id ON space_shared_with(space_id);
CREATE INDEX idx_space_shared_with_shared_space_id ON space_shared_with(shared_space_id);

-- Space Allowed Days (migrated from V1__Create_spaces_tables.sql)
CREATE TABLE space_allowed_days (
    space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    day_of_week VARCHAR(10) NOT NULL CHECK (day_of_week IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY')),
    PRIMARY KEY (space_id, day_of_week)
);

CREATE INDEX idx_space_allowed_days_space_id ON space_allowed_days(space_id);

-- Space Cleaning Days
CREATE TABLE space_cleaning_days (
    space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    day_of_week VARCHAR(10) NOT NULL CHECK (day_of_week IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY')),
    PRIMARY KEY (space_id, day_of_week)
);

CREATE INDEX idx_space_cleaning_days_space_id ON space_cleaning_days(space_id);

-- Units table (must be created before reservations as reservations references units)
CREATE TABLE units (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name varchar(255) NOT NULL,
    type varchar(50) NOT NULL DEFAULT 'FLAT' CHECK (type IN ('FLAT', 'GARAGE', 'PARKING', 'COMMERCIAL', 'OTHER')),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_units_type ON units(type);

-- Digital Door Credentials (V3.10)
-- Note: Must be created after units table due to foreign key reference
-- reservation_id foreign key will be added later after reservations table is created
CREATE TABLE IF NOT EXISTS digital_door_credentials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    unifi_door_controller_id UUID REFERENCES unifi_door_controllers(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL CHECK (type IN ('CODE', 'BADGE_VIGIK')),
    name VARCHAR(255) NOT NULL,
    origin VARCHAR(20) NOT NULL DEFAULT 'SPACE' CHECK (origin IN ('MANUAL', 'SPACE')),
    label VARCHAR(500), -- Reason for creation (for manual credentials)
    code VARCHAR(255), -- PIN code (for type CODE)
    vigik_badge_number VARCHAR(255), -- Badge number (for type BADGE_VIGIK)
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL, -- Link to unit for Vigik badges
    reservation_id UUID, -- Link to reservation (for SPACE origin credentials) - FK constraint added later
    activation_date TIMESTAMP WITH TIME ZONE,
    expiration_date TIMESTAMP WITH TIME ZONE, -- For all credentials (unified)
    digital_lock_id UUID REFERENCES digital_locks(id),
    digital_lock_code_id VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    physical_credential_token VARCHAR(255), -- Physical credential token
    last_synced_at TIMESTAMP WITH TIME ZONE,
    sync_status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (sync_status IN ('PENDING', 'SYNCED', 'FAILED', 'ORPHANED')),
    used_at TIMESTAMP,
    regenerated_at TIMESTAMP,
    regenerated_by UUID REFERENCES users(id) ON DELETE SET NULL, -- User who regenerated the code (NULL for system)
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_digital_door_credentials_unifi_door_controller_id ON digital_door_credentials(unifi_door_controller_id);
CREATE INDEX idx_digital_door_credentials_type ON digital_door_credentials(type);
CREATE INDEX idx_digital_door_credentials_code ON digital_door_credentials(code) WHERE code IS NOT NULL;
CREATE INDEX idx_digital_door_credentials_vigik_badge_number ON digital_door_credentials(vigik_badge_number) WHERE vigik_badge_number IS NOT NULL;
CREATE INDEX idx_digital_door_credentials_unit_id ON digital_door_credentials(unit_id) WHERE unit_id IS NOT NULL;
CREATE INDEX idx_digital_door_credentials_reservation_id ON digital_door_credentials(reservation_id) WHERE reservation_id IS NOT NULL;
CREATE INDEX idx_digital_door_credentials_physical_token ON digital_door_credentials(physical_credential_token) WHERE physical_credential_token IS NOT NULL;
CREATE INDEX idx_digital_door_credentials_is_active ON digital_door_credentials(is_active);
CREATE INDEX idx_digital_door_credentials_origin ON digital_door_credentials(origin);
CREATE INDEX idx_digital_door_credentials_digital_lock_id ON digital_door_credentials(digital_lock_id) WHERE digital_lock_id IS NOT NULL;

-- Table de jointure many-to-many entre digital_door_credentials et unifi_doors
CREATE TABLE IF NOT EXISTS digital_door_credential_unifi_doors (
    credential_id UUID NOT NULL REFERENCES digital_door_credentials(id) ON DELETE CASCADE,
    door_id UUID NOT NULL REFERENCES unifi_doors(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (credential_id, door_id)
);

CREATE INDEX idx_credential_unifi_doors_credential_id ON digital_door_credential_unifi_doors(credential_id);
CREATE INDEX idx_credential_unifi_doors_door_id ON digital_door_credential_unifi_doors(door_id);

-- Add unique constraints for digital_door_credentials
CREATE UNIQUE INDEX IF NOT EXISTS unique_code_per_controller 
    ON digital_door_credentials(unifi_door_controller_id, code) 
    WHERE type = 'CODE' AND code IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS unique_vigik_per_controller 
    ON digital_door_credentials(unifi_door_controller_id, vigik_badge_number) 
    WHERE type = 'BADGE_VIGIK' AND vigik_badge_number IS NOT NULL;

-- Create trigger for updated_at (digital_door_credentials)
CREATE TRIGGER update_digital_door_credentials_updated_at 
    BEFORE UPDATE ON digital_door_credentials
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Unit members table
CREATE TABLE unit_members (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    unit_id uuid REFERENCES units(id) ON DELETE CASCADE NOT NULL,
    user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    role varchar(50) NOT NULL CHECK (role IN ('ADMIN', 'MEMBER')),
    residence_role varchar(50) NOT NULL DEFAULT 'TENANT' CHECK (residence_role IN ('PROPRIETAIRE', 'BAILLEUR', 'MANAGER', 'TENANT')),
    joined_at timestamp DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(unit_id, user_id)
);
CREATE INDEX idx_unit_members_unit_id ON unit_members(unit_id);
CREATE INDEX idx_unit_members_user_id ON unit_members(user_id);
CREATE INDEX idx_unit_members_residence_role ON unit_members(residence_role);

-- Add primary_unit_id column to users table (after units table is created)
ALTER TABLE users ADD COLUMN primary_unit_id uuid REFERENCES units(id) ON DELETE SET NULL;
CREATE INDEX idx_users_primary_unit_id ON users(primary_unit_id);
CREATE INDEX idx_users_is_board_member ON users(is_board_member);

-- Unit invitations table
CREATE TABLE unit_invitations (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    unit_id uuid REFERENCES units(id) ON DELETE CASCADE NOT NULL,
    invited_user_id uuid REFERENCES users(id) ON DELETE SET NULL,
    invited_email varchar(255),
    invited_by uuid REFERENCES users(id) NOT NULL,
    status varchar(50) NOT NULL CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED')),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    responded_at timestamp
);
CREATE INDEX idx_unit_invitations_unit_id ON unit_invitations(unit_id);
CREATE INDEX idx_unit_invitations_invited_user_id ON unit_invitations(invited_user_id);
CREATE INDEX idx_unit_invitations_status ON unit_invitations(status);

-- Unit join requests table (requests from users to join a unit)
CREATE TABLE unit_join_requests (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    unit_id uuid REFERENCES units(id) ON DELETE CASCADE NOT NULL,
    requested_by uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    status varchar(50) NOT NULL CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),
    message text,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    responded_at timestamp,
    responded_by uuid REFERENCES users(id) ON DELETE SET NULL
);
CREATE INDEX idx_unit_join_requests_unit_id ON unit_join_requests(unit_id);
CREATE INDEX idx_unit_join_requests_requested_by ON unit_join_requests(requested_by);
CREATE INDEX idx_unit_join_requests_status ON unit_join_requests(status);

-- Tenant-level join requests (copropriété); ex-V30
CREATE TABLE IF NOT EXISTS users_join_requests (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    requested_by uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status varchar(50) NOT NULL CHECK (status IN ('PENDING', 'AWAITING_UNIT_CONFIRMATION', 'COMPLETED', 'REJECTED')),
    requester_role varchar(50) NOT NULL CHECK (requester_role IN ('PROPRIETAIRE', 'LOCATAIRE', 'SYNDIC', 'PRESTATAIRE', 'AUTRE')),
    message text,
    tenant_slug_snapshot varchar(255),
    decision_source varchar(30) CHECK (decision_source IN ('PORTAL', 'EMAIL')),
    suggested_unit_ids jsonb,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    responded_at timestamp with time zone,
    responded_by uuid REFERENCES users(id)
);
CREATE INDEX IF NOT EXISTS idx_users_join_requests_status ON users_join_requests(status);
CREATE INDEX IF NOT EXISTS idx_users_join_requests_requested_by ON users_join_requests(requested_by);
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_join_requests_one_open_per_user
    ON users_join_requests(requested_by)
    WHERE status IN ('PENDING', 'AWAITING_UNIT_CONFIRMATION');

CREATE TABLE IF NOT EXISTS users_join_request_units (
    join_request_id uuid NOT NULL REFERENCES users_join_requests(id) ON DELETE CASCADE,
    unit_id uuid NOT NULL REFERENCES units(id) ON DELETE CASCADE,
    source varchar(30) NOT NULL CHECK (source IN ('USER_SELECTED', 'AUTO_SUGGESTED', 'ADMIN_CONFIRMED')),
    PRIMARY KEY (join_request_id, unit_id)
);
CREATE INDEX IF NOT EXISTS idx_users_join_request_units_unit ON users_join_request_units(unit_id);

-- Reservations (migrated from V2__Create_reservations_tables.sql)
CREATE TABLE reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING_PAYMENT' CHECK (status IN ('PENDING_PAYMENT', 'PAYMENT_FAILED', 'EXPIRED', 'CONFIRMED', 'ACTIVE', 'COMPLETED', 'CANCELLED', 'REFUNDED')),
    total_price DECIMAL(10,2) NOT NULL,
    stripe_payment_intent_id VARCHAR(255),
    stripe_session_id VARCHAR(255),
    payment_status VARCHAR(50) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PROCESSING', 'SUCCEEDED', 'FAILED', 'CANCELLED', 'REFUNDED', 'PARTIALLY_REFUNDED')),
    cancellation_reason TEXT,
    cancelled_at TIMESTAMP,
    cancelled_by VARCHAR(255),
    payment_expires_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reservations_user_id ON reservations(user_id);
CREATE INDEX idx_reservations_space_id ON reservations(space_id);
CREATE INDEX idx_reservations_unit_id ON reservations(unit_id);
CREATE INDEX idx_reservations_status ON reservations(status);
CREATE INDEX idx_reservations_payment_status ON reservations(payment_status);
CREATE INDEX idx_reservations_dates ON reservations(start_date, end_date);
CREATE INDEX idx_reservations_space_dates ON reservations(space_id, start_date, end_date);
CREATE INDEX idx_reservations_stripe_payment_intent ON reservations(stripe_payment_intent_id);
CREATE INDEX idx_reservations_stripe_session ON reservations(stripe_session_id);
CREATE INDEX idx_reservations_payment_expiration ON reservations(status, payment_expires_at) WHERE status = 'PENDING_PAYMENT';

-- Add foreign key constraint for reservation_id (after reservations table is created)
ALTER TABLE digital_door_credentials 
    ADD CONSTRAINT fk_digital_door_credentials_reservation_id 
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE;

-- Create indexes for columns that may not have been indexed yet
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_digital_lock_code ON digital_door_credentials(digital_lock_code_id) WHERE digital_lock_code_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_expiration_date ON digital_door_credentials(expiration_date) WHERE expiration_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_sync_status ON digital_door_credentials(sync_status);

-- Access Codes table has been merged into digital_door_credentials
-- All access code functionality is now handled by digital_door_credentials with reservation_id

-- Add constraints
ALTER TABLE reservations ADD CONSTRAINT chk_reservations_dates CHECK (end_date >= start_date);

-- Create trigger function for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers
CREATE TRIGGER update_spaces_updated_at BEFORE UPDATE ON spaces
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_space_images_updated_at BEFORE UPDATE ON space_images
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reservations_updated_at BEFORE UPDATE ON reservations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Reservation Feedback (migrated from V8__Create_reservation_feedback_table.sql)
CREATE TABLE reservation_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    cleanliness INTEGER CHECK (cleanliness >= 1 AND cleanliness <= 5),
    communication INTEGER CHECK (communication >= 1 AND communication <= 5),
    value INTEGER CHECK (value >= 1 AND value <= 5),
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique constraint: one feedback per reservation
    CONSTRAINT uk_reservation_feedback_reservation 
        UNIQUE (reservation_id),
    
    -- Check constraints for optional ratings
    CONSTRAINT chk_cleanliness_range CHECK (cleanliness IS NULL OR (cleanliness >= 1 AND cleanliness <= 5)),
    CONSTRAINT chk_communication_range CHECK (communication IS NULL OR (communication >= 1 AND communication <= 5)),
    CONSTRAINT chk_value_range CHECK (value IS NULL OR (value >= 1 AND value <= 5))
);

-- Create indexes for better performance
CREATE INDEX idx_reservation_feedback_reservation_id ON reservation_feedback(reservation_id);
CREATE INDEX idx_reservation_feedback_user_id ON reservation_feedback(user_id);
CREATE INDEX idx_reservation_feedback_submitted_at ON reservation_feedback(submitted_at);

-- Create trigger for reservation_feedback updated_at
CREATE TRIGGER update_reservation_feedback_updated_at BEFORE UPDATE ON reservation_feedback
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Space Settings (for global platform fee configuration)
CREATE TABLE space_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    platform_fee_percentage DECIMAL(5,2) NOT NULL DEFAULT 2.00,
    platform_fixed_fee DECIMAL(10,2) NOT NULL DEFAULT 0.25,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger for space_settings updated_at
CREATE TRIGGER update_space_settings_updated_at BEFORE UPDATE ON space_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Add platform fee columns to reservations table
ALTER TABLE reservations ADD COLUMN platform_fee_amount DECIMAL(10,2);
ALTER TABLE reservations ADD COLUMN platform_fixed_fee_amount DECIMAL(10,2);

-- Reservation Audit Log Table
CREATE TABLE reservation_audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    log_message TEXT,
    performed_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indexes for reservation audit log
CREATE INDEX idx_reservation_audit_log_reservation_id ON reservation_audit_log(reservation_id);
CREATE INDEX idx_reservation_audit_log_created_at ON reservation_audit_log(created_at);
CREATE INDEX idx_reservation_audit_log_event_type ON reservation_audit_log(event_type);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for units updated_at
CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON units
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Migration: Set primary_unit_id for existing users based on their first unit membership
-- This sets the primary unit for users who are TENANT or OWNER in at least one unit
UPDATE users 
SET primary_unit_id = (
    SELECT um.unit_id 
    FROM unit_members um 
    WHERE um.user_id = users.id 
    LIMIT 1
)
WHERE primary_unit_id IS NULL 
AND EXISTS (
    SELECT 1 FROM unit_members um WHERE um.user_id = users.id
);

-- Matrix Bot Tables
CREATE TABLE matrix_bot_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    access_token VARCHAR(2048) NOT NULL,
    refresh_token VARCHAR(2048) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_matrix_bot_tokens_created_at ON matrix_bot_tokens(created_at DESC);

CREATE TABLE matrix_bot_error_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    last_notification_date DATE NOT NULL UNIQUE,
    error_message TEXT
);

CREATE INDEX idx_matrix_bot_error_notifications_date ON matrix_bot_error_notifications(last_notification_date);

-- Create trigger for matrix_bot_tokens updated_at
CREATE TRIGGER update_matrix_bot_tokens_updated_at BEFORE UPDATE ON matrix_bot_tokens
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Note: matrix_bot_sync_state table was removed, trigger removed accordingly

-- TV Mode Feature: Create TV info tables
-- Main TV info configuration table
CREATE TABLE tv_info (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50) NOT NULL CHECK (type IN ('ANNOUNCEMENT', 'WELCOME', 'STATIC', 'SPACE')),
    enabled BOOLEAN NOT NULL DEFAULT true,
    display_duration_seconds INTEGER NOT NULL DEFAULT 10 CHECK (display_duration_seconds >= 3 AND display_duration_seconds <= 15),
    config JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(type)
);

CREATE INDEX idx_tv_info_type ON tv_info(type);
CREATE INDEX idx_tv_info_enabled ON tv_info(enabled);

-- TV info announcements - Links announcements to TV mode
CREATE TABLE tv_info_announcements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    announcement_id UUID NOT NULL REFERENCES announcements(id) ON DELETE CASCADE,
    tv_enabled BOOLEAN NOT NULL DEFAULT false,
    display_days INTEGER NOT NULL DEFAULT 7 CHECK (display_days >= 1 AND display_days <= 15),
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(announcement_id)
);

CREATE INDEX idx_tv_info_announcements_announcement_id ON tv_info_announcements(announcement_id);
CREATE INDEX idx_tv_info_announcements_tv_enabled ON tv_info_announcements(tv_enabled);
CREATE INDEX idx_tv_info_announcements_dates ON tv_info_announcements(start_date, end_date);

-- TV info welcome - Welcome message configuration
CREATE TABLE tv_info_welcome (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_days INTEGER NOT NULL DEFAULT 7 CHECK (display_days >= 1 AND display_days <= 15),
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- TV info static - Static content (Element promo, etc.)
CREATE TABLE tv_info_static (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content_type VARCHAR(50) NOT NULL CHECK (content_type IN ('ELEMENT_PROMO', 'PORTAL_PROMO', 'ALFRED_PROMO')),
    display_days INTEGER NOT NULL DEFAULT 30 CHECK (display_days >= 1 AND display_days <= 365),
    qr_code_url TEXT,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tv_info_static_content_type ON tv_info_static(content_type);
CREATE INDEX idx_tv_info_static_enabled ON tv_info_static(enabled);

-- TV info spaces - Space information configuration
CREATE TABLE tv_info_spaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_days INTEGER NOT NULL DEFAULT 7 CHECK (display_days >= 1 AND display_days <= 15),
    show_calendar BOOLEAN NOT NULL DEFAULT true,
    show_rules BOOLEAN NOT NULL DEFAULT true,
    show_stats BOOLEAN NOT NULL DEFAULT false,
    show_essential_info BOOLEAN NOT NULL DEFAULT true,
    space_type_config JSONB,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tv_info_spaces_enabled ON tv_info_spaces(enabled);

-- TV info spaces - Selected space IDs (many-to-many relationship)
CREATE TABLE tv_info_spaces_selected (
    tv_info_spaces_id UUID NOT NULL REFERENCES tv_info_spaces(id) ON DELETE CASCADE,
    space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    PRIMARY KEY (tv_info_spaces_id, space_id)
);

CREATE INDEX idx_tv_info_spaces_selected_space_id ON tv_info_spaces_selected(space_id);

-- TV info CSS - Custom CSS per TV info type
CREATE TABLE tv_info_css (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tv_info_type VARCHAR(50) NOT NULL CHECK (tv_info_type IN ('ANNOUNCEMENT', 'WELCOME', 'STATIC', 'SPACE')),
    background_css TEXT,
    title_css TEXT,
    content_css TEXT,
    custom_css TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tv_info_type)
);

CREATE INDEX idx_tv_info_css_type ON tv_info_css(tv_info_type);

-- TV slide designs - Slide design templates and options
CREATE TABLE tv_slide_designs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    background_type VARCHAR(50) NOT NULL CHECK (background_type IN ('SOLID', 'GRADIENT', 'IMAGE')),
    background_value TEXT NOT NULL,
    corner_element_type VARCHAR(50) NOT NULL CHECK (corner_element_type IN ('LEAVES', 'GEOMETRIC', 'NONE')),
    corner_element_position VARCHAR(100) NOT NULL,
    corner_element_svg TEXT,
    icon_position VARCHAR(50) NOT NULL CHECK (icon_position IN ('TOP_LEFT', 'TOP_RIGHT', 'BOTTOM_LEFT', 'BOTTOM_RIGHT', 'CENTER')),
    title_style JSONB,
    content_style JSONB,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tv_slide_designs_name ON tv_slide_designs(name);
CREATE INDEX idx_tv_slide_designs_enabled ON tv_slide_designs(enabled);

-- Create trigger for TV tables updated_at
CREATE TRIGGER update_tv_info_updated_at BEFORE UPDATE ON tv_info
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tv_info_announcements_updated_at BEFORE UPDATE ON tv_info_announcements
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tv_info_welcome_updated_at BEFORE UPDATE ON tv_info_welcome
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tv_info_static_updated_at BEFORE UPDATE ON tv_info_static
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tv_info_spaces_updated_at BEFORE UPDATE ON tv_info_spaces
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tv_info_css_updated_at BEFORE UPDATE ON tv_info_css
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tv_slide_designs_updated_at BEFORE UPDATE ON tv_slide_designs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Assistant Debug Conversations Tables
-- Main table for storing debug conversations
-- Conversation ID format: "portal-{uuid}" for Portal conversations, "matrix-{roomId}" for Matrix conversations
CREATE TABLE assistant_debug_conversations (
    conversation_id VARCHAR(255) PRIMARY KEY,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_message_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    conversation_data JSONB NOT NULL,
    -- Cost metrics (calculated from LLM requests)
    total_cost DOUBLE PRECISION,
    -- LLM Judge evaluation metrics (aggregated from LLM_JUDGE events)
    judge_score DOUBLE PRECISION,
    judge_correctness DOUBLE PRECISION,
    judge_clarity DOUBLE PRECISION,
    judge_completeness DOUBLE PRECISION,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Authors table (many-to-many relationship between conversations and users)
CREATE TABLE assistant_debug_conversation_authors (
    conversation_id VARCHAR(255) NOT NULL REFERENCES assistant_debug_conversations(conversation_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (conversation_id, user_id)
);

-- Indexes for assistant_debug_conversations
CREATE INDEX idx_assistant_debug_conversations_last_message_date 
    ON assistant_debug_conversations(last_message_date);

CREATE INDEX idx_assistant_debug_conversation_authors_user_id 
    ON assistant_debug_conversation_authors(user_id);

-- Indexes for filtering by cost and judge scores
CREATE INDEX idx_assistant_debug_conversations_total_cost 
    ON assistant_debug_conversations(total_cost) WHERE total_cost IS NOT NULL;

CREATE INDEX idx_assistant_debug_conversations_judge_score 
    ON assistant_debug_conversations(judge_score) WHERE judge_score IS NOT NULL;

CREATE INDEX idx_assistant_debug_conversations_judge_correctness 
    ON assistant_debug_conversations(judge_correctness) WHERE judge_correctness IS NOT NULL;

CREATE INDEX idx_assistant_debug_conversations_judge_clarity 
    ON assistant_debug_conversations(judge_clarity) WHERE judge_clarity IS NOT NULL;

CREATE INDEX idx_assistant_debug_conversations_judge_completeness 
    ON assistant_debug_conversations(judge_completeness) WHERE judge_completeness IS NOT NULL;

-- GIN index for JSONB queries (allows efficient queries on conversation_data)
CREATE INDEX idx_assistant_debug_conversations_conversation_data 
    ON assistant_debug_conversations USING GIN (conversation_data);

-- Index on start_date for cleanup queries
CREATE INDEX idx_assistant_debug_conversations_start_date 
    ON assistant_debug_conversations(start_date);

-- Create trigger for assistant_debug_conversations updated_at
CREATE TRIGGER update_assistant_debug_conversations_updated_at BEFORE UPDATE ON assistant_debug_conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- LLM Judge Evaluations Table
-- Stores LLM-as-a-Judge evaluations of AI assistant responses
CREATE TABLE llm_judge_evaluations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id VARCHAR(255) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    message_id VARCHAR(255) NOT NULL,
    user_question TEXT,
    bot_response TEXT,
    evaluation_score INTEGER,
    correctness_score INTEGER,
    clarity_score INTEGER,
    completeness_score INTEGER,
    evaluation_feedback TEXT,
    issues TEXT,
    user_reaction_emoji VARCHAR(50),
    user_reaction_sentiment INTEGER,
    evaluated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    warned_in_it_room BOOLEAN DEFAULT FALSE
);

-- Add indexes for common queries
CREATE INDEX idx_llm_judge_evaluations_message_id ON llm_judge_evaluations(message_id);
CREATE INDEX idx_llm_judge_evaluations_room_id ON llm_judge_evaluations(room_id);
CREATE INDEX idx_llm_judge_evaluations_user_id ON llm_judge_evaluations(user_id);
CREATE INDEX idx_llm_judge_evaluations_evaluated_at ON llm_judge_evaluations(evaluated_at);
CREATE INDEX idx_llm_judge_evaluations_score ON llm_judge_evaluations(evaluation_score);
CREATE INDEX idx_llm_judge_evaluations_warned ON llm_judge_evaluations(warned_in_it_room) WHERE warned_in_it_room = FALSE;

-- Add comments for documentation
COMMENT ON TABLE llm_judge_evaluations IS 'Stores LLM-as-a-Judge evaluations of AI assistant responses';
COMMENT ON COLUMN llm_judge_evaluations.evaluation_score IS 'Overall score from LLM-as-a-Judge (0-100)';
COMMENT ON COLUMN llm_judge_evaluations.user_reaction_sentiment IS 'Sentiment of user emoji reaction: -1 (negative), 0 (neutral), 1 (positive)';
COMMENT ON COLUMN llm_judge_evaluations.warned_in_it_room IS 'Whether a warning was sent to IT room for low score';

-- Incident Management Tables
-- Sequence for incremental incident reference numbers
CREATE SEQUENCE incident_ref_seq START WITH 1 INCREMENT BY 1;

-- Main incidents table
CREATE TABLE incidents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_ref INTEGER UNIQUE NOT NULL DEFAULT nextval('incident_ref_seq'),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'WAITING_EXTERNAL', 'WAITING_INTERNAL', 'RESOLVED', 'ARCHIVED')),
    priority VARCHAR(50) NOT NULL DEFAULT 'MEDIUM' CHECK (priority IN ('URGENT', 'HIGH', 'MEDIUM', 'LOW')),
    visibility VARCHAR(50) NOT NULL DEFAULT 'EVERYONE' CHECK (visibility IN ('INTERNAL', 'EXTERNAL', 'BOARD_MEMBER', 'MANAGER', 'OWNER', 'EVERYONE')),
    impact_level VARCHAR(50) NOT NULL DEFAULT 'MEDIUM' CHECK (impact_level IN ('LOW', 'MEDIUM', 'HIGH')),
    affected_units INTEGER,
    expected_response_date TIMESTAMP WITH TIME ZONE,
    expected_resolution_date TIMESTAMP WITH TIME ZONE,
    location_scope VARCHAR(50) NOT NULL DEFAULT 'UNIT' CHECK (location_scope IN ('UNIT', 'BUILDING', 'COMMON_AREA', 'GARAGE', 'GLOBAL')),
    location_ref VARCHAR(255),
    ai_summary TEXT,
    summary_updated_at TIMESTAMP WITH TIME ZONE,
    resolution_reason TEXT,
    solution_applied TEXT,
    follow_up_required BOOLEAN NOT NULL DEFAULT FALSE,
    matrix_room VARCHAR(255),
    owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_incidents_status ON incidents(status);
CREATE INDEX idx_incidents_priority ON incidents(priority);
CREATE INDEX idx_incidents_visibility ON incidents(visibility);
CREATE INDEX idx_incidents_impact_level ON incidents(impact_level);
CREATE INDEX idx_incidents_location_scope ON incidents(location_scope);
CREATE INDEX idx_incidents_expected_response_date ON incidents(expected_response_date);
CREATE INDEX idx_incidents_expected_resolution_date ON incidents(expected_resolution_date);
CREATE INDEX idx_incidents_owner_id ON incidents(owner_id);
CREATE INDEX idx_incidents_created_by ON incidents(created_by);
CREATE INDEX idx_incidents_created_at ON incidents(created_at);
CREATE INDEX idx_incidents_updated_at ON incidents(updated_at);
CREATE INDEX idx_incidents_ref ON incidents(incident_ref);

-- Incident tags (many-to-many)
CREATE TABLE incident_tags (
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    tag VARCHAR(100) NOT NULL,
    PRIMARY KEY (incident_id, tag)
);

CREATE INDEX idx_incident_tags_incident_id ON incident_tags(incident_id);
CREATE INDEX idx_incident_tags_tag ON incident_tags(tag);

-- Incident participants (contacts/intervenants associated with an incident)
CREATE TABLE incident_participants (
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    contact_id UUID NOT NULL REFERENCES contact_numbers(id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    added_by UUID REFERENCES users(id) ON DELETE SET NULL,
    PRIMARY KEY (incident_id, contact_id)
);

CREATE INDEX idx_incident_participants_incident_id ON incident_participants(incident_id);
CREATE INDEX idx_incident_participants_contact_id ON incident_participants(contact_id);

-- Incident events (event-sourced history)
CREATE TABLE incident_events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL CHECK (event_type IN ('COMMUNICATION', 'STATE', 'FILE', 'SYSTEM')),
    event_sub_type VARCHAR(50) NOT NULL,
    visibility VARCHAR(50) NOT NULL DEFAULT 'PRIMARY' CHECK (visibility IN ('PRIMARY', 'SECONDARY')),
    payload JSONB,
    author_type VARCHAR(50) NOT NULL CHECK (author_type IN ('user', 'system', 'bot', 'ai')),
    author_id UUID, -- Optional: linked user/contact ID if found, no FK constraint
    author_email VARCHAR(255), -- Email address of the author (from email, user, etc.)
    author_name VARCHAR(255), -- Display name of the author
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_incident_events_incident_id ON incident_events(incident_id);
CREATE INDEX idx_incident_events_event_type ON incident_events(event_type);
CREATE INDEX idx_incident_events_event_sub_type ON incident_events(event_sub_type);
CREATE INDEX idx_incident_events_visibility ON incident_events(visibility);
CREATE INDEX idx_incident_events_created_at ON incident_events(created_at);
CREATE INDEX idx_incident_events_author ON incident_events(author_type, author_id);
CREATE INDEX idx_incident_events_author_email ON incident_events(author_email);

-- Incident files (metadata only, actual files in Scaleway Object Storage)
CREATE TABLE incident_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    object_key VARCHAR(500) NOT NULL, -- S3 key in Scaleway
    filename VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    size BIGINT NOT NULL,
    uploaded_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    uploaded_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_incident_files_incident_id ON incident_files(incident_id);
CREATE INDEX idx_incident_files_uploaded_by ON incident_files(uploaded_by);
CREATE INDEX idx_incident_files_uploaded_at ON incident_files(uploaded_at);

-- Unassigned emails (emails received that couldn't be matched to an incident)
CREATE TABLE unassigned_emails (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_email VARCHAR(255) NOT NULL,
    subject VARCHAR(500),
    body TEXT,
    headers TEXT,
    received_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN NOT NULL DEFAULT FALSE,
    processed_at TIMESTAMP WITH TIME ZONE,
    processed_by UUID REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_unassigned_emails_processed ON unassigned_emails(processed);
CREATE INDEX idx_unassigned_emails_received_at ON unassigned_emails(received_at);

-- Incident expected actions (next expected action tracking)
CREATE TABLE incident_expected_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    action TEXT NOT NULL,
    expected_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_incident_expected_actions_incident_id ON incident_expected_actions(incident_id);
CREATE INDEX idx_incident_expected_actions_expected_date ON incident_expected_actions(expected_date);

-- Incident relations (related incidents)
CREATE TABLE incident_relations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    related_incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    relation_type VARCHAR(50) NOT NULL CHECK (relation_type IN ('CAUSED_BY', 'RELATED_TO', 'DUPLICATE_OF', 'BLOCKS', 'BLOCKED_BY')),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE(incident_id, related_incident_id)
);

CREATE INDEX idx_incident_relations_incident_id ON incident_relations(incident_id);
CREATE INDEX idx_incident_relations_related_incident_id ON incident_relations(related_incident_id);
CREATE INDEX idx_incident_relations_relation_type ON incident_relations(relation_type);

-- Incident watchers (users watching an incident without being owner)
CREATE TABLE incident_watchers (
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    added_by UUID REFERENCES users(id) ON DELETE SET NULL,
    PRIMARY KEY (incident_id, user_id)
);

CREATE INDEX idx_incident_watchers_incident_id ON incident_watchers(incident_id);
CREATE INDEX idx_incident_watchers_user_id ON incident_watchers(user_id);

-- Create trigger for incidents updated_at
CREATE TRIGGER update_incidents_updated_at BEFORE UPDATE ON incidents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Align users.id and users.user_id (ex-V31/V32; V32 guards when only user_id column exists)
CREATE OR REPLACE FUNCTION sync_users_id_user_id()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.user_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = current_schema() AND table_name = 'users' AND column_name = 'id'
        ) THEN
            NEW.id := NEW.user_id;
        END IF;
    ELSIF NEW.id IS NOT NULL THEN
        NEW.user_id := NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_users_id_user_id ON users;
CREATE TRIGGER trg_sync_users_id_user_id
    BEFORE INSERT OR UPDATE ON users
    FOR EACH ROW
    EXECUTE PROCEDURE sync_users_id_user_id();
