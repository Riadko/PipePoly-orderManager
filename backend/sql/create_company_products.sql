-- Create a separate table for company products (images and PDFs stored as file paths)
CREATE TABLE IF NOT EXISTS company_products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  image_path VARCHAR(1024),
  drawing_path VARCHAR(1024),
  specsheet_path VARCHAR(1024),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_company_products_name ON company_products(name);
