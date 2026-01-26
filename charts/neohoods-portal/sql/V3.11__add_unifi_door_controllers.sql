-- Migration V3.11: Add UniFi door controllers support
-- This migration adds UniFi support similar to Axis:
-- - Adds UniFi support to digital_locks
-- - Creates unifi_door_controllers and unifi_doors tables
-- - Adds unifi_door_controller_id and unifi_door_id columns to digital_locks

-- 1. Alter digital_locks.type to include 'UNIFI' (if not already present)
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
    CHECK (type IN ('TTLOCK', 'NUKI', 'YALE', 'AXIS', 'UNIFI'));

-- 2. Add unifi_door_controller_id and unifi_door_id columns to digital_locks (if not already present)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_locks' AND column_name = 'unifi_door_controller_id'
    ) THEN
        ALTER TABLE digital_locks 
            ADD COLUMN unifi_door_controller_id UUID;
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_locks' AND column_name = 'unifi_door_id'
    ) THEN
        ALTER TABLE digital_locks 
            ADD COLUMN unifi_door_id UUID;
    END IF;
END $$;

-- 3. Create unifi_door_controllers table
-- Note: API key is NOT stored here - it comes from application.yml (K8s secrets)
CREATE TABLE IF NOT EXISTS unifi_door_controllers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    controller_id VARCHAR(255) NOT NULL UNIQUE, -- Logical ID from application.yml (e.g., "main-controller")
    name VARCHAR(255), -- Name comes from config (application.yml), nullable as it's not always stored in DB
    model VARCHAR(50) NOT NULL DEFAULT 'UD-Pro',
    last_seen TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_unifi_door_controllers_controller_id ON unifi_door_controllers(controller_id);
CREATE INDEX IF NOT EXISTS idx_unifi_door_controllers_model ON unifi_door_controllers(model);

-- 4. Create unifi_doors table
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

CREATE INDEX IF NOT EXISTS idx_unifi_doors_door_controller_id ON unifi_doors(door_controller_id);
CREATE INDEX IF NOT EXISTS idx_unifi_doors_door_id ON unifi_doors(door_id);

-- 5. Add foreign key constraints to digital_locks (after unifi tables are created)
DO $$
BEGIN
    -- Add FK for unifi_door_controller_id if column exists and constraint doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_locks' AND column_name = 'unifi_door_controller_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'digital_locks_unifi_door_controller_id_fkey'
    ) THEN
        ALTER TABLE digital_locks 
            ADD CONSTRAINT digital_locks_unifi_door_controller_id_fkey
            FOREIGN KEY (unifi_door_controller_id) 
            REFERENCES unifi_door_controllers(id) ON DELETE SET NULL;
    END IF;
    
    -- Add FK for unifi_door_id if column exists and constraint doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_locks' AND column_name = 'unifi_door_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'digital_locks_unifi_door_id_fkey'
    ) THEN
        ALTER TABLE digital_locks 
            ADD CONSTRAINT digital_locks_unifi_door_id_fkey
            FOREIGN KEY (unifi_door_id) 
            REFERENCES unifi_doors(id) ON DELETE SET NULL;
    END IF;
END $$;

-- 6. Add unifi_door_controller_id column to digital_door_credentials (if not already present)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_door_credentials' AND column_name = 'unifi_door_controller_id'
    ) THEN
        ALTER TABLE digital_door_credentials 
            ADD COLUMN unifi_door_controller_id UUID;
    END IF;
END $$;

-- 7. Add foreign key constraint for unifi_door_controller_id in digital_door_credentials
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'digital_door_credentials' AND column_name = 'unifi_door_controller_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'digital_door_credentials_unifi_door_controller_id_fkey'
    ) THEN
        ALTER TABLE digital_door_credentials 
            ADD CONSTRAINT digital_door_credentials_unifi_door_controller_id_fkey
            FOREIGN KEY (unifi_door_controller_id) 
            REFERENCES unifi_door_controllers(id) ON DELETE CASCADE;
    END IF;
END $$;

-- 8. Create index for unifi_door_controller_id
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_unifi_door_controller_id 
    ON digital_door_credentials(unifi_door_controller_id);

-- 9. Create table for many-to-many relationship between digital_door_credentials and unifi_doors
CREATE TABLE IF NOT EXISTS digital_door_credential_unifi_doors (
    credential_id UUID NOT NULL REFERENCES digital_door_credentials(id) ON DELETE CASCADE,
    door_id UUID NOT NULL REFERENCES unifi_doors(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (credential_id, door_id)
);

CREATE INDEX IF NOT EXISTS idx_credential_unifi_doors_credential_id 
    ON digital_door_credential_unifi_doors(credential_id);
CREATE INDEX IF NOT EXISTS idx_credential_unifi_doors_door_id 
    ON digital_door_credential_unifi_doors(door_id);

-- 10. Create triggers for updated_at
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_unifi_door_controllers_updated_at'
    ) THEN
        CREATE TRIGGER update_unifi_door_controllers_updated_at 
            BEFORE UPDATE ON unifi_door_controllers
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_unifi_doors_updated_at'
    ) THEN
        CREATE TRIGGER update_unifi_doors_updated_at 
            BEFORE UPDATE ON unifi_doors
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;
