-- Migration: add items JSONB column to orders and populate from order_items
ALTER TABLE orders ADD COLUMN IF NOT EXISTS items JSONB;

-- For orders that already have order_items, populate items from that table
WITH oi AS (
  SELECT order_id, jsonb_agg(jsonb_build_object('product', product, 'quantity', quantity)) AS items_json
  FROM order_items
  GROUP BY order_id
)
UPDATE orders
SET items = oi.items_json
FROM oi
WHERE orders.id = oi.order_id;

-- For legacy orders without order_items, populate items from product/quantity fields
UPDATE orders
SET items = jsonb_build_array(jsonb_build_object('product', product, 'quantity', quantity))
WHERE items IS NULL;
