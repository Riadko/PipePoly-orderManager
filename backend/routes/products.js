const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const multer = require('multer');
const { authRequired, requirePermissions } = require('../middleware/auth');
const path = require('path');
const fs = require('fs');

// Ensure upload dir exists
const uploadDir = path.join(__dirname, '..', 'public', 'uploads');
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname);
    const base = path.basename(file.originalname, ext).replace(/[^a-z0-9_-]/gi, '_');
    cb(null, `${Date.now()}_${base}${ext}`);
  }
});

const upload = multer({ storage });

// GET /products - list all products
router.get('/', authRequired, requirePermissions(['products.read']), async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM products ORDER BY id DESC');
    res.json(rows);
  } catch (err) {
    console.error('Error fetching products:', err);
    res.status(500).json({ error: err.message });
  }
});

// POST /products - multipart form: fields name, description, files: image, drawing, spec
router.post('/', authRequired, requirePermissions(['products.create']), upload.fields([
  { name: 'image', maxCount: 1 },
  { name: 'drawing', maxCount: 1 },
  { name: 'spec', maxCount: 1 }
]), async (req, res) => {
  try {
    const { name, description } = req.body;
    if (!name) return res.status(400).json({ error: 'Product name required' });

    const image = req.files?.image?.[0];
    const drawing = req.files?.drawing?.[0];
    const spec = req.files?.spec?.[0];

    const imagePath = image ? `/public/uploads/${image.filename}` : null;
    const drawingPath = drawing ? `/public/uploads/${drawing.filename}` : null;
    const specPath = spec ? `/public/uploads/${spec.filename}` : null;

    const result = await pool.query(
      'INSERT INTO products (name, description, image_path, drawing_path, spec_path) VALUES ($1,$2,$3,$4,$5) RETURNING *',
      [name, description || null, imagePath, drawingPath, specPath]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error creating product:', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
