-- Add is_public to global.tenants for public/demo copropriétés (anyone can access admin)
ALTER TABLE global.tenants ADD COLUMN IF NOT EXISTS is_public boolean NOT NULL DEFAULT false;

-- Demo tenant is public for live demos
UPDATE global.tenants SET is_public = true WHERE slug = 'demo';
