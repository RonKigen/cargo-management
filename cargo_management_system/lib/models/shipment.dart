import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer' as dev;

class Shipment {
  final ObjectId? id;
  final String trackingNumber;
  final String origin;
  final String destination;
  final String status;
  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final String? description;
  final double weight;
  final String customerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shipment({
    this.id,
    required this.trackingNumber,
    required this.origin,
    required this.destination,
    required this.status,
    this.departureDate,
    this.arrivalDate,
    this.description,
    required this.weight,
    required this.customerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    dev.log('Parsing Shipment JSON: $json', name: 'Shipment.fromJson');

    try {
      return Shipment(
        id: _parseObjectId(json['_id']),
        trackingNumber: _parseString(json, 'trackingNumber'),
        origin: _parseString(json, 'origin'),
        destination: _parseString(json, 'destination'),
        status: _parseString(json, 'status'),
        departureDate: _parseDateTime(json['departureDate']),
        arrivalDate: _parseDateTime(json['arrivalDate']),
        description: json['description']?.toString(),
        weight: _parseDouble(json, 'weight'),
        customerId: _parseString(json, 'customerId'),
        createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
        updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
      );
    } catch (e) {
      dev.log('Error in Shipment.fromJson: $e', name: 'Shipment.fromJson');
      rethrow;
    }
  }

  // Add this method to support list conversion
  static List<Shipment> fromJsonList(List<dynamic> jsonList) {
    try {
      return jsonList.map((json) => Shipment.fromJson(json)).toList();
    } catch (e) {
      dev.log('Error in Shipment.fromJsonList: $e',
          name: 'Shipment.fromJsonList');
      rethrow;
    }
  }

  static ObjectId? _parseObjectId(dynamic id) {
    try {
      if (id is ObjectId) return id;
      if (id is String) return ObjectId.fromHexString(id);
      if (id is Map && id['\$oid'] is String) {
        return ObjectId.fromHexString(id['\$oid']);
      }
      return null;
    } catch (e) {
      dev.log('Error parsing ObjectId: $e', name: 'Shipment._parseObjectId');
      return null;
    }
  }

  static DateTime? _parseDateTime(dynamic date) {
    try {
      if (date == null) return null;
      if (date is DateTime) return date;
      if (date is String) return DateTime.tryParse(date);
      return null;
    } catch (e) {
      dev.log('Error parsing DateTime: $e', name: 'Shipment._parseDateTime');
      return null;
    }
  }

  static String _parseString(Map<String, dynamic> json, String key,
      {String defaultValue = ''}) {
    try {
      final value = json[key];
      if (value == null) {
        dev.log('Null value for key: $key', name: 'Shipment._parseString');
        return defaultValue;
      }
      return value.toString();
    } catch (e) {
      dev.log('Error parsing string for key $key: $e',
          name: 'Shipment._parseString');
      return defaultValue;
    }
  }

  static double _parseDouble(Map<String, dynamic> json, String key,
      {double defaultValue = 0.0}) {
    try {
      final value = json[key];
      if (value == null) {
        dev.log('Null value for key: $key', name: 'Shipment._parseDouble');
        return defaultValue;
      }
      return (value is num) ? value.toDouble() : defaultValue;
    } catch (e) {
      dev.log('Error parsing double for key $key: $e',
          name: 'Shipment._parseDouble');
      return defaultValue;
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'trackingNumber': trackingNumber,
      'origin': origin,
      'destination': destination,
      'status': status,
      'weight': weight,
      'customerId': customerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };

    if (id != null) {
      map['_id'] = id!.toHexString();
    }
    if (departureDate != null) {
      map['departureDate'] = departureDate!.toIso8601String();
    }
    if (arrivalDate != null) {
      map['arrivalDate'] = arrivalDate!.toIso8601String();
    }
    if (description != null) {
      map['description'] = description;
    }

    return map;
  }

  String get idString => id?.toHexString() ?? '';

  @override
  String toString() => 'Shipment(${toJson()})';

  // Optional: Add a copyWith method for easier updates
  Shipment copyWith({
    ObjectId? id,
    String? trackingNumber,
    String? origin,
    String? destination,
    String? status,
    DateTime? departureDate,
    DateTime? arrivalDate,
    String? description,
    double? weight,
    String? customerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Shipment(
      id: id ?? this.id,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      status: status ?? this.status,
      departureDate: departureDate ?? this.departureDate,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      customerId: customerId ?? this.customerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
