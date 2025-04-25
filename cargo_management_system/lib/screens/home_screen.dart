import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shipment_provider.dart';
import '../models/shipment.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(shipmentProvider.notifier).fetchShipments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shipmentState = ref.watch(shipmentProvider);
    final shipments = shipmentState.shipments;

    final statistics = _calculateStatistics(shipments);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(shipmentProvider.notifier).fetchShipments();
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Welcome and date section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, Admin',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dashboard overview',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    DateTime.now().toString().substring(0, 10),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  avatar: const Icon(Icons.calendar_today, size: 16),
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    Icons.add_box,
                    'New Shipment',
                    Colors.blue,
                    _showShipmentForm,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context,
                    Icons.search,
                    'Track Cargo',
                    Colors.orange,
                    _showTrackingForm,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context,
                    Icons.inventory,
                    'Inventory',
                    Colors.green,
                    _showInventoryDetails,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Shipment statistics
            const Text(
              'Shipment Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Shipments',
                    statistics['total'].toString(),
                    Icons.inventory_2,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'In Transit',
                    statistics['inTransit'].toString(),
                    Icons.local_shipping,
                    Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Delivered',
                    statistics['delivered'].toString(),
                    Icons.done_all,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Delayed',
                    statistics['delayed'].toString(),
                    Icons.report_problem,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent activities
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < shipments.length; i++)
              _buildActivityItem(
                context,
                'Shipment #${shipments[i].trackingNumber}',
                shipments[i].status,
                shipments[i].createdAt.toString(),
                _getStatusColor(shipments[i].status),
                i,
              ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _calculateStatistics(List<Shipment> shipments) {
    int total = shipments.length;
    int inTransit = shipments.where((s) => s.status.contains('Transit')).length;
    int delivered =
        shipments.where((s) => s.status.contains('Delivered')).length;
    int delayed = shipments.where((s) => s.status.contains('Delayed')).length;

    return {
      'total': total,
      'inTransit': inTransit,
      'delivered': delivered,
      'delayed': delayed,
    };
  }

  Color _getStatusColor(String status) {
    if (status.contains('Delivered')) {
      return Colors.green;
    } else if (status.contains('Transit')) {
      return Colors.amber;
    } else if (status.contains('Processing')) {
      return Colors.blue;
    } else if (status.contains('Delayed')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Color.fromRGBO(
                  color.r.toInt(),
                  color.g.toInt(),
                  color.b.toInt(),
                  0.2,
                ),
                radius: 20,
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color.fromRGBO(
                color.r.toInt(),
                color.g.toInt(),
                color.b.toInt(),
                0.2,
              ),
              radius: 24,
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String title, String subtitle,
      String time, Color color, int index) {
    final shipment = ref.watch(shipmentProvider).shipments[index];

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(
            color.r.toInt(),
            color.g.toInt(),
            color.b.toInt(),
            0.2,
          ),
          child: Icon(
            _getIconForStatus(shipment.status),
            color: _getStatusColor(shipment.status),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 2),
            Text(
              time.substring(0, 10),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'update') {
              _updateShipmentStatus(index);
            } else if (value == 'delete') {
              _removeShipment(index);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'update',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Update Status'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForStatus(String status) {
    if (status.contains('Delivered')) {
      return Icons.done_all;
    } else if (status.contains('Transit')) {
      return Icons.local_shipping;
    } else if (status.contains('Processing')) {
      return Icons.inventory;
    } else if (status.contains('Delayed')) {
      return Icons.report_problem;
    }
    return Icons.local_shipping;
  }

  void _showShipmentForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Shipment'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tracking Number',
                prefixText: 'SH',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Origin',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Destination',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Weight',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Add Shipment'),
          ),
        ],
      ),
    );
  }

  void _showTrackingForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Track Cargo'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tracking Number',
                prefixText: 'SH',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Track'),
          ),
        ],
      ),
    );
  }

  void _showInventoryDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inventory Status'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.inventory_2, color: Colors.blue),
              title: Text('Available Containers'),
              trailing:
                  Text('24', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.inventory_2, color: Colors.amber),
              title: Text('Reserved Containers'),
              trailing:
                  Text('12', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.inventory_2, color: Colors.green),
              title: Text('Total Capacity'),
              trailing:
                  Text('50', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.warehouse, color: Colors.purple),
              title: Text('Warehouse Utilization'),
              trailing:
                  Text('72%', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  void _updateShipmentStatus(int index) {
    final shipment = ref.read(shipmentProvider).shipments[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Shipment Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Shipment #${shipment.trackingNumber}'),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('In Transit'),
              leading: const Icon(Icons.local_shipping, color: Colors.amber),
              onTap: () {
                _updateShipmentStatusInProvider(shipment, 'In Transit');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Processing'),
              leading: const Icon(Icons.inventory, color: Colors.blue),
              onTap: () {
                _updateShipmentStatusInProvider(shipment, 'Processing');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Delivered'),
              leading: const Icon(Icons.done_all, color: Colors.green),
              onTap: () {
                _updateShipmentStatusInProvider(shipment, 'Delivered');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Delayed'),
              leading: const Icon(Icons.report_problem, color: Colors.red),
              onTap: () {
                _updateShipmentStatusInProvider(shipment, 'Delayed');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateShipmentStatusInProvider(Shipment shipment, String newStatus) {
    final updatedShipment = Shipment(
      id: shipment.id,
      trackingNumber: shipment.trackingNumber,
      origin: shipment.origin,
      destination: shipment.destination,
      status: newStatus,
      departureDate: shipment.departureDate,
      arrivalDate: shipment.arrivalDate,
      description: shipment.description,
      weight: shipment.weight,
      customerId: shipment.customerId,
      createdAt: shipment.createdAt,
      updatedAt: DateTime.now(),
    );

    ref.read(shipmentProvider.notifier).updateShipment(updatedShipment);
    ref.read(shipmentProvider.notifier).fetchShipments();
  }

  void _removeShipment(int index) {
    final shipment = ref.read(shipmentProvider).shipments[index];
    ref.read(shipmentProvider.notifier).deleteShipment(shipment);
  }
}
