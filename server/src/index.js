const express = require('express');
const cors = require('cors');
const auth = require('./middleware/auth');
const errorHandler = require('./middleware/errorHandler');
const seed = require('./db/seed');

// Routes
const productosRouter = require('./routes/productos');
const gastosRouter = require('./routes/gastos');
const personalRouter = require('./routes/personal');
const pagosRouter = require('./routes/pagos');
const cierresRouter = require('./routes/cierres');

const app = express();
const PORT = 8000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(auth);

// Mount routes
app.use('/api/v1/productos', productosRouter);
app.use('/api/v1/gastos', gastosRouter);
app.use('/api/v1/personal', personalRouter);
app.use('/api/v1/pagos', pagosRouter);
app.use('/api/v1/cierres', cierresRouter);

// Error handler (must be last)
app.use(errorHandler);

// Seed database on startup
seed();

app.listen(PORT, () => {
  console.log(`Solo Pastas API corriendo en http://localhost:${PORT}`);
});
