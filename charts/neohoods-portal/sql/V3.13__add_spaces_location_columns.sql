-- Migration V3.13: Add location and location_plan_image_id to spaces
-- Fixes: column se1_0.location does not exist (app expects these columns on spaces)

ALTER TABLE spaces ADD COLUMN IF NOT EXISTS location TEXT;
ALTER TABLE spaces ADD COLUMN IF NOT EXISTS location_plan_image_id UUID;

-- FK for location_plan_image_id (must reference space_images, added after column exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'spaces' AND constraint_name = 'fk_spaces_location_plan_image'
    ) THEN
        ALTER TABLE spaces
            ADD CONSTRAINT fk_spaces_location_plan_image
            FOREIGN KEY (location_plan_image_id) REFERENCES space_images(id) ON DELETE SET NULL;
    END IF;
END $$;
