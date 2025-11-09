import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Terms & Conditions Screen
/// 
/// Displays app terms and conditions

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: December 2024',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              '1. Acceptance of Terms',
              'By accessing and using this Rental Management App, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            ),

            _buildSection(
              context,
              '2. Use License',
              'Permission is granted to temporarily access the materials on the Rental Management App for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n'
              '• Modify or copy the materials\n'
              '• Use the materials for any commercial purpose\n'
              '• Attempt to decompile or reverse engineer any software\n'
              '• Remove any copyright or other proprietary notations\n'
              '• Transfer the materials to another person',
            ),

            _buildSection(
              context,
              '3. User Accounts',
              'When you create an account with us, you must provide accurate, complete, and current information. Failure to do so constitutes a breach of the Terms. You are responsible for safeguarding the password and for all activities that occur under your account.',
            ),

            _buildSection(
              context,
              '4. Payment Terms',
              'All payments made through the app are subject to the payment terms agreed upon in your rental agreement. Payment processing fees may apply. Rental Management App is not responsible for any disputes between tenants and landlords regarding payment amounts or schedules.',
            ),

            _buildSection(
              context,
              '5. Maintenance Requests',
              'The app provides a platform for submitting maintenance requests. Response times and resolution are subject to your rental agreement and are managed by property landlords. Emergency maintenance should be reported directly to emergency contacts.',
            ),

            _buildSection(
              context,
              '6. Data Collection and Use',
              'We collect and use your personal information in accordance with our Privacy Policy. By using the app, you consent to such processing and you warrant that all data provided by you is accurate.',
            ),

            _buildSection(
              context,
              '7. Messaging and Communication',
              'The messaging feature is provided for communication between tenants and landlords. Users must not use the messaging system for spam, harassment, or any illegal activities. All communications should remain professional and relevant to rental matters.',
            ),

            _buildSection(
              context,
              '8. Prohibited Uses',
              'You may not use the app:\n\n'
              '• For any unlawful purpose\n'
              '• To solicit others to perform unlawful acts\n'
              '• To violate any international, federal, provincial or state regulations\n'
              '• To infringe upon intellectual property rights\n'
              '• To harass, abuse, insult, harm, defame, slander, or intimidate\n'
              '• To submit false or misleading information',
            ),

            _buildSection(
              context,
              '9. Limitation of Liability',
              'In no event shall Rental Management App or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on the app.',
            ),

            _buildSection(
              context,
              '10. Modifications',
              'Rental Management App may revise these terms of service at any time without notice. By using this app you are agreeing to be bound by the then current version of these terms of service.',
            ),

            _buildSection(
              context,
              '11. Termination',
              'We may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
            ),

            _buildSection(
              context,
              '12. Contact Information',
              'If you have any questions about these Terms, please contact us at:\n\n'
              'Email: legal@rentalapp.com\n'
              'Phone: +1 (555) 123-4567',
            ),

            const SizedBox(height: 24),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'By continuing to use this app, you acknowledge that you have read and understood these Terms and Conditions.',
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
