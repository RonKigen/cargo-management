const mongoose = require('mongoose');
const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const logger = require('./utils/logger'); // Custom logger

// Load environment variables
dotenv.config({ path: './.env' });

// Debug: Log all environment variables
console.log('All environment variables:', process.env);

// Initialize Express app
const app = express();
const port = process.env.PORT || 5001;

// Middleware
app.use(cors()); // Enable CORS
app.use(express.json()); // Parse JSON bodies

// Debug: Log MONGO_URI
logger.info('MONGO_URI:', process.env.MONGO_URI || 'Not defined');

// Validate environment variables
const mongoURI = process.env.MONGO_URI;
if (!mongoURI) {
  logger.error('MongoDB URI is not defined!');
  process.exit(1); // Stop server if URI is missing
}

// Connect to MongoDB
mongoose.connect(mongoURI)
  .then(() => logger.info('Connected to MongoDB'))
  .catch(err => {
    logger.error('MongoDB connection error:', err);
    process.exit(1); // Stop server if MongoDB connection fails
  });

// Routes
app.get('/', (req, res) => {
  res.send('Cargo Management System backend');
});

// Use authRoutes for /api
app.use('/api', require('./routes/authRoutes'));

// Use shipmentRoutes for /api/shipments
app.use('/api/shipments', require('./routes/shipmentRoutes')); // Add this line

// Error handling middleware
app.use((err, req, res, next) => {
  logger.error('Error:', err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Start the server
const server = app.listen(port, () => {
  logger.info(`Server running on port ${port}`);
});

// Graceful shutdown
process.on('SIGINT', () => {
  logger.info('Shutting down server...');
  server.close(() => {
    logger.info('Server closed.');
    mongoose.connection.close(false, () => {
      logger.info('MongoDB connection closed.');
      process.exit(0);
    });
  });
});