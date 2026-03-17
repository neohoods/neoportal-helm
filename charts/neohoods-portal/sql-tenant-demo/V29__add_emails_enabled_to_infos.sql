-- Add emails_enabled column to infos table (tenant-level setting to disable email sending)
ALTER TABLE infos ADD COLUMN IF NOT EXISTS emails_enabled BOOLEAN NOT NULL DEFAULT true;
