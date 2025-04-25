import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import '../models/shipment.dart';
import '../config/api_config.dart';

class DatabaseService {
  final Logger _logger = Logger();
  final http.Client _client;

  DatabaseService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Shipment>> getShipments() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.shipmentsEndpoint}'),
        headers: ApiConfig.defaultHeaders,
      );

      return _parseShipmentResponse(response);
    } catch (e) {
      _logger.e('Error in getShipments: $e');
      return [];
    }
  }

  Future<List<Shipment>> getRecentShipments({int limit = 5}) async {
    try {
      final response = await _client.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.recentShipmentsEndpoint}?limit=$limit'),
        headers: ApiConfig.defaultHeaders,
      );

      return _parseShipmentResponse(response);
    } catch (e) {
      _logger.e('Error in getRecentShipments: $e');
      return [];
    }
  }

  Future<Shipment?> addShipment(Shipment shipment) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.shipmentsEndpoint}'),
        headers: ApiConfig.defaultHeaders,
        body: json.encode(shipment.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Shipment.fromJson(json.decode(response.body));
      }
      _logger.e(
          'Failed to add shipment: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      _logger.e('Error in addShipment: $e');
      return null;
    }
  }

  Future<bool> updateShipmentById(String id, Shipment shipment) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.shipmentsEndpoint}/$id'),
        headers: ApiConfig.defaultHeaders,
        body: json.encode(shipment.toJson()),
      );

      if (response.statusCode == 200) {
        _logger.i('Shipment updated successfully: ${response.body}');
        return true;
      }
      _logger.e(
          'Failed to update shipment: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      _logger.e('Error in updateShipmentById: $e');
      return false;
    }
  }

  Future<bool> deleteShipmentById(String id) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.shipmentsEndpoint}/$id'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _logger.i('Shipment deleted successfully: ${response.body}');
        return true;
      }
      _logger.e(
          'Failed to delete shipment: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      _logger.e('Error in deleteShipmentById: $e');
      return false;
    }
  }

  List<Shipment> _parseShipmentResponse(http.Response response) {
    if (response.statusCode != 200) {
      _logger.e('Request failed: ${response.statusCode} - ${response.body}');
      return [];
    }

    try {
      final dynamic responseBody = json.decode(response.body);
      final List<dynamic> data =
          responseBody is List ? responseBody : [responseBody];

      return data
          .where((item) => item != null)
          .map((json) => Shipment.fromJson(json as Map<String, dynamic>))
          .whereType<Shipment>()
          .toList();
    } catch (e) {
      _logger.e('Error parsing response: $e');
      return [];
    }
  }

  void dispose() {
    _client.close();
  }
}
