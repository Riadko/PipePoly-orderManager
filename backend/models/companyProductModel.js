const pool = require('../config/db');

const getAll = async () => {
  const res = await pool.query('SELECT * FROM company_products ORDER BY created_at DESC');
  return res.rows;
};

const getById = async (id) => {
  const res = await pool.query('SELECT * FROM company_products WHERE id = $1', [id]);
  return res.rows[0];
};

const create = async ({ name, description, image_path, drawing_path, specsheet_path }) => {
  const res = await pool.query(
    'INSERT INTO company_products (name, description, image_path, drawing_path, specsheet_path) VALUES ($1,$2,$3,$4,$5) RETURNING *',
    [name, description, image_path, drawing_path, specsheet_path]
  );
  return res.rows[0];
};

module.exports = { getAll, getById, create };
