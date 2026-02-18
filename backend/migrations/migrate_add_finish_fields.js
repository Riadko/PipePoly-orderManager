const fs = require('fs');
const path = require('path');
const pool = require('../config/db');

async function run() {
  try {
    const sqlPath = path.resolve(__dirname, './20250913_add_finish_fields.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    console.log('Running migration:', sqlPath);
    await pool.query(sql);
    console.log('Migration applied successfully.');
    process.exit(0);
  } catch (err) {
    console.error('Migration failed:', err);
    process.exit(1);
  }
}

run();
