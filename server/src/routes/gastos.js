const { Router } = require('express');
const Decimal = require('decimal.js');
const db = require('../db/database');

const router = Router();

const TIPOS_VALIDOS = ['Insumo', 'Servicio', 'Otros'];

// GET /api/v1/gastos?fecha=YYYY-MM-DD
router.get('/', (req, res) => {
  const { fecha } = req.query;
  if (!fecha) {
    const err = new Error('Parámetro requerido: fecha (YYYY-MM-DD)');
    err.status = 400;
    throw err;
  }

  const gastos = db.prepare(
    'SELECT * FROM gastos WHERE fecha = ? ORDER BY hora DESC'
  ).all(fecha);

  res.json(gastos);
});

// POST /api/v1/gastos
router.post('/', (req, res) => {
  const { descripcion, monto, tipo_gasto } = req.body;

  // Validate required fields
  if (!descripcion || !monto || !tipo_gasto) {
    const err = new Error('Campos requeridos: descripcion, monto, tipo_gasto');
    err.status = 400;
    throw err;
  }

  if (!TIPOS_VALIDOS.includes(tipo_gasto)) {
    const err = new Error('tipo_gasto debe ser: Insumo, Servicio u Otros');
    err.status = 400;
    throw err;
  }

  const montoDecimal = new Decimal(monto);
  if (montoDecimal.lte(0)) {
    const err = new Error('El monto debe ser mayor a 0');
    err.status = 400;
    throw err;
  }

  const now = new Date();
  const fecha = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
  const hora = now.toTimeString().split(' ')[0];

  const result = db.prepare(
    'INSERT INTO gastos (descripcion, monto, tipo_gasto, fecha, hora) VALUES (?, ?, ?, ?, ?)'
  ).run(descripcion, montoDecimal.toFixed(2), tipo_gasto, fecha, hora);

  res.json({
    id_gasto: result.lastInsertRowid,
    descripcion,
    monto: montoDecimal.toFixed(2),
    tipo_gasto,
    fecha,
    hora,
  });
});

module.exports = router;
