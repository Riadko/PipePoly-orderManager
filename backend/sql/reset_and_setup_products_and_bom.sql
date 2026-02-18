-- Reset example data and set correct products + BOM + inventory
-- This script will:
-- 1) delete previous example rows from product_bom, products, stock_movements, inventory
-- 2) insert inventory rows for raw tubes (by diameter) with sample quantities (in mm)
-- 3) insert products (each diameter + piece name)
-- 4) insert product_bom entries linking products -> tube inventory with the provided Q (mm)

BEGIN;

-- 0) Safety: ensure tables exist
SELECT 1 FROM information_schema.tables WHERE table_name IN ('inventory','products','product_bom');

-- 1) Remove previous example data (order matters because of FKs)
DELETE FROM product_bom;
DELETE FROM products;
DELETE FROM stock_movements;
DELETE FROM inventory;

-- 2) Insert inventory (raw tubes by diameter). Quantities are arbitrary (au pif) in mm.
INSERT INTO inventory (name, total_quantity, unit) VALUES
  ('Tube D63', 100000, 'mm'),
  ('Tube D75', 100000, 'mm'),
  ('Tube D90', 100000, 'mm'),
  ('Tube D110', 50000, 'mm'),
  ('Tube D125', 50000, 'mm');

-- 3) Insert products: each combination piece + diameter is a product
-- We'll insert all products mentioned
INSERT INTO products (name, description) VALUES
  ('Y D63', NULL), ('Y D75', NULL), ('Y D90', NULL), ('Y D110', NULL), ('Y D125', NULL),
  ('Coude 11.25 D63', NULL), ('Coude 11.25 D75', NULL), ('Coude 11.25 D90', NULL), ('Coude 11.25 D110', NULL), ('Coude 11.25 D125', NULL),
  ('Coude 22.5 D63', NULL), ('Coude 22.5 D75', NULL), ('Coude 22.5 D90', NULL), ('Coude 22.5 D110', NULL), ('Coude 22.5 D125', NULL),
  ('Coude 45 D63', NULL), ('Coude 45 D75', NULL), ('Coude 45 D90', NULL), ('Coude 45 D110', NULL), ('Coude 45 D125', NULL),
  ('Coude 90 D63', NULL), ('Coude 90 D75', NULL), ('Coude 90 D90', NULL), ('Coude 90 D110', NULL), ('Coude 90 D125', NULL),
  ('Te egal D63', NULL), ('Te egal D75', NULL), ('Te egal D90', NULL), ('Te egal D110', NULL), ('Te egal D125', NULL),
  ('Croix D63', NULL), ('Croix D75', NULL), ('Croix D90', NULL), ('Croix D110', NULL), ('Croix D125', NULL);

-- 4) Insert BOM entries linking product -> tube by diameter with quantities Q (mm)
-- For each product we use inventory item with matching diameter (Tube Dxx)

-- Y
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
VALUES
  ((SELECT id FROM products WHERE name='Y D63'),  (SELECT id FROM inventory WHERE name='Tube D63'), 833, 'mm'),
  ((SELECT id FROM products WHERE name='Y D75'),  (SELECT id FROM inventory WHERE name='Tube D75'), 836, 'mm'),
  ((SELECT id FROM products WHERE name='Y D90'),  (SELECT id FROM inventory WHERE name='Tube D90'), 839, 'mm'),
  ((SELECT id FROM products WHERE name='Y D110'), (SELECT id FROM inventory WHERE name='Tube D110'),943, 'mm'),
  ((SELECT id FROM products WHERE name='Y D125'), (SELECT id FROM inventory WHERE name='Tube D125'),966, 'mm');

-- Coude 11.25
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
VALUES
  ((SELECT id FROM products WHERE name='Coude 11.25 D63'), (SELECT id FROM inventory WHERE name='Tube D63'),206,'mm'),
  ((SELECT id FROM products WHERE name='Coude 11.25 D75'), (SELECT id FROM inventory WHERE name='Tube D75'),208,'mm'),
  ((SELECT id FROM products WHERE name='Coude 11.25 D90'), (SELECT id FROM inventory WHERE name='Tube D90'),249,'mm'),
  ((SELECT id FROM products WHERE name='Coude 11.25 D110'),(SELECT id FROM inventory WHERE name='Tube D110'),251,'mm'),
  ((SELECT id FROM products WHERE name='Coude 11.25 D125'),(SELECT id FROM inventory WHERE name='Tube D125'),293,'mm');

-- Coude 22.5
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
VALUES
  ((SELECT id FROM products WHERE name='Coude 22.5 D63'), (SELECT id FROM inventory WHERE name='Tube D63'),213,'mm'),
  ((SELECT id FROM products WHERE name='Coude 22.5 D75'), (SELECT id FROM inventory WHERE name='Tube D75'),215,'mm'),
  ((SELECT id FROM products WHERE name='Coude 22.5 D90'), (SELECT id FROM inventory WHERE name='Tube D90'),258,'mm'),
  ((SELECT id FROM products WHERE name='Coude 22.5 D110'),(SELECT id FROM inventory WHERE name='Tube D110'),262,'mm'),
  ((SELECT id FROM products WHERE name='Coude 22.5 D125'),(SELECT id FROM inventory WHERE name='Tube D125'),305,'mm');

-- Coude 45
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
VALUES
  ((SELECT id FROM products WHERE name='Coude 45 D63'), (SELECT id FROM inventory WHERE name='Tube D63'),305,'mm'),
  ((SELECT id FROM products WHERE name='Coude 45 D75'), (SELECT id FROM inventory WHERE name='Tube D75'),310,'mm'),
  ((SELECT id FROM products WHERE name='Coude 45 D90'), (SELECT id FROM inventory WHERE name='Tube D90'),376,'mm'),
  ((SELECT id FROM products WHERE name='Coude 45 D110'),(SELECT id FROM inventory WHERE name='Tube D110'),384,'mm'),
  ((SELECT id FROM products WHERE name='Coude 45 D125'),(SELECT id FROM inventory WHERE name='Tube D125'),430,'mm');

-- Coude 90
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
VALUES
  ((SELECT id FROM products WHERE name='Coude 90 D63'), (SELECT id FROM inventory WHERE name='Tube D63'),411,'mm'),
  ((SELECT id FROM products WHERE name='Coude 90 D75'), (SELECT id FROM inventory WHERE name='Tube D75'),420,'mm'),
  ((SELECT id FROM products WHERE name='Coude 90 D90'), (SELECT id FROM inventory WHERE name='Tube D90'),512,'mm'),
  ((SELECT id FROM products WHERE name='Coude 90 D110'),(SELECT id FROM inventory WHERE name='Tube D110'),528,'mm'),
  ((SELECT id FROM products WHERE name='Coude 90 D125'),(SELECT id FROM inventory WHERE name='Tube D125'),580,'mm');

-- Te egal
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
VALUES
  ((SELECT id FROM products WHERE name='Te egal D63'), (SELECT id FROM inventory WHERE name='Tube D63'),395,'mm'),
  ((SELECT id FROM products WHERE name='Te egal D75'), (SELECT id FROM inventory WHERE name='Tube D75'),413,'mm'),
  ((SELECT id FROM products WHERE name='Te egal D90'), (SELECT id FROM inventory WHERE name='Tube D90'),465,'mm'),
  ((SELECT id FROM products WHERE name='Te egal D110'),(SELECT id FROM inventory WHERE name='Tube D110'),585,'mm'),
  ((SELECT id FROM products WHERE name='Te egal D125'),(SELECT id FROM inventory WHERE name='Tube D125'),638,'mm');

-- Croix
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
VALUES
  ((SELECT id FROM products WHERE name='Croix D63'), (SELECT id FROM inventory WHERE name='Tube D63'),526,'mm'),
  ((SELECT id FROM products WHERE name='Croix D75'), (SELECT id FROM inventory WHERE name='Tube D75'),550,'mm'),
  ((SELECT id FROM products WHERE name='Croix D90'), (SELECT id FROM inventory WHERE name='Tube D90'),620,'mm'),
  ((SELECT id FROM products WHERE name='Croix D110'),(SELECT id FROM inventory WHERE name='Tube D110'),780,'mm'),
  ((SELECT id FROM products WHERE name='Croix D125'),(SELECT id FROM inventory WHERE name='Tube D125'),850,'mm');

COMMIT;

-- End of script
