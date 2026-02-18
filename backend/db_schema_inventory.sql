-- Simplified inventory schema (no inventory_segments). Use inventory.total_quantity only.

-- Table: products
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT
);

-- Table: inventory (raw materials / pieces)
CREATE TABLE IF NOT EXISTS inventory (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  total_quantity NUMERIC NOT NULL DEFAULT 0,
  unit VARCHAR(50)
);

-- Table: product_bom (Bill of Materials)
CREATE TABLE IF NOT EXISTS product_bom (
  id SERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL REFERENCES products(id),
  inventory_item_id INTEGER NOT NULL REFERENCES inventory(id),
  quantity NUMERIC NOT NULL,
  unit VARCHAR(50) NOT NULL
);

-- Table: stock_movements (traceability)
CREATE TABLE IF NOT EXISTS stock_movements (
  id SERIAL PRIMARY KEY,
  inventory_id INTEGER REFERENCES inventory(id),
  segment_id INTEGER, -- reserved / deprecated
  order_id INTEGER,
  movement_type VARCHAR(50) NOT NULL, -- 'in' or 'out'
  quantity NUMERIC,
  unit VARCHAR(50),
  movement_date TIMESTAMP NOT NULL DEFAULT NOW(),
  reason TEXT
);

-- Example data placeholder for inventory and products removed. Use the provided setup script to populate inventory with pieces.
