import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_shipment_screen.dart';
import 'tracking_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart'; // Add this import for the profile screen
import 'settings_screen.dart'; // Add this import for the settings screen
import 'shipment_history_screen.dart'; // Add this import for the shipment history screen
import 'support_screen.dart'; // Add this import for the support screen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> _titles = [
    'Dashboard',
    'Add Shipment',
    'Track Shipment',
    'Reports'
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const AddShipmentScreen(),
      const TrackingScreen(),
      const ReportsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: ShipmentSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showNotificationsModal(context);
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(Icons.add_box),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              activeIcon: Icon(Icons.local_shipping),
              label: 'Track',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Reports',
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 1
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              backgroundColor: Theme.of(context).primaryColor,
              tooltip: 'Add New Shipment',
              child: const Icon(Icons.add),
            ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'John Smith',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Logistics Manager',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.account_circle, 'Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }),
          _buildDrawerItem(Icons.settings, 'Settings', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          }),
          const Divider(),
          _buildDrawerItem(Icons.history, 'Shipment History', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ShipmentHistoryScreen()),
            );
          }),
          _buildDrawerItem(Icons.support_agent, 'Support', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SupportScreen()),
            );
          }),
          const Divider(),
          _buildDrawerItem(Icons.logout, 'Logout', () {
            // Implement logout functionality here
            _logout(context);
          }),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text('No new notifications'),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Implement logout logic here
    // For example, clear user session and navigate to login screen
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

class ShipmentSearchDelegate extends SearchDelegate<String> {
  final List<String> _recentSearches = [
    'SHIP123456',
    'SHIP654321',
    'SHIP789012'
  ];

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text('Results for "$query"'),
      );

  @override
  Widget buildSuggestions(BuildContext context) => ListView(
        children: _recentSearches
            .where((s) => s.contains(query))
            .map((s) => ListTile(
                  title: Text(s),
                  onTap: () {
                    query = s;
                    showResults(context);
                  },
                ))
            .toList(),
      );
}
