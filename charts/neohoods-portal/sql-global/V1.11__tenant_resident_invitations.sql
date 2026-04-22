-- Admin-initiated resident invitations (invite by email before user joins copro)
CREATE TABLE IF NOT EXISTS global.tenant_resident_invitations (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    email_normalized varchar(512) NOT NULL,
    invited_user_type varchar(64) NOT NULL,
    invited_by_user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    status varchar(32) NOT NULL,
    delivery_status varchar(16) NOT NULL DEFAULT 'FAILED',
    first_sent_at timestamp with time zone,
    last_sent_at timestamp with time zone,
    send_attempt_count integer NOT NULL DEFAULT 0,
    automated_reminder_count integer NOT NULL DEFAULT 0,
    last_automated_reminder_at timestamp with time zone,
    last_delivery_error varchar(512),
    rejection_message text,
    responded_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tri_tenant ON global.tenant_resident_invitations(tenant_id);
CREATE INDEX IF NOT EXISTS idx_tri_email_norm ON global.tenant_resident_invitations(email_normalized);

CREATE UNIQUE INDEX IF NOT EXISTS idx_tri_pending_email_unique
    ON global.tenant_resident_invitations(tenant_id, email_normalized)
    WHERE status = 'PENDING';
