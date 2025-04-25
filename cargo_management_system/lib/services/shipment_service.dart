import '../models/shipment.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

class ShipmentService {
  // Using an in-memory list to store shipments for simplicity
  final List<Shipment> _shipments = [];

  static final ShipmentService _instance = ShipmentService._internal();
  factory ShipmentService() => _instance;
  ShipmentService._internal();

  Future<String> addShipment(Shipment shipment) async {
    // Assign a unique ID using ObjectId
    final id = ObjectId(); // Generate a new ObjectId
    final newShipment = Shipment(
      id: id, // Use ObjectId for the ID
      trackingNumber: shipment.trackingNumber,
      origin: shipment.origin,
      destination: shipment.destination,
      status: shipment.status,
      departureDate: shipment.departureDate,
      arrivalDate: shipment.arrivalDate,
      description: shipment.description,
      weight: shipment.weight,
      customerId: shipment.customerId,
      createdAt: DateTime.now(), // Set createdAt to current time
      updatedAt: DateTime.now(), // Set updatedAt to current time
    );
    _shipments.add(newShipment);
    return id.toHexString(); // Return the ID as a String
  }

  Future<List<Shipment>> getShipments() async {
    return _shipments;
  }

  Future<List<Shipment>> getRecentShipments({int limit = 10}) async {
    // Sort shipments by createdAt in descending order
    _shipments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _shipments.take(limit).toList();
  }

  Future<bool> updateShipment(Shipment shipment) async {
    final index = _shipments.indexWhere((s) => s.id == shipment.id);
    if (index != -1) {
      _shipments[index] = shipment;
      return true;
    }
    return false;
  }

  Future<bool> deleteShipment(String id) async {
    final initialLength = _shipments.length;
    _shipments
        .removeWhere((s) => s.id?.toHexString() == id); // Compare as String
    return _shipments.length < initialLength;
  }

  Future<void> close() async {
    // No-op for in-memory storage
  }
}
