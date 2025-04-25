const mongoose = require('mongoose');

const shipmentSchema = new mongoose.Schema({
  trackingNumber: {
    type: String,
    required: [true, 'Tracking number is required'],
    unique: true,
    index: true,
    trim: true,
    validate: {
      validator: function(v) {
        return /^[A-Za-z0-9]{8,20}$/.test(v);
      },
      message: props => `${props.value} is not a valid tracking number!`
    }
  },
  origin: {
    type: String,
    required: [true, 'Origin is required'],
    trim: true
  },
  destination: {
    type: String,
    required: [true, 'Destination is required'],
    trim: true
  },
  weight: {
    type: Number,
    required: [true, 'Weight is required'],
    min: [0.1, 'Weight must be at least 0.1kg'],
    max: [1000, 'Weight cannot exceed 1000kg']
  },
  dimensions: {
    type: String,
    required: [true, 'Dimensions are required'],
    trim: true,
    validate: {
      validator: function(v) {
        return /^\d+(\.\d+)?x\d+(\.\d+)?x\d+(\.\d+)?(cm|in|m)$/.test(v);
      },
      message: props => `${props.value} is not valid dimensions format! Use LxWxH with unit (e.g., 20x30x15cm)`
    }
  },
  expectedDeliveryDate: {
    type: Date,
    required: [true, 'Expected delivery date is required'],
    validate: {
      validator: function(v) {
        return v > new Date();
      },
      message: props => `${props.value} must be in the future!`
    }
  },
  shipmentType: {
    type: String,
    required: [true, 'Shipment type is required'],
    enum: {
      values: ['Standard', 'Express', 'Economy', 'Overnight', 'International'],
      message: '{VALUE} is not a valid shipment type'
    },
    default: 'Standard'
  },
  carrier: {
    type: String,
    required: [true, 'Carrier is required'],
    trim: true
  },
  isFragile: {
    type: Boolean,
    default: false
  },
  isUrgent: {
    type: Boolean,
    default: false
  },
  senderName: {
    type: String,
    required: [true, 'Sender name is required'],
    trim: true
  },
  senderContact: {
    type: String,
    required: [true, 'Sender contact is required'],
    trim: true,
    validate: {
      validator: function(v) {
        return /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/.test(v);
      },
      message: props => `${props.value} is not a valid phone number!`
    }
  },
  receiverName: {
    type: String,
    required: [true, 'Receiver name is required'],
    trim: true
  },
  receiverContact: {
    type: String,
    required: [true, 'Receiver contact is required'],
    trim: true,
    validate: {
      validator: function(v) {
        return /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/.test(v);
      },
      message: props => `${props.value} is not a valid phone number!`
    }
  },
  notes: {
    type: String,
    trim: true,
    maxlength: [500, 'Notes cannot exceed 500 characters']
  },
  status: {
    type: String,
    required: true,
    default: 'Pending',
    enum: {
      values: ['Pending', 'In Transit', 'Delivered', 'Cancelled', 'Returned'],
      message: '{VALUE} is not a valid status'
    }
  },
  createdAt: {
    type: Date,
    default: Date.now,
    immutable: true
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Update timestamp before saving
shipmentSchema.pre('save', function(next) {
  this.updatedAt = new Date();
  next();
});

// Add indexes for optimized queries
shipmentSchema.index({ trackingNumber: 1 });
shipmentSchema.index({ status: 1 });
shipmentSchema.index({ createdAt: -1 });
shipmentSchema.index({ carrier: 1, status: 1 });
shipmentSchema.index({ expectedDeliveryDate: 1 });

// Virtual for formatted delivery date
shipmentSchema.virtual('formattedDeliveryDate').get(function() {
  return this.expectedDeliveryDate.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
});

module.exports = mongoose.model('Shipment', shipmentSchema);