require('dotenv').config();
const express = require('express');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const auth = require('./middleware/auth');
const errorHandler = require('./middleware/errorHandler');
const seed = require('./db/seed');

// Routes
const gastosRouter = require('./routes/gastos');
const personalRouter = require('./routes/personal');
const pagosRouter = require('./routes/pagos');
const cierresRouter = require('./routes/cierres');

const app = express();
const PORT = process.env.PORT || 8000;

// CORS — restrict to allowed origins
const allowedOrigins = (process.env.ALLOWED_ORIGINS || '')
  .split(',')
  .map(o => o.trim())
  .filter(Boolean);

app.use(cors({
  origin: allowedOrigins.length > 0
    ? (origin, callback) => {
        // Allow requests with no origin (mobile apps, curl)
        if (!origin) return callback(null, true);
        // Allow any localhost port (Flutter web debug uses random ports)
        const isLocalhost = /^https?:\/\/localhost(:\d+)?$/.test(origin);
        if (isLocalhost || allowedOrigins.includes(origin)) {
          callback(null, true);
        } else {
          callback(new Error('No permitido por CORS'));
        }
      }
    : true, // fallback: allow all if no origins configured
}));

// Body parser with size limit
app.use(express.json({ limit: '100kb' }));

// Rate limiting: 100 requests per minute per IP
const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Demasiadas solicitudes, intente de nuevo en un minuto' },
});
app.use('/api/', limiter);

app.use(auth);

// Mount routes
app.use('/api/v1/gastos', gastosRouter);
app.use('/api/v1/personal', personalRouter);
app.use('/api/v1/pagos', pagosRouter);
app.use('/api/v1/cierres', cierresRouter);

// Error handler (must be last)
app.use(errorHandler);

// Seed database on startup
seed();

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Solo Pastas API corriendo en http://0.0.0.0:${PORT}`);
});
