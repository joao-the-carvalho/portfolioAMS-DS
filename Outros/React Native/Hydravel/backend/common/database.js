const {Sequelize} = require('sequelize');
const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: './storage/data.db'
});
module.exports = sequelize;