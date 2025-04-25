import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'providers/shipment_provider.dart';

void main() {
  runApp(
    // Wrap the app with ProviderScope to enable Riverpod
    const ProviderScope(
      child: CargoManagementApp(),
    ),
  );
}

class CargoManagementApp extends ConsumerStatefulWidget {
  const CargoManagementApp({super.key});

  @override
  ConsumerState<CargoManagementApp> createState() => _CargoManagementAppState();
}

class _CargoManagementAppState extends ConsumerState<CargoManagementApp> {
  Widget _initialScreen =
      const Scaffold(body: Center(child: CircularProgressIndicator()));

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (mounted) {
        setState(() {
          _initialScreen =
              token != null ? const HomePage() : const LoginScreen();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _initialScreen = const LoginScreen(); // Fallback to login on error
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the ref to initialize the shipment provider
    ref.read(shipmentProvider.notifier).initialize();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cargo Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1A4D8C),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1A4D8C),
          secondary: Color(0xFF3E8ED0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Roboto',
      ),
      home: _initialScreen,
    );
  }
}
