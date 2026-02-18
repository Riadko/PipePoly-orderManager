-- Migration: add binary fields for catalog_products
ALTER TABLE catalog_products ADD COLUMN IF NOT EXISTS image_filename TEXT;
ALTER TABLE catalog_products ADD COLUMN IF NOT EXISTS image_data BYTEA;
ALTER TABLE catalog_products ADD COLUMN IF NOT EXISTS drawing_filename TEXT;
ALTER TABLE catalog_products ADD COLUMN IF NOT EXISTS drawing_data BYTEA;
ALTER TABLE catalog_products ADD COLUMN IF NOT EXISTS spec_filename TEXT;
ALTER TABLE catalog_products ADD COLUMN IF NOT EXISTS spec_data BYTEA;
