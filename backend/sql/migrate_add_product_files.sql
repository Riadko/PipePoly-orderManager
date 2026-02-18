-- Migration: add file path columns to products table for images, drawing and spec
BEGIN;

ALTER TABLE IF EXISTS products ADD COLUMN IF NOT EXISTS image_path TEXT;
ALTER TABLE IF EXISTS products ADD COLUMN IF NOT EXISTS drawing_path TEXT;
ALTER TABLE IF EXISTS products ADD COLUMN IF NOT EXISTS spec_path TEXT;

COMMIT;

-- Note: run this migration with psql or your DB tool before using upload endpoints.
