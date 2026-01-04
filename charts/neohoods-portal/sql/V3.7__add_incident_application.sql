-- Migration V3.7: Add Incident application

INSERT INTO applications (id, name, url, icon, help_text, disabled) 
VALUES (
    '550e8400-e29b-41d4-a716-446655440006', 
    'Incident', 
    '/incident', 
    '/assets/applications/incident.png', 
    'Gestion des incidents et signalements', 
    false
);

