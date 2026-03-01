const { Router } = require('express');
const Decimal = require('decimal.js');
const db = require('../db/database');

const router = Router();

// GET /api/v1/cierres?fecha=YYYY-MM-DD
router.get('/', (req, res) => {
  const { fecha } = req.query;
  if (!fecha || !/^\d{4}-\d{2}-\d{2}$/.test(fecha)) {
    const err = new Error('Parámetro fecha requerido (YYYY-MM-DD)');
    err.status = 400;
    throw err;
  }

  const cierres = db.prepare(
    'SELECT * FROM cierres WHERE fecha = ? ORDER BY id_cierre DESC'
  ).all(fecha);

  res.json(cierres);
});

// GET /api/v1/cierres/resumen-dia?fecha=YYYY-MM-DD
router.get('/resumen-dia', (req, res) => {
  const { fecha } = req.query;

  if (!fecha || !/^\d{4}-\d{2}-\d{2}$/.test(fecha)) {
    const err = new Error('Parámetro fecha requerido (YYYY-MM-DD)');
    err.status = 400;
    throw err;
  }

  const gastosRow = db.prepare(
    "SELECT COALESCE(SUM(CAST(monto AS REAL)), 0) AS total FROM gastos WHERE fecha = ?"
  ).get(fecha);
  const totalGastos = new Decimal(gastosRow.total);

  const pagosRow = db.prepare(
    "SELECT COALESCE(SUM(CAST(monto_pagado AS REAL)), 0) AS total FROM pagos WHERE fecha = ?"
  ).get(fecha);
  const totalPagos = new Decimal(pagosRow.total);

  res.json({
    fecha,
    total_gastos: totalGastos.toFixed(2),
    total_pagos: totalPagos.toFixed(2),
  });
});

// POST /api/v1/cierres
router.post('/', (req, res) => {
  const { ingresos_ventas, fecha } = req.body;

  if (!ingresos_ventas || !fecha) {
    const err = new Error('Campos requeridos: ingresos_ventas, fecha');
    err.status = 400;
    throw err;
  }

  // Validate date format YYYY-MM-DD
  if (!/^\d{4}-\d{2}-\d{2}$/.test(fecha)) {
    const err = new Error('Formato de fecha inválido, use YYYY-MM-DD');
    err.status = 400;
    throw err;
  }

  const ingresos = new Decimal(ingresos_ventas);
  if (ingresos.lt(0)) {
    const err = new Error('Los ingresos no pueden ser negativos');
    err.status = 400;
    throw err;
  }

  // Auto-aggregate gastos for the date
  const gastosRow = db.prepare(
    "SELECT COALESCE(SUM(CAST(monto AS REAL)), 0) AS total FROM gastos WHERE fecha = ?"
  ).get(fecha);
  const totalGastos = new Decimal(gastosRow.total);

  // Auto-aggregate pagos for the date
  const pagosRow = db.prepare(
    "SELECT COALESCE(SUM(CAST(monto_pagado AS REAL)), 0) AS total FROM pagos WHERE fecha = ?"
  ).get(fecha);
  const totalPagos = new Decimal(pagosRow.total);

  // Calculate net profit
  const utilidadNeta = ingresos.minus(totalGastos).minus(totalPagos);

  const result = db.prepare(
    'INSERT INTO cierres (ingresos_ventas, total_gastos, total_pagos, utilidad_neta, fecha) VALUES (?, ?, ?, ?, ?)'
  ).run(
    ingresos.toFixed(2),
    totalGastos.toFixed(2),
    totalPagos.toFixed(2),
    utilidadNeta.toFixed(2),
    fecha
  );

  res.json({
    id_cierre: result.lastInsertRowid,
    ingresos_ventas: ingresos.toFixed(2),
    total_gastos: totalGastos.toFixed(2),
    total_pagos: totalPagos.toFixed(2),
    utilidad_neta: utilidadNeta.toFixed(2),
    fecha,
  });
});

module.exports = router;
