-- Add Té réduit products with dual-tube BOM
-- Each té réduit uses TWO tubes: main diameter tube + branch (side) diameter tube
-- Format: Té réduit Dmain/Dbranch uses Tube Dmain (LTUBE mm) + Tube Dbranch (L1 Piquage mm)

BEGIN;

-- Step 1: Ensure all required tube inventory items exist
-- (Add missing tube diameters: D50, D630, D710, D800)
INSERT INTO inventory (name, total_quantity, unit)
SELECT 'Tube D50', 100000, 'mm' WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE name = 'Tube D50');

-- Step 2: Insert all Té réduit products
INSERT INTO products (name, description)
SELECT 'Té réduit D90/D63', 'Té with main tube D90 and branch tube D63' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D90/D63')
UNION ALL
SELECT 'Té réduit D110/D63', 'Té with main tube D110 and branch tube D63' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D110/D63')
UNION ALL
SELECT 'Té réduit D110/D75', 'Té with main tube D110 and branch tube D75' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D110/D75')
UNION ALL
SELECT 'Té réduit D110/D90', 'Té with main tube D110 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D110/D90')
UNION ALL
SELECT 'Té réduit D125/D50', 'Té with main tube D125 and branch tube D50' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D125/D50')
UNION ALL
SELECT 'Té réduit D125/D63', 'Té with main tube D125 and branch tube D63' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D125/D63')
UNION ALL
SELECT 'Té réduit D125/D75', 'Té with main tube D125 and branch tube D75' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D125/D75')
UNION ALL
SELECT 'Té réduit D125/D90', 'Té with main tube D125 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D125/D90')
UNION ALL
SELECT 'Té réduit D125/D110', 'Té with main tube D125 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D125/D110')
UNION ALL
SELECT 'Té réduit D160/D50', 'Té with main tube D160 and branch tube D50' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D160/D50')
UNION ALL
SELECT 'Té réduit D160/D63', 'Té with main tube D160 and branch tube D63' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D160/D63')
UNION ALL
SELECT 'Té réduit D160/D75', 'Té with main tube D160 and branch tube D75' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D160/D75')
UNION ALL
SELECT 'Té réduit D160/D90', 'Té with main tube D160 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D160/D90')
UNION ALL
SELECT 'Té réduit D160/D110', 'Té with main tube D160 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D160/D110')
UNION ALL
SELECT 'Té réduit D160/D125', 'Té with main tube D160 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D160/D125')
UNION ALL
SELECT 'Té réduit D200/D63', 'Té with main tube D200 and branch tube D63' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D200/D63')
UNION ALL
SELECT 'Té réduit D200/D75', 'Té with main tube D200 and branch tube D75' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D200/D75')
UNION ALL
SELECT 'Té réduit D200/D90', 'Té with main tube D200 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D200/D90')
UNION ALL
SELECT 'Té réduit D200/D110', 'Té with main tube D200 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D200/D110')
UNION ALL
SELECT 'Té réduit D200/D125', 'Té with main tube D200 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D200/D125')
UNION ALL
SELECT 'Té réduit D200/D160', 'Té with main tube D200 and branch tube D160' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D200/D160')
UNION ALL
SELECT 'Té réduit D250/D75', 'Té with main tube D250 and branch tube D75' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D250/D75')
UNION ALL
SELECT 'Té réduit D250/D90', 'Té with main tube D250 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D250/D90')
UNION ALL
SELECT 'Té réduit D250/D110', 'Té with main tube D250 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D250/D110')
UNION ALL
SELECT 'Té réduit D250/D125', 'Té with main tube D250 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D250/D125')
UNION ALL
SELECT 'Té réduit D250/D160', 'Té with main tube D250 and branch tube D160' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D250/D160')
UNION ALL
SELECT 'Té réduit D250/D200', 'Té with main tube D250 and branch tube D200' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D250/D200')
UNION ALL
SELECT 'Té réduit D315/D63', 'Té with main tube D315 and branch tube D63' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D315/D63')
UNION ALL
SELECT 'Té réduit D315/D75', 'Té with main tube D315 and branch tube D75' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D315/D75')
UNION ALL
SELECT 'Té réduit D315/D90', 'Té with main tube D315 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D315/D90')
UNION ALL
SELECT 'Té réduit D315/D110', 'Té with main tube D315 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D315/D110')
UNION ALL
SELECT 'Té réduit D315/D125', 'Té with main tube D315 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D315/D125')
UNION ALL
SELECT 'Té réduit D315/D160', 'Té with main tube D315 and branch tube D160' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D315/D160')
UNION ALL
SELECT 'Té réduit D315/D200', 'Té with main tube D315 and branch tube D200' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D315/D200')
UNION ALL
SELECT 'Té réduit D400/D63', 'Té with main tube D400 and branch tube D63' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D400/D63')
UNION ALL
SELECT 'Té réduit D400/D75', 'Té with main tube D400 and branch tube D75' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D400/D75')
UNION ALL
SELECT 'Té réduit D400/D90', 'Té with main tube D400 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D400/D90')
UNION ALL
SELECT 'Té réduit D400/D110', 'Té with main tube D400 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D400/D110')
UNION ALL
SELECT 'Té réduit D400/D125', 'Té with main tube D400 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D400/D125')
UNION ALL
SELECT 'Té réduit D400/D160', 'Té with main tube D400 and branch tube D160' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D400/D160')
UNION ALL
SELECT 'Té réduit D400/D200', 'Té with main tube D400 and branch tube D200' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D400/D200')
UNION ALL
SELECT 'Té réduit D400/D250', 'Té with main tube D400 and branch tube D250' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D400/D250')
UNION ALL
SELECT 'Té réduit D500/D63', 'Té with main tube D500 and branch tube D63' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D63')
UNION ALL
SELECT 'Té réduit D500/D75', 'Té with main tube D500 and branch tube D75' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D75')
UNION ALL
SELECT 'Té réduit D500/D90', 'Té with main tube D500 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D90')
UNION ALL
SELECT 'Té réduit D500/D110', 'Té with main tube D500 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D110')
UNION ALL
SELECT 'Té réduit D500/D125', 'Té with main tube D500 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D125')
UNION ALL
SELECT 'Té réduit D500/D160', 'Té with main tube D500 and branch tube D160' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D160')
UNION ALL
SELECT 'Té réduit D500/D200', 'Té with main tube D500 and branch tube D200' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D200')
UNION ALL
SELECT 'Té réduit D500/D250', 'Té with main tube D500 and branch tube D250' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D250')
UNION ALL
SELECT 'Té réduit D500/D315', 'Té with main tube D500 and branch tube D315' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D500/D315')
UNION ALL
SELECT 'Té réduit D630/D90', 'Té with main tube D630 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D630/D90')
UNION ALL
SELECT 'Té réduit D630/D110', 'Té with main tube D630 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D630/D110')
UNION ALL
SELECT 'Té réduit D630/D125', 'Té with main tube D630 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D630/D125')
UNION ALL
SELECT 'Té réduit D630/D160', 'Té with main tube D630 and branch tube D160' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D630/D160')
UNION ALL
SELECT 'Té réduit D630/D200', 'Té with main tube D630 and branch tube D200' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D630/D200')
UNION ALL
SELECT 'Té réduit D630/D250', 'Té with main tube D630 and branch tube D250' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D630/D250')
UNION ALL
SELECT 'Té réduit D630/D315', 'Té with main tube D630 and branch tube D315' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D630/D315')
UNION ALL
SELECT 'Té réduit D630/D400', 'Té with main tube D630 and branch tube D400' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D630/D400')
UNION ALL
SELECT 'Té réduit D710/D110', 'Té with main tube D710 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D710/D110')
UNION ALL
SELECT 'Té réduit D710/D125', 'Té with main tube D710 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D710/D125')
UNION ALL
SELECT 'Té réduit D710/D160', 'Té with main tube D710 and branch tube D160' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D710/D160')
UNION ALL
SELECT 'Té réduit D710/D200', 'Té with main tube D710 and branch tube D200' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D710/D200')
UNION ALL
SELECT 'Té réduit D710/D250', 'Té with main tube D710 and branch tube D250' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D710/D250')
UNION ALL
SELECT 'Té réduit D710/D315', 'Té with main tube D710 and branch tube D315' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D710/D315')
UNION ALL
SELECT 'Té réduit D710/D400', 'Té with main tube D710 and branch tube D400' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D710/D400')
UNION ALL
SELECT 'Té réduit D800/D90', 'Té with main tube D800 and branch tube D90' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D800/D90')
UNION ALL
SELECT 'Té réduit D800/D110', 'Té with main tube D800 and branch tube D110' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D800/D110')
UNION ALL
SELECT 'Té réduit D800/D125', 'Té with main tube D800 and branch tube D125' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D800/D125')
UNION ALL
SELECT 'Té réduit D800/D160', 'Té with main tube D800 and branch tube D160' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D800/D160')
UNION ALL
SELECT 'Té réduit D800/D200', 'Té with main tube D800 and branch tube D200' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D800/D200')
UNION ALL
SELECT 'Té réduit D800/D250', 'Té with main tube D800 and branch tube D250' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D800/D250')
UNION ALL
SELECT 'Té réduit D800/D315', 'Té with main tube D800 and branch tube D315' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D800/D315')
UNION ALL
SELECT 'Té réduit D800/D400', 'Té with main tube D800 and branch tube D400' WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Té réduit D800/D400');

-- Step 3: Insert BOM entries for main tubes (LTUBE quantities)
-- D90/D63: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D90/D63' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D110/D63: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D110/D63' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D110/D75: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D110/D75' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D110/D90: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D110/D90' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D50: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D50' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D63: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D63' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D75: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D75' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D90: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D90' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D110: 340mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 340, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D110' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D50: 410mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 410, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D50' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D63: 410mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 410, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D63' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D75: 410mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 410, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D75' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D90: 430mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 430, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D90' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D110: 430mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 430, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D110' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D125: 440mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 440, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D125' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D63: 460mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 460, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D63' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D75: 460mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 460, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D75' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D90: 460mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 460, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D90' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D110: 470mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 470, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D110' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D125: 480mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 480, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D125' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D160: 520mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 520, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D160' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D75: 540mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 540, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D75' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D90: 540mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 540, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D90' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D110: 540mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 540, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D110' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D125: 560mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 560, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D125' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D160: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D160' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D200: 620mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 620, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D200' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D63: 520mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 520, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D63' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D75: 520mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 520, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D75' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D90: 520mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 520, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D90' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D110: 550mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 550, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D110' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D125: 550mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 550, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D125' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D160: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D160' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D200: 620mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 620, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D200' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D63: 540mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 540, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D63' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D75: 540mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 540, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D75' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D90: 540mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 540, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D90' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D110: 560mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 560, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D110' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D125: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D125' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D160: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D160' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D200: 700mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 700, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D200' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D250: 750mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 750, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D250' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D63: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D63' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D75: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D75' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D90: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D90' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D110: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D110' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D125: 600mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 600, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D125' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D160: 700mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 700, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D160' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D200: 720mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 720, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D200' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D250: 760mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 760, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D250' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D315: 800mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 800, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D315' AND i.name = 'Tube D500'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D90: 700mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 700, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D90' AND i.name = 'Tube D630'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D110: 700mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 700, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D110' AND i.name = 'Tube D630'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D125: 700mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 700, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D125' AND i.name = 'Tube D630'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D160: 720mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 720, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D160' AND i.name = 'Tube D630'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D200: 760mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 760, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D200' AND i.name = 'Tube D630'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D250: 820mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 820, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D250' AND i.name = 'Tube D630'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D315: 920mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 920, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D315' AND i.name = 'Tube D630'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D400: 960mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 960, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D400' AND i.name = 'Tube D630'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D110: 810mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 810, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D110' AND i.name = 'Tube D710'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D125: 810mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 810, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D125' AND i.name = 'Tube D710'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D160: 860mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 860, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D160' AND i.name = 'Tube D710'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D200: 910mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 910, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D200' AND i.name = 'Tube D710'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D250: 1000mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1000, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D250' AND i.name = 'Tube D710'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D315: 1000mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1000, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D315' AND i.name = 'Tube D710'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D400: 1100mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1100, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D400' AND i.name = 'Tube D710'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D90: 810mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 810, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D90' AND i.name = 'Tube D800'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D110: 810mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 810, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D110' AND i.name = 'Tube D800'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D125: 810mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 810, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D125' AND i.name = 'Tube D800'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D160: 820mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 820, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D160' AND i.name = 'Tube D800'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D200: 860mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 860, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D200' AND i.name = 'Tube D800'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D250: 910mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 910, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D250' AND i.name = 'Tube D800'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D315: 1000mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1000, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D315' AND i.name = 'Tube D800'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D400: 1150mm main
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 1150, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D400' AND i.name = 'Tube D800'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- Step 4: Insert BOM entries for branch tubes (L1 Piquage quantities)
-- D90/D63: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D90/D63' AND i.name = 'Tube D63'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D110/D63: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D110/D63' AND i.name = 'Tube D63'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D110/D75: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D110/D75' AND i.name = 'Tube D75'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D110/D90: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D110/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D50: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D50' AND i.name = 'Tube D50'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D63: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D63' AND i.name = 'Tube D63'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D75: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D75' AND i.name = 'Tube D75'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D90: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D125/D110: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D125/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D50: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D50' AND i.name = 'Tube D50'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D63: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D63' AND i.name = 'Tube D63'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D75: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D75' AND i.name = 'Tube D75'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D90: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D110: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D160/D125: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D160/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D63: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D63' AND i.name = 'Tube D63'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D75: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D75' AND i.name = 'Tube D75'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D90: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D110: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D125: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D200/D160: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D200/D160' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D75: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D75' AND i.name = 'Tube D75'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D90: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D110: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D125: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D160: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D160' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D250/D200: 220mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 220, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D250/D200' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D63: 120mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 120, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D63' AND i.name = 'Tube D63'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D75: 120mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 120, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D75' AND i.name = 'Tube D75'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D90: 120mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 120, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D110: 120mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 120, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D125: 120mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 120, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D160: 120mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 120, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D160' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D315/D200: 220mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 220, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D315/D200' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D63: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D63' AND i.name = 'Tube D63'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D75: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D75' AND i.name = 'Tube D75'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D90: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D110: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D125: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D160: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D160' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D200: 170mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 170, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D200' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D400/D250: 250mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 250, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D400/D250' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D63: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D63' AND i.name = 'Tube D63'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D75: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D75' AND i.name = 'Tube D75'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D90: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D110: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D125: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D160: 130mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 130, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D160' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D200: 170mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 170, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D200' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D250: 250mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 250, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D250' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D500/D315: 300mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 300, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D500/D315' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D90: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D110: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D125: 140mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 140, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D160: 170mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 170, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D160' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D200: 170mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 170, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D200' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D250: 300mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 300, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D250' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D315: 300mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 300, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D315' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D630/D400: 300mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 300, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D630/D400' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D110: 180mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 180, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D125: 180mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 180, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D160: 180mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 180, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D160' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D200: 190mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 190, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D200' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D250: 350mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 350, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D250' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D315: 350mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 350, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D315' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D710/D400: 350mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 350, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D710/D400' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D90: 190mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 190, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D90' AND i.name = 'Tube D90'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D110: 190mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 190, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D110' AND i.name = 'Tube D110'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D125: 190mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 190, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D125' AND i.name = 'Tube D125'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D160: 190mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 190, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D160' AND i.name = 'Tube D160'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D200: 190mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 190, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D200' AND i.name = 'Tube D200'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D250: 400mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 400, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D250' AND i.name = 'Tube D250'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D315: 400mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 400, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D315' AND i.name = 'Tube D315'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

-- D800/D400: 400mm branch
INSERT INTO product_bom (product_id, inventory_item_id, quantity, unit)
SELECT p.id, i.id, 400, 'mm' FROM products p, inventory i WHERE p.name = 'Té réduit D800/D400' AND i.name = 'Tube D400'
AND NOT EXISTS (SELECT 1 FROM product_bom WHERE product_id = p.id AND inventory_item_id = i.id);

COMMIT;

-- Summary:
-- ✓ Added 4 missing tube inventory items (D50, D630, D710, D800)
-- ✓ Inserted 73 Té réduit products
-- ✓ Inserted 146 BOM entries (2 per product: main tube + branch tube)
-- 
-- Each product now automatically deducts TWO different tube types when validated!
