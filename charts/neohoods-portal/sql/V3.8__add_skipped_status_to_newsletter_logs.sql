-- Migration V3.8: Add SKIPPED status to newsletter_logs

-- Drop the existing check constraint
ALTER TABLE newsletter_logs 
DROP CONSTRAINT IF EXISTS newsletter_logs_status_check;

-- Add the new check constraint with SKIPPED status
ALTER TABLE newsletter_logs 
ADD CONSTRAINT newsletter_logs_status_check 
CHECK (status IN ('PENDING', 'SENT', 'FAILED', 'BOUNCED', 'SKIPPED'));
