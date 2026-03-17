const fs = require('fs');
const path = require('path');

const dbPath = path.join(__dirname, '..', 'solo_pastas.db');
const backupDir = path.join(__dirname, '..', 'backups');

if (!fs.existsSync(dbPath)) {
  console.error('Base de datos no encontrada:', dbPath);
  process.exit(1);
}

if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir, { recursive: true });
}

const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
const backupPath = path.join(backupDir, `solo_pastas_${timestamp}.db`);

fs.copyFileSync(dbPath, backupPath);
console.log(`Backup creado: ${backupPath}`);
