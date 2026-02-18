-- Migration: drop name column from clients table
ALTER TABLE clients DROP COLUMN IF EXISTS name;
-- It's safe to run even if column doesn't exist.
