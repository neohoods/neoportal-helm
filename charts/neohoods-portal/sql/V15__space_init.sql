-- Digital Locks (migrated from V7__Create_digital_locks_table.sql)
CREATE TABLE digital_locks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
        type VARCHAR(20) NOT NULL DEFAULT 'TTLOCK' CHECK (type IN ('TTLOCK', 'NUKI', 'YALE')),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE', 'ERROR')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_digital_lock_type ON digital_locks(type);
CREATE INDEX idx_digital_lock_status ON digital_locks(status);

-- TTLock Configuration
CREATE TABLE ttlock_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    digital_lock_id UUID NOT NULL REFERENCES digital_locks(id) ON DELETE CASCADE,
    device_id VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    battery_level INTEGER,
    signal_strength INTEGER,
    last_seen TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(digital_lock_id)
);

CREATE INDEX idx_ttlock_configs_digital_lock_id ON ttlock_configs(digital_lock_id);
CREATE INDEX idx_ttlock_configs_device_id ON ttlock_configs(device_id);

-- Nuki Configuration
CREATE TABLE nuki_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    digital_lock_id UUID NOT NULL REFERENCES digital_locks(id) ON DELETE CASCADE,
    device_id VARCHAR(255) NOT NULL,
    token VARCHAR(500) NOT NULL,
    battery_level INTEGER,
    last_seen TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(digital_lock_id)
);

CREATE INDEX idx_nuki_configs_digital_lock_id ON nuki_configs(digital_lock_id);
CREATE INDEX idx_nuki_configs_device_id ON nuki_configs(device_id);

-- Note: ttlock_devices table is kept for reference but data is inserted directly into digital_locks and ttlock_configs

-- Spaces (migrated from V1__Create_spaces_tables.sql)
CREATE TABLE spaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    instructions TEXT,
    type VARCHAR(50) NOT NULL CHECK (type IN ('GUEST_ROOM', 'COMMON_ROOM', 'COWORKING', 'PARKING')),
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE', 'DISABLED')),
    tenant_price DECIMAL(10,2) NOT NULL,
    owner_price DECIMAL(10,2),
    cleaning_fee DECIMAL(10,2),
    deposit DECIMAL(10,2),
    currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
    min_duration_days INTEGER NOT NULL DEFAULT 1,
    max_duration_days INTEGER NOT NULL DEFAULT 365,
    requires_apartment_access BOOLEAN NOT NULL DEFAULT FALSE,
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
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    name varchar(255) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Unit members table
CREATE TABLE unit_members (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    unit_id uuid REFERENCES units(id) ON DELETE CASCADE NOT NULL,
    user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    role varchar(50) NOT NULL CHECK (role IN ('ADMIN', 'MEMBER')),
    joined_at timestamp DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(unit_id, user_id)
);
CREATE INDEX idx_unit_members_unit_id ON unit_members(unit_id);
CREATE INDEX idx_unit_members_user_id ON unit_members(user_id);

-- Unit invitations table
CREATE TABLE unit_invitations (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
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
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
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

-- Access Codes (migrated from V2__Create_reservations_tables.sql)
CREATE TABLE access_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    code VARCHAR(10) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    digital_lock_id UUID REFERENCES digital_locks(id),
    digital_lock_code_id VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    used_at TIMESTAMP,
    regenerated_at TIMESTAMP,
    regenerated_by VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_access_codes_reservation_id ON access_codes(reservation_id);
CREATE INDEX idx_access_codes_code ON access_codes(code);
CREATE INDEX idx_access_codes_active ON access_codes(is_active);
CREATE INDEX idx_access_codes_expires_at ON access_codes(expires_at);
CREATE INDEX idx_access_codes_digital_lock ON access_codes(digital_lock_id);
CREATE INDEX idx_access_codes_digital_lock_code ON access_codes(digital_lock_code_id);

-- Add constraints
ALTER TABLE reservations ADD CONSTRAINT chk_reservations_dates CHECK (end_date >= start_date);
ALTER TABLE access_codes ADD CONSTRAINT chk_access_codes_expires_after_creation CHECK (expires_at > created_at);

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

CREATE TRIGGER update_access_codes_updated_at BEFORE UPDATE ON access_codes
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

-- Add primary_unit_id column to users table (for explicit primary unit management)
ALTER TABLE users ADD COLUMN IF NOT EXISTS primary_unit_id UUID REFERENCES units(id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_users_primary_unit_id ON users(primary_unit_id);