-- Create order_items table to allow multiple products per order
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product VARCHAR(255) NOT NULL,
  quantity NUMERIC NOT NULL DEFAULT 1
);

-- Optional index for faster lookups
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
