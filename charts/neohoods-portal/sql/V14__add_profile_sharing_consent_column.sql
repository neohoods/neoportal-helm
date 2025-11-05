-- Add profile_sharing_consent column to users table
ALTER TABLE users 
ADD COLUMN profile_sharing_consent boolean NOT NULL DEFAULT true;

-- Update existing records to have profile_sharing_consent = false by default
UPDATE users 
SET profile_sharing_consent = true 
WHERE profile_sharing_consent IS NULL;
