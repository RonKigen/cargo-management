import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import '../models/shipment.dart';

final _logger = Logger();

final shipmentProvider =
    StateNotifierProvider<ShipmentNotifier, ShipmentState>((ref) {
  return ShipmentNotifier();
});

class ShipmentState {
  final List<Shipment> shipments;
  final List<Shipment> recentShipments;
  final bool isLoading;
  final String? errorMessage;

  ShipmentState({
    this.shipments = const [],
    this.recentShipments = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ShipmentState copyWith({
    List<Shipment>? shipments,
    List<Shipment>? recentShipments,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ShipmentState(
      shipments: shipments ?? this.shipments,
      recentShipments: recentShipments ?? this.recentShipments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ShipmentNotifier extends StateNotifier<ShipmentState> {
  ShipmentNotifier() : super(ShipmentState()) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      await Future.wait([
        fetchShipments(),
        fetchRecentShipments(),
      ]);
    } catch (e) {
      state = state.copyWith(
        errorMessage: _parseErrorMessage(e, 'Failed to initialize shipments'),
      );
      _logger.e('Initialization error: ${state.errorMessage}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchShipments() async {
    try {
      state = state.copyWith(isLoading: true);

      final response =
          await http.get(Uri.parse('http://localhost:5001/api/shipments'));
      if (response.statusCode == 200) {
        final shipments = Shipment.fromJsonList(json.decode(response.body));
        state = state.copyWith(
          shipments: shipments,
          errorMessage: shipments.isEmpty ? 'No shipments found' : null,
        );
      } else {
        throw Exception('Failed to load shipments');
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: _parseErrorMessage(e, 'Error fetching shipments'),
        shipments: [],
      );
      _logger.e('Fetch shipments error: ${state.errorMessage}');
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchRecentShipments({int limit = 5}) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await http.get(
          Uri.parse('http://localhost:5001/api/shipments/recent?limit=$limit'));
      if (response.statusCode == 200) {
        final recentShipments =
            Shipment.fromJsonList(json.decode(response.body));
        state = state.copyWith(
          recentShipments: recentShipments,
          errorMessage:
              recentShipments.isEmpty ? 'No recent shipments found' : null,
        );
      } else {
        throw Exception('Failed to load recent shipments');
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: _parseErrorMessage(e, 'Error fetching recent shipments'),
        recentShipments: [],
      );
      _logger.e('Fetch recent shipments error: ${state.errorMessage}');
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> addShipment(Shipment shipment) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await http.post(
        Uri.parse('http://localhost:5001/api/shipments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(shipment.toJson()),
      );

      if (response.statusCode == 201) {
        final newShipment = Shipment.fromJson(json.decode(response.body));
        state = state.copyWith(
          shipments: [newShipment, ...state.shipments],
          errorMessage: null,
        );
        await fetchRecentShipments();
        return true;
      } else {
        throw Exception('Failed to add shipment');
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: _parseErrorMessage(e, 'Error adding shipment'),
      );
      _logger.e('Add shipment error: ${state.errorMessage}');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> updateShipment(Shipment shipment) async {
    try {
      if (shipment.id == null) {
        state =
            state.copyWith(errorMessage: 'Cannot update shipment without ID');
        return false;
      }

      state = state.copyWith(isLoading: true);

      final response = await http.patch(
        Uri.parse('http://localhost:5001/api/shipments/${shipment.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(shipment.toJson()),
      );

      if (response.statusCode == 200) {
        final updatedShipment = Shipment.fromJson(json.decode(response.body));
        state = state.copyWith(
          shipments: state.shipments
              .map((s) => s.id == shipment.id ? updatedShipment : s)
              .toList(),
          errorMessage: null,
        );
        await fetchRecentShipments();
        return true;
      } else {
        throw Exception('Failed to update shipment');
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: _parseErrorMessage(e, 'Error updating shipment'),
      );
      _logger.e(
          'Update shipment error for ID ${shipment.id}: ${state.errorMessage}');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> deleteShipment(Shipment shipment) async {
    try {
      if (shipment.id == null) {
        state =
            state.copyWith(errorMessage: 'Cannot delete shipment without ID');
        return false;
      }

      state = state.copyWith(isLoading: true);

      final response = await http.delete(
        Uri.parse('http://localhost:5001/api/shipments/${shipment.id}'),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(
          shipments: state.shipments.where((s) => s.id != shipment.id).toList(),
          errorMessage: null,
        );
        await fetchRecentShipments();
        return true;
      } else {
        throw Exception('Failed to delete shipment');
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: _parseErrorMessage(e, 'Error deleting shipment'),
      );
      _logger.e(
          'Delete shipment error for ID ${shipment.id}: ${state.errorMessage}');
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  String _parseErrorMessage(dynamic error, String defaultMessage) {
    if (error.toString().contains('404')) {
      return 'Resource not found. Please refresh and try again.';
    } else if (error.toString().contains('connection') ||
        error.toString().contains('Network is unreachable')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.toString().contains('timed out')) {
      return 'Request timed out. Please try again.';
    } else if (error.toString().contains('empty') ||
        error.toString().contains('No shipments')) {
      return 'No shipments available.';
    }
    return '$defaultMessage: ${error.toString().replaceAll('Exception: ', '')}';
  }
}
