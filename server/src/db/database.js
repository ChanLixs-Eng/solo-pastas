const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, '..', '..', 'solo_pastas.db');
const db = Database(dbPath);

// Enable WAL mode for better concurrency
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

db.exec(`
  CREATE TABLE IF NOT EXISTS personal (
    id_personal INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    cargo TEXT NOT NULL,
    sueldo_base TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS gastos (
    id_gasto INTEGER PRIMARY KEY AUTOINCREMENT,
    descripcion TEXT NOT NULL,
    monto TEXT NOT NULL,
    tipo_gasto TEXT NOT NULL CHECK(tipo_gasto IN ('Insumo', 'Servicio', 'Otros')),
    fecha TEXT NOT NULL,
    hora TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS pagos (
    id_pago INTEGER PRIMARY KEY AUTOINCREMENT,
    id_personal INTEGER NOT NULL,
    monto_pagado TEXT NOT NULL,
    concepto TEXT NOT NULL CHECK(concepto IN ('Sueldo', 'Adelanto', 'Bono')),
    fecha TEXT NOT NULL,
    FOREIGN KEY (id_personal) REFERENCES personal(id_personal)
  );

  CREATE TABLE IF NOT EXISTS cierres (
    id_cierre INTEGER PRIMARY KEY AUTOINCREMENT,
    ingresos_ventas TEXT NOT NULL,
    total_gastos TEXT NOT NULL,
    total_pagos TEXT NOT NULL,
    utilidad_neta TEXT NOT NULL,
    fecha TEXT NOT NULL
  );
`);

module.exports = db;
