-- Migration V3.16: GDPR - soft delete, anonymization, reactivation (hash), admin-disabled flag

ALTER TABLE users ADD COLUMN IF NOT EXISTS deleted_at timestamp with time zone;
ALTER TABLE users ADD COLUMN IF NOT EXISTS anonymized_at timestamp with time zone;
ALTER TABLE users ADD COLUMN IF NOT EXISTS anonymized_email_hash varchar(128);
ALTER TABLE users ADD COLUMN IF NOT EXISTS disabled_by_admin boolean NOT NULL DEFAULT false;
