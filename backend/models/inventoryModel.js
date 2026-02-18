const pool = require('../config/db');

const Inventory = {
  async getAll() {
    const { rows } = await pool.query('SELECT * FROM inventory');
    return rows;
  },
  async getById(id) {
    const { rows } = await pool.query('SELECT * FROM inventory WHERE id = $1', [id]);
    return rows[0];
  },
  async updateQuantity(id, quantity) {
    await pool.query('UPDATE inventory SET total_quantity = $1 WHERE id = $2', [quantity, id]);
  }
};

module.exports = Inventory;
