const jwt = require('jsonwebtoken');
const pool = require('../config/db');

const JWT_SECRET = process.env.JWT_SECRET || 'dev-secret';
const JWT_EXPIRES = process.env.JWT_EXPIRES || '8h';

async function getUserAuth(userId) {
  const userRes = await pool.query(
    'SELECT id, email, full_name, is_active FROM users WHERE id = $1',
    [userId]
  );
  const user = userRes.rows[0];
  if (!user || user.is_active === false) return null;

  const rolesRes = await pool.query(
    `SELECT r.name
     FROM roles r
     JOIN user_roles ur ON ur.role_id = r.id
     WHERE ur.user_id = $1`,
    [userId]
  );
  const roles = rolesRes.rows.map(r => r.name);

  const permsRes = await pool.query(
    `SELECT DISTINCT p.code
     FROM permissions p
     JOIN role_permissions rp ON rp.permission_id = p.id
     JOIN user_roles ur ON ur.role_id = rp.role_id
     WHERE ur.user_id = $1`,
    [userId]
  );
  const permissions = permsRes.rows.map(p => p.code);

  return { user, roles, permissions };
}

function signToken(payload) {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES });
}

async function authRequired(req, res, next) {
  const auth = req.headers.authorization || '';
  const token = auth.startsWith('Bearer ') ? auth.slice(7) : null;
  if (!token) return res.status(401).json({ error: 'Unauthorized' });

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    const authInfo = await getUserAuth(decoded.sub);
    if (!authInfo) return res.status(401).json({ error: 'Unauthorized' });
    req.auth = { ...authInfo, tokenClaims: decoded };
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

function requirePermissions(required = []) {
  return (req, res, next) => {
    if (!req.auth) return res.status(401).json({ error: 'Unauthorized' });
    const userPerms = req.auth.permissions || [];
    const ok = required.every(p => userPerms.includes(p));
    if (!ok) return res.status(403).json({ error: 'Forbidden' });
    next();
  };
}

module.exports = {
  authRequired,
  requirePermissions,
  signToken,
  getUserAuth
};
