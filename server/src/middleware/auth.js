function auth(req, res, next) {
  const appPin = process.env.APP_PIN;
  if (!appPin) {
    console.error('APP_PIN no configurado en variables de entorno');
    return res.status(500).json({ error: 'Configuración del servidor incompleta' });
  }

  const pin = req.headers['x-app-pin'];
  if (!pin || pin !== appPin) {
    return res.status(401).json({ error: 'PIN inválido' });
  }
  next();
}

module.exports = auth;
