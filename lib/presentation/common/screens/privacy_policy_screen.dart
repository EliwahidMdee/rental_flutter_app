import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Privacy Policy Screen
/// 
/// Displays app privacy policy

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
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
              'Introduction',
              'Rental Management App ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),

            _buildSection(
              context,
              '1. Information We Collect',
              'We collect information that you provide directly to us, including:\n\n'
              '• Personal Information: Name, email address, phone number, and profile photo\n'
              '• Account Information: Username, password, and preferences\n'
              '• Property Information: Lease details, property address, and rental history\n'
              '• Payment Information: Payment methods, transaction history, and receipts\n'
              '• Communication Data: Messages between tenants and landlords\n'
              '• Maintenance Records: Maintenance requests and resolution history\n'
              '• Device Information: Device type, operating system, and unique identifiers\n'
              '• Usage Data: App interactions, features used, and timestamps',
            ),

            _buildSection(
              context,
              '2. How We Use Your Information',
              'We use the collected information for:\n\n'
              '• Providing and maintaining the app functionality\n'
              '• Processing rental payments and transactions\n'
              '• Facilitating communication between tenants and landlords\n'
              '• Managing maintenance requests and notifications\n'
              '• Improving app features and user experience\n'
              '• Sending administrative information and updates\n'
              '• Detecting and preventing fraud or security issues\n'
              '• Complying with legal obligations',
            ),

            _buildSection(
              context,
              '3. Information Sharing',
              'We do not sell your personal information. We may share your information:\n\n'
              '• With landlords and tenants as necessary for rental management\n'
              '• With service providers who assist in app operations\n'
              '• With payment processors for transaction handling\n'
              '• When required by law or to protect rights and safety\n'
              '• In connection with business transfers or acquisitions',
            ),

            _buildSection(
              context,
              '4. Data Storage and Security',
              'We implement appropriate security measures to protect your information:\n\n'
              '• Encryption of sensitive data in transit and at rest\n'
              '• Secure authentication mechanisms\n'
              '• Regular security audits and updates\n'
              '• Access controls and monitoring\n'
              '• Secure cloud storage infrastructure',
            ),

            _buildSection(
              context,
              '5. Your Privacy Rights',
              'You have the right to:\n\n'
              '• Access your personal information\n'
              '• Correct inaccurate data\n'
              '• Request deletion of your data\n'
              '• Opt-out of marketing communications\n'
              '• Export your data\n'
              '• Withdraw consent where applicable',
            ),

            _buildSection(
              context,
              '6. Cookies and Tracking',
              'We use cookies and similar tracking technologies to:\n\n'
              '• Maintain your session\n'
              '• Remember your preferences\n'
              '• Analyze app usage patterns\n'
              '• Improve performance and functionality',
            ),

            _buildSection(
              context,
              '7. Third-Party Services',
              'Our app may integrate with third-party services:\n\n'
              '• Firebase (Google) for authentication and notifications\n'
              '• Payment processors for transactions\n'
              '• Analytics services for app improvement\n'
              '• Cloud storage providers\n\n'
              'These services have their own privacy policies that govern their use of your information.',
            ),

            _buildSection(
              context,
              '8. Children\'s Privacy',
              'Our app is not intended for users under 18 years of age. We do not knowingly collect personal information from children. If you believe we have collected information from a child, please contact us immediately.',
            ),

            _buildSection(
              context,
              '9. Data Retention',
              'We retain your personal information for as long as necessary to:\n\n'
              '• Provide app services\n'
              '• Comply with legal obligations\n'
              '• Resolve disputes\n'
              '• Enforce agreements\n\n'
              'When information is no longer needed, we will securely delete or anonymize it.',
            ),

            _buildSection(
              context,
              '10. International Data Transfers',
              'Your information may be transferred to and maintained on servers located outside your jurisdiction. We ensure appropriate safeguards are in place for such transfers.',
            ),

            _buildSection(
              context,
              '11. Changes to Privacy Policy',
              'We may update this Privacy Policy from time to time. We will notify you of significant changes through the app or via email. Continued use after changes constitutes acceptance.',
            ),

            _buildSection(
              context,
              '12. Contact Us',
              'If you have questions about this Privacy Policy or our practices, contact us at:\n\n'
              'Email: privacy@rentalapp.com\n'
              'Phone: +1 (555) 123-4567\n'
              'Address: 123 Main Street, Suite 100, City, State 12345',
            ),

            const SizedBox(height: 24),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your privacy is important to us. We are committed to protecting your personal information and being transparent about our practices.',
                        style: TextStyle(color: Colors.green.shade900),
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
