-- Stripe keys per tenant at global level (JPA: TenantStripeConfigEntity). Runtime billing still uses tenant DB
-- tenant_stripe_config via TenantStripeConfigProvider; this table supports FK cleanup on tenant delete.

CREATE TABLE IF NOT EXISTS global.tenant_stripe_config (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    secret_key text,
    publishable_key varchar(512),
    webhook_secret text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id)
);

CREATE INDEX IF NOT EXISTS idx_tenant_stripe_config_tenant_id ON global.tenant_stripe_config(tenant_id);
