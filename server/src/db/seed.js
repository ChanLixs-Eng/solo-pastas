const db = require('./database');

function seed() {
  const hasData = db.prepare('SELECT COUNT(*) AS count FROM personal').get();
  if (hasData.count > 0) return;

  const insertPersonal = db.prepare('INSERT INTO personal (nombre, cargo, sueldo_base) VALUES (?, ?, ?)');

  const seedAll = db.transaction(() => {
    // Employees
    insertPersonal.run('Ana Pérez', 'Cocinera', '3000.00');
    insertPersonal.run('Carlos López', 'Mesero', '2200.00');
    insertPersonal.run('María García', 'Ayudante de Cocina', '2000.00');
    insertPersonal.run('Luis Mamani', 'Mesero', '2200.00');
  });

  seedAll();
  console.log('Base de datos inicializada con datos de prueba');
}

module.exports = seed;
