const express = require('express');
const cors = require('cors');
const path = require('path');

const ordersRoutes = require('./routes/orders');
const authRoutes = require('./routes/auth');
// const productsRoutes = require('./routes/products');
const catalogProductsRoutes = require('./routes/catalogProducts');
const clientsRoutes = require('./routes/clients');
const { cleanupOldAuditLogs } = require('./utils/audit');

require('dotenv').config();

const app = express();

app.set('trust proxy', true);

app.use(cors());
app.use(express.json());

// serve uploaded files from backend/uploads

app.use('/auth', authRoutes);
app.use('/orders', ordersRoutes);
app.use('/catalog', catalogProductsRoutes);
app.use('/clients', clientsRoutes);

// Serve React frontend build
app.use(express.static(path.join(__dirname, '../frontend/build')));

// Catch-all route pour React SPA
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/build', 'index.html'));
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  
  // Audit log retention cleanup
  const retentionDays = parseInt(process.env.AUDIT_LOG_RETENTION_DAYS || '90', 10);
  
  // Run cleanup on startup
  cleanupOldAuditLogs(retentionDays);
  
  // Run cleanup daily at 2:00 AM
  const scheduleCleanup = () => {
    const now = new Date();
    const next2Am = new Date(now);
    next2Am.setHours(2, 0, 0, 0);
    if (next2Am <= now) {
      next2Am.setDate(next2Am.getDate() + 1);
    }
    const delay = next2Am.getTime() - now.getTime();
    setTimeout(() => {
      cleanupOldAuditLogs(retentionDays);
      scheduleCleanup(); // Reschedule for next day
    }, delay);
  };
  scheduleCleanup();
});
