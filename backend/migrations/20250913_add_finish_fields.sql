-- Migration: Add worker, machine and report_photo columns to orders
-- Run with psql or the provided Node migration runner.

ALTER TABLE IF EXISTS orders
  ADD COLUMN IF NOT EXISTS worker text,
  ADD COLUMN IF NOT EXISTS machine text,
  ADD COLUMN IF NOT EXISTS report_photo bytea;

-- optional: create an index on worker/machine if you plan to query them
-- CREATE INDEX IF NOT EXISTS idx_orders_worker ON orders(worker);
-- CREATE INDEX IF NOT EXISTS idx_orders_machine ON orders(machine);
