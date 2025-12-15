-- Migration V3.4: Add recent database changes
-- This migration includes all schema changes from Flyway migrations V8 through V23

-- ============================================================================
-- V8: Create reservation_feedback table
-- ============================================================================
CREATE TABLE IF NOT EXISTS reservation_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    cleanliness INTEGER CHECK (cleanliness >= 1 AND cleanliness <= 5),
    communication INTEGER CHECK (communication >= 1 AND communication <= 5),
    value INTEGER CHECK (value >= 1 AND value <= 5),
    submitted_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT fk_reservation_feedback_reservation 
        FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    CONSTRAINT fk_reservation_feedback_user 
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Unique constraint: one feedback per reservation
    CONSTRAINT uk_reservation_feedback_reservation 
        UNIQUE (reservation_id),
    
    -- Check constraints for optional ratings
    CONSTRAINT chk_cleanliness_range CHECK (cleanliness IS NULL OR (cleanliness >= 1 AND cleanliness <= 5)),
    CONSTRAINT chk_communication_range CHECK (communication IS NULL OR (communication >= 1 AND communication <= 5)),
    CONSTRAINT chk_value_range CHECK (value IS NULL OR (value >= 1 AND value <= 5))
);

CREATE INDEX IF NOT EXISTS idx_reservation_feedback_reservation_id ON reservation_feedback(reservation_id);
CREATE INDEX IF NOT EXISTS idx_reservation_feedback_user_id ON reservation_feedback(user_id);
CREATE INDEX IF NOT EXISTS idx_reservation_feedback_submitted_at ON reservation_feedback(submitted_at);

-- Create trigger for reservation_feedback updated_at
CREATE TRIGGER update_reservation_feedback_updated_at BEFORE UPDATE ON reservation_feedback
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- V9: Add cleaning settings to spaces table
-- ============================================================================
ALTER TABLE spaces
ADD COLUMN IF NOT EXISTS cleaning_enabled BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN IF NOT EXISTS cleaning_email VARCHAR(255),
ADD COLUMN IF NOT EXISTS cleaning_notifications_enabled BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN IF NOT EXISTS cleaning_calendar_enabled BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN IF NOT EXISTS cleaning_days_after_checkout INTEGER DEFAULT 0 NOT NULL,
ADD COLUMN IF NOT EXISTS cleaning_hour VARCHAR(5) DEFAULT '10:00' NOT NULL;

-- ============================================================================
-- V17: Make residence_role required in unit_members
-- ============================================================================
-- First, update all NULL values to 'TENANT' (default)
UPDATE unit_members SET residence_role = 'TENANT' WHERE residence_role IS NULL;

-- Now make the column NOT NULL with default
ALTER TABLE unit_members 
    ALTER COLUMN residence_role SET NOT NULL,
    ALTER COLUMN residence_role SET DEFAULT 'TENANT';

-- ============================================================================
-- V18: Add phone_number to users table
-- ============================================================================
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone_number VARCHAR(255);

-- ============================================================================
-- V19: Add COMMERCIAL and OTHER to unit types
-- ============================================================================
ALTER TABLE units DROP CONSTRAINT IF EXISTS units_type_check;
ALTER TABLE units ADD CONSTRAINT units_type_check CHECK (type IN ('FLAT', 'GARAGE', 'PARKING', 'COMMERCIAL', 'OTHER'));

-- ============================================================================
-- V20: Remove user_properties table
-- ============================================================================
DROP TABLE IF EXISTS user_properties CASCADE;

-- ============================================================================
-- V21: Add UNIT_JOIN_REQUEST and RESERVATION to notifications type CHECK constraint
-- ============================================================================
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_type_check;
ALTER TABLE notifications ADD CONSTRAINT notifications_type_check CHECK (type IN (
    'ADMIN_NEW_USER',
    'NEW_ANNOUNCEMENT',
    'RESERVATION',
    'UNIT_INVITATION',
    'UNIT_JOIN_REQUEST'
));

-- ============================================================================
-- V22: Create TV info tables
-- ============================================================================
-- Main TV info configuration table
CREATE TABLE IF NOT EXISTS tv_info (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(50) NOT NULL CHECK (type IN ('ANNOUNCEMENT', 'WELCOME', 'STATIC', 'SPACE')),
    enabled BOOLEAN NOT NULL DEFAULT true,
    display_duration_seconds INTEGER NOT NULL DEFAULT 10 CHECK (display_duration_seconds >= 3 AND display_duration_seconds <= 15),
    config JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(type)
);

CREATE INDEX IF NOT EXISTS idx_tv_info_type ON tv_info(type);
CREATE INDEX IF NOT EXISTS idx_tv_info_enabled ON tv_info(enabled);

-- TV info announcements - Links announcements to TV mode
CREATE TABLE IF NOT EXISTS tv_info_announcements (
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

CREATE INDEX IF NOT EXISTS idx_tv_info_announcements_announcement_id ON tv_info_announcements(announcement_id);
CREATE INDEX IF NOT EXISTS idx_tv_info_announcements_tv_enabled ON tv_info_announcements(tv_enabled);
CREATE INDEX IF NOT EXISTS idx_tv_info_announcements_dates ON tv_info_announcements(start_date, end_date);

-- TV info welcome - Welcome message configuration
CREATE TABLE IF NOT EXISTS tv_info_welcome (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_days INTEGER NOT NULL DEFAULT 7 CHECK (display_days >= 1 AND display_days <= 15),
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- TV info static - Static content (Element promo, etc.)
CREATE TABLE IF NOT EXISTS tv_info_static (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content_type VARCHAR(50) NOT NULL CHECK (content_type IN ('ELEMENT_PROMO', 'PORTAL_PROMO', 'ALFRED_PROMO')),
    display_days INTEGER NOT NULL DEFAULT 30 CHECK (display_days >= 1 AND display_days <= 365),
    qr_code_url TEXT,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tv_info_static_content_type ON tv_info_static(content_type);
CREATE INDEX IF NOT EXISTS idx_tv_info_static_enabled ON tv_info_static(enabled);

-- TV info spaces - Space information configuration
CREATE TABLE IF NOT EXISTS tv_info_spaces (
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

CREATE INDEX IF NOT EXISTS idx_tv_info_spaces_enabled ON tv_info_spaces(enabled);

-- TV info spaces - Selected space IDs (many-to-many relationship)
CREATE TABLE IF NOT EXISTS tv_info_spaces_selected (
    tv_info_spaces_id UUID NOT NULL REFERENCES tv_info_spaces(id) ON DELETE CASCADE,
    space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    PRIMARY KEY (tv_info_spaces_id, space_id)
);

CREATE INDEX IF NOT EXISTS idx_tv_info_spaces_selected_tv_info_spaces_id ON tv_info_spaces_selected(tv_info_spaces_id);
CREATE INDEX IF NOT EXISTS idx_tv_info_spaces_selected_space_id ON tv_info_spaces_selected(space_id);

-- TV info CSS - Custom CSS per TV info type
CREATE TABLE IF NOT EXISTS tv_info_css (
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

CREATE INDEX IF NOT EXISTS idx_tv_info_css_type ON tv_info_css(tv_info_type);

-- TV slide designs - Slide design templates and options
CREATE TABLE IF NOT EXISTS tv_slide_designs (
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

CREATE INDEX IF NOT EXISTS idx_tv_slide_designs_name ON tv_slide_designs(name);
CREATE INDEX IF NOT EXISTS idx_tv_slide_designs_enabled ON tv_slide_designs(enabled);

-- Create triggers for TV tables updated_at
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

-- Insert default TV info configurations for each type (if not exists)
INSERT INTO tv_info (type, enabled, display_duration_seconds) 
SELECT * FROM (VALUES
    ('ANNOUNCEMENT', true, 10),
    ('WELCOME', true, 10),
    ('STATIC', true, 10),
    ('SPACE', true, 10)
) AS v(type, enabled, display_duration_seconds)
ON CONFLICT (type) DO NOTHING;

-- Insert default welcome configuration (if not exists)
INSERT INTO tv_info_welcome (display_days, enabled) 
SELECT 7, true
WHERE NOT EXISTS (SELECT 1 FROM tv_info_welcome);

-- Insert default static content configurations (if not exists)
INSERT INTO tv_info_static (content_type, display_days, enabled) 
SELECT 'ELEMENT_PROMO', 30, true
WHERE NOT EXISTS (SELECT 1 FROM tv_info_static WHERE content_type = 'ELEMENT_PROMO');

INSERT INTO tv_info_static (content_type, display_days, enabled) 
SELECT 'PORTAL_PROMO', 30, true
WHERE NOT EXISTS (SELECT 1 FROM tv_info_static WHERE content_type = 'PORTAL_PROMO');

INSERT INTO tv_info_static (content_type, display_days, enabled) 
SELECT 'ALFRED_PROMO', 30, true
WHERE NOT EXISTS (SELECT 1 FROM tv_info_static WHERE content_type = 'ALFRED_PROMO');

-- Insert default space configuration (if not exists)
INSERT INTO tv_info_spaces (display_days, show_calendar, show_rules, show_stats, show_essential_info, enabled) 
SELECT 7, true, true, false, true, true
WHERE NOT EXISTS (SELECT 1 FROM tv_info_spaces);

-- Insert default design templates (if not exists)
INSERT INTO tv_slide_designs (name, background_type, background_value, corner_element_type, corner_element_position, icon_position, enabled) 
SELECT * FROM (VALUES
    ('default', 'GRADIENT', 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', 'LEAVES', 'top-left,top-right', 'TOP_LEFT', true),
    ('gradient-blue', 'GRADIENT', 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)', 'LEAVES', 'top-left,top-right', 'TOP_RIGHT', true),
    ('gradient-green', 'GRADIENT', 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)', 'GEOMETRIC', 'bottom-left,bottom-right', 'CENTER', true),
    ('solid-purple', 'SOLID', '#8B5CF6', 'LEAVES', 'top-left,top-right', 'TOP_LEFT', true),
    ('nature', 'GRADIENT', 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', 'LEAVES', 'bottom-left,bottom-right', 'CENTER', true)
) AS v(name, background_type, background_value, corner_element_type, corner_element_position, icon_position, enabled)
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- V23: Add summary field to announcements table for TV mode
-- ============================================================================
ALTER TABLE announcements ADD COLUMN IF NOT EXISTS summary TEXT;

-- ============================================================================
-- V24: Add ALFRED_PROMO to static content types
-- ============================================================================
-- Update CHECK constraint to include ALFRED_PROMO (in case table already exists)
ALTER TABLE tv_info_static DROP CONSTRAINT IF EXISTS tv_info_static_content_type_check;
ALTER TABLE tv_info_static ADD CONSTRAINT tv_info_static_content_type_check CHECK (content_type IN ('ELEMENT_PROMO', 'PORTAL_PROMO', 'ALFRED_PROMO'));

