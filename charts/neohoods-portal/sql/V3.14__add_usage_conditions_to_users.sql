-- Migration V3.14: Add usage conditions acceptance tracking to users (legal compliance)
-- Aligns with platform-api Flyway V27

ALTER TABLE users ADD COLUMN IF NOT EXISTS usage_conditions_accepted_version VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS usage_conditions_accepted_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS usage_conditions_rejected_at TIMESTAMP WITH TIME ZONE;
