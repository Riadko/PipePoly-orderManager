const pool = require('../config/db');

// Helper select that returns items (from orders.items JSONB or aggregated order_items)
const ORDERS_WITH_ITEMS_SELECT = `
SELECT o.*, COALESCE(o.items, oi.items_json) AS items
FROM orders o
LEFT JOIN (
  SELECT order_id, jsonb_agg(jsonb_build_object('product', product, 'quantity', quantity)) AS items_json
  FROM order_items GROUP BY order_id
) oi ON oi.order_id = o.id
`;

// Get all orders
const getAllOrders = async () => {
  const result = await pool.query(ORDERS_WITH_ITEMS_SELECT);
  return result.rows;
};

// Get orders by status
const getOrdersByStatus = async (validated, finished) => {
  const sql = ORDERS_WITH_ITEMS_SELECT + ' WHERE o.validated = $1 AND o.finished = $2';
  const result = await pool.query(sql, [validated, finished]);
  return result.rows;
};

// Add a new order
const addOrder = async (order) => {
  const { order_number, client_name, product, quantity, order_date, delivery_date, status, remarks } = order;
  const result = await pool.query(
    'INSERT INTO orders (order_number, client_name, product, quantity, order_date, delivery_date, status, remarks) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
    [order_number, client_name, product, quantity, order_date, delivery_date, status, remarks]
  );
  return result.rows[0];
};

// Validate an order
const validateOrder = async (id) => {
  const result = await pool.query('UPDATE orders SET validated = true, validated_date = NOW() WHERE id = $1 RETURNING *', [id]);
  return result.rows[0];
};

// Finish an order
const finishOrder = async (id) => {
  const result = await pool.query('UPDATE orders SET finished = true, finished_date = NOW() WHERE id = $1 RETURNING *', [id]);
  return result.rows[0];
};

module.exports = {
  getAllOrders,
  getOrdersByStatus,
  addOrder,
  validateOrder,
  finishOrder
};