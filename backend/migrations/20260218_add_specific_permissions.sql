-- Add specific product and client permissions separately
-- This migration adds granular permissions that were previously grouped under 'write' permissions

INSERT INTO permissions (code, description) VALUES
  ('products.create', 'Create products'),
  ('products.update', 'Update products'),
  ('products.delete', 'Delete products'),
  ('clients.create', 'Create clients'),
  ('clients.update', 'Update clients'),
  ('clients.delete', 'Delete clients')
ON CONFLICT (code) DO NOTHING;

-- Remove old 'write' permissions if they exist
DELETE FROM role_permissions 
WHERE permission_id IN (
  SELECT id FROM permissions WHERE code IN ('products.write', 'clients.write')
);

DELETE FROM permissions WHERE code IN ('products.write', 'clients.write');

-- Re-apply production role permissions (gets all permissions except users/roles/permissions management)
DELETE FROM role_permissions WHERE role_id IN (
  SELECT id FROM roles WHERE name = 'production'
);

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.code NOT IN ('users.manage','roles.manage','permissions.manage')
WHERE r.name = 'production'
ON CONFLICT DO NOTHING;

-- Commercial role: add client management permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.code IN (
  'clients.create', 'clients.update', 'clients.delete'
)
WHERE r.name = 'commercial'
ON CONFLICT DO NOTHING;
