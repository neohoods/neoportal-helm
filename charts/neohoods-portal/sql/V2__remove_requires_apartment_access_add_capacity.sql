-- Migration V2: Remove requires_apartment_access and add capacity
-- This migration removes the unused requires_apartment_access column
-- and adds the new capacity column to track the number of people allowed in a space

-- Add capacity column (nullable, as existing spaces may not have this set)
ALTER TABLE spaces ADD COLUMN IF NOT EXISTS capacity INTEGER;

-- Remove requires_apartment_access column
ALTER TABLE spaces DROP COLUMN IF EXISTS requires_apartment_access;

