-- V31 trigger sync_users_id_user_id() sets NEW.id := NEW.user_id.
-- Some tenant schemas only have user_id (PK), no separate "id" column → trigger error:
--   record "new" has no field "id"
-- Only sync id when the column exists (schemas with both id and user_id).
-- Kept in sync with neoportal-app/platform-api/.../db/migration/tenant/V32__fix_sync_users_id_trigger_when_no_id_column.sql

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
