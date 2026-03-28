-- Superadmin toggle for Matrix AI assistant replies (see MatrixAssistantAiToggleService).
-- Idempotent for clusters that already have the column from a refreshed V1.1 baseline.
ALTER TABLE global.system_settings
    ADD COLUMN IF NOT EXISTS matrix_assistant_enabled boolean NOT NULL DEFAULT true;
