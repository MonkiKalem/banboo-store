const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const connection = require('../database/connect');
const SECRET_KEY = process.env.JWT_SECRET || 'my_secret_key';

const router = express.Router();

// Utility function to promisify connection.query  
const queryAsync = (query, params = []) => {  
  return new Promise((resolve, reject) => {  
    connection.query(query, params, (err, results) => {  
      if (err) return reject(err);  
      resolve(results);  
    });  
  });  
};  

// Validate user input
const validateUserInput = (email, password) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Basic email validation
  if (!emailRegex.test(email)) return 'Invalid email format.';
  if (password.length < 6) return 'Password must be at least 6 characters long.';
  return null;
};

// User login
router.post('/login', async (req, res) => {  
  const { email, password } = req.body;  

  if (!email || !password) {  
    return res.status(400).json({ message: 'Email and password are required.' });  
  }  

  try {  
    await queryAsync('USE db_banboo');  
    const results = await queryAsync('SELECT * FROM users WHERE email = ?', [email]);  

    if (results.length === 0) {  
      return res.status(401).json({ message: 'Email not found' });  
    }  

    const user = results[0];  

    const isMatch = await bcrypt.compare(password, user.password);  
    if (!isMatch) {  
      return res.status(401).json({ message: 'Incorrect password' });  
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
  } catch (err) {  
    console.error('Database error:', err.message);  
    res.status(500).json({ message: 'Internal server error' });  
  }  
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
    await queryAsync('USE db_banboo');  
    const hashedPassword = await bcrypt.hash(password, 10);  

    await queryAsync(  
      'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)',  
      [name, email, hashedPassword, role || 'customer']  
    );  

    res.status(201).json({ message: 'User registered successfully' });  
  } catch (err) {  
    if (err.code === 'ER_DUP_ENTRY') {  
      return res.status(409).json({ message: 'Email already exists.' });  
    }  
    console.error('Error creating user:', err.message);  
    res.status(500).json({ message: 'Internal server error' });  
  }  
});  

module.exports = router;
