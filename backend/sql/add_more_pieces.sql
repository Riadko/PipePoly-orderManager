-- Add many new pieces, their BOM and inventory tube entries
-- Inserts only if not exist to avoid duplicates

-- Inventory: ensure tubes for all diameters exist (quantities set arbitrarily in mm)
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D63', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D63');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D75', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D75');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D90', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D90');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D110', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D110');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D125', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D125');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D160', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D160');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D200', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D200');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D250', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D250');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D315', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D315');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D400', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D400');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D500', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D500');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D630', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D630');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D710', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D710');
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D800', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D800');

-- Helper function: insert product if not exists
-- We'll use conditional INSERTs for each product and then insert BOM entries linking to tube

-- Y
INSERT INTO products (name, description)
SELECT 'Y D63', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D63');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 833, 'mm' FROM (SELECT id FROM products WHERE name='Y D63') p, (SELECT id FROM inventory WHERE name='Tube D63') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 833);

INSERT INTO products (name, description)
SELECT 'Y D75', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D75');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 836, 'mm' FROM (SELECT id FROM products WHERE name='Y D75') p, (SELECT id FROM inventory WHERE name='Tube D75') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 836);

INSERT INTO products (name, description)
SELECT 'Y D90', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D90');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 839, 'mm' FROM (SELECT id FROM products WHERE name='Y D90') p, (SELECT id FROM inventory WHERE name='Tube D90') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 839);

INSERT INTO products (name, description)
SELECT 'Y D110', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D110');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 943, 'mm' FROM (SELECT id FROM products WHERE name='Y D110') p, (SELECT id FROM inventory WHERE name='Tube D110') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 943);

INSERT INTO products (name, description)
SELECT 'Y D125', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D125');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 966, 'mm' FROM (SELECT id FROM products WHERE name='Y D125') p, (SELECT id FROM inventory WHERE name='Tube D125') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 966);

INSERT INTO products (name, description)
SELECT 'Y D160', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D160');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1083, 'mm' FROM (SELECT id FROM products WHERE name='Y D160') p, (SELECT id FROM inventory WHERE name='Tube D160') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1083);

INSERT INTO products (name, description)
SELECT 'Y D200', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D200');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1521, 'mm' FROM (SELECT id FROM products WHERE name='Y D200') p, (SELECT id FROM inventory WHERE name='Tube D200') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1521);

INSERT INTO products (name, description)
SELECT 'Y D250', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D250');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1872, 'mm' FROM (SELECT id FROM products WHERE name='Y D250') p, (SELECT id FROM inventory WHERE name='Tube D250') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1872);

INSERT INTO products (name, description)
SELECT 'Y D315', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D315');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2015, 'mm' FROM (SELECT id FROM products WHERE name='Y D315') p, (SELECT id FROM inventory WHERE name='Tube D315') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2015);

INSERT INTO products (name, description)
SELECT 'Y D400', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D400');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2463, 'mm' FROM (SELECT id FROM products WHERE name='Y D400') p, (SELECT id FROM inventory WHERE name='Tube D400') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2463);

INSERT INTO products (name, description)
SELECT 'Y D500', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D500');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2824, 'mm' FROM (SELECT id FROM products WHERE name='Y D500') p, (SELECT id FROM inventory WHERE name='Tube D500') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2824);

INSERT INTO products (name, description)
SELECT 'Y D630', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Y D630');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 3300, 'mm' FROM (SELECT id FROM products WHERE name='Y D630') p, (SELECT id FROM inventory WHERE name='Tube D630') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 3300);

-- Coude 11.25
INSERT INTO products (name, description)
SELECT 'Coude 11.25 D63', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D63');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 206, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D63') p, (SELECT id FROM inventory WHERE name='Tube D63') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 206);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D75', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D75');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 208, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D75') p, (SELECT id FROM inventory WHERE name='Tube D75') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 208);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D90', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D90');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 249, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D90') p, (SELECT id FROM inventory WHERE name='Tube D90') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 249);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D110', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D110');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 251, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D110') p, (SELECT id FROM inventory WHERE name='Tube D110') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 251);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D125', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D125');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 293, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D125') p, (SELECT id FROM inventory WHERE name='Tube D125') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 293);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D160', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D160');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 316, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D160') p, (SELECT id FROM inventory WHERE name='Tube D160') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 316);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D200', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D200');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 380, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D200') p, (SELECT id FROM inventory WHERE name='Tube D200') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 380);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D250', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D250');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 465, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D250') p, (SELECT id FROM inventory WHERE name='Tube D250') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 465);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D315', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D315');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 532, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D315') p, (SELECT id FROM inventory WHERE name='Tube D315') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 532);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D400', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D400');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D400') p, (SELECT id FROM inventory WHERE name='Tube D400') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 600);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D500', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D500');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 690, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D500') p, (SELECT id FROM inventory WHERE name='Tube D500') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 690);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D630', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D630');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 803, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D630') p, (SELECT id FROM inventory WHERE name='Tube D630') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 803);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D710', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D710');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 911, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D710') p, (SELECT id FROM inventory WHERE name='Tube D710') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 911);

INSERT INTO products (name, description)
SELECT 'Coude 11.25 D800', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 11.25 D800');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 981, 'mm' FROM (SELECT id FROM products WHERE name='Coude 11.25 D800') p, (SELECT id FROM inventory WHERE name='Tube D800') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 981);

-- Coude 22.5
INSERT INTO products (name, description)
SELECT 'Coude 22.5 D63', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D63');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 213, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D63') p, (SELECT id FROM inventory WHERE name='Tube D63') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 213);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D75', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D75');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 215, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D75') p, (SELECT id FROM inventory WHERE name='Tube D75') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 215);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D90', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D90');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 258, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D90') p, (SELECT id FROM inventory WHERE name='Tube D90') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 258);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D110', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D110');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 262, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D110') p, (SELECT id FROM inventory WHERE name='Tube D110') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 262);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D125', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D125');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 305, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D125') p, (SELECT id FROM inventory WHERE name='Tube D125') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 305);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D160', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D160');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 332, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D160') p, (SELECT id FROM inventory WHERE name='Tube D160') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 332);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D200', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D200');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 400, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D200') p, (SELECT id FROM inventory WHERE name='Tube D200') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 400);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D250', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D250');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 490, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D250') p, (SELECT id FROM inventory WHERE name='Tube D250') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 490);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D315', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D315');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 563, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D315') p, (SELECT id FROM inventory WHERE name='Tube D315') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 563);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D400', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D400');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 640, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D400') p, (SELECT id FROM inventory WHERE name='Tube D400') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 640);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D500', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D500');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 739, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D500') p, (SELECT id FROM inventory WHERE name='Tube D500') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 739);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D630', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D630');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 865, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D630') p, (SELECT id FROM inventory WHERE name='Tube D630') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 865);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D710', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D710');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 981, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D710') p, (SELECT id FROM inventory WHERE name='Tube D710') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 981);

INSERT INTO products (name, description)
SELECT 'Coude 22.5 D800', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 22.5 D800');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1059, 'mm' FROM (SELECT id FROM products WHERE name='Coude 22.5 D800') p, (SELECT id FROM inventory WHERE name='Tube D800') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1059);

-- Coude 45
INSERT INTO products (name, description)
SELECT 'Coude 45 D63', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D63');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 305, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D63') p, (SELECT id FROM inventory WHERE name='Tube D63') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 305);

INSERT INTO products (name, description)
SELECT 'Coude 45 D75', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D75');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 310, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D75') p, (SELECT id FROM inventory WHERE name='Tube D75') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 310);

INSERT INTO products (name, description)
SELECT 'Coude 45 D90', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D90');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 376, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D90') p, (SELECT id FROM inventory WHERE name='Tube D90') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 376);

INSERT INTO products (name, description)
SELECT 'Coude 45 D110', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D110');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 384, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D110') p, (SELECT id FROM inventory WHERE name='Tube D110') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 384);

INSERT INTO products (name, description)
SELECT 'Coude 45 D125', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D125');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 430, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D125') p, (SELECT id FROM inventory WHERE name='Tube D125') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 430);

INSERT INTO products (name, description)
SELECT 'Coude 45 D160', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D160');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 484, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D160') p, (SELECT id FROM inventory WHERE name='Tube D160') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 484);

INSERT INTO products (name, description)
SELECT 'Coude 45 D200', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D200');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 560, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D200') p, (SELECT id FROM inventory WHERE name='Tube D200') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 560);

INSERT INTO products (name, description)
SELECT 'Coude 45 D250', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D250');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 689, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D250') p, (SELECT id FROM inventory WHERE name='Tube D250') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 689);

INSERT INTO products (name, description)
SELECT 'Coude 45 D315', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D315');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 775, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D315') p, (SELECT id FROM inventory WHERE name='Tube D315') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 775);

INSERT INTO products (name, description)
SELECT 'Coude 45 D400', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D400');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 899, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D400') p, (SELECT id FROM inventory WHERE name='Tube D400') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 899);

INSERT INTO products (name, description)
SELECT 'Coude 45 D500', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D500');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1139, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D500') p, (SELECT id FROM inventory WHERE name='Tube D500') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1139);

INSERT INTO products (name, description)
SELECT 'Coude 45 D630', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D630');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1311, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D630') p, (SELECT id FROM inventory WHERE name='Tube D630') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1311);

INSERT INTO products (name, description)
SELECT 'Coude 45 D710', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D710');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1532, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D710') p, (SELECT id FROM inventory WHERE name='Tube D710') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1532);

INSERT INTO products (name, description)
SELECT 'Coude 45 D800', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 45 D800');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1568, 'mm' FROM (SELECT id FROM products WHERE name='Coude 45 D800') p, (SELECT id FROM inventory WHERE name='Tube D800') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1568);

-- Coude 90
INSERT INTO products (name, description)
SELECT 'Coude 90 D63', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D63');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 411, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D63') p, (SELECT id FROM inventory WHERE name='Tube D63') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 411);

INSERT INTO products (name, description)
SELECT 'Coude 90 D75', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D75');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 420, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D75') p, (SELECT id FROM inventory WHERE name='Tube D75') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 420);

INSERT INTO products (name, description)
SELECT 'Coude 90 D90', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D90');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 512, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D90') p, (SELECT id FROM inventory WHERE name='Tube D90') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 512);

INSERT INTO products (name, description)
SELECT 'Coude 90 D110', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D110');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 528, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D110') p, (SELECT id FROM inventory WHERE name='Tube D110') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 528);

INSERT INTO products (name, description)
SELECT 'Coude 90 D125', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D125');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 580, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D125') p, (SELECT id FROM inventory WHERE name='Tube D125') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 580);

INSERT INTO products (name, description)
SELECT 'Coude 90 D160', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D160');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 669, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D160') p, (SELECT id FROM inventory WHERE name='Tube D160') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 669);

INSERT INTO products (name, description)
SELECT 'Coude 90 D200', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D200');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 761, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D200') p, (SELECT id FROM inventory WHERE name='Tube D200') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 761);

INSERT INTO products (name, description)
SELECT 'Coude 90 D250', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D250');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 941, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D250') p, (SELECT id FROM inventory WHERE name='Tube D250') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 941);

INSERT INTO products (name, description)
SELECT 'Coude 90 D315', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D315');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1053, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D315') p, (SELECT id FROM inventory WHERE name='Tube D315') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1053);

INSERT INTO products (name, description)
SELECT 'Coude 90 D400', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D400');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1242, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D400') p, (SELECT id FROM inventory WHERE name='Tube D400') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1242);

INSERT INTO products (name, description)
SELECT 'Coude 90 D500', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D500');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1642, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D500') p, (SELECT id FROM inventory WHERE name='Tube D500') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1642);

INSERT INTO products (name, description)
SELECT 'Coude 90 D630', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D630');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1886, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D630') p, (SELECT id FROM inventory WHERE name='Tube D630') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1886);

INSERT INTO products (name, description)
SELECT 'Coude 90 D710', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D710');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2111, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D710') p, (SELECT id FROM inventory WHERE name='Tube D710') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2111);

INSERT INTO products (name, description)
SELECT 'Coude 90 D800', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Coude 90 D800');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2183, 'mm' FROM (SELECT id FROM products WHERE name='Coude 90 D800') p, (SELECT id FROM inventory WHERE name='Tube D800') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2183);

-- Te egal
INSERT INTO products (name, description)
SELECT 'Te egal D63', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D63');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 395, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D63') p, (SELECT id FROM inventory WHERE name='Tube D63') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 395);

INSERT INTO products (name, description)
SELECT 'Te egal D75', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D75');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 413, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D75') p, (SELECT id FROM inventory WHERE name='Tube D75') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 413);

INSERT INTO products (name, description)
SELECT 'Te egal D90', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D90');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 465, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D90') p, (SELECT id FROM inventory WHERE name='Tube D90') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 465);

INSERT INTO products (name, description)
SELECT 'Te egal D110', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D110');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 585, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D110') p, (SELECT id FROM inventory WHERE name='Tube D110') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 585);

INSERT INTO products (name, description)
SELECT 'Te egal D125', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D125');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 638, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D125') p, (SELECT id FROM inventory WHERE name='Tube D125') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 638);

INSERT INTO products (name, description)
SELECT 'Te egal D160', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D160');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 780, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D160') p, (SELECT id FROM inventory WHERE name='Tube D160') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 780);

INSERT INTO products (name, description)
SELECT 'Te egal D200', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D200');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 900, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D200') p, (SELECT id FROM inventory WHERE name='Tube D200') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 900);

INSERT INTO products (name, description)
SELECT 'Te egal D250', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D250');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1065, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D250') p, (SELECT id FROM inventory WHERE name='Tube D250') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1065);

INSERT INTO products (name, description)
SELECT 'Te egal D315', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D315');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1223, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D315') p, (SELECT id FROM inventory WHERE name='Tube D315') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1223);

INSERT INTO products (name, description)
SELECT 'Te egal D400', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D400');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1440, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D400') p, (SELECT id FROM inventory WHERE name='Tube D400') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1440);

INSERT INTO products (name, description)
SELECT 'Te egal D500', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D500');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1710, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D500') p, (SELECT id FROM inventory WHERE name='Tube D500') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1710);

INSERT INTO products (name, description)
SELECT 'Te egal D630', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D630');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2055, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D630') p, (SELECT id FROM inventory WHERE name='Tube D630') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2055);

INSERT INTO products (name, description)
SELECT 'Te egal D710', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D710');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2625, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D710') p, (SELECT id FROM inventory WHERE name='Tube D710') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2625);

INSERT INTO products (name, description)
SELECT 'Te egal D800', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Te egal D800');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2760, 'mm' FROM (SELECT id FROM products WHERE name='Te egal D800') p, (SELECT id FROM inventory WHERE name='Tube D800') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2760);

-- croix
INSERT INTO products (name, description)
SELECT 'Croix D63', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D63');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 526, 'mm' FROM (SELECT id FROM products WHERE name='Croix D63') p, (SELECT id FROM inventory WHERE name='Tube D63') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 526);

INSERT INTO products (name, description)
SELECT 'Croix D75', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D75');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 550, 'mm' FROM (SELECT id FROM products WHERE name='Croix D75') p, (SELECT id FROM inventory WHERE name='Tube D75') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 550);

INSERT INTO products (name, description)
SELECT 'Croix D90', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D90');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 620, 'mm' FROM (SELECT id FROM products WHERE name='Croix D90') p, (SELECT id FROM inventory WHERE name='Tube D90') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 620);

INSERT INTO products (name, description)
SELECT 'Croix D110', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D110');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 780, 'mm' FROM (SELECT id FROM products WHERE name='Croix D110') p, (SELECT id FROM inventory WHERE name='Tube D110') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 780);

INSERT INTO products (name, description)
SELECT 'Croix D125', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D125');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 850, 'mm' FROM (SELECT id FROM products WHERE name='Croix D125') p, (SELECT id FROM inventory WHERE name='Tube D125') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 850);

INSERT INTO products (name, description)
SELECT 'Croix D160', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D160');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1040, 'mm' FROM (SELECT id FROM products WHERE name='Croix D160') p, (SELECT id FROM inventory WHERE name='Tube D160') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1040);

INSERT INTO products (name, description)
SELECT 'Croix D200', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D200');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1200, 'mm' FROM (SELECT id FROM products WHERE name='Croix D200') p, (SELECT id FROM inventory WHERE name='Tube D200') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1200);

INSERT INTO products (name, description)
SELECT 'Croix D250', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D250');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1420, 'mm' FROM (SELECT id FROM products WHERE name='Croix D250') p, (SELECT id FROM inventory WHERE name='Tube D250') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1420);

INSERT INTO products (name, description)
SELECT 'Croix D315', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D315');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1630, 'mm' FROM (SELECT id FROM products WHERE name='Croix D315') p, (SELECT id FROM inventory WHERE name='Tube D315') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1630);

INSERT INTO products (name, description)
SELECT 'Croix D400', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D400');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1920, 'mm' FROM (SELECT id FROM products WHERE name='Croix D400') p, (SELECT id FROM inventory WHERE name='Tube D400') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 1920);

INSERT INTO products (name, description)
SELECT 'Croix D500', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D500');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2280, 'mm' FROM (SELECT id FROM products WHERE name='Croix D500') p, (SELECT id FROM inventory WHERE name='Tube D500') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2280);

INSERT INTO products (name, description)
SELECT 'Croix D630', NULL WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Croix D630');
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 2740, 'mm' FROM (SELECT id FROM products WHERE name='Croix D630') p, (SELECT id FROM inventory WHERE name='Tube D630') i
WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id AND quantity = 2740);

-- end of inserts

-- (continued below for remaining items)
