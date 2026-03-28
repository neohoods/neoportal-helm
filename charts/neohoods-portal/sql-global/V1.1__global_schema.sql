-- Global schema: identity, shared data, public.settings, matrix_bot_tokens (public).
-- UUID defaults: gen_random_uuid() (PG13+). Squashed from former V1.1–V1.5 (DB reset required when upgrading from old split migrations).

CREATE SCHEMA IF NOT EXISTS global;

-- Global users: full profile + auth (login, SSO). One row per person across all tenants.
CREATE TABLE IF NOT EXISTS global.users (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    username varchar(255) NOT NULL UNIQUE,
    email varchar(255) NOT NULL UNIQUE,
    password varchar(255),
    auth0_sub varchar(255),
    first_name varchar(255),
    last_name varchar(255),
    avatar_url varchar(512),
    preferred_language varchar(255) DEFAULT 'fr',
    phone_number varchar(255),
    flat_number varchar(255),
    street_address varchar(255),
    city varchar(255),
    postal_code varchar(255),
    country varchar(255),
    is_email_verified boolean NOT NULL DEFAULT false,
    disabled boolean NOT NULL DEFAULT false,
    disabled_by_admin boolean NOT NULL DEFAULT false,
    is_super_admin boolean NOT NULL DEFAULT false,
    matrix_user_id varchar(255),
    usage_conditions_accepted_version varchar(255),
    usage_conditions_accepted_at timestamp with time zone,
    usage_conditions_rejected_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp with time zone,
    anonymized_at timestamp with time zone,
    anonymized_email_hash varchar(128)
);
CREATE INDEX IF NOT EXISTS idx_global_users_email ON global.users(email);
CREATE INDEX IF NOT EXISTS idx_global_users_username ON global.users(username);
CREATE INDEX IF NOT EXISTS idx_global_users_auth0_sub ON global.users(auth0_sub);
ALTER TABLE global.users ADD COLUMN IF NOT EXISTS is_super_admin boolean NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS global.tenants (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    slug varchar(255) NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    disabled boolean NOT NULL DEFAULT false,
    is_public boolean NOT NULL DEFAULT false,
    custom_domains jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    db_name varchar(255) NOT NULL,
    description text,
    address text,
    units_count integer
);
ALTER TABLE global.tenants ADD COLUMN IF NOT EXISTS is_public boolean NOT NULL DEFAULT false;
ALTER TABLE global.tenants ADD COLUMN IF NOT EXISTS description text;
ALTER TABLE global.tenants ADD COLUMN IF NOT EXISTS address text;
ALTER TABLE global.tenants ADD COLUMN IF NOT EXISTS units_count integer;

CREATE TABLE IF NOT EXISTS global.user_tenants (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    role varchar(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, tenant_id)
);
CREATE INDEX IF NOT EXISTS idx_user_tenants_user_id ON global.user_tenants(user_id);
CREATE INDEX IF NOT EXISTS idx_user_tenants_tenant_id ON global.user_tenants(tenant_id);

CREATE TABLE IF NOT EXISTS global.user_devices (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    device_id varchar(255) NOT NULL,
    push_token text,
    platform varchar(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_used_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, device_id)
);
CREATE INDEX IF NOT EXISTS idx_global_user_devices_user_id ON global.user_devices(user_id);

CREATE TABLE IF NOT EXISTS global.notification_settings (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE UNIQUE,
    enable_notifications boolean NOT NULL DEFAULT true,
    newsletter_enabled boolean NOT NULL DEFAULT true
);
CREATE INDEX IF NOT EXISTS idx_global_notification_settings_user_id ON global.notification_settings(user_id);

CREATE TABLE IF NOT EXISTS global.system_settings (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    registration_enabled boolean NOT NULL DEFAULT false,
    maintenance_mode boolean NOT NULL DEFAULT false,
    usage_conditions_version varchar(255),
    matrix_assistant_enabled boolean NOT NULL DEFAULT true,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.settings (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    is_registration_enabled boolean NOT NULL DEFAULT false
);
INSERT INTO public.settings (id, is_registration_enabled) VALUES ('00000000-0000-0000-0000-000000000001', false)
ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS global.tenant_matrix_config (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    matrix_space_id varchar(512),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id)
);
CREATE INDEX IF NOT EXISTS idx_tenant_matrix_config_tenant_id ON global.tenant_matrix_config(tenant_id);

CREATE TABLE IF NOT EXISTS global.tenant_unifi_config (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    config_json jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id)
);
CREATE INDEX IF NOT EXISTS idx_tenant_unifi_config_tenant_id ON global.tenant_unifi_config(tenant_id);

-- Read-model for GET /tenants pending join requests (avoids scanning tenant schemas).
CREATE TABLE IF NOT EXISTS global.user_tenant_join_requests_index (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    global_user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    tenant_slug varchar(255) NOT NULL,
    tenant_join_request_id uuid NOT NULL,
    status varchar(50) NOT NULL,
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (global_user_id, tenant_slug)
);
CREATE INDEX IF NOT EXISTS idx_utjri_user_status
    ON global.user_tenant_join_requests_index(global_user_id, status);
CREATE INDEX IF NOT EXISTS idx_utjri_tenant_status
    ON global.user_tenant_join_requests_index(tenant_slug, status);

-- Matrix OAuth tokens for the portal bot (public schema; no tenant context).
CREATE TABLE IF NOT EXISTS matrix_bot_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    access_token VARCHAR(2048) NOT NULL,
    refresh_token VARCHAR(2048) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_matrix_bot_tokens_created_at ON matrix_bot_tokens(created_at DESC);
