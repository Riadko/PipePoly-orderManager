const pool = require('../config/db');

const StockMovement = {
  async create({ inventory_id, segment_id, order_id, movement_type, quantity, unit, reason }) {
    await pool.query(
      'INSERT INTO stock_movements (inventory_id, segment_id, order_id, movement_type, quantity, unit, reason) VALUES ($1, $2, $3, $4, $5, $6, $7)',
      [inventory_id, segment_id, order_id, movement_type, quantity, unit, reason]
    );
  }
};

module.exports = StockMovement;
