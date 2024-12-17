const { generateJWT } = require("../util/jwt")
const { comparePassword } = require("../util/hashing")
const { queryAsync } = require("../util/queryAsync")
const connection = require('../database/connect');
const express = require('express');

async function login(req, res) {

  const {
    email,
    password
  } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      message: 'Email and password are required.'
    });
  }

  try {
    await queryAsync('USE db_banboo');
    const results = await queryAsync('SELECT * FROM users WHERE email = ?', [email]);

    if (results.length === 0) {
      return res.status(401).json({
        message: 'Email not found'
      });
    }

    const user = results[0];

    const isMatch = await comparePassword(password, user.password);

    if (!isMatch) {
      return res.status(401).json({
        message: 'Incorrect password'
      });
    }

    // Generate JWT token  
    const token = await generateJWT(user);

    res.json({
      message: 'Login successful',
      token,
      user: {
        userId: user.userId,
        name: user.name,
        email: user.email,
        profile_picture: user.profile_picture,
        role: user.role
      },
    });
  } catch (err) {
    console.error('Database error:', err.message);
    res.status(500).json({
      message: 'Internal server error',
      error: error.message
    });
  }

}

module.exports = {
  login
}