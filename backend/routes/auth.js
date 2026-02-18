const express = require('express');
const bcrypt = require('bcryptjs');
const pool = require('../config/db');
const { authRequired, requirePermissions, signToken, getUserAuth } = require('../middleware/auth');
const { logAudit, getAuditContext } = require('../utils/audit');

const router = express.Router();

// POST /auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body || {};
    if (!email || !password) {
      await logAudit({
        action: 'auth.login.failed',
        entityType: 'auth',
        metadata: { reason: 'missing_credentials', email: email || null },
        ...getAuditContext(req)
      });
      return res.status(400).json({ error: 'email and password required' });
    }

    const userRes = await pool.query('SELECT * FROM users WHERE email = $1', [String(email).toLowerCase()]);
    const user = userRes.rows[0];
    if (!user || user.is_active === false) {
      await logAudit({
        action: 'auth.login.failed',
        entityType: 'auth',
        metadata: { reason: 'invalid_credentials', email: String(email).toLowerCase() },
        ...getAuditContext(req)
      });
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const ok = await bcrypt.compare(String(password), user.password_hash);
    if (!ok) {
      await logAudit({
        action: 'auth.login.failed',
        entityType: 'auth',
        metadata: { reason: 'invalid_credentials', email: String(email).toLowerCase() },
        ...getAuditContext(req)
      });
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const authInfo = await getUserAuth(user.id);
    if (!authInfo) {
      await logAudit({
        action: 'auth.login.failed',
        entityType: 'auth',
        metadata: { reason: 'invalid_credentials', email: String(email).toLowerCase() },
        ...getAuditContext(req)
      });
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    await logAudit({
      action: 'auth.login.success',
      entityType: 'user',
      entityId: user.id,
      actorUserId: user.id,
      actorEmail: authInfo.user.email,
      actorRoles: authInfo.roles,
      ipAddress: req.ip || null,
      userAgent: req.get('user-agent') || null,
      metadata: { email: authInfo.user.email }
    });

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

// Admin: list roles with their permissions
router.get('/roles', authRequired, requirePermissions(['roles.manage']), async (req, res) => {
  try {
    const rolesRes = await pool.query('SELECT id, name FROM roles ORDER BY name ASC');
    const roles = rolesRes.rows || [];

    const permsRes = await pool.query(
      `SELECT rp.role_id, p.id, p.code, p.description
       FROM role_permissions rp
       JOIN permissions p ON p.id = rp.permission_id
       ORDER BY p.code ASC`
    );
    const permsByRole = {};
    permsRes.rows.forEach(p => {
      if (!permsByRole[p.role_id]) permsByRole[p.role_id] = [];
      permsByRole[p.role_id].push({ id: p.id, code: p.code, description: p.description });
    });

    res.json(roles.map(r => ({ ...r, permissions: permsByRole[r.id] || [] })));
  } catch (err) {
    console.error('List roles error', err);
    res.status(500).json({ error: 'Failed to list roles' });
  }
});

// Admin: get single role with its permissions
router.get('/roles/:id', authRequired, requirePermissions(['roles.manage']), async (req, res) => {
  try {
    const { id } = req.params;
    const roleRes = await pool.query('SELECT id, name FROM roles WHERE id = $1', [id]);
    const role = roleRes.rows[0];
    if (!role) return res.status(404).json({ error: 'Role not found' });

    const permsRes = await pool.query(
      `SELECT p.id, p.code, p.description
       FROM role_permissions rp
       JOIN permissions p ON p.id = rp.permission_id
       WHERE rp.role_id = $1
       ORDER BY p.code ASC`,
      [id]
    );

    res.json({
      ...role,
      permissions: permsRes.rows || []
    });
  } catch (err) {
    console.error('Get role error', err);
    res.status(500).json({ error: 'Failed to get role' });
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

// Admin: delete role
router.delete('/roles/:id', authRequired, requirePermissions(['roles.manage']), async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query('DELETE FROM role_permissions WHERE role_id = $1', [id]);
    await pool.query('DELETE FROM user_roles WHERE role_id = $1', [id]);
    await pool.query('DELETE FROM roles WHERE id = $1', [id]);
    res.json({ success: true });
  } catch (err) {
    console.error('Delete role error', err);
    res.status(500).json({ error: 'Failed to delete role' });
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

// Admin: list audit logs
router.get('/audit-logs', authRequired, requirePermissions(['permissions.manage']), async (req, res) => {
  try {
    const {
      action,
      entity_type,
      entity_id,
      actor_email,
      from,
      to,
      limit,
      offset
    } = req.query || {};

    const clauses = [];
    const params = [];

    if (action) {
      params.push(`%${String(action)}%`);
      clauses.push(`action ILIKE $${params.length}`);
    }
    if (entity_type) {
      params.push(`%${String(entity_type)}%`);
      clauses.push(`entity_type ILIKE $${params.length}`);
    }
    if (entity_id) {
      params.push(`%${String(entity_id)}%`);
      clauses.push(`entity_id ILIKE $${params.length}`);
    }
    if (actor_email) {
      params.push(`%${String(actor_email).toLowerCase()}%`);
      clauses.push(`LOWER(actor_email) ILIKE $${params.length}`);
    }

    const fromDate = from ? new Date(from) : null;
    if (fromDate && !Number.isNaN(fromDate.getTime())) {
      params.push(fromDate);
      clauses.push(`created_at >= $${params.length}`);
    }

    const toDate = to ? new Date(to) : null;
    if (toDate && !Number.isNaN(toDate.getTime())) {
      params.push(toDate);
      clauses.push(`created_at <= $${params.length}`);
    }

    const whereSql = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';

    const safeLimit = Math.min(Math.max(parseInt(limit, 10) || 50, 1), 200);
    const safeOffset = Math.max(parseInt(offset, 10) || 0, 0);

    const countRes = await pool.query(
      `SELECT COUNT(*)::int AS total FROM audit_logs ${whereSql}`,
      params
    );

    const listSql = `
      SELECT id, action, entity_type, entity_id, actor_user_id, actor_email, actor_roles,
             ip_address, user_agent, metadata, created_at
      FROM audit_logs
      ${whereSql}
      ORDER BY created_at DESC
      LIMIT $${params.length + 1} OFFSET $${params.length + 2}
    `;
    const listParams = params.concat([safeLimit, safeOffset]);
    const listRes = await pool.query(listSql, listParams);

    res.json({
      total: countRes.rows[0]?.total || 0,
      limit: safeLimit,
      offset: safeOffset,
      rows: listRes.rows || []
    });
  } catch (err) {
    console.error('List audit logs error', err);
    res.status(500).json({ error: 'Failed to list audit logs' });
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
