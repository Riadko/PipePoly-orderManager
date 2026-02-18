const express = require('express');
const cors = require('cors');
const path = require('path');

const ordersRoutes = require('./routes/orders');
const authRoutes = require('./routes/auth');
// const productsRoutes = require('./routes/products');
const catalogProductsRoutes = require('./routes/catalogProducts');
const clientsRoutes = require('./routes/clients');

require('dotenv').config();

const app = express();

app.set('trust proxy', true);

app.use(cors());
app.use(express.json());

// serve uploaded files from backend/uploads

app.use('/auth', authRoutes);
app.use('/orders', ordersRoutes);
app.use('/catalog', catalogProductsRoutes);
app.use('/clients', clientsRoutes);

// Serve React frontend build
app.use(express.static(path.join(__dirname, '../frontend/build')));

// Catch-all route pour React SPA
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/build', 'index.html'));
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
