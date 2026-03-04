const { Router } = require('express');
const Decimal = require('decimal.js');
const db = require('../db/database');

const router = Router();

// GET /api/v1/personal
router.get('/', (req, res, next) => {
  try {
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
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/personal
router.post('/', (req, res, next) => {
  try {
    const { nombre, cargo, sueldo_base } = req.body;

    if (!nombre || !cargo || !sueldo_base) {
      const err = new Error('nombre, cargo y sueldo_base son requeridos');
      err.status = 400;
      throw err;
    }

    const salary = new Decimal(sueldo_base);
    if (salary.lte(0)) {
      const err = new Error('El sueldo base debe ser mayor a 0');
      err.status = 400;
      throw err;
    }

    const result = db.prepare(
      'INSERT INTO personal (nombre, cargo, sueldo_base) VALUES (?, ?, ?)'
    ).run(nombre.trim(), cargo.trim(), salary.toFixed(2));

    res.status(201).json({
      id_personal: result.lastInsertRowid,
      nombre: nombre.trim(),
      cargo: cargo.trim(),
      sueldo_pendiente: salary.toFixed(2),
      ultimo_pago: null,
    });
  } catch (err) {
    next(err);
  }
});

// DELETE /api/v1/personal/:id
router.delete('/:id', (req, res, next) => {
  try {
    const { id } = req.params;

    const existing = db.prepare('SELECT id_personal FROM personal WHERE id_personal = ?').get(id);
    if (!existing) {
      const err = new Error('Empleado no encontrado');
      err.status = 404;
      throw err;
    }

    const deleteAll = db.transaction(() => {
      db.prepare('DELETE FROM pagos WHERE id_personal = ?').run(id);
      db.prepare('DELETE FROM personal WHERE id_personal = ?').run(id);
    });
    deleteAll();

    res.json({ message: 'Empleado eliminado' });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
