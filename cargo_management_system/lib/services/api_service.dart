import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shipment.dart';
import '../config/api_config.dart'; // Ensure this file contains your API base URL

class ApiService {
  final String baseUrl = ApiConfig.baseUrl;

  // Fetch all shipments
  Future<List<Shipment>> getShipments() async {
    final response = await http.get(Uri.parse('$baseUrl/shipments'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Shipment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load shipments: ${response.statusCode}');
    }
  }

  // Fetch recent shipments with a limit
  Future<List<Shipment>> getRecentShipments({int limit = 5}) async {
    final response =
        await http.get(Uri.parse('$baseUrl/shipments/recent?limit=$limit'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Shipment.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load recent shipments: ${response.statusCode}');
    }
  }

  // Add a shipment
  Future<void> addShipment(Shipment shipment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/shipments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(shipment.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add shipment: ${response.statusCode}');
    }
  }

  // Update a shipment
  Future<void> updateShipment(Shipment shipment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/shipments/${shipment.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(shipment.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update shipment: ${response.statusCode}');
    }
  }

  // Delete a shipment
  Future<void> deleteShipment(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/shipments/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete shipment: ${response.statusCode}');
    }
  }
}
