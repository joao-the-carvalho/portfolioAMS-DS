const sequelize = require('../database');
const defineUser = require('../models/Usuario');
const Usuario = defineUser(sequelize);

exports.has = (requiredRole) => async (req, res, next) => {
  const user = await Usuario.findByPk(req.Usuario.UsuarioId);
  if (!user || Usuario.role !== requiredRole) {
    return res.status(403).json({ error: `Requires ${requiredRole} role` });
  }
  next();
};