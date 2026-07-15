const sequelize = require('../common/database');
const defineUser = require('../common/models/Usuario');
const Usuario = defineUser(sequelize);

exports.getUsuario = async (req, res) => {
  const usuario = await Usuario.findByPk(req.user.userId);
  if (!usuario) return res.status(404).json({ error: 'User not found' });
  res.json({ success: true, data: usuario });
};

exports.getAllUsers = async (req, res) => {
  const usuarios = await Usuario.findAll();
  res.json({ success: true, data: usuarios });
};