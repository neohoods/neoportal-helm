-- Migration V3.15: Add user_devices table (sync with neoportal-app/db/postgres/init.sql)
-- Table was added in init.sql for push notifications / device tracking and was missing from Helm migrations.

CREATE TABLE IF NOT EXISTS user_devices (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES users(id),
    device_id varchar(255) NOT NULL,
    push_token text,
    platform varchar(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_used_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, device_id)
);
