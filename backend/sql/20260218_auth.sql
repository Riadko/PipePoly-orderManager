-- Auth tables, roles, and permissions
-- Replace the admin email/password hash before running.

CREATE TABLE IF NOT EXISTS public.users (
  id SERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  password_hash TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.roles (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS public.permissions (
  id SERIAL PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  description TEXT
);

CREATE TABLE IF NOT EXISTS public.user_roles (
  user_id INTEGER NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  role_id INTEGER NOT NULL REFERENCES public.roles(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, role_id)
);

CREATE TABLE IF NOT EXISTS public.role_permissions (
  role_id INTEGER NOT NULL REFERENCES public.roles(id) ON DELETE CASCADE,
  permission_id INTEGER NOT NULL REFERENCES public.permissions(id) ON DELETE CASCADE,
  PRIMARY KEY (role_id, permission_id)
);

-- Base permissions
INSERT INTO public.permissions (code, description) VALUES
  ('orders.read', 'Read orders'),
  ('orders.create', 'Create orders'),
  ('orders.update', 'Update orders'),
  ('orders.delete', 'Delete orders'),
  ('orders.validate', 'Validate orders'),
  ('orders.finish', 'Finish orders'),
  ('orders.production', 'Production actions'),
  ('orders.download', 'Download PDFs'),
  ('products.read', 'Read products'),
  ('products.write', 'Manage products'),
  ('clients.read', 'Read clients'),
  ('clients.write', 'Manage clients'),
  ('inventory.read', 'Read inventory'),
  ('users.manage', 'Manage users'),
  ('roles.manage', 'Manage roles'),
  ('permissions.manage', 'Manage permissions')
ON CONFLICT (code) DO NOTHING;

-- Roles
INSERT INTO public.roles (name) VALUES
  ('admin'),
  ('production'),
  ('commercial')
ON CONFLICT (name) DO NOTHING;

-- Role permissions
-- Admin gets all permissions
INSERT INTO public.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM public.roles r
JOIN public.permissions p ON true
WHERE r.name = 'admin'
ON CONFLICT DO NOTHING;

-- Production gets everything except user/role/permission management
INSERT INTO public.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM public.roles r
JOIN public.permissions p ON p.code NOT IN ('users.manage','roles.manage','permissions.manage')
WHERE r.name = 'production'
ON CONFLICT DO NOTHING;

-- Commercial: read + manage orders (no validate/finish/production), read products/clients/inventory
INSERT INTO public.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM public.roles r
JOIN public.permissions p ON p.code IN (
  'orders.read','orders.create','orders.update','orders.delete','orders.download',
  'products.read','clients.read','inventory.read'
)
WHERE r.name = 'commercial'
ON CONFLICT DO NOTHING;

-- First admin user (replace email and password hash)
-- Example hash command:
-- node -e "const bcrypt=require('bcryptjs');console.log(bcrypt.hashSync('pipepomyadmin',10))"
INSERT INTO public.users (email, full_name, password_hash, is_active)
VALUES ('admin@pipepoly.local', 'Admin', '$2b$10$nKVdxcZSY0LJRYbouDT0rO4Ucm5dBsLOMl5k7sPuzs85tw057eZl.', true)
ON CONFLICT (email) DO NOTHING;

-- Assign admin role to the admin user
INSERT INTO public.user_roles (user_id, role_id)
SELECT u.id, r.id
FROM public.users u
JOIN public.roles r ON r.name = 'admin'
WHERE u.email = 'admin@pipepoly.local'
ON CONFLICT DO NOTHING;
