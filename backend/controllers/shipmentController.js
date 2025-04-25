const Shipment = require('../models/shipment.'); // This should match the file name

exports.createShipment = async (req, res) => {
  const {
    trackingNumber,
    origin,
    destination,
    weight,
    dimensions,
    expectedDeliveryDate,
    shipmentType,
    carrier,
    isFragile,
    isUrgent,
    senderName,
    senderContact,
    receiverName,
    receiverContact,
    notes,
  } = req.body;

  try {
    const newShipment = new Shipment({
      trackingNumber,
      origin,
      destination,
      weight,
      dimensions,
      expectedDeliveryDate,
      shipmentType,
      carrier,
      isFragile,
      isUrgent,
      senderName,
      senderContact,
      receiverName,
      receiverContact,
      notes,
    });

    const shipment = await newShipment.save();
    res.json(shipment);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

exports.getShipments = async (req, res) => {
  try {
    const shipments = await Shipment.find().sort({ createdAt: -1 });
    res.json(shipments);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

exports.getShipmentById = async (req, res) => {
  try {
    const shipment = await Shipment.findById(req.params.id);

    if (!shipment) {
      return res.status(404).json({ msg: 'Shipment not found' });
    }

    res.json(shipment);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

exports.updateShipmentStatus = async (req, res) => {
  const { status } = req.body;

  try {
    let shipment = await Shipment.findById(req.params.id);

    if (!shipment) {
      return res.status(404).json({ msg: 'Shipment not found' });
    }

    shipment.status = status;
    await shipment.save();

    res.json(shipment);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};

exports.deleteShipment = async (req, res) => {
  try {
    const shipment = await Shipment.findById(req.params.id);

    if (!shipment) {
      return res.status(404).json({ msg: 'Shipment not found' });
    }

    await shipment.remove();
    res.json({ msg: 'Shipment removed' });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
};