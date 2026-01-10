-- Migration V3.9: Add board member flag and update incident visibility

-- Add is_board_member column to users table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'is_board_member'
    ) THEN
        ALTER TABLE users ADD COLUMN is_board_member BOOLEAN NOT NULL DEFAULT FALSE;
        CREATE INDEX IF NOT EXISTS idx_users_is_board_member ON users(is_board_member);
    END IF;
END $$;

-- Update incidents visibility constraint to include new values
-- Do everything in one transaction to ensure proper order
DO $$
DECLARE
    constraint_name TEXT;
    constraint_def TEXT;
    constraint_oid OID;
BEGIN
    -- Find and drop all check constraints that involve the visibility column
    FOR constraint_oid, constraint_name, constraint_def IN
        SELECT oid, conname, pg_get_constraintdef(oid)
        FROM pg_constraint
        WHERE conrelid = 'incidents'::regclass
        AND contype = 'c'
    LOOP
        -- Check if this constraint involves the visibility column
        -- Check both the constraint definition and if it's on the visibility column
        IF constraint_def LIKE '%visibility%' 
           OR constraint_def LIKE '%VISIBILITY%'
           OR constraint_name LIKE '%visibility%'
           OR constraint_name = 'incidents_visibility_check' THEN
            BEGIN
                EXECUTE format('ALTER TABLE incidents DROP CONSTRAINT %I', constraint_name);
            EXCEPTION
                WHEN OTHERS THEN
                    -- If dropping fails, try to continue
                    NULL;
            END;
        END IF;
    END LOOP;
    
    -- Also explicitly try to drop the named constraint if it exists (case-insensitive search)
    BEGIN
        ALTER TABLE incidents DROP CONSTRAINT incidents_visibility_check;
    EXCEPTION
        WHEN undefined_object THEN
            -- Constraint doesn't exist, that's fine
            NULL;
    END;
    
    -- Now update existing data: INTERNAL/EXTERNAL -> EVERYONE
    -- This should work now that constraints are dropped
    UPDATE incidents 
    SET visibility = 'EVERYONE' 
    WHERE visibility IN ('INTERNAL', 'EXTERNAL');
    
    -- Add the new constraint with all visibility values
    BEGIN
        ALTER TABLE incidents ADD CONSTRAINT incidents_visibility_check 
            CHECK (visibility IN ('INTERNAL', 'EXTERNAL', 'BOARD_MEMBER', 'MANAGER', 'OWNER', 'EVERYONE'));
    EXCEPTION
        WHEN duplicate_object THEN
            -- Constraint already exists, ignore
            NULL;
    END;
END $$;

-- Update default visibility to EVERYONE for new incidents
ALTER TABLE incidents ALTER COLUMN visibility SET DEFAULT 'EVERYONE';
