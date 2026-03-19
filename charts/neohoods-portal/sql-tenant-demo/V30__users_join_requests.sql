-- Tenant-level join requests (copropriete), distinct from unit_join_requests.

CREATE TABLE IF NOT EXISTS users_join_requests (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    requested_by uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status varchar(50) NOT NULL CHECK (status IN ('PENDING', 'AWAITING_UNIT_CONFIRMATION', 'COMPLETED', 'REJECTED')),
    requester_role varchar(50) NOT NULL CHECK (requester_role IN ('PROPRIETAIRE', 'LOCATAIRE', 'SYNDIC', 'PRESTATAIRE', 'AUTRE')),
    message text,
    tenant_slug_snapshot varchar(255),
    decision_source varchar(30) CHECK (decision_source IN ('PORTAL', 'EMAIL')),
    suggested_unit_ids jsonb,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    responded_at timestamp with time zone,
    responded_by uuid REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS idx_users_join_requests_status
    ON users_join_requests(status);

CREATE INDEX IF NOT EXISTS idx_users_join_requests_requested_by
    ON users_join_requests(requested_by);

CREATE UNIQUE INDEX IF NOT EXISTS idx_users_join_requests_one_open_per_user
    ON users_join_requests(requested_by)
    WHERE status IN ('PENDING', 'AWAITING_UNIT_CONFIRMATION');

CREATE TABLE IF NOT EXISTS users_join_request_units (
    join_request_id uuid NOT NULL REFERENCES users_join_requests(id) ON DELETE CASCADE,
    unit_id uuid NOT NULL REFERENCES units(id) ON DELETE CASCADE,
    source varchar(30) NOT NULL CHECK (source IN ('USER_SELECTED', 'AUTO_SUGGESTED', 'ADMIN_CONFIRMED')),
    PRIMARY KEY (join_request_id, unit_id)
);

CREATE INDEX IF NOT EXISTS idx_users_join_request_units_unit
    ON users_join_request_units(unit_id);

ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_type_check;
ALTER TABLE notifications ADD CONSTRAINT notifications_type_check CHECK (type IN (
    'ADMIN_NEW_USER',
    'NEW_ANNOUNCEMENT',
    'RESERVATION',
    'UNIT_INVITATION',
    'UNIT_JOIN_REQUEST',
    'TENANT_JOIN_REQUEST'
));
