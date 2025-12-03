-- Migration V3: Add Matrix Bot tables
-- This migration adds tables for Matrix bot token management and error notifications

-- Matrix Bot Tokens table
CREATE TABLE matrix_bot_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    access_token VARCHAR(2048) NOT NULL,
    refresh_token VARCHAR(2048) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_matrix_bot_tokens_created_at ON matrix_bot_tokens(created_at DESC);

-- Matrix Bot Error Notifications table
CREATE TABLE matrix_bot_error_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    last_notification_date DATE NOT NULL UNIQUE,
    error_message TEXT
);

CREATE INDEX idx_matrix_bot_error_notifications_date ON matrix_bot_error_notifications(last_notification_date);

-- Create trigger for matrix_bot_tokens updated_at
CREATE TRIGGER update_matrix_bot_tokens_updated_at BEFORE UPDATE ON matrix_bot_tokens
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

















