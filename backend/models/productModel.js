const pool = require('../config/db');

const Product = {
  async getAll() {
    const { rows } = await pool.query('SELECT * FROM products');
    return rows;
  },
  async getById(id) {
    const { rows } = await pool.query('SELECT * FROM products WHERE id = $1', [id]);
    return rows[0];
  }
};

module.exports = Product;
