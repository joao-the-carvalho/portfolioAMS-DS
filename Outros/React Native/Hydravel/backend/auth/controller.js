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

exports.list = async (req, res) => {
  try{
    const usuarios = await Usuario.findAll();
    res.status(200).json({
      success: true,
      count: usuarios.length,
      users: usuarios
    });
  }
  catch (err){
    console.error('Erro ao listar usuários:', err);
    res.status(500).json({
      success: false,
      error: 'Erro ao buscar usuários'
    });
  }
};