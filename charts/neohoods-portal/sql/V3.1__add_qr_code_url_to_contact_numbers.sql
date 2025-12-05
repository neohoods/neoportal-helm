-- Migration V3.1: Add qr_code_url, responsibility, and metadata columns to contact_numbers table
-- This migration adds support for QR code URLs (e.g., for Otis elevator service),
-- responsibility fields (to match problems with correct contacts), and metadata
-- (for additional instructions like ACAF number 153596)

-- Add responsibility column if it doesn't exist
ALTER TABLE contact_numbers
ADD COLUMN IF NOT EXISTS responsibility TEXT;

-- Add metadata column if it doesn't exist
ALTER TABLE contact_numbers
ADD COLUMN IF NOT EXISTS metadata TEXT;

-- Add qr_code_url column if it doesn't exist
ALTER TABLE contact_numbers
ADD COLUMN IF NOT EXISTS qr_code_url VARCHAR(500);

-- Add comments for documentation
COMMENT ON COLUMN contact_numbers.responsibility IS 'Scope of services provided by this contact (e.g., "garages, portails", "ascenseur", "canalisations, système de chauffage")';
COMMENT ON COLUMN contact_numbers.metadata IS 'Additional instructions or information (e.g., "numéro à donner: 153596" for ACAF)';
COMMENT ON COLUMN contact_numbers.qr_code_url IS 'URL of QR code image (e.g., for Otis elevator service)';

