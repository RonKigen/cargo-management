import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state variables
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _darkMode = false;
  String _distanceUnit = 'Kilometers';
  String _language = 'English';
  bool _locationTracking = true;
  bool _autoRefresh = true;
  double _refreshInterval = 5.0; // Minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSettingsSection('Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive updates on shipment status'),
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive summary reports via email'),
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          _buildSettingsSection('Display'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme throughout the app'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
                // In a real app, you'd apply theme change here
              });
            },
          ),
          _buildSettingsSection('Preferences'),
          ListTile(
            title: const Text('Distance Unit'),
            subtitle: Text(_distanceUnit),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showUnitSelectionDialog();
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageSelectionDialog();
            },
          ),
          _buildSettingsSection('Privacy'),
          SwitchListTile(
            title: const Text('Location Tracking'),
            subtitle: const Text('Allow location tracking for shipments'),
            value: _locationTracking,
            onChanged: (value) {
              setState(() {
                _locationTracking = value;
              });
            },
          ),
          _buildSettingsSection('Data Usage'),
          SwitchListTile(
            title: const Text('Auto Refresh'),
            subtitle: const Text('Automatically refresh shipment data'),
            value: _autoRefresh,
            onChanged: (value) {
              setState(() {
                _autoRefresh = value;
              });
            },
          ),
          if (_autoRefresh)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Refresh Interval: ${_refreshInterval.toStringAsFixed(1)} minutes',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Slider(
                    min: 1.0,
                    max: 30.0,
                    divisions: 29,
                    value: _refreshInterval,
                    onChanged: (value) {
                      setState(() {
                        _refreshInterval = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          _buildSettingsSection('Account'),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change Password'),
            onTap: () {
              _showChangePasswordDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear App Data'),
            onTap: () {
              _showClearDataConfirmation();
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'App Version: 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              letterSpacing: 1.0,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _showUnitSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Distance Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Kilometers'),
              value: 'Kilometers',
              groupValue: _distanceUnit,
              onChanged: (value) {
                setState(() {
                  _distanceUnit = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Miles'),
              value: 'Miles',
              groupValue: _distanceUnit,
              onChanged: (value) {
                setState(() {
                  _distanceUnit = value!;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Spanish'),
              value: 'Spanish',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('French'),
              value: 'French',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('German'),
              value: 'German',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration:
                  const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // Implement password change logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully')),
              );
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _showClearDataConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear App Data'),
        content: const Text(
            'This will clear all cached data and preferences. This action cannot be undone. Are you sure you want to continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // Implement data clearing logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App data cleared')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }
}
