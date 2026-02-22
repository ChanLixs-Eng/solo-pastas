const { Router } = require('express');
const Decimal = require('decimal.js');
const db = require('../db/database');

const router = Router();

const CONCEPTOS_VALIDOS = ['Sueldo', 'Adelanto', 'Bono'];

// POST /api/v1/pagos
router.post('/', (req, res) => {
  const { id_personal, monto_pagado, concepto } = req.body;

  if (!id_personal || !monto_pagado || !concepto) {
    const err = new Error('Campos requeridos: id_personal, monto_pagado, concepto');
    err.status = 400;
    throw err;
  }

  // Validate employee exists
  const empleado = db.prepare('SELECT id_personal FROM personal WHERE id_personal = ?').get(id_personal);
  if (!empleado) {
    const err = new Error('Empleado no encontrado');
    err.status = 404;
    throw err;
  }

  if (!CONCEPTOS_VALIDOS.includes(concepto)) {
    const err = new Error('concepto debe ser: Sueldo, Adelanto o Bono');
    err.status = 400;
    throw err;
  }

  const montoDecimal = new Decimal(monto_pagado);
  if (montoDecimal.lte(0)) {
    const err = new Error('El monto debe ser mayor a 0');
    err.status = 400;
    throw err;
  }

  const fecha = new Date().toISOString().split('T')[0];

  db.prepare(
    'INSERT INTO pagos (id_personal, monto_pagado, concepto, fecha) VALUES (?, ?, ?, ?)'
  ).run(id_personal, montoDecimal.toFixed(2), concepto, fecha);

  res.json({});
});

module.exports = router;
