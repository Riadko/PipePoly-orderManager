const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const path = require('path');
const { authRequired, requirePermissions } = require('../middleware/auth');
const multer = require('multer');

// Use memory storage so we can persist files into DB as bytea
const storage = multer.memoryStorage();
const upload = multer({ storage });

// List products
router.get('/', authRequired, requirePermissions(['products.read']), async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM catalog_products ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (err) {
    console.error('Error listing catalog products', err);
    res.status(500).json({ error: err.message });
  }
});

// Create product with optional files; files saved to DB as bytea
router.post('/', authRequired, requirePermissions(['products.create']), upload.fields([
  { name: 'image', maxCount: 1 },
  { name: 'drawing', maxCount: 1 },
  { name: 'spec', maxCount: 1 }
]), async (req, res) => {
  try {
    const { name, description } = req.body;

    const imageFile = req.files?.image?.[0] || null;
    const drawingFile = req.files?.drawing?.[0] || null;
    const specFile = req.files?.spec?.[0] || null;

    const result = await pool.query(
      `INSERT INTO catalog_products
       (name, description, image_filename, image_data, drawing_filename, drawing_data, spec_filename, spec_data)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *`,
      [
        name,
        description,
        imageFile ? imageFile.originalname : null,
        imageFile ? imageFile.buffer : null,
        drawingFile ? drawingFile.originalname : null,
        drawingFile ? drawingFile.buffer : null,
        specFile ? specFile.originalname : null,
        specFile ? specFile.buffer : null,
      ]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating catalog product', err);
    res.status(500).json({ error: err.message });
  }
});

// Update product
router.put('/:id', authRequired, requirePermissions(['products.update']), upload.fields([
  { name: 'image', maxCount: 1 },
  { name: 'drawing', maxCount: 1 },
  { name: 'spec', maxCount: 1 }
]), async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description } = req.body;

    // Get current product to preserve existing files if not updating
    const currentRes = await pool.query('SELECT * FROM catalog_products WHERE id = $1', [id]);
    const current = currentRes.rows[0];
    if (!current) return res.status(404).json({ error: 'Product not found' });

    const imageFile = req.files?.image?.[0] || null;
    const drawingFile = req.files?.drawing?.[0] || null;
    const specFile = req.files?.spec?.[0] || null;

    const result = await pool.query(
      `UPDATE catalog_products SET
        name = $1,
        description = $2,
        image_filename = COALESCE($3, image_filename),
        image_data = COALESCE($4, image_data),
        drawing_filename = COALESCE($5, drawing_filename),
        drawing_data = COALESCE($6, drawing_data),
        spec_filename = COALESCE($7, spec_filename),
        spec_data = COALESCE($8, spec_data)
       WHERE id = $9 RETURNING *`,
      [
        name || current.name,
        description || current.description,
        imageFile ? imageFile.originalname : null,
        imageFile ? imageFile.buffer : null,
        drawingFile ? drawingFile.originalname : null,
        drawingFile ? drawingFile.buffer : null,
        specFile ? specFile.originalname : null,
        specFile ? specFile.buffer : null,
        id
      ]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error('Error updating catalog product', err);
    res.status(500).json({ error: err.message });
  }
});

// File serving endpoints - no auth required for reading product files (they're public once created)
router.get('/:id/image', async (req, res) => {
  try {
    const { id } = req.params;
    const r = await pool.query('SELECT image_filename, image_data FROM catalog_products WHERE id = $1', [id]);
    const row = r.rows[0];
    if (!row || !row.image_data) return res.status(404).json({ error: 'Image not found' });
    const filename = row.image_filename || `product_${id}.bin`;
    const ext = path.extname(filename).toLowerCase();
    const mime = ext === '.png' ? 'image/png' : ext === '.jpg' || ext === '.jpeg' ? 'image/jpeg' : 'application/octet-stream';
    res.setHeader('Content-Type', mime);
    res.setHeader('Content-Disposition', `inline; filename="${filename}"`);
    res.send(row.image_data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

router.get('/:id/drawing', async (req, res) => {
  try {
    const { id } = req.params;
    const r = await pool.query('SELECT drawing_filename, drawing_data FROM catalog_products WHERE id = $1', [id]);
    const row = r.rows[0];
    if (!row || !row.drawing_data) return res.status(404).json({ error: 'Drawing not found' });
    const filename = row.drawing_filename || `product_${id}_drawing.bin`;
    const ext = path.extname(filename).toLowerCase();
    const mime = ext === '.png' ? 'image/png' : ext === '.jpg' || ext === '.jpeg' ? 'image/jpeg' : 'application/octet-stream';
    res.setHeader('Content-Type', mime);
    res.setHeader('Content-Disposition', `inline; filename="${filename}"`);
    res.send(row.drawing_data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

router.get('/:id/spec', async (req, res) => {
  try {
    const { id } = req.params;
    const r = await pool.query('SELECT spec_filename, spec_data FROM catalog_products WHERE id = $1', [id]);
    const row = r.rows[0];
    if (!row || !row.spec_data) return res.status(404).json({ error: 'Spec not found' });
    const filename = row.spec_filename || `product_${id}_spec.pdf`;
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    res.send(row.spec_data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

// Delete a product
router.delete('/:id', authRequired, requirePermissions(['products.delete']), async (req, res) => {
  try {
    const { id } = req.params;
    const r = await pool.query('DELETE FROM catalog_products WHERE id = $1 RETURNING *', [id]);
    if (r.rowCount === 0) return res.status(404).json({ error: 'Product not found' });
    res.json({ success: true });
  } catch (err) {
    console.error('Error deleting catalog product', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
