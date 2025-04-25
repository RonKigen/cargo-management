import 'package:flutter/material.dart';
import '../models/shipment.dart';

class ShipmentCard extends StatelessWidget {
  final Shipment shipment;

  const ShipmentCard({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(shipment.trackingNumber),
        subtitle: Text(shipment.destination),
        trailing: Text(shipment.status),
      ),
    );
  }
}
