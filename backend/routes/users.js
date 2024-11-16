const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const connection = require('../database/connect');
const SECRET_KEY = process.env.JWT_SECRET || 'my_secret_key'; // Use environment variable or fallback

const router = express.Router();

router.post('/login', (req, res) => {
  const { email, password } = req.body;

  connection.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
      if (err) {
          console.error('Database error:', err.message);
          return res.status(500).json({ message: 'Internal server error' });
      }

      if (results.length === 0) {
          return res.status(401).json({ message: 'Invalid email or password' });
      }

      const user = results[0];

      bcrypt.compare(password, user.password, (err, isMatch) => {
          if (err) {
              console.error('Error comparing passwords:', err.message);
              return res.status(500).json({ message: 'Internal server error' });
          }

          if (!isMatch) {
              return res.status(401).json({ message: 'Invalid email or password' });
          }

          // Generate JWT token
          const token = jwt.sign(
              { userId: user.userId, role: user.role },
              SECRET_KEY,
              { expiresIn: '1h' }
          );

          res.json({
              message: 'Login successful',
              token: token
          });
      });
  });
});

router.post('/register', async (req, res) => {
  const { name, email, password, role } = req.body;

  try {
      const hashedPassword = await bcrypt.hash(password, 10);

      connection.query(
          'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)',
          [name, email, hashedPassword, role || 'customer'],
          (err, results) => {
              if (err) {
                  console.error('Error creating user:', err.message);
                  return res.status(500).json({ message: 'Internal server error' });
              }
              res.status(201).json({ message: 'User registered successfully' });
          }
      );
  } catch (err) {
      console.error('Error hashing password:', err.message);
      res.status(500).json({ message: 'Internal server error' });
  }
});


module.exports = router;
