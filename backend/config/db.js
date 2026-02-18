require('dotenv').config();
const { Pool } = require('pg');


let pool;
if (process.env.DATABASE_URL) {
  // Use DATABASE_URL (Render or production)
  pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false,
    },
  });
} else {
  // Use local environment variables
  pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT || 5432,
    ssl: false,
  });
}

module.exports = pool;