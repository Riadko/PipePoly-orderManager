-- Simplified inventory schema: remove inventory_segments and use inventory.total_quantity only

-- If a foreign key constraint exists in stock_movements referencing inventory_segments, try to drop it.
ALTER TABLE IF EXISTS stock_movements DROP CONSTRAINT IF EXISTS stock_movements_segment_id_fkey;

-- If the constraint name was different or other objects depend on inventory_segments,
-- use DROP ... CASCADE to remove those dependent constraints (this will not drop tables that reference it,
-- it will only remove the dependency entries).
DROP TABLE IF EXISTS inventory_segments CASCADE;

-- Create inventory table (if not exists) - simplified
CREATE TABLE IF NOT EXISTS inventory (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    total_quantity NUMERIC NOT NULL,
    unit VARCHAR(50) NOT NULL
);

-- Ensure additional columns exist and defaults are set for compatibility
ALTER TABLE IF EXISTS inventory ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE IF EXISTS inventory ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT NOW();
ALTER TABLE IF EXISTS inventory ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- Ensure total_quantity has a sensible default
ALTER TABLE IF EXISTS inventory ALTER COLUMN total_quantity SET DEFAULT 0;

-- Ensure unit column has default 'mm' and existing rows set to 'mm' if empty
ALTER TABLE IF EXISTS inventory ALTER COLUMN unit SET DEFAULT 'mm';
UPDATE inventory SET unit = 'mm' WHERE unit IS NULL OR unit = '';
-- Optionally enforce NOT NULL (skip if you prefer to keep nullable during migration)
-- ALTER TABLE IF EXISTS inventory ALTER COLUMN unit SET NOT NULL;

-- stock_movements (keep for traceability)
CREATE TABLE IF NOT EXISTS stock_movements (
    id SERIAL PRIMARY KEY,
    inventory_id INTEGER REFERENCES inventory(id) ON DELETE SET NULL,
    segment_id INTEGER, -- deprecated / reserved
    order_id INTEGER,
    movement_type TEXT,
    quantity NUMERIC,
    unit TEXT,
    reason TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
