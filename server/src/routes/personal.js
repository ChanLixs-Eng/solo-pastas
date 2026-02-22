const { Router } = require('express');
const Decimal = require('decimal.js');
const db = require('../db/database');

const router = Router();

// GET /api/v1/personal
router.get('/', (req, res) => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const monthPrefix = `${year}-${month}`;

  const empleados = db.prepare('SELECT * FROM personal').all();

  const result = empleados.map(emp => {
    // Sum of payments this month
    const pagosRow = db.prepare(
      "SELECT COALESCE(SUM(CAST(monto_pagado AS REAL)), 0) AS total FROM pagos WHERE id_personal = ? AND fecha LIKE ?"
    ).get(emp.id_personal, `${monthPrefix}%`);

    const sueldoBase = new Decimal(emp.sueldo_base);
    const totalPagado = new Decimal(pagosRow.total);
    const pendiente = Decimal.max(sueldoBase.minus(totalPagado), new Decimal(0));

    // Last payment date
    const ultimoPago = db.prepare(
      'SELECT fecha FROM pagos WHERE id_personal = ? ORDER BY fecha DESC LIMIT 1'
    ).get(emp.id_personal);

    let ultimoPagoFormatted = null;
    if (ultimoPago) {
      const parts = ultimoPago.fecha.split('-');
      ultimoPagoFormatted = `${parts[2]}/${parts[1]}`;
    }

    return {
      id_personal: emp.id_personal,
      nombre: emp.nombre,
      cargo: emp.cargo,
      sueldo_pendiente: pendiente.toFixed(2),
      ultimo_pago: ultimoPagoFormatted,
    };
  });

  res.json(result);
});

module.exports = router;
