const { Router } = require('express');
const Decimal = require('decimal.js');
const db = require('../db/database');

const router = Router();

const TIPOS_VALIDOS = ['Insumo', 'Servicio', 'Otros'];

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
  const fecha = now.toISOString().split('T')[0];
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
