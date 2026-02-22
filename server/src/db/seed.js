const db = require('./database');

function seed() {
  const hasData = db.prepare('SELECT COUNT(*) AS count FROM categorias').get();
  if (hasData.count > 0) return;

  const insertCategoria = db.prepare('INSERT INTO categorias (nombre) VALUES (?)');
  const insertProducto = db.prepare('INSERT INTO productos (nombre, precio_venta, estado, id_categoria) VALUES (?, ?, ?, ?)');
  const insertPersonal = db.prepare('INSERT INTO personal (nombre, cargo, sueldo_base) VALUES (?, ?, ?)');

  const seedAll = db.transaction(() => {
    // Categories
    insertCategoria.run('Pastas');
    insertCategoria.run('Refrescos');
    insertCategoria.run('Postres');

    // Products — Pastas (id_categoria = 1)
    insertProducto.run('Fettuccine Alfredo', '45.00', 1, 1);
    insertProducto.run('Spaghetti Bolognesa', '40.00', 1, 1);
    insertProducto.run('Penne al Pesto', '42.00', 1, 1);
    insertProducto.run('Lasagna Clásica', '50.00', 1, 1);
    insertProducto.run('Ravioli de Ricotta', '48.00', 1, 1);

    // Products — Refrescos (id_categoria = 2)
    insertProducto.run('Limonada', '15.00', 1, 2);
    insertProducto.run('Jugo de Maracuyá', '18.00', 1, 2);

    // Products — Postres (id_categoria = 3)
    insertProducto.run('Tiramisú', '35.00', 1, 3);

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
