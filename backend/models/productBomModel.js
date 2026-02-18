const pool = require('../config/db');

const ProductBOM = {
  async getByProductId(productId) {
    const { rows } = await pool.query('SELECT * FROM product_bom WHERE product_id = $1', [productId]);
    return rows;
  }
};

module.exports = ProductBOM;
