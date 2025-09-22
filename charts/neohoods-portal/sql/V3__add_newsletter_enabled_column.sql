-- Add newsletter_enabled column to notification_settings table
ALTER TABLE notification_settings 
ADD COLUMN newsletter_enabled boolean NOT NULL DEFAULT true;

-- Update existing records to have newsletter_enabled = true by default
UPDATE notification_settings 
SET newsletter_enabled = true 
WHERE newsletter_enabled IS NULL;
