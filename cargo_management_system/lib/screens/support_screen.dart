import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I track my shipment?',
      'answer':
          'You can track your shipment by entering your tracking number in the Track section of the app, or by clicking on the shipment from your Dashboard or Shipment History.'
    },
    {
      'question': 'What should I do if my shipment is delayed?',
      'answer':
          'If your shipment is delayed, you can contact our customer support team through the Contact Us section below. Please have your tracking number ready.'
    },
    {
      'question': 'How do I add a new shipment?',
      'answer':
          'To add a new shipment, tap on the "Add" button in the bottom navigation bar or use the floating action button from any other screen.'
    },
    {
      'question':
          'Can I change the delivery address after creating a shipment?',
      'answer':
          'Yes, you can modify the delivery address for pending shipments. Navigate to the specific shipment details and select "Edit" to update the address.'
    },
    {
      'question': 'How do I generate shipping reports?',
      'answer':
          'You can generate custom shipping reports from the Reports section. Select the date range and filter options to create detailed shipment analytics.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Help Center Section
              _buildSectionHeader(context, 'Help Center'),
              const SizedBox(height: 16),
              _buildHelpCenter(),

              const SizedBox(height: 24),

              // FAQ Section
              _buildSectionHeader(context, 'Frequently Asked Questions'),
              const SizedBox(height: 16),
              _buildFAQs(),

              const SizedBox(height: 24),

              // Terms & Policies Section
              _buildSectionHeader(context, 'Terms & Policies'),
              const SizedBox(height: 16),
              _buildTermsAndPolicies(),

              const SizedBox(height: 24),

              // Contact Us Section
              _buildSectionHeader(context, 'Contact Us'),
              const SizedBox(height: 16),
              _buildContactUs(context),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
    );
  }

  Widget _buildHelpCenter() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(
                    Icons.help_outline,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need assistance?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "We're here to help you",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildHelpCenterButton(
              Icons.menu_book_outlined,
              'Knowledge Base',
              'Access guides & tutorials',
              () {},
            ),
            const Divider(height: 24),
            _buildHelpCenterButton(
              Icons.chat_outlined,
              'Live Chat',
              'Chat with our support team',
              () {},
            ),
            const Divider(height: 24),
            _buildHelpCenterButton(
              Icons.video_call_outlined,
              'Video Tutorial',
              'Watch how-to videos',
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCenterButton(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blue,
              size: 28,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQs() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ExpansionPanelList(
          elevation: 0,
          expandedHeaderPadding: EdgeInsets.zero,
          dividerColor: Colors.grey.shade200,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _faqs[index]['isExpanded'] = !isExpanded;
            });
          },
          children: _faqs.map<ExpansionPanel>((Map<String, dynamic> faq) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    faq['question'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  faq['answer'],
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              isExpanded: faq['isExpanded'] ?? false,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTermsAndPolicies() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTermsItem(
              Icons.description_outlined,
              'Terms of Service',
              'Last updated: March 1, 2025',
              () => _showTermsDialog(context, 'Terms of Service'),
            ),
            const Divider(height: 24),
            _buildTermsItem(
              Icons.policy_outlined,
              'Privacy Policy',
              'Last updated: February 15, 2025',
              () => _showTermsDialog(context, 'Privacy Policy'),
            ),
            const Divider(height: 24),
            _buildTermsItem(
              Icons.local_shipping_outlined,
              'Shipping Policy',
              'Last updated: January 20, 2025',
              () => _showTermsDialog(context, 'Shipping Policy'),
            ),
            const Divider(height: 24),
            _buildTermsItem(
              Icons.security_outlined,
              'Data Security',
              'Last updated: March 10, 2025',
              () => _showTermsDialog(context, 'Data Security'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsItem(
      IconData icon, String title, String lastUpdated, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade100,
              child: Icon(
                icon,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  lastUpdated,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(
              _getDummyText(title),
              style: const TextStyle(height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  String _getDummyText(String policyType) {
    switch (policyType) {
      case 'Terms of Service':
        return 'These Terms of Service ("Terms") govern your access to and use of our shipment tracking services. By using our services, you agree to be bound by these Terms. Our services are provided "as is" without warranties of any kind, either express or implied.\n\nYou are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. We reserve the right to modify these Terms at any time.';
      case 'Privacy Policy':
        return 'This Privacy Policy describes how we collect, use, and disclose your personal information when you use our shipment tracking services. We collect information such as your name, contact details, and shipment information to provide and improve our services.\n\nWe may share your information with carriers and logistics partners to facilitate shipment tracking. We implement reasonable security measures to protect your personal information.';
      case 'Shipping Policy':
        return 'Our Shipping Policy outlines the terms and conditions for shipping services provided through our platform. Shipping rates and delivery times vary based on the destination, package dimensions, weight, and shipping method selected.\n\nWe are not liable for any delays, damages, or losses that occur during transit. Package tracking information is provided as a courtesy and may not reflect real-time status.';
      case 'Data Security':
        return 'We are committed to ensuring the security of your data. We employ industry-standard encryption and security protocols to protect your information. Our platform undergoes regular security audits and vulnerability assessments.\n\nAll shipment data is stored in secure cloud environments with restricted access. We do not store payment information on our servers.';
      default:
        return 'Policy content goes here.';
    }
  }

  Widget _buildContactUs(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in touch with our support team',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactMethod(
              Icons.email_outlined,
              'Email Support',
              'support@shiptrack.com',
              () {},
            ),
            const SizedBox(height: 12),
            _buildContactMethod(
              Icons.phone_outlined,
              'Phone Support',
              '(800) 123-4567',
              () {},
            ),
            const SizedBox(height: 12),
            _buildContactMethod(
              Icons.location_on_outlined,
              'Headquarters',
              '123 Logistics Ave, Shipping City',
              () {},
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showContactForm(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'CONTACT US',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod(
      IconData icon, String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey.shade700,
              size: 24,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showContactForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String subject = '';
    String message = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Support',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    subject = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    message = value ?? '';
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            // Process the form - actually use the subject and message values
                            debugPrint('Sending message: $subject - $message');

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Message sent successfully!'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
