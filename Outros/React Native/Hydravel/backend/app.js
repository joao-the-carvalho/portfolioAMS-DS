const express = require('express');
const app = express();
const sequelize = require('./common/database');
const defineUser = require('./common/models/Usuario');
const Usuario = defineUser(sequelize);
const authRoutes = require('./auth/routes');
const userRoutes = require('./usuarios/routes');

app.use(express.json());
sequelize.sync({ alter: true }).then(() => {
  console.log("Banco de dados sincronizado!");
});
app.use('/', authRoutes);
app.use('/user', userRoutes);

app.get('/status', (req, res) => {
  res.json({
    status: 'Running',
    timestamp: new Date().toISOString()
  });
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: 'Something went wrong'
  });
});