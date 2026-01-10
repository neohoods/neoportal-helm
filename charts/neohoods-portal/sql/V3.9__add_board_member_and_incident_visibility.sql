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
-- First, migrate existing data: INTERNAL/EXTERNAL -> EVERYONE
DO $$
BEGIN
    -- Update existing incidents to EVERYONE (default for migration)
    UPDATE incidents 
    SET visibility = 'EVERYONE' 
    WHERE visibility IN ('INTERNAL', 'EXTERNAL');
END $$;

-- Drop the old constraint and add new one
DO $$
BEGIN
    -- Drop the old check constraint if it exists
    ALTER TABLE incidents DROP CONSTRAINT IF EXISTS incidents_visibility_check;
    
    -- Add new constraint with all visibility values
    ALTER TABLE incidents ADD CONSTRAINT incidents_visibility_check 
        CHECK (visibility IN ('INTERNAL', 'EXTERNAL', 'BOARD_MEMBER', 'MANAGER', 'OWNER', 'EVERYONE'));
END $$;

-- Update default visibility to EVERYONE for new incidents
ALTER TABLE incidents ALTER COLUMN visibility SET DEFAULT 'EVERYONE';
