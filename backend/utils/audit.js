const pool = require('../config/db');
const geoip = require('geoip-lite');
const UAParser = require('ua-parser-js');

function normalizeIp(ip) {
  if (!ip) return null;
  const raw = String(ip).trim();
  if (!raw) return null;
  if (raw === '::1') return '127.0.0.1';
  if (raw.startsWith('::ffff:')) return raw.replace('::ffff:', '');
  return raw;
}

function isPrivateOrLocalIp(ip) {
  if (!ip) return true;
  return (
    ip === '127.0.0.1' ||
    ip === '0.0.0.0' ||
    ip.startsWith('10.') ||
    ip.startsWith('192.168.') ||
    /^172\.(1[6-9]|2\d|3[0-1])\./.test(ip)
  );
}

function getLocationFromIp(ip) {
  const normalized = normalizeIp(ip);
  if (!normalized || isPrivateOrLocalIp(normalized)) {
    return {
      city: null,
      region: null,
      country: null,
      timezone: null,
      label: 'Local / Private Network'
    };
  }

  try {
    const geo = geoip.lookup(normalized);
    if (!geo) {
      return {
        city: null,
        region: null,
        country: null,
        timezone: null,
        label: 'Unknown'
      };
    }

    const city = geo.city || null;
    const region = geo.region || null;
    const country = geo.country || null;
    const timezone = geo.timezone || null;
    const parts = [city, region, country].filter(Boolean);
    return {
      city,
      region,
      country,
      timezone,
      label: parts.length ? parts.join(', ') : 'Unknown'
    };
  } catch (_) {
    return {
      city: null,
      region: null,
      country: null,
      timezone: null,
      label: 'Unknown'
    };
  }
}

function parseDevice(userAgent) {
  const parser = new UAParser(userAgent || '');
  const parsed = parser.getResult();

  const deviceType = parsed.device?.type || 'desktop';
  const vendor = parsed.device?.vendor || null;
  const model = parsed.device?.model || null;
  const browserName = parsed.browser?.name || null;
  const browserVersion = parsed.browser?.version || null;
  const osName = parsed.os?.name || null;
  const osVersion = parsed.os?.version || null;

  let label = deviceType;
  if (vendor || model) {
    label = [vendor, model].filter(Boolean).join(' ');
  } else if (deviceType === 'desktop' && osName) {
    label = `Desktop (${osName})`;
  }

  return {
    type: deviceType,
    label,
    vendor,
    model,
    browser: [browserName, browserVersion].filter(Boolean).join(' ') || null,
    os: [osName, osVersion].filter(Boolean).join(' ') || null
  };
}

async function logAudit({
  action,
  entityType = null,
  entityId = null,
  actorUserId = null,
  actorEmail = null,
  actorRoles = null,
  ipAddress = null,
  userAgent = null,
  connectionInfo = null,
  metadata = null
}) {
  try {
    let finalMetadata = metadata;
    if (connectionInfo) {
      if (metadata && typeof metadata === 'object' && !Array.isArray(metadata)) {
        finalMetadata = {
          ...metadata,
          connection: {
            ...(metadata.connection || {}),
            ...connectionInfo
          }
        };
      } else if (metadata == null) {
        finalMetadata = { connection: connectionInfo };
      } else {
        finalMetadata = {
          original_metadata: metadata,
          connection: connectionInfo
        };
      }
    }

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
        finalMetadata
      ]
    );
  } catch (err) {
    // Never block the main request on audit failures
    console.warn('Audit log failed:', err.message);
  }
}

function getAuditContext(req) {
  const ipAddress = normalizeIp(req.ip || null);
  const userAgent = req.get('user-agent') || null;
  const connectionInfo = {
    device: parseDevice(userAgent),
    location: getLocationFromIp(ipAddress)
  };

  return {
    actorUserId: req.auth?.user?.id || null,
    actorEmail: req.auth?.user?.email || null,
    actorRoles: req.auth?.roles || null,
    ipAddress,
    userAgent,
    connectionInfo
  };
}

async function cleanupOldAuditLogs(retentionDays = 90) {
  try {
    const result = await pool.query(
      `DELETE FROM audit_logs WHERE created_at < NOW() - INTERVAL '${retentionDays} days'`
    );
    if (result.rowCount > 0) {
      console.log(`[Audit Cleanup] Deleted ${result.rowCount} audit logs older than ${retentionDays} days`);
    }
  } catch (err) {
    console.error('[Audit Cleanup] Error deleting old audit logs:', err.message);
  }
}

module.exports = {
  logAudit,
  getAuditContext,
  cleanupOldAuditLogs
};
