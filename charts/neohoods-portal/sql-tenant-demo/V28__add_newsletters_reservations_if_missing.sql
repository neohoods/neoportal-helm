-- Repair migration for tenant DBs that ran an older V1 without newsletters/reservations.
-- All operations are idempotent (IF NOT EXISTS / DO blocks) so safe to run on any tenant DB.

-- Newsletters (from V1 baseline)
CREATE TABLE IF NOT EXISTS "newsletters" (
    "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    "subject" varchar(255) NOT NULL,
    "content" text,
    "status" varchar(50) NOT NULL CHECK (status IN ('DRAFT', 'SCHEDULED', 'SENDING', 'SENT', 'CANCELLED', 'FAILED')) DEFAULT 'DRAFT',
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "scheduled_at" timestamp with time zone,
    "sent_at" timestamp with time zone,
    "created_by" uuid NOT NULL,
    "recipient_count" integer,
    "audience_type" varchar(50) NOT NULL DEFAULT 'ALL' CHECK (audience_type IN ('ALL', 'USER_TYPES', 'SPECIFIC_USERS')),
    "audience_user_types" jsonb,
    "audience_user_ids" jsonb,
    "audience_exclude_user_ids" jsonb,
    FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE CASCADE
);

-- Newsletter logs (depends on newsletters)
CREATE TABLE IF NOT EXISTS "newsletter_logs" (
    "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    "newsletter_id" uuid NOT NULL,
    "user_id" uuid NOT NULL,
    "user_email" varchar(255) NOT NULL,
    "status" varchar(50) NOT NULL CHECK (status IN ('PENDING', 'SENT', 'FAILED', 'BOUNCED', 'SKIPPED')) DEFAULT 'PENDING',
    "sent_at" timestamp with time zone,
    "error_message" text,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("newsletter_id") REFERENCES "newsletters"("id") ON DELETE CASCADE,
    FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "idx_newsletter_logs_newsletter_id" ON "newsletter_logs"("newsletter_id");
CREATE INDEX IF NOT EXISTS "idx_newsletter_logs_user_id" ON "newsletter_logs"("user_id");
CREATE INDEX IF NOT EXISTS "idx_newsletter_logs_status" ON "newsletter_logs"("status");
CREATE INDEX IF NOT EXISTS "idx_newsletter_logs_created_at" ON "newsletter_logs"("created_at");

-- Reservations (from V1 baseline)
CREATE TABLE IF NOT EXISTS reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id UUID NOT NULL REFERENCES spaces(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING_PAYMENT' CHECK (status IN ('PENDING_PAYMENT', 'PAYMENT_FAILED', 'EXPIRED', 'CONFIRMED', 'ACTIVE', 'COMPLETED', 'CANCELLED', 'REFUNDED')),
    total_price DECIMAL(10,2) NOT NULL,
    stripe_payment_intent_id VARCHAR(255),
    stripe_session_id VARCHAR(255),
    payment_status VARCHAR(50) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PROCESSING', 'SUCCEEDED', 'FAILED', 'CANCELLED', 'REFUNDED', 'PARTIALLY_REFUNDED')),
    cancellation_reason TEXT,
    cancelled_at TIMESTAMP,
    cancelled_by VARCHAR(255),
    payment_expires_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_reservations_user_id ON reservations(user_id);
CREATE INDEX IF NOT EXISTS idx_reservations_space_id ON reservations(space_id);
CREATE INDEX IF NOT EXISTS idx_reservations_unit_id ON reservations(unit_id);
CREATE INDEX IF NOT EXISTS idx_reservations_status ON reservations(status);
CREATE INDEX IF NOT EXISTS idx_reservations_payment_status ON reservations(payment_status);
CREATE INDEX IF NOT EXISTS idx_reservations_dates ON reservations(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_reservations_space_dates ON reservations(space_id, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_reservations_stripe_payment_intent ON reservations(stripe_payment_intent_id);
CREATE INDEX IF NOT EXISTS idx_reservations_stripe_session ON reservations(stripe_session_id);
CREATE INDEX IF NOT EXISTS idx_reservations_payment_expiration ON reservations(status, payment_expires_at) WHERE status = 'PENDING_PAYMENT';

-- Constraint chk_reservations_dates only if missing
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_reservations_dates') THEN
        ALTER TABLE reservations ADD CONSTRAINT chk_reservations_dates CHECK (end_date >= start_date);
    END IF;
END $$;

-- Trigger update_reservations_updated_at only if missing (update_updated_at_column exists from V1)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger t
        JOIN pg_class c ON t.tgrelid = c.oid
        WHERE c.relname = 'reservations' AND t.tgname = 'update_reservations_updated_at'
    ) THEN
        CREATE TRIGGER update_reservations_updated_at BEFORE UPDATE ON reservations
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- FK from digital_door_credentials to reservations (if table exists and constraint missing)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'digital_door_credentials')
       AND NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_digital_door_credentials_reservation_id') THEN
        ALTER TABLE digital_door_credentials
            ADD CONSTRAINT fk_digital_door_credentials_reservation_id
            FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Reservation feedback table
CREATE TABLE IF NOT EXISTS reservation_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    cleanliness INTEGER CHECK (cleanliness >= 1 AND cleanliness <= 5),
    communication INTEGER CHECK (communication >= 1 AND communication <= 5),
    value INTEGER CHECK (value >= 1 AND value <= 5),
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_reservation_feedback_reservation UNIQUE (reservation_id),
    CONSTRAINT chk_cleanliness_range CHECK (cleanliness IS NULL OR (cleanliness >= 1 AND cleanliness <= 5)),
    CONSTRAINT chk_communication_range CHECK (communication IS NULL OR (communication >= 1 AND communication <= 5)),
    CONSTRAINT chk_value_range CHECK (value IS NULL OR (value >= 1 AND value <= 5))
);

CREATE INDEX IF NOT EXISTS idx_reservation_feedback_reservation_id ON reservation_feedback(reservation_id);
CREATE INDEX IF NOT EXISTS idx_reservation_feedback_user_id ON reservation_feedback(user_id);
CREATE INDEX IF NOT EXISTS idx_reservation_feedback_submitted_at ON reservation_feedback(submitted_at);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger t
        JOIN pg_class c ON t.tgrelid = c.oid
        WHERE c.relname = 'reservation_feedback' AND t.tgname = 'update_reservation_feedback_updated_at'
    ) THEN
        CREATE TRIGGER update_reservation_feedback_updated_at BEFORE UPDATE ON reservation_feedback
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- Platform fee columns on reservations (if missing)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reservations' AND column_name = 'platform_fee_amount') THEN
        ALTER TABLE reservations ADD COLUMN platform_fee_amount DECIMAL(10,2);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'reservations' AND column_name = 'platform_fixed_fee_amount') THEN
        ALTER TABLE reservations ADD COLUMN platform_fixed_fee_amount DECIMAL(10,2);
    END IF;
END $$;

-- Reservation audit log
CREATE TABLE IF NOT EXISTS reservation_audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reservation_id UUID NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    log_message TEXT,
    performed_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reservation_audit_log_reservation_id ON reservation_audit_log(reservation_id);
CREATE INDEX IF NOT EXISTS idx_reservation_audit_log_created_at ON reservation_audit_log(created_at);
CREATE INDEX IF NOT EXISTS idx_reservation_audit_log_event_type ON reservation_audit_log(event_type);
