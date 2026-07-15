const router = require('express').Router();
const AuthController = require('./controller');
router.get('/', (req, res)=>{
    res.json({message: "essa é a 'página' principal da api. :)"});
})
router.post('/signup', AuthController.register);
router.post('/login', AuthController.login);
module.exports = router;