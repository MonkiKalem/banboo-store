const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const connection = require('../database/connect');
const SECRET_KEY = process.env.JWT_SECRET || 'my_secret_key';

const router = express.Router();

// Validate user input
const validateUserInput = (email, password) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Basic email validation
  if (!emailRegex.test(email)) return 'Invalid email format.';
  if (password.length < 6) return 'Password must be at least 6 characters long.';
  return null;
};

// User login
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required.' });
  }

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
        token,
        user: { userId: user.userId, name: user.name, email: user.email, role: user.role },
      });
    });
  });
});

// User registration
router.post('/register', async (req, res) => {
  const { name, email, password, role } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ message: 'Name, email, and password are required.' });
  }

  const inputError = validateUserInput(email, password);
  if (inputError) {
    return res.status(400).json({ message: inputError });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    connection.query(
      'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)',
      [name, email, hashedPassword, role || 'customer'],
      (err, results) => {
        if (err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ message: 'Email already exists.' });
          }
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
