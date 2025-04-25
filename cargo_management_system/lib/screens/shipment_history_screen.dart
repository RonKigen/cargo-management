import 'package:flutter/material.dart';

class ShipmentHistoryScreen extends StatefulWidget {
  const ShipmentHistoryScreen({super.key});

  @override
  State<ShipmentHistoryScreen> createState() => _ShipmentHistoryScreenState();
}

class _ShipmentHistoryScreenState extends State<ShipmentHistoryScreen> {
  final List<ShipmentData> _shipments = [
    ShipmentData(
      id: 'SHIP123456',
      origin: 'New York, NY',
      destination: 'Los Angeles, CA',
      date: '2025-03-15',
      status: 'Delivered',
      statusColor: Colors.green,
    ),
    ShipmentData(
      id: 'SHIP654321',
      origin: 'Chicago, IL',
      destination: 'Miami, FL',
      date: '2025-03-10',
      status: 'In Transit',
      statusColor: Colors.blue,
    ),
    ShipmentData(
      id: 'SHIP789012',
      origin: 'Seattle, WA',
      destination: 'Boston, MA',
      date: '2025-03-05',
      status: 'Delayed',
      statusColor: Colors.orange,
    ),
    ShipmentData(
      id: 'SHIP456789',
      origin: 'Austin, TX',
      destination: 'Denver, CO',
      date: '2025-02-28',
      status: 'Delivered',
      statusColor: Colors.green,
    ),
    ShipmentData(
      id: 'SHIP987654',
      origin: 'Portland, OR',
      destination: 'Nashville, TN',
      date: '2025-02-20',
      status: 'Delivered',
      statusColor: Colors.green,
    ),
  ];

  String _filterStatus = 'All';
  final List<String> _statusOptions = [
    'All',
    'Delivered',
    'In Transit',
    'Delayed',
    'Cancelled'
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ShipmentData> filteredShipments = _shipments
        .where((shipment) =>
            (_filterStatus == 'All' || shipment.status == _filterStatus) &&
            (shipment.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                shipment.origin
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                shipment.destination
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase())))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shipment History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: filteredShipments.isEmpty
                ? const Center(
                    child: Text('No shipments found'),
                  )
                : ListView.builder(
                    itemCount: filteredShipments.length,
                    itemBuilder: (context, index) {
                      return _buildShipmentCard(filteredShipments[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by ID, origin, or destination',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _statusOptions.length,
        itemBuilder: (context, index) {
          final status = _statusOptions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              selected: _filterStatus == status,
              label: Text(status),
              onSelected: (selected) {
                setState(() {
                  _filterStatus = status;
                });
              },
              selectedColor: Theme.of(context)
                  .primaryColor
                  .withAlpha(51), // Fixed deprecated withOpacity(0.2)
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShipmentCard(ShipmentData shipment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          _showShipmentDetails(shipment);
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    shipment.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Chip(
                    label: Text(
                      shipment.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    backgroundColor: shipment.statusColor,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16.0, color: Colors.grey),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'From: ${shipment.origin}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.flag_outlined,
                      size: 16.0, color: Colors.grey),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'To: ${shipment.destination}',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16.0, color: Colors.grey),
                  const SizedBox(width: 8.0),
                  Text(
                    'Date: ${shipment.date}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShipmentDetails(ShipmentData shipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipment Details',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16.0),
            _detailRow('Tracking Number', shipment.id),
            _detailRow('Status', shipment.status,
                valueColor: shipment.statusColor),
            _detailRow('Shipment Date', shipment.date),
            _detailRow('Origin', shipment.origin),
            _detailRow('Destination', shipment.destination),
            const SizedBox(height: 24.0),
            const Text(
              'Tracking History',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _buildTrackingTimeline(shipment),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement download invoice functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invoice downloaded'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Download Invoice'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(ShipmentData shipment) {
    final List<TrackingEvent> events = _generateTrackingEvents(shipment);

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isLastItem = index == events.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 16.0,
                  height: 16.0,
                  decoration: BoxDecoration(
                    color: event.color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLastItem)
                  Container(
                    width: 2.0,
                    height: 50.0,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    event.location,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    event.time,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<TrackingEvent> _generateTrackingEvents(ShipmentData shipment) {
    final List<TrackingEvent> events = [];

    switch (shipment.status) {
      case 'Delivered':
        events.add(
          TrackingEvent(
            title: 'Delivered',
            location: shipment.destination,
            time: '${shipment.date} 14:30',
            color: Colors.green,
          ),
        );
        events.add(
          TrackingEvent(
            title: 'Out for Delivery',
            location: 'Local Delivery Facility',
            time: '${shipment.date} 09:15',
            color: Colors.blue,
          ),
        );
        events.add(
          TrackingEvent(
            title: 'Arrived at Destination',
            location: shipment.destination.split(',')[0],
            time:
                '${shipment.date.split('-')[0]}-${shipment.date.split('-')[1]}-${int.parse(shipment.date.split('-')[2]) - 1} 18:45',
            color: Colors.blue,
          ),
        );
        events.add(
          TrackingEvent(
            title: 'In Transit',
            location: 'Regional Hub',
            time:
                '${shipment.date.split('-')[0]}-${shipment.date.split('-')[1]}-${int.parse(shipment.date.split('-')[2]) - 2} 10:30',
            color: Colors.blue,
          ),
        );
        events.add(
          TrackingEvent(
            title: 'Shipped',
            location: shipment.origin,
            time:
                '${shipment.date.split('-')[0]}-${shipment.date.split('-')[1]}-${int.parse(shipment.date.split('-')[2]) - 3} 15:20',
            color: Colors.blue,
          ),
        );
        break;
      case 'In Transit':
        events.add(
          TrackingEvent(
            title: 'In Transit',
            location: 'Regional Hub',
            time: '${shipment.date} 10:30',
            color: Colors.blue,
          ),
        );
        events.add(
          TrackingEvent(
            title: 'Shipped',
            location: shipment.origin,
            time:
                '${shipment.date.split('-')[0]}-${shipment.date.split('-')[1]}-${int.parse(shipment.date.split('-')[2]) - 1} 15:20',
            color: Colors.blue,
          ),
        );
        break;
      case 'Delayed':
        events.add(
          TrackingEvent(
            title: 'Delayed',
            location: 'Regional Hub',
            time: '${shipment.date} 16:45',
            color: Colors.orange,
          ),
        );
        events.add(
          TrackingEvent(
            title: 'In Transit',
            location: 'Regional Hub',
            time: '${shipment.date} 10:30',
            color: Colors.blue,
          ),
        );
        events.add(
          TrackingEvent(
            title: 'Shipped',
            location: shipment.origin,
            time:
                '${shipment.date.split('-')[0]}-${shipment.date.split('-')[1]}-${int.parse(shipment.date.split('-')[2]) - 1} 15:20',
            color: Colors.blue,
          ),
        );
        break;
      default:
        events.add(
          TrackingEvent(
            title: shipment.status,
            location: shipment.origin,
            time: shipment.date,
            color: shipment.statusColor,
          ),
        );
    }

    return events;
  }
}

class ShipmentData {
  final String id;
  final String origin;
  final String destination;
  final String date;
  final String status;
  final Color statusColor;

  ShipmentData({
    required this.id,
    required this.origin,
    required this.destination,
    required this.date,
    required this.status,
    required this.statusColor,
  });
}

class TrackingEvent {
  final String title;
  final String location;
  final String time;
  final Color color;

  TrackingEvent({
    required this.title,
    required this.location,
    required this.time,
    required this.color,
  });
}
