-- Migration V3.12: Sync schema with init.sql (commit bc5f995 "Unifi")
-- Reflects changes from neoportal-app/db/postgres/init.sql: drop Axis/TTLock/Nuki, UniFi only.
-- Does not modify any existing migration files.

-- =============================================================================
-- Part 1: Drop Axis and legacy lock configs (order respects FKs)
-- =============================================================================

-- 1.1 Drop junction table digital_door_credential_doors (Axis) – credentials ↔ axis_doors
DROP TABLE IF EXISTS digital_door_credential_doors CASCADE;

-- 1.2 digital_door_credentials: drop Axis column and index
ALTER TABLE digital_door_credentials DROP COLUMN IF EXISTS door_controller_id CASCADE;
DROP INDEX IF EXISTS idx_digital_door_credentials_door_controller_id;

-- 1.3 Recreate unique constraints on unifi_door_controller_id (init uses unifi, not door_controller_id)
DROP INDEX IF EXISTS unique_code_per_controller;
DROP INDEX IF EXISTS unique_vigik_per_controller;
CREATE UNIQUE INDEX IF NOT EXISTS unique_code_per_controller
    ON digital_door_credentials(unifi_door_controller_id, code)
    WHERE type = 'CODE' AND code IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS unique_vigik_per_controller
    ON digital_door_credentials(unifi_door_controller_id, vigik_badge_number)
    WHERE type = 'BADGE_VIGIK' AND vigik_badge_number IS NOT NULL;

-- 1.4 digital_locks: drop Axis columns (and their FKs)
ALTER TABLE digital_locks DROP COLUMN IF EXISTS axis_door_controller_id CASCADE;
ALTER TABLE digital_locks DROP COLUMN IF EXISTS axis_door_id CASCADE;

-- 1.5 digital_locks: type only UNIFI (align with init.sql)
-- Update existing rows so they satisfy the new check, then change constraint and default
UPDATE digital_locks SET type = 'UNIFI' WHERE type IS NOT NULL AND type != 'UNIFI';

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conrelid = 'digital_locks'::regclass AND conname = 'digital_locks_type_check') THEN
        ALTER TABLE digital_locks DROP CONSTRAINT digital_locks_type_check;
    END IF;
END $$;
ALTER TABLE digital_locks
    ADD CONSTRAINT digital_locks_type_check CHECK (type IN ('UNIFI'));
ALTER TABLE digital_locks ALTER COLUMN type SET DEFAULT 'UNIFI';

-- 1.6 Drop Axis tables (triggers are dropped with tables)
DROP TRIGGER IF EXISTS update_axis_door_controllers_updated_at ON axis_door_controllers;
DROP TRIGGER IF EXISTS update_axis_doors_updated_at ON axis_doors;
DROP TABLE IF EXISTS axis_doors CASCADE;
DROP TABLE IF EXISTS axis_door_controllers CASCADE;

-- 1.7 Drop TTLock and Nuki config tables (init.sql no longer has them)
DROP TABLE IF EXISTS ttlock_configs CASCADE;
DROP TABLE IF EXISTS nuki_configs CASCADE;

-- =============================================================================
-- Part 2: Other sync with init.sql (unchanged from previous V3.12)
-- =============================================================================

-- 2.1 notification_settings: user_id UNIQUE
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_class t ON t.oid = c.conrelid
        WHERE t.relname = 'notification_settings' AND c.contype = 'u'
    ) THEN
        ALTER TABLE notification_settings ADD CONSTRAINT notification_settings_user_id_key UNIQUE (user_id);
    END IF;
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- 2.2 digital_door_credentials: FK reservation_id -> reservations
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'digital_door_credentials' AND constraint_name = 'fk_digital_door_credentials_reservation_id'
    ) THEN
        ALTER TABLE digital_door_credentials
            ADD CONSTRAINT fk_digital_door_credentials_reservation_id
            FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE;
    END IF;
END $$;

-- 2.3 Indexes on digital_door_credentials
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_digital_lock_code
    ON digital_door_credentials(digital_lock_code_id) WHERE digital_lock_code_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_expiration_date
    ON digital_door_credentials(expiration_date) WHERE expiration_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_digital_door_credentials_sync_status
    ON digital_door_credentials(sync_status);

-- 2.4 llm_judge_evaluations: id DEFAULT gen_random_uuid()
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'llm_judge_evaluations' AND column_name = 'id'
    ) THEN
        ALTER TABLE llm_judge_evaluations ALTER COLUMN id SET DEFAULT gen_random_uuid();
    END IF;
END $$;
