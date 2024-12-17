const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const connection = require('../database/connect');
const SECRET_KEY = process.env.JWT_SECRET || 'my_secret_key';
const { login } = require('../controller/authenticationController');
const {getUserById ,getAllUsers, updateProfile } = require('../controller/userController');
const { authenticateToken, isAdmin } = require('../middleware/authMiddleware');
const { queryAsync } = require("../util/queryAsync")

const router = express.Router();

// Validate user input
const validateUserInput = (email, password) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Basic email validation
  if (!emailRegex.test(email)) return 'Invalid email format.';
  if (password.length < 6) return 'Password must be at least 6 characters long.';
  return null;
};

// User login
router.post('/login', login);  

// get user by id
router.get(  
  '/:userId',   
  authenticateToken,   
  getUserById
);  

// get all user Admin only
router.get(  
  '/',   
  authenticateToken,   
  isAdmin,   
  getAllUsers
);  

// User update profile
router.put(  
  '/update-profile', authenticateToken, updateProfile 
);   

// Google login route  
router.post('/google-login', async (req, res) => {  
  try {  
    const { email, name, googleId, profilePicture } = req.body;  
    
    // Validate input  
    if (!email || !googleId) {  
      return res.status(400).json({   
        message: 'Email and Google ID are required.'   
      });  
    }  

    // Use connection query instead of database  
    await queryAsync('USE db_banboo');   

    // Check if user exists  
    const existingUsers = await queryAsync(  
      'SELECT * FROM users WHERE email = ? OR google_id = ?',   
      [email, googleId]  
    );  

    let userId;  
    let isNewUser = false;  
    let userRole = 'customer';

    if (existingUsers.length > 0) {  
      // Update existing user  
      userId = existingUsers[0].userId;  
      
      // Update user details if they've changed  
      await queryAsync(  
        'UPDATE users SET google_id = ?, profile_picture = ?, is_google_user = ? WHERE userId = ?',  
        [ googleId, profilePicture, true, userId]  
      );  
    } else {  
      // Create new user with a default password and customer role  
      const defaultPassword = generateRandomPassword();  
      const hashedPassword = await bcrypt.hash(defaultPassword, 10);  

      const result = await queryAsync(  
        'INSERT INTO users (email, name, password, google_id, profile_picture,is_google_user, role) VALUES (?, ?, ?, ?, ?, ?, ?)',  
        [email, name, hashedPassword, googleId, profilePicture, true, userRole]  
      );  
      
      userId = result.insertId;  
      isNewUser = true;  
    }  

    // Generate JWT token  
    const token = generateToken(userId, userRole);  

    res.status(200).json({  
      token,  
      userId,  
      email,  
      name,  
      profilePicture,  
      role: userRole,  
      message: isNewUser ? 'Account created' : 'Login successful',  
      isNewUser  
    });  
  } catch (error) {  
    console.error('Google Login Error:', error);  
    
    if (error.code === 'ER_DUP_ENTRY') {  
      return res.status(409).json({   
        message: 'User with this email already exists',  
        error: error.message   
      });  
    }  

    res.status(500).json({   
      message: 'Server error during Google login',   
      error: error.message   
    });  
  }  
});  

// Utility function to generate a random password  
function generateRandomPassword(length = 16) {  
  const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+';  
  let password = '';  
  for (let i = 0; i < length; i++) {  
    const randomIndex = Math.floor(Math.random() * charset.length);  
    password += charset[randomIndex];  
  }  
  return password;  
}  

// JWT Token generation function  
function generateToken(userId, role) {  
  return jwt.sign(  
    { userId: userId , role: role },   
    process.env.JWT_SECRET,   
    { expiresIn: '1h' }  
  );  
}
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
      [name, email, hashedPassword, role]  
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
