import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Changed to Riverpod
import '../providers/shipment_provider.dart';
import '../models/shipment.dart';

class ReportsScreen extends ConsumerWidget {
  // Changed to ConsumerWidget
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef parameter
    final shipmentState = ref.watch(shipmentProvider); // Using Riverpod's watch
    final shipments = shipmentState.shipments;

    // Calculate statistics based on the shipments
    final statistics = _calculateStatistics(shipments);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipment Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh data using Riverpod
              ref.read(shipmentProvider.notifier).fetchShipments();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing reports...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildFilterSheet(context),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(context, statistics),
              const SizedBox(height: 20),
              const Text(
                'Shipment Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatusCards(context, statistics),
              const SizedBox(height: 24),
              _buildExportButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Build the summary card
  Widget _buildSummaryCard(BuildContext context, Map<String, int> statistics) {
    final totalShipments = statistics['total'] ?? 0;
    final deliveredShipments = statistics['delivered'] ?? 0;
    final progress =
        totalShipments > 0 ? deliveredShipments / totalShipments : 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Shipments',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '$totalShipments',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.toDouble(),
              backgroundColor: Colors.grey,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% of shipments delivered',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Build the status cards
  Widget _buildStatusCards(BuildContext context, Map<String, int> statistics) {
    final statuses = [
      {
        'label': 'In Transit',
        'count': statistics['inTransit']?.toString() ?? '0',
        'color': Colors.blue,
        'icon': Icons.local_shipping
      },
      {
        'label': 'Delivered',
        'count': statistics['delivered']?.toString() ?? '0',
        'color': Colors.green,
        'icon': Icons.check_circle
      },
      {
        'label': 'Processing',
        'count': statistics['processing']?.toString() ?? '0',
        'color': Colors.orange,
        'icon': Icons.hourglass_bottom
      },
      {
        'label': 'Delayed',
        'count': statistics['delayed']?.toString() ?? '0',
        'color': Colors.red,
        'icon': Icons.warning
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        final status = statuses[index];
        return Card(
          elevation: 2,
          color: status['color'] as Color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            onTap: () {
              // Navigate to cargo detail screen for this status
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CargoListScreen(
                    status: status['label'] as String,
                    statusColor: status['color'] as Color,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    status['icon'] as IconData,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status['label'] as String,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    status['count'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build the export button
  Widget _buildExportButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.download),
        label: const Text('Export Report'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () {
          // Handle export
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exporting report...')),
          );
        },
      ),
    );
  }

  // Build the filter sheet
  Widget _buildFilterSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Reports',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Date Range'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Last 7 days'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Last 30 days'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Status'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('In Transit'),
                selected: true,
                onSelected: (bool selected) {
                  // Handle selection
                },
              ),
              FilterChip(
                label: const Text('Delivered'),
                selected: true,
                onSelected: (bool selected) {
                  // Handle selection
                },
              ),
              FilterChip(
                label: const Text('Processing'),
                selected: true,
                onSelected: (bool selected) {
                  // Handle selection
                },
              ),
              FilterChip(
                label: const Text('Delayed'),
                selected: true,
                onSelected: (bool selected) {
                  // Handle selection
                },
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Reset'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filters applied')),
                  );
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Calculate statistics based on the shipments
  Map<String, int> _calculateStatistics(List<Shipment> shipments) {
    int total = shipments.length;
    int inTransit = shipments.where((s) => s.status == 'In Transit').length;
    int delivered = shipments.where((s) => s.status == 'Delivered').length;
    int processing = shipments.where((s) => s.status == 'Processing').length;
    int delayed = shipments.where((s) => s.status == 'Delayed').length;

    return {
      'total': total,
      'inTransit': inTransit,
      'delivered': delivered,
      'processing': processing,
      'delayed': delayed,
    };
  }
}

// New screen to display cargo items based on status
class CargoListScreen extends ConsumerWidget {
  final String status;
  final Color statusColor;

  const CargoListScreen({
    Key? key,
    required this.status,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipmentState = ref.watch(shipmentProvider);
    final shipments =
        shipmentState.shipments.where((s) => s.status == status).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$status Shipments'),
        backgroundColor: statusColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: shipments.length,
        itemBuilder: (context, index) {
          final shipment = shipments[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                _getIconForStatus(status),
                color: statusColor,
              ),
              title: Text(shipment.trackingNumber),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From: ${shipment.origin}'),
                  Text('To: ${shipment.destination}'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    shipment.createdAt.toString().substring(0, 10),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shipment.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          status == 'Delivered' ? Colors.green : Colors.black,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CargoDetailScreen(
                      shipment: shipment,
                      status: status,
                      statusColor: statusColor,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'In Transit':
        return Icons.local_shipping;
      case 'Delivered':
        return Icons.check_circle;
      case 'Processing':
        return Icons.hourglass_bottom;
      case 'Delayed':
        return Icons.warning;
      default:
        return Icons.inventory;
    }
  }
}

// New screen to display detailed cargo information
class CargoDetailScreen extends StatelessWidget {
  final Shipment shipment;
  final String status;
  final Color statusColor;

  const CargoDetailScreen({
    Key? key,
    required this.shipment,
    required this.status,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipment ${shipment.trackingNumber}'),
        backgroundColor: statusColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBar(context),
            _buildShipmentDetails(context, shipment),
            _buildRouteMap(context),
            _buildTrackingHistory(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Sharing shipment details...')),
                  );
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.support_agent),
                label: const Text('Support'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contacting support...')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'In Transit':
        statusIcon = Icons.local_shipping;
        statusText = 'Shipment is in transit';
        break;
      case 'Delivered':
        statusIcon = Icons.check_circle;
        statusText = 'Shipment has been delivered';
        break;
      case 'Processing':
        statusIcon = Icons.hourglass_bottom;
        statusText = 'Shipment is being processed';
        break;
      case 'Delayed':
        statusIcon = Icons.warning;
        statusText = 'Shipment is delayed';
        break;
      default:
        statusIcon = Icons.inventory;
        statusText = 'Shipment status unknown';
    }

    return Container(
      color: statusColor.withAlpha((0.1 * 255).toInt()),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontSize: 18,
                ),
              ),
              Text(
                statusText,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentDetails(BuildContext context, Shipment shipment) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipment Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Origin', shipment.origin),
              _buildDetailRow('Destination', shipment.destination),
              _buildDetailRow(
                  'Ship Date', shipment.createdAt.toString().substring(0, 10)),
              _buildDetailRow('Estimated Arrival',
                  shipment.arrivalDate?.toString().substring(0, 10) ?? 'N/A'),
              _buildDetailRow('Service Type', 'Standard'),
              _buildDetailRow('Weight', '${shipment.weight} kg'),
              _buildDetailRow('Dimensions', 'N/A'),
              _buildDetailRow('Tracking Number', shipment.trackingNumber),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Route Map',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Text('Route Map Placeholder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingHistory(BuildContext context) {
    final events = _getMockTrackingEvents();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tracking History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final bool isLast = index == events.length - 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Text(
                                event['date']!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                event['time']!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color:
                                    index == 0 ? statusColor : Colors.grey[400],
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: VerticalDivider(
                                  color: Colors.grey[400],
                                  width: 20,
                                  thickness: 2,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['status']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      index == 0 ? statusColor : Colors.black,
                                ),
                              ),
                              Text(
                                event['location']!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getMockTrackingEvents() {
    switch (status) {
      case 'In Transit':
        return [
          {
            'date': '2025-03-17',
            'time': '09:45',
            'status': 'In Transit',
            'location': 'International Sorting Center, Frankfurt, Germany'
          },
          {
            'date': '2025-03-16',
            'time': '18:30',
            'status': 'Departed Facility',
            'location': 'JFK International Airport, New York, USA'
          },
          {
            'date': '2025-03-15',
            'time': '14:20',
            'status': 'Processing at Origin',
            'location': 'Sorting Facility, New York, USA'
          },
          {
            'date': '2025-03-15',
            'time': '08:00',
            'status': 'Shipment Created',
            'location': 'New York, USA'
          },
        ];
      case 'Delivered':
        return [
          {
            'date': '2025-03-18',
            'time': '14:30',
            'status': 'Delivered',
            'location': 'London, UK'
          },
          {
            'date': '2025-03-18',
            'time': '09:15',
            'status': 'Out for Delivery',
            'location': 'Local Delivery Facility, London, UK'
          },
          {
            'date': '2025-03-17',
            'time': '18:40',
            'status': 'Arrived at Destination',
            'location': 'Heathrow Airport, London, UK'
          },
          {
            'date': '2025-03-16',
            'time': '08:30',
            'status': 'Departed Facility',
            'location': 'JFK International Airport, New York, USA'
          },
          {
            'date': '2025-03-15',
            'time': '14:20',
            'status': 'Processing at Origin',
            'location': 'Sorting Facility, New York, USA'
          },
          {
            'date': '2025-03-15',
            'time': '08:00',
            'status': 'Shipment Created',
            'location': 'New York, USA'
          },
        ];
      case 'Processing':
        return [
          {
            'date': '2025-03-18',
            'time': '10:00',
            'status': 'Processing',
            'location': 'Sorting Facility, New York, USA'
          },
          {
            'date': '2025-03-18',
            'time': '08:00',
            'status': 'Shipment Created',
            'location': 'New York, USA'
          },
        ];
      case 'Delayed':
        return [
          {
            'date': '2025-03-17',
            'time': '16:20',
            'status': 'Delayed - Weather Conditions',
            'location': 'JFK International Airport, New York, USA'
          },
          {
            'date': '2025-03-16',
            'time': '14:30',
            'status': 'Processing at Origin',
            'location': 'Sorting Facility, New York, USA'
          },
          {
            'date': '2025-03-15',
            'time': '09:00',
            'status': 'Shipment Created',
            'location': 'New York, USA'
          },
        ];
      default:
        return [];
    }
  }
}
