const APP_PIN = '1234';

function auth(req, res, next) {
  const pin = req.headers['x-app-pin'];
  if (!pin || pin !== APP_PIN) {
    return res.status(401).json({ detail: 'PIN inválido' });
  }
  next();
}

module.exports = auth;
