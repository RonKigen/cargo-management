import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:http/http.dart' as http;
import 'dart:convert';
// Removing import '../config/api_config.dart' since we're hardcoding the URL

class AddShipmentScreen extends StatefulWidget {
  const AddShipmentScreen({Key? key}) : super(key: key);

  @override
  State<AddShipmentScreen> createState() => _AddShipmentScreenState();
}

class _AddShipmentScreenState extends State<AddShipmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _trackingNumberController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _weightController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderContactController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _receiverContactController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _expectedDeliveryDate = DateTime.now().add(const Duration(days: 3));
  String _selectedShipmentType = 'Standard';
  String _selectedCarrier = 'In-house Fleet';
  bool _isFragile = false;
  bool _isUrgent = false;
  bool _isSaving = false;

  final List<String> _shipmentTypes = [
    'Standard',
    'Express',
    'Economy',
    'Overnight',
    'International'
  ];

  final List<String> _carriers = [
    'In-house Fleet',
    'FedEx',
    'UPS',
    'DHL',
    'USPS',
    'Other'
  ];

  @override
  void dispose() {
    _trackingNumberController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _weightController.dispose();
    _dimensionsController.dispose();
    _senderNameController.dispose();
    _senderContactController.dispose();
    _receiverNameController.dispose();
    _receiverContactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _generateTrackingNumber() {
    // Generate a random tracking number pattern
    const String prefix = 'CMPR-';
    final String timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13);
    final String suffix =
        (1000 + DateTime.now().millisecond).toString().substring(1);
    final String trackingNumber = '$prefix$timestamp-$suffix';

    setState(() {
      _trackingNumberController.text = trackingNumber;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        final shipmentData = {
          'trackingNumber': _trackingNumberController.text,
          'origin': _originController.text,
          'destination': _destinationController.text,
          'weight': double.parse(_weightController.text),
          'dimensions': _dimensionsController.text,
          'expectedDeliveryDate': _expectedDeliveryDate.toIso8601String(),
          'shipmentType': _selectedShipmentType,
          'carrier': _selectedCarrier,
          'isFragile': _isFragile,
          'isUrgent': _isUrgent,
          'senderName': _senderNameController.text,
          'senderContact': _senderContactController.text,
          'receiverName': _receiverNameController.text,
          'receiverContact': _receiverContactController.text,
          'notes': _notesController.text,
          'status': 'Pending',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        // Updated to use the hardcoded URL
        final response = await http.post(
          Uri.parse('http://localhost:5001/api/shipments'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(shipmentData),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Shipment ${_trackingNumberController.text} created successfully!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            _resetForm();
          }
        } else {
          throw Exception('Failed to add shipment: ${response.body}');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _trackingNumberController.clear();
    _originController.clear();
    _destinationController.clear();
    _weightController.clear();
    _dimensionsController.clear();
    _senderNameController.clear();
    _senderContactController.clear();
    _receiverNameController.clear();
    _receiverContactController.clear();
    _notesController.clear();

    setState(() {
      _expectedDeliveryDate = DateTime.now().add(const Duration(days: 3));
      _selectedShipmentType = 'Standard';
      _selectedCarrier = 'In-house Fleet';
      _isFragile = false;
      _isUrgent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Shipment'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Create New Shipment',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Tracking number with auto-generate option
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _trackingNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Tracking Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.qr_code),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a tracking number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _generateTrackingNumber,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  child: const Text('Generate'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Shipment type and carrier selection
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedShipmentType,
                    decoration: const InputDecoration(
                      labelText: 'Shipment Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _shipmentTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedShipmentType = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a shipment type';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCarrier,
                    decoration: const InputDecoration(
                      labelText: 'Carrier',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_shipping),
                    ),
                    items: _carriers.map((String carrier) {
                      return DropdownMenuItem<String>(
                        value: carrier,
                        child: Text(carrier),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCarrier = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a carrier';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Origin and destination
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _originController,
                    decoration: const InputDecoration(
                      labelText: 'Origin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter origin';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flag),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter destination';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weight and dimensions
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.scale),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter weight';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _dimensionsController,
                    decoration: const InputDecoration(
                      labelText: 'Dimensions (LxWxH cm)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.straighten),
                      hintText: '30x20x15',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter dimensions';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expected delivery date selector
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _expectedDeliveryDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null &&
                    picked != _expectedDeliveryDate &&
                    mounted) {
                  setState(() {
                    _expectedDeliveryDate = picked;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Expected Delivery Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                  controller: TextEditingController(
                    text: '${_expectedDeliveryDate.toLocal()}'.split(' ')[0],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select expected delivery date';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Special handling options
            const Text(
              'Special Handling',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Fragile'),
                    value: _isFragile,
                    onChanged: (bool? value) {
                      setState(() {
                        _isFragile = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Urgent'),
                    value: _isUrgent,
                    onChanged: (bool? value) {
                      setState(() {
                        _isUrgent = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sender information
            const Text(
              'Sender Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _senderNameController,
              decoration: const InputDecoration(
                labelText: 'Sender Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter sender name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _senderContactController,
              decoration: const InputDecoration(
                labelText: 'Sender Contact',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                hintText: 'Phone or Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter sender contact';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Receiver information
            const Text(
              'Receiver Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _receiverNameController,
              decoration: const InputDecoration(
                labelText: 'Receiver Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter receiver name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _receiverContactController,
              decoration: const InputDecoration(
                labelText: 'Receiver Contact',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                hintText: 'Phone or Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter receiver contact';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Additional notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
                hintText: 'Special instructions or requirements',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Submit and reset buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _submitForm,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: const Text('SAVE SHIPMENT'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _resetForm,
                  icon: const Icon(Icons.refresh),
                  label: const Text('RESET'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32), // Extra space at the bottom
          ],
        ),
      ),
    );
  }
}
