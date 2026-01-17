import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. Data Collection',
              'We collect information necessary to process your orders, including name, shipping address, and payment details.',
            ),
            _buildSection(
              '2. Data Usage',
              'Your data is used solely for order fulfillment, customer support, and improving our services. We do not sell your data to third parties.',
            ),
            _buildSection(
              '3. Security',
              'We implement industry-standard security measures to protect your personal information during transmission and storage.',
            ),
            _buildSection(
              '4. Cookies',
              'Our app performs optimally with local storage enabled to remember your preferences and login session.',
            ),
             _buildSection(
              '5. Contact',
              'If you have questions about our privacy practices, please contact us via the "Contact Us" section.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
