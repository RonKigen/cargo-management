import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _trackingController = TextEditingController();
  bool _isTracking = false;
  String? _trackingNumber;

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  void _trackShipment() {
    if (_trackingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a tracking number')),
      );
      return;
    }

    setState(() {
      _isTracking = true;
      _trackingNumber = _trackingController.text;
    });

    // In a real app, you would make an API call here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Shipment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show tracking history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Viewing tracking history')),
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
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Enter your tracking number',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _trackingController,
                        decoration: InputDecoration(
                          hintText: 'e.g. SHIP1234567890',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            onPressed: () {
                              // Scan QR code
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('QR scanner opened')),
                              );
                            },
                          ),
                        ),
                        onSubmitted: (_) => _trackShipment(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _trackShipment,
                          child: const Text('Track Shipment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_isTracking) ...[
                Text(
                  'Tracking Details for $_trackingNumber',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildTrackingTimeline(),
                const SizedBox(height: 24),
                _buildShipmentDetails(),
              ] else ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Enter a tracking number to see shipment details',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    final steps = [
      {
        'status': 'Order Placed',
        'date': 'Mar 5, 2025',
        'time': '09:45 AM',
        'completed': true,
      },
      {
        'status': 'Processing',
        'date': 'Mar 6, 2025',
        'time': '10:30 AM',
        'completed': true,
      },
      {
        'status': 'Shipped',
        'date': 'Mar 7, 2025',
        'time': '02:15 PM',
        'completed': true,
      },
      {
        'status': 'Out for Delivery',
        'date': 'Mar 9, 2025',
        'time': '08:20 AM',
        'completed': true,
      },
      {
        'status': 'Delivered',
        'date': 'Expected: Mar 9, 2025',
        'time': 'By 8:00 PM',
        'completed': false,
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(steps.length, (index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: step['completed'] as bool
                            ? Colors.green
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: step['completed'] as bool
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        color: step['completed'] as bool
                            ? Colors.green
                            : Colors.grey,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['status'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: step['completed'] as bool
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${step['date']} at ${step['time']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: step['completed'] as bool
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                      if (!isLast) const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildShipmentDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipment Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Carrier', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text('Express Shipping Co.'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Service', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text('Priority Delivery'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Origin', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text('New York, NY'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Destination', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Text('San Francisco, CA'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Shipment Contents',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            const Text('1 × Package (3.5 lbs)'),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.support_agent),
                label: const Text('Contact Support'),
                onPressed: () {
                  // Contact support
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contacting support...')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
