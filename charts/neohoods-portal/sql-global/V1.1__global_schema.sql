-- Global schema: one source of truth for identity and shared data.
-- Run on default DB (neohoods-portal). Tenant DBs only have minimal user link + tenant-specific data.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE SCHEMA IF NOT EXISTS global;

-- Global users: full profile + auth (login, SSO). One row per person across all tenants.
CREATE TABLE IF NOT EXISTS global.users (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
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
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    slug varchar(255) NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    disabled boolean NOT NULL DEFAULT false,
    custom_domains jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    db_name varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS global.user_tenants (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE,
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    role varchar(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, tenant_id)
);
CREATE INDEX IF NOT EXISTS idx_user_tenants_user_id ON global.user_tenants(user_id);
CREATE INDEX IF NOT EXISTS idx_user_tenants_tenant_id ON global.user_tenants(tenant_id);

CREATE TABLE IF NOT EXISTS global.user_devices (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
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
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES global.users(id) ON DELETE CASCADE UNIQUE,
    enable_notifications boolean NOT NULL DEFAULT true,
    newsletter_enabled boolean NOT NULL DEFAULT true
);
CREATE INDEX IF NOT EXISTS idx_global_notification_settings_user_id ON global.notification_settings(user_id);

CREATE TABLE IF NOT EXISTS global.system_settings (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    registration_enabled boolean NOT NULL DEFAULT false,
    maintenance_mode boolean NOT NULL DEFAULT false,
    usage_conditions_version varchar(255),
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.settings (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    is_registration_enabled boolean NOT NULL DEFAULT false
);
INSERT INTO public.settings (id, is_registration_enabled) VALUES ('00000000-0000-0000-0000-000000000001', false)
ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS global.tenant_matrix_config (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    matrix_space_id varchar(512),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id)
);
CREATE INDEX IF NOT EXISTS idx_tenant_matrix_config_tenant_id ON global.tenant_matrix_config(tenant_id);

CREATE TABLE IF NOT EXISTS global.tenant_unifi_config (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES global.tenants(id) ON DELETE CASCADE,
    config_json jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (tenant_id)
);
CREATE INDEX IF NOT EXISTS idx_tenant_unifi_config_tenant_id ON global.tenant_unifi_config(tenant_id);
