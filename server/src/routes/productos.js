const { Router } = require('express');
const Decimal = require('decimal.js');
const db = require('../db/database');

const router = Router();

// GET /api/v1/productos
router.get('/', (req, res) => {
  const rows = db.prepare(`
    SELECT p.id_producto, p.nombre, p.precio_venta, p.estado, c.nombre AS nombre_categoria
    FROM productos p
    JOIN categorias c ON p.id_categoria = c.id_categoria
    ORDER BY c.nombre, p.nombre
  `).all();

  const productos = rows.map(row => ({
    id_producto: row.id_producto,
    nombre: row.nombre,
    precio_venta: row.precio_venta,
    estado: row.estado === 1,
    nombre_categoria: row.nombre_categoria,
  }));

  res.json(productos);
});

// PUT /api/v1/productos/:id
router.put('/:id', (req, res) => {
  const { id } = req.params;
  const { precio_venta, estado } = req.body;

  // Validate product exists
  const existing = db.prepare('SELECT id_producto FROM productos WHERE id_producto = ?').get(id);
  if (!existing) {
    const err = new Error('Producto no encontrado');
    err.status = 404;
    throw err;
  }

  // Validate inputs
  if (precio_venta !== undefined) {
    const price = new Decimal(precio_venta);
    if (price.lte(0)) {
      const err = new Error('El precio debe ser mayor a 0');
      err.status = 400;
      throw err;
    }
  }

  if (estado !== undefined && typeof estado !== 'boolean') {
    const err = new Error('El estado debe ser verdadero o falso');
    err.status = 400;
    throw err;
  }

  // Build update
  const updates = [];
  const params = [];

  if (precio_venta !== undefined) {
    updates.push('precio_venta = ?');
    params.push(new Decimal(precio_venta).toFixed(2));
  }
  if (estado !== undefined) {
    updates.push('estado = ?');
    params.push(estado ? 1 : 0);
  }

  if (updates.length === 0) {
    const err = new Error('No se proporcionaron campos para actualizar');
    err.status = 400;
    throw err;
  }

  params.push(id);
  db.prepare(`UPDATE productos SET ${updates.join(', ')} WHERE id_producto = ?`).run(...params);

  // Return updated product
  const updated = db.prepare(`
    SELECT p.id_producto, p.nombre, p.precio_venta, p.estado, c.nombre AS nombre_categoria
    FROM productos p
    JOIN categorias c ON p.id_categoria = c.id_categoria
    WHERE p.id_producto = ?
  `).get(id);

  res.json({
    id_producto: updated.id_producto,
    nombre: updated.nombre,
    precio_venta: updated.precio_venta,
    estado: updated.estado === 1,
    nombre_categoria: updated.nombre_categoria,
  });
});

module.exports = router;
