-- Create a separate table for company catalog products (images and PDF stored on disk, paths in table)
CREATE TABLE IF NOT EXISTS catalog_products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  image_path VARCHAR(1024),
  drawing_path VARCHAR(1024),
  spec_path VARCHAR(1024),
  created_at TIMESTAMP DEFAULT NOW()
);
