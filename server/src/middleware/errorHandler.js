function errorHandler(err, req, res, _next) {
  console.error(err.stack || err.message);

  const status = err.status || 500;
  const message = err.status ? err.message : 'Error interno del servidor';

  res.status(status).json({ detail: message });
}

module.exports = errorHandler;
