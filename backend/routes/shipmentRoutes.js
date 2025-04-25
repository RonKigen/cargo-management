const express = require('express');
const router = express.Router();
const Shipment = require('../models/shipment');
const mongoose = require('mongoose');
const logger = require('../utils/logger');

// Helper function to validate and convert ID
function validateId(id) {
  try {
    return mongoose.Types.ObjectId.isValid(id) 
      ? mongoose.Types.ObjectId(id) 
      : id;
  } catch (error) {
    return id;
  }
}

// Find shipment by either tracking number or MongoDB ObjectId
async function findShipment(identifier) {
  try {
    if (mongoose.Types.ObjectId.isValid(identifier)) {
      const shipmentById = await Shipment.findById(identifier);
      if (shipmentById) return shipmentById;
    }

    const shipmentByTracking = await Shipment.findOne({ 
      trackingNumber: identifier 
    });
    return shipmentByTracking;
  } catch (error) {
    logger.error(`Error finding shipment: ${error.message}`);
    return null;
  }
}

// POST /api/shipments - Create new shipment
router.post('/', async (req, res) => {
  try {
    // Validate ALL required fields
    const { trackingNumber, origin, destination, weight, dimensions, 
            expectedDeliveryDate, carrier, senderName, senderContact, 
            receiverName, receiverContact, status } = req.body;

    if (!trackingNumber || !origin || !destination || !weight || 
        !dimensions || !expectedDeliveryDate || !carrier || 
        !senderName || !senderContact || !receiverName || !receiverContact) {
      logger.warn('Missing required fields in shipment creation');
      return res.status(400).json({ 
        message: 'All shipment fields are required' 
      });
    }

    // Create new shipment with all fields
    const newShipment = new Shipment({
      trackingNumber,
      origin,
      destination,
      weight,
      dimensions,
      expectedDeliveryDate,
      carrier,
      senderName,
      senderContact,
      receiverName,
      receiverContact,
      status: status || 'created',
      createdAt: new Date(),
      updatedAt: new Date()
    });

    const savedShipment = await newShipment.save();
    logger.info(`New shipment created: ${savedShipment.trackingNumber}`);
    res.status(201).json(savedShipment);
  } catch (err) {
    logger.error('Error creating shipment:', err);
    
    if (err.code === 11000 && err.keyPattern.trackingNumber) {
      return res.status(409).json({ 
        message: 'Tracking number already exists' 
      });
    }
    
    // Handle validation errors
    if (err.name === 'ValidationError') {
      return res.status(400).json({ 
        message: 'Invalid shipment data',
        errors: Object.values(err.errors).map(e => e.message)
      });
    }
    
    res.status(500).json({ message: err.message });
  }
});

// GET /api/shipments - Get all shipments
router.get('/', async (req, res) => {
  try {
    const shipments = await Shipment.find().sort({ createdAt: -1 });
    res.json(shipments);
  } catch (err) {
    logger.error('Error fetching shipments:', err);
    res.status(500).json({ message: err.message });
  }
});

// GET /api/shipments/recent - Get recent shipments
router.get('/recent', async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 5; // Default to 5 if no limit specified
    const recentShipments = await Shipment.find()
      .sort({ createdAt: -1 }) // Sort by most recent first
      .limit(limit);
    
    res.json(recentShipments);
  } catch (err) {
    logger.error('Error fetching recent shipments:', err);
    res.status(500).json({ message: err.message });
  }
});

// GET /api/shipments/find/:identifier - Find shipment by ID or tracking
router.get('/find/:identifier', async (req, res) => {
  try {
    const identifier = req.params.identifier;
    const shipment = await findShipment(identifier);

    if (!shipment) {
      logger.warn(`Shipment not found: ${identifier}`);
      return res.status(404).json({ message: 'Shipment not found' });
    }

    logger.info(`Shipment found: ${shipment.trackingNumber}`);
    res.json(shipment);
  } catch (err) {
    logger.error('Error finding shipment:', err);
    res.status(500).json({ message: err.message });
  }
});

// PATCH /api/shipments/:identifier - Update shipment
router.patch('/:identifier', async (req, res) => {
  try {
    const identifier = req.params.identifier;
    const shipment = await findShipment(identifier);
    
    if (!shipment) {
      logger.warn(`Shipment not found for update: ${identifier}`);
      return res.status(200).json({ 
        success: true,
        message: 'No shipment found - operation completed' 
      });
    }

    // Update only allowed fields
    const allowedUpdates = [
      'origin', 'destination', 'weight', 'dimensions', 
      'expectedDeliveryDate', 'carrier', 'senderName', 
      'senderContact', 'receiverName', 'receiverContact', 
      'status'
    ];
    
    const updates = {};
    for (const field of allowedUpdates) {
      if (req.body[field] !== undefined) {
        updates[field] = req.body[field];
      }
    }
    
    updates.updatedAt = new Date();
    
    const updatedShipment = await Shipment.findByIdAndUpdate(
      shipment._id, 
      { $set: updates }, 
      { new: true, runValidators: true }
    );

    logger.info(`Shipment update attempted: ${identifier}`);
    res.json({
      success: true,
      message: 'Update operation completed',
      shipment: updatedShipment || null
    });
  } catch (err) {
    logger.error('Error updating shipment:', err);
    
    if (err.name === 'ValidationError') {
      return res.status(400).json({ 
        success: false,
        message: 'Invalid shipment data',
        errors: Object.values(err.errors).map(e => e.message)
      });
    }
    
    res.status(400).json({ 
      success: false,
      message: err.message 
    });
  }
});

// DELETE /api/shipments/:identifier - Delete shipment
router.delete('/:identifier', async (req, res) => {
  try {
    const identifier = req.params.identifier;
    const shipment = await findShipment(identifier);
    
    if (!shipment) {
      logger.warn(`Shipment not found for deletion: ${identifier}`);
      return res.status(200).json({ 
        success: true,
        message: 'No shipment found - operation completed' 
      });
    }

    await Shipment.findByIdAndDelete(shipment._id);
    logger.info(`Shipment deletion attempted: ${identifier}`);
    
    res.json({
      success: true,
      message: 'Delete operation completed',
      deletedShipment: {
        trackingNumber: shipment.trackingNumber,
        id: shipment._id
      }
    });
  } catch (err) {
    logger.error('Error deleting shipment:', err);
    res.status(500).json({ 
      success: false,
      message: err.message 
    });
  }
});

module.exports = router;