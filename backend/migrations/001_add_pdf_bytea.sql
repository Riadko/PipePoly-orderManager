-- Migration: add PDF storage columns to orders table
ALTER TABLE orders ADD COLUMN IF NOT EXISTS pdf_data BYTEA;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS pdf_filename TEXT;
-- Optional: keep pdf_path for backwards compatibility
ALTER TABLE orders ADD COLUMN IF NOT EXISTS pdf_path TEXT;
