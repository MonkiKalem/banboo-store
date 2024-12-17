const { hash,compare } = require("bcrypt");
const SALT_ROUND = 10;

async function createHash(plainPassword){
  return (await hash(plainPassword, SALT_ROUND));
}

async function comparePassword(plainPassword, hashedPassword){
  return compare(plainPassword, hashedPassword );
}

module.exports = {
  createHash,
  comparePassword
}