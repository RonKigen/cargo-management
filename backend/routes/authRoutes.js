const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken'); // For JWT token generation
const User = require('../models/User'); // Ensure correct path to the User model
const logger = require('../utils/logger'); // Use your existing logger
const router = express.Router();

// Debugging Route: To test if the route is accessible
router.get('/register', (req, res) => {
  res.send('Register endpoint is working');
});

router.get('/signup', (req, res) => {
  res.send('Signup endpoint is working');
});

// Registration endpoint handler
const registerHandler = async (req, res) => {
  const { username, email, password } = req.body;
  try {
    // Check if the user already exists
    const existingUser = await User.findOne({ $or: [{ username }, { email }] });
    if (existingUser) {
      return res.status(400).json({
        message: existingUser.username === username ? 'Username already exists' : 'Email already exists'
      });
    }
    
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // Create a new user
    const newUser = new User({
      username,
      email,
      password: hashedPassword,
    });
    
    // Save the user to the database
    await newUser.save();
    
    // Generate JWT token
    const token = jwt.sign(
      { userId: newUser._id, username: newUser.username },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '1d' }
    );
    
    // Return success with token
    return res.status(201).json({ 
      message: 'User registered successfully',
      token 
    });
  } catch (error) {
    console.error('Registration error:', error);
    return res.status(500).json({ message: 'Server error during registration' });
  }
};

// Login endpoint handler
const loginHandler = async (req, res) => {
  const { username, password } = req.body;
  
  try {
    // Find user by username
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(400).json({ message: 'Invalid username or password' });
    }
    
    // Compare passwords
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid username or password' });
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { userId: user._id, username: user.username },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '1d' }
    );
    
    // Return success with token
    return res.status(200).json({ 
      message: 'Login successful',
      token 
    });
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({ message: 'Server error during login' });
  }
};

// Add the login route with logging
router.post('/login', (req, res) => {
  logger.info('Login attempt received:', { username: req.body.username });
  loginHandler(req, res);
});

// Add the register route with logging
router.post('/register', (req, res) => {
  logger.info('Registration attempt received:', { 
    username: req.body.username,
    email: req.body.email 
  });
  registerHandler(req, res);
});

// Connect the handler to both POST routes (optional, since they are already added above)
router.post('/signup', registerHandler);

module.exports = router;