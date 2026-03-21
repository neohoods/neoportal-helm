-- Fix legacy demo schema where users.user_id was defined as GENERATED and not writable.
-- App code writes users.user_id directly, so this must be a regular column.

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = current_schema()
          AND table_name = 'users'
          AND column_name = 'user_id'
          AND is_generated = 'ALWAYS'
    ) THEN
        -- Recreate user_id as a writable column, preserving existing values.
        ALTER TABLE users DROP COLUMN user_id;
        ALTER TABLE users ADD COLUMN user_id uuid;
        UPDATE users SET user_id = id WHERE user_id IS NULL;
        ALTER TABLE users ALTER COLUMN user_id SET NOT NULL;

        IF NOT EXISTS (
            SELECT 1
            FROM pg_constraint
            WHERE conname = 'users_user_id_key'
        ) THEN
            ALTER TABLE users ADD CONSTRAINT users_user_id_key UNIQUE (user_id);
        END IF;
    END IF;
END $$;

-- Keep id/user_id aligned for inserts done with user_id only (only when column "id" exists).
CREATE OR REPLACE FUNCTION sync_users_id_user_id()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.user_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = current_schema()
              AND table_name = 'users'
              AND column_name = 'id'
        ) THEN
            NEW.id := NEW.user_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_users_id_user_id ON users;
CREATE TRIGGER trg_sync_users_id_user_id
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION sync_users_id_user_id();
