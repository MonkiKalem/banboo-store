const SECRET_KEY = process.env.JWT_SECRET || 'my_secret_key';
const jwt = require('jsonwebtoken');


async function generateJWT(user) {
  return jwt.sign(
    {
      userId: user.userId,
      role: user.role
    },
    SECRET_KEY, {
      expiresIn: '1h'
    }
  );
}


module.exports = {
  generateJWT
}