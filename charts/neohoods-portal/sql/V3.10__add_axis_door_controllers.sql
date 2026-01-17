-- Migration V3.10: Add Axis door controllers support and digital door credentials
-- This migration consolidates all Axis-related changes:
-- - Adds Axis support to digital_locks
-- - Creates axis_door_controllers and axis_doors tables
-- - Creates digital_door_credentials table with sync_status, regenerated_by (UUID), and expiration_date
-- - Creates digital_door_credential_doors junction table

-- 1. Alter digital_locks.type to include 'AXIS' (if not already present)
DO $$
BEGIN
    -- Drop existing constraint if it exists
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'digital_locks_type_check'
    ) THEN
        ALTER TABLE digital_locks DROP CONSTRAINT digital_locks_type_check;
    END IF;
END $$;

ALTER TABLE digital_locks 
    ADD CONSTRAINT digital_locks_type_check 
    CHECK (type IN ('TTLOCK', 'NUKI', 'YALE', 'AXIS'));

-- 2. Add axis_door_controller_id and axis_door_id columns to digital_locks (if not already present)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_locks' AND column_name = 'axis_door_controller_id'
    ) THEN
        ALTER TABLE digital_locks 
            ADD COLUMN axis_door_controller_id UUID;
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_locks' AND column_name = 'axis_door_id'
    ) THEN
        ALTER TABLE digital_locks 
            ADD COLUMN axis_door_id UUID;
    END IF;
END $$;

-- 3. Create axis_door_controllers table
-- Note: username and password are NOT stored here - they come from application.yml (K8s secrets)
CREATE TABLE IF NOT EXISTS axis_door_controllers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    controller_id VARCHAR(255) NOT NULL UNIQUE, -- Logical ID from application.yml (e.g., "main-controller")
    name VARCHAR(255), -- Name comes from config (application.yml), nullable as it's not always stored in DB
    model VARCHAR(50) NOT NULL DEFAULT 'A1610',
    last_seen TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_axis_door_controllers_controller_id ON axis_door_controllers(controller_id);
CREATE INDEX IF NOT EXISTS idx_axis_door_controllers_model ON axis_door_controllers(model);

-- 4. Create axis_doors table
CREATE TABLE IF NOT EXISTS axis_doors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    door_controller_id UUID NOT NULL REFERENCES axis_door_controllers(id) ON DELETE CASCADE,
    door_token VARCHAR(255) NOT NULL, -- VAPIX door token (format: Axis-{MAC}:{timestamp})
    name VARCHAR(255) NOT NULL,
    description TEXT,
    last_seen TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(door_controller_id, door_token)
);

CREATE INDEX IF NOT EXISTS idx_axis_doors_door_controller_id ON axis_doors(door_controller_id);
CREATE INDEX IF NOT EXISTS idx_axis_doors_door_token ON axis_doors(door_token);

-- 5. Add foreign key constraints to digital_locks (after axis tables are created)
DO $$
BEGIN
    -- Add FK for axis_door_controller_id if column exists and constraint doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_locks' AND column_name = 'axis_door_controller_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'digital_locks_axis_door_controller_id_fkey'
    ) THEN
        ALTER TABLE digital_locks 
            ADD CONSTRAINT digital_locks_axis_door_controller_id_fkey
            FOREIGN KEY (axis_door_controller_id) 
            REFERENCES axis_door_controllers(id) ON DELETE SET NULL;
    END IF;
    
    -- Add FK for axis_door_id if column exists and constraint doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_locks' AND column_name = 'axis_door_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'digital_locks_axis_door_id_fkey'
    ) THEN
        ALTER TABLE digital_locks 
            ADD CONSTRAINT digital_locks_axis_door_id_fkey
            FOREIGN KEY (axis_door_id) 
            REFERENCES axis_doors(id) ON DELETE SET NULL;
    END IF;
END $$;

-- 6. Create digital_door_credentials table
-- This table includes all features: origin, label, sync_status, regenerated_by (UUID), expiration_date
CREATE TABLE IF NOT EXISTS digital_door_credentials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    door_controller_id UUID NOT NULL REFERENCES axis_door_controllers(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL CHECK (type IN ('CODE', 'BADGE_VIGIK')),
    name VARCHAR(255) NOT NULL,
    origin VARCHAR(20) NOT NULL DEFAULT 'SPACE' CHECK (origin IN ('MANUAL', 'SPACE')),
    label VARCHAR(500), -- Reason for creation (for manual credentials)
    code VARCHAR(255), -- PIN code (for type CODE)
    vigik_badge_number VARCHAR(255), -- Badge number (for type BADGE_VIGIK)
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL, -- Link to unit for Vigik badges
    reservation_id UUID, -- Link to reservation (for SPACE origin credentials) - FK constraint added later after reservations table exists
    activation_date TIMESTAMP WITH TIME ZONE,
    expiration_date TIMESTAMP WITH TIME ZONE, -- Unified expiration date for all credentials
    digital_lock_id UUID REFERENCES digital_locks(id),
    digital_lock_code_id VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    physical_credential_token VARCHAR(255), -- Token from VAPIX API (format: Axis-{MAC}:{timestamp})
    last_synced_at TIMESTAMP WITH TIME ZONE,
    sync_status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (sync_status IN ('PENDING', 'SYNCED', 'FAILED', 'ORPHANED')),
    used_at TIMESTAMP,
    regenerated_at TIMESTAMP,
    regenerated_by UUID REFERENCES users(id) ON DELETE SET NULL, -- User who regenerated the code (NULL for system)
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 7. Create indexes for digital_door_credentials
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_door_controller_id ON digital_door_credentials(door_controller_id);
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_type ON digital_door_credentials(type);
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_code ON digital_door_credentials(code) WHERE code IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_vigik_badge_number ON digital_door_credentials(vigik_badge_number) WHERE vigik_badge_number IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_unit_id ON digital_door_credentials(unit_id) WHERE unit_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_reservation_id ON digital_door_credentials(reservation_id) WHERE reservation_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_physical_token ON digital_door_credentials(physical_credential_token) WHERE physical_credential_token IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_is_active ON digital_door_credentials(is_active);
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_origin ON digital_door_credentials(origin);
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_digital_lock_id ON digital_door_credentials(digital_lock_id) WHERE digital_lock_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_digital_lock_code ON digital_door_credentials(digital_lock_code_id) WHERE digital_lock_code_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_expiration_date ON digital_door_credentials(expiration_date) WHERE expiration_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_sync_status ON digital_door_credentials(sync_status);

-- 8. Create digital_door_credential_doors table for many-to-many relationship
-- This table links digital door credentials to axis doors (a credential can apply to multiple doors)
CREATE TABLE IF NOT EXISTS digital_door_credential_doors (
    credential_id UUID NOT NULL REFERENCES digital_door_credentials(id) ON DELETE CASCADE,
    door_id UUID NOT NULL REFERENCES axis_doors(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (credential_id, door_id)
);

CREATE INDEX IF NOT EXISTS idx_credential_doors_credential_id ON digital_door_credential_doors(credential_id);
CREATE INDEX IF NOT EXISTS idx_credential_doors_door_id ON digital_door_credential_doors(door_id);

-- 9. Add unique constraints for digital_door_credentials
-- Note: PostgreSQL partial unique constraints require a different approach
-- We'll use a unique index instead
CREATE UNIQUE INDEX IF NOT EXISTS unique_code_per_controller 
    ON digital_door_credentials(door_controller_id, code) 
    WHERE type = 'CODE' AND code IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS unique_vigik_per_controller 
    ON digital_door_credentials(door_controller_id, vigik_badge_number) 
    WHERE type = 'BADGE_VIGIK' AND vigik_badge_number IS NOT NULL;

-- 10. Create triggers for updated_at
-- Check if function exists before creating trigger
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_axis_door_controllers_updated_at'
    ) THEN
        CREATE TRIGGER update_axis_door_controllers_updated_at 
            BEFORE UPDATE ON axis_door_controllers
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_axis_doors_updated_at'
    ) THEN
        CREATE TRIGGER update_axis_doors_updated_at 
            BEFORE UPDATE ON axis_doors
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_digital_door_credentials_updated_at'
    ) THEN
        CREATE TRIGGER update_digital_door_credentials_updated_at 
            BEFORE UPDATE ON digital_door_credentials
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- 11. Update existing credentials: set sync_status to SYNCED if they have a physical_credential_token
-- This handles existing data that might have been created before sync_status existed
UPDATE digital_door_credentials 
SET sync_status = CASE 
    WHEN physical_credential_token IS NOT NULL AND physical_credential_token != '' THEN 'SYNCED'
    ELSE 'PENDING'
END
WHERE sync_status = 'PENDING' OR sync_status IS NULL;

-- Note: The foreign key constraint for reservation_id will be added in a later migration
-- after the reservations table is created, as it depends on that table's existence.
