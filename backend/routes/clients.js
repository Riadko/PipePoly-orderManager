const express = require('express');
const router = express.Router();
const Client = require('../models/clientModel');
const { authRequired, requirePermissions } = require('../middleware/auth');

// GET /clients
router.get('/', authRequired, requirePermissions(['clients.read']), async (req, res) => {
  try {
    const clients = await Client.getAll();
    res.json(clients);
  } catch (err) {
    console.error('Error fetching clients', err);
    res.status(500).json({ error: err.message });
  }
});

// GET /clients/:id
router.get('/:id', authRequired, requirePermissions(['clients.read']), async (req, res) => {
  try {
    const client = await Client.getById(req.params.id);
    if (!client) return res.status(404).json({ error: 'Client not found' });
    res.json(client);
  } catch (err) {
    console.error('Error fetching client', err);
    res.status(500).json({ error: err.message });
  }
});

// POST /clients
router.post('/', authRequired, requirePermissions(['clients.create']), async (req, res) => {
  try {
    const created = await Client.create(req.body);
    res.status(201).json(created);
  } catch (err) {
    console.error('Error creating client', err);
    res.status(500).json({ error: err.message });
  }
});

// PUT /clients/:id
router.put('/:id', authRequired, requirePermissions(['clients.update']), async (req, res) => {
  try {
    const updated = await Client.update(req.params.id, req.body);
    res.json(updated);
  } catch (err) {
    console.error('Error updating client', err);
    res.status(500).json({ error: err.message });
  }
});

// DELETE /clients/:id
router.delete('/:id', authRequired, requirePermissions(['clients.delete']), async (req, res) => {
  try {
    await Client.delete(req.params.id);
    res.json({ success: true });
  } catch (err) {
    console.error('Error deleting client', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
