-- Add NEW_ANNOUNCEMENT to the notifications type check constraint
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_type_check;
ALTER TABLE notifications ADD CONSTRAINT notifications_type_check CHECK (type IN (
    'ADMIN_NEW_USER',
    'NEW_ANNOUNCEMENT'
));
