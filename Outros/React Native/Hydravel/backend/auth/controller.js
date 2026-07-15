const jwt = require('jsonwebtoken');
const crypt = require('crypto');
const sequelize = require('../common/database');
const defineUser = require('../common/models/Usuario');
const { Database } = require('sqlite3');
const Usuario = defineUser(sequelize);
const senhaHash = (senha) =>
  crypt.createHash('sha256').update(senha).digest('hex');


const generateAccessToken = (usuarioId, nome) =>
  jwt.sign({ usuarioId, nome }, 'your-secret-key', { expiresIn: '24h' });

exports.register = async (req, res) => {
  /*if (!validate(req.body)) {
  return res.status(400).json({ error: 'Invalid input', details: validate.errors });
  }*/
  try {
    const { nome, email, senha } = req.body;
    const senhaHashada = senhaHash(senha);
    const usuario = await Usuario.create({
      nome,
      email,
      senha: senhaHashada

    });
    const accessToken = generateAccessToken(usuario.id, usuario.nome);
    res.status(201).json({
      success: true,
      user: { id: usuario.id, nome: usuario.nome, email: usuario.email },
      token: accessToken
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message, details: err.errors });
  }
};

exports.login = async (req, res) => {
  const { email, senha } = req.body;
  const senhaHashada = senhaHash(senha);
  const usuario = await Usuario.findOne({ where: { email } });

  if (!usuario || usuario.senha !== senhaHashada)
    return res.status(401).json({ error: 'Invalid credentials' });

  const token = generateAccessToken(email, usuario.id);
  res.json({ success: true, usuario, token });
};