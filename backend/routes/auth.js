const express = require('express');
const bcrypt = require('bcryptjs');
const pool = require('../config/db');
const { authRequired, requirePermissions, signToken, getUserAuth } = require('../middleware/auth');

const router = express.Router();

// POST /auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body || {};
    if (!email || !password) return res.status(400).json({ error: 'email and password required' });

    const userRes = await pool.query('SELECT * FROM users WHERE email = $1', [String(email).toLowerCase()]);
    const user = userRes.rows[0];
    if (!user || user.is_active === false) return res.status(401).json({ error: 'Invalid credentials' });

    const ok = await bcrypt.compare(String(password), user.password_hash);
    if (!ok) return res.status(401).json({ error: 'Invalid credentials' });

    const authInfo = await getUserAuth(user.id);
    if (!authInfo) return res.status(401).json({ error: 'Invalid credentials' });

    const token = signToken({ sub: user.id });
    res.json({
      token,
      user: {
        id: authInfo.user.id,
        email: authInfo.user.email,
        full_name: authInfo.user.full_name,
        roles: authInfo.roles,
        permissions: authInfo.permissions
      }
    });
  } catch (err) {
    console.error('Login error', err);
    res.status(500).json({ error: 'Login failed' });
  }
});

// GET /auth/me
router.get('/me', authRequired, async (req, res) => {
  res.json({
    id: req.auth.user.id,
    email: req.auth.user.email,
    full_name: req.auth.user.full_name,
    roles: req.auth.roles,
    permissions: req.auth.permissions
  });
});

// Admin: list users
router.get('/users', authRequired, requirePermissions(['users.manage']), async (req, res) => {
  try {
    const usersRes = await pool.query('SELECT id, email, full_name, is_active, created_at FROM users ORDER BY id ASC');
    const users = usersRes.rows || [];

    const rolesRes = await pool.query(
      `SELECT ur.user_id, r.name
       FROM user_roles ur
       JOIN roles r ON r.id = ur.role_id
       ORDER BY r.name`
    );
    const rolesByUser = {};
    rolesRes.rows.forEach(r => {
      if (!rolesByUser[r.user_id]) rolesByUser[r.user_id] = [];
      rolesByUser[r.user_id].push(r.name);
    });

    res.json(users.map(u => ({ ...u, roles: rolesByUser[u.id] || [] })));
  } catch (err) {
    console.error('List users error', err);
    res.status(500).json({ error: 'Failed to list users' });
  }
});

// Admin: create user
router.post('/users', authRequired, requirePermissions(['users.manage']), async (req, res) => {
  try {
    const { email, full_name, password, roles = ['commercial'], is_active = true } = req.body || {};
    if (!email || !password) return res.status(400).json({ error: 'email and password required' });

    const hash = await bcrypt.hash(String(password), 10);
    const userRes = await pool.query(
      'INSERT INTO users (email, full_name, password_hash, is_active) VALUES ($1,$2,$3,$4) RETURNING id, email, full_name, is_active',
      [String(email).toLowerCase(), full_name || null, hash, !!is_active]
    );
    const user = userRes.rows[0];

    if (Array.isArray(roles) && roles.length) {
      await pool.query(
        `INSERT INTO user_roles (user_id, role_id)
         SELECT $1, r.id FROM roles r WHERE r.name = ANY($2::text[])
         ON CONFLICT DO NOTHING`,
        [user.id, roles]
      );
    }

    res.status(201).json(user);
  } catch (err) {
    console.error('Create user error', err);
    if (String(err.message || '').toLowerCase().includes('duplicate')) {
      return res.status(409).json({ error: 'Email already exists' });
    }
    res.status(500).json({ error: 'Failed to create user' });
  }
});

// Admin: update user
router.put('/users/:id', authRequired, requirePermissions(['users.manage']), async (req, res) => {
  try {
    const { id } = req.params;
    const { email, full_name, password, roles, is_active } = req.body || {};

    const updates = [];
    const params = [];
    let i = 1;
    if (email !== undefined) { updates.push(`email = $${i++}`); params.push(String(email).toLowerCase()); }
    if (full_name !== undefined) { updates.push(`full_name = $${i++}`); params.push(full_name || null); }
    if (is_active !== undefined) { updates.push(`is_active = $${i++}`); params.push(!!is_active); }
    if (password) {
      const hash = await bcrypt.hash(String(password), 10);
      updates.push(`password_hash = $${i++}`);
      params.push(hash);
    }
    if (updates.length) {
      params.push(id);
      await pool.query(`UPDATE users SET ${updates.join(', ')} WHERE id = $${i}`, params);
    }

    if (Array.isArray(roles)) {
      await pool.query('DELETE FROM user_roles WHERE user_id = $1', [id]);
      if (roles.length) {
        await pool.query(
          `INSERT INTO user_roles (user_id, role_id)
           SELECT $1, r.id FROM roles r WHERE r.name = ANY($2::text[])
           ON CONFLICT DO NOTHING`,
          [id, roles]
        );
      }
    }

    res.json({ success: true });
  } catch (err) {
    console.error('Update user error', err);
    res.status(500).json({ error: 'Failed to update user' });
  }
});

// Admin: delete user
router.delete('/users/:id', authRequired, requirePermissions(['users.manage']), async (req, res) => {
  try {
    await pool.query('DELETE FROM users WHERE id = $1', [req.params.id]);
    res.json({ success: true });
  } catch (err) {
    console.error('Delete user error', err);
    res.status(500).json({ error: 'Failed to delete user' });
  }
});

// Admin: list roles
router.get('/roles', authRequired, requirePermissions(['roles.manage']), async (req, res) => {
  try {
    const rolesRes = await pool.query('SELECT id, name FROM roles ORDER BY name ASC');
    res.json(rolesRes.rows || []);
  } catch (err) {
    console.error('List roles error', err);
    res.status(500).json({ error: 'Failed to list roles' });
  }
});

// Admin: create role
router.post('/roles', authRequired, requirePermissions(['roles.manage']), async (req, res) => {
  try {
    const { name } = req.body || {};
    if (!name) return res.status(400).json({ error: 'role name required' });
    const r = await pool.query('INSERT INTO roles (name) VALUES ($1) RETURNING id, name', [name]);
    res.status(201).json(r.rows[0]);
  } catch (err) {
    console.error('Create role error', err);
    res.status(500).json({ error: 'Failed to create role' });
  }
});

// Admin: list permissions
router.get('/permissions', authRequired, requirePermissions(['permissions.manage']), async (req, res) => {
  try {
    const r = await pool.query('SELECT id, code, description FROM permissions ORDER BY code ASC');
    res.json(r.rows || []);
  } catch (err) {
    console.error('List permissions error', err);
    res.status(500).json({ error: 'Failed to list permissions' });
  }
});

// Admin: update role permissions (replace all)
router.put('/roles/:id/permissions', authRequired, requirePermissions(['roles.manage']), async (req, res) => {
  try {
    const { id } = req.params;
    const { permissions = [] } = req.body || {};
    await pool.query('DELETE FROM role_permissions WHERE role_id = $1', [id]);
    if (Array.isArray(permissions) && permissions.length) {
      await pool.query(
        `INSERT INTO role_permissions (role_id, permission_id)
         SELECT $1, p.id FROM permissions p WHERE p.code = ANY($2::text[])
         ON CONFLICT DO NOTHING`,
        [id, permissions]
      );
    }
    res.json({ success: true });
  } catch (err) {
    console.error('Update role permissions error', err);
    res.status(500).json({ error: 'Failed to update role permissions' });
  }
});

module.exports = router;
