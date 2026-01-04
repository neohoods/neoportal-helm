-- Migration V3.6: Add Incident Management schema

-- Incident Management Tables
-- Sequence for incremental incident reference numbers
CREATE SEQUENCE incident_ref_seq START WITH 1 INCREMENT BY 1;

-- Main incidents table
CREATE TABLE incidents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_ref INTEGER UNIQUE NOT NULL DEFAULT nextval('incident_ref_seq'),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'WAITING_EXTERNAL', 'WAITING_INTERNAL', 'RESOLVED', 'ARCHIVED')),
    priority VARCHAR(50) NOT NULL DEFAULT 'MEDIUM' CHECK (priority IN ('URGENT', 'HIGH', 'MEDIUM', 'LOW')),
    visibility VARCHAR(50) NOT NULL DEFAULT 'INTERNAL' CHECK (visibility IN ('INTERNAL', 'EXTERNAL')),
    impact_level VARCHAR(50) NOT NULL DEFAULT 'MEDIUM' CHECK (impact_level IN ('LOW', 'MEDIUM', 'HIGH')),
    affected_units INTEGER,
    expected_response_date TIMESTAMP WITH TIME ZONE,
    expected_resolution_date TIMESTAMP WITH TIME ZONE,
    location_scope VARCHAR(50) NOT NULL DEFAULT 'UNIT' CHECK (location_scope IN ('UNIT', 'BUILDING', 'COMMON_AREA', 'GARAGE', 'GLOBAL')),
    location_ref VARCHAR(255),
    ai_summary TEXT,
    summary_updated_at TIMESTAMP WITH TIME ZONE,
    resolution_reason TEXT,
    solution_applied TEXT,
    follow_up_required BOOLEAN NOT NULL DEFAULT FALSE,
    matrix_room VARCHAR(255),
    owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_incidents_status ON incidents(status);
CREATE INDEX idx_incidents_priority ON incidents(priority);
CREATE INDEX idx_incidents_visibility ON incidents(visibility);
CREATE INDEX idx_incidents_impact_level ON incidents(impact_level);
CREATE INDEX idx_incidents_location_scope ON incidents(location_scope);
CREATE INDEX idx_incidents_expected_response_date ON incidents(expected_response_date);
CREATE INDEX idx_incidents_expected_resolution_date ON incidents(expected_resolution_date);
CREATE INDEX idx_incidents_owner_id ON incidents(owner_id);
CREATE INDEX idx_incidents_created_by ON incidents(created_by);
CREATE INDEX idx_incidents_created_at ON incidents(created_at);
CREATE INDEX idx_incidents_updated_at ON incidents(updated_at);
CREATE INDEX idx_incidents_ref ON incidents(incident_ref);

-- Incident tags (many-to-many)
CREATE TABLE incident_tags (
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    tag VARCHAR(100) NOT NULL,
    PRIMARY KEY (incident_id, tag)
);

CREATE INDEX idx_incident_tags_incident_id ON incident_tags(incident_id);
CREATE INDEX idx_incident_tags_tag ON incident_tags(tag);

-- Incident participants (contacts/intervenants associated with an incident)
CREATE TABLE incident_participants (
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    contact_id UUID NOT NULL REFERENCES contact_numbers(id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    added_by UUID REFERENCES users(id) ON DELETE SET NULL,
    PRIMARY KEY (incident_id, contact_id)
);

CREATE INDEX idx_incident_participants_incident_id ON incident_participants(incident_id);
CREATE INDEX idx_incident_participants_contact_id ON incident_participants(contact_id);

-- Incident events (event-sourced history)
CREATE TABLE incident_events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL CHECK (event_type IN ('COMMUNICATION', 'STATE', 'FILE', 'SYSTEM')),
    event_sub_type VARCHAR(50) NOT NULL,
    visibility VARCHAR(50) NOT NULL DEFAULT 'PRIMARY' CHECK (visibility IN ('PRIMARY', 'SECONDARY')),
    payload JSONB,
    author_type VARCHAR(50) NOT NULL CHECK (author_type IN ('user', 'system', 'bot', 'ai')),
    author_id UUID, -- Optional: linked user/contact ID if found, no FK constraint
    author_email VARCHAR(255), -- Email address of the author (from email, user, etc.)
    author_name VARCHAR(255), -- Display name of the author
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_incident_events_incident_id ON incident_events(incident_id);
CREATE INDEX idx_incident_events_event_type ON incident_events(event_type);
CREATE INDEX idx_incident_events_event_sub_type ON incident_events(event_sub_type);
CREATE INDEX idx_incident_events_visibility ON incident_events(visibility);
CREATE INDEX idx_incident_events_created_at ON incident_events(created_at);
CREATE INDEX idx_incident_events_author ON incident_events(author_type, author_id);
CREATE INDEX idx_incident_events_author_email ON incident_events(author_email);

-- Incident files (metadata only, actual files in Scaleway Object Storage)
CREATE TABLE incident_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    object_key VARCHAR(500) NOT NULL, -- S3 key in Scaleway
    filename VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    size BIGINT NOT NULL,
    uploaded_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    uploaded_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_incident_files_incident_id ON incident_files(incident_id);
CREATE INDEX idx_incident_files_uploaded_by ON incident_files(uploaded_by);
CREATE INDEX idx_incident_files_uploaded_at ON incident_files(uploaded_at);

-- Unassigned emails (emails received that couldn't be matched to an incident)
CREATE TABLE unassigned_emails (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_email VARCHAR(255) NOT NULL,
    subject VARCHAR(500),
    body TEXT,
    headers TEXT,
    received_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN NOT NULL DEFAULT FALSE,
    processed_at TIMESTAMP WITH TIME ZONE,
    processed_by UUID REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_unassigned_emails_processed ON unassigned_emails(processed);
CREATE INDEX idx_unassigned_emails_received_at ON unassigned_emails(received_at);

-- Incident expected actions (next expected action tracking)
CREATE TABLE incident_expected_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    action TEXT NOT NULL,
    expected_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_incident_expected_actions_incident_id ON incident_expected_actions(incident_id);
CREATE INDEX idx_incident_expected_actions_expected_date ON incident_expected_actions(expected_date);

-- Incident relations (related incidents)
CREATE TABLE incident_relations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    related_incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    relation_type VARCHAR(50) NOT NULL CHECK (relation_type IN ('CAUSED_BY', 'RELATED_TO', 'DUPLICATE_OF', 'BLOCKS', 'BLOCKED_BY')),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE(incident_id, related_incident_id)
);

CREATE INDEX idx_incident_relations_incident_id ON incident_relations(incident_id);
CREATE INDEX idx_incident_relations_related_incident_id ON incident_relations(related_incident_id);
CREATE INDEX idx_incident_relations_relation_type ON incident_relations(relation_type);

-- Incident watchers (users watching an incident without being owner)
CREATE TABLE incident_watchers (
    incident_id UUID NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    added_by UUID REFERENCES users(id) ON DELETE SET NULL,
    PRIMARY KEY (incident_id, user_id)
);

CREATE INDEX idx_incident_watchers_incident_id ON incident_watchers(incident_id);
CREATE INDEX idx_incident_watchers_user_id ON incident_watchers(user_id);

-- Create trigger for incidents updated_at
CREATE TRIGGER update_incidents_updated_at BEFORE UPDATE ON incidents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


