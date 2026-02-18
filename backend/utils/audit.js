const pool = require('../config/db');

async function logAudit({
  action,
  entityType = null,
  entityId = null,
  actorUserId = null,
  actorEmail = null,
  actorRoles = null,
  ipAddress = null,
  userAgent = null,
  metadata = null
}) {
  try {
    await pool.query(
      `INSERT INTO audit_logs (
        action, entity_type, entity_id,
        actor_user_id, actor_email, actor_roles,
        ip_address, user_agent, metadata
      ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
      [
        action,
        entityType,
        entityId ? String(entityId) : null,
        actorUserId,
        actorEmail,
        Array.isArray(actorRoles) ? actorRoles : null,
        ipAddress,
        userAgent,
        metadata
      ]
    );
  } catch (err) {
    // Never block the main request on audit failures
    console.warn('Audit log failed:', err.message);
  }
}

function getAuditContext(req) {
  return {
    actorUserId: req.auth?.user?.id || null,
    actorEmail: req.auth?.user?.email || null,
    actorRoles: req.auth?.roles || null,
    ipAddress: req.ip || null,
    userAgent: req.get('user-agent') || null
  };
}

module.exports = {
  logAudit,
  getAuditContext
};
