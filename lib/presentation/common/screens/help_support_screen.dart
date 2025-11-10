import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Help & Support Screen
/// 
/// Provides help resources and contact support

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Support Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.support_agent,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Contact Support',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Need help? Get in touch with our support team.'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showContactDialog(context, 'Email Support');
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showContactDialog(context, 'Call Support');
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // FAQ Section
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            context,
            'How do I pay my rent?',
            'You can pay rent through the app by going to Dashboard → Pay Now. Select your payment method and follow the instructions.',
          ),
          _buildFAQItem(
            context,
            'How do I submit a maintenance request?',
            'Go to Dashboard → Maintenance Request. Fill in the details, select urgency level, and submit. You\'ll receive updates via notifications.',
          ),
          _buildFAQItem(
            context,
            'Can I view my lease agreement?',
            'Yes, go to Dashboard → Lease Details to view your complete lease agreement, terms, and conditions.',
          ),
          _buildFAQItem(
            context,
            'How do I contact my landlord?',
            'Use the Messages feature to communicate directly with your landlord. Tap the message icon in the dashboard.',
          ),
          _buildFAQItem(
            context,
            'What payment methods are accepted?',
            'We accept bank transfers, credit/debit cards, cash, mobile money, and cheques. Select your preferred method during payment.',
          ),
          _buildFAQItem(
            context,
            'How long does payment approval take?',
            'Payment approvals typically take 24-48 hours. You\'ll receive a notification once approved.',
          ),
          const SizedBox(height: 24),

          // Quick Links
          Text(
            'Quick Links',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildQuickLink(
            context,
            Icons.article,
            'Terms & Conditions',
            () => context.push('/terms'),
          ),
          _buildQuickLink(
            context,
            Icons.privacy_tip,
            'Privacy Policy',
            () => context.push('/privacy'),
          ),
          _buildQuickLink(
            context,
            Icons.gavel,
            'Rental Agreement',
            () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feature coming soon')),
            ),
          ),
          _buildQuickLink(
            context,
            Icons.info,
            'About Us',
            () => _showAboutDialog(context),
          ),
          const SizedBox(height: 24),

          // Support Hours
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Text(
                        'Support Hours',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monday - Friday: 8:00 AM - 8:00 PM\nSaturday: 9:00 AM - 5:00 PM\nSunday: Closed',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLink(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showContactDialog(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(method),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (method.contains('Email')) ...[
              const Text('Email us at:'),
              const SizedBox(height: 8),
              const SelectableText(
                'support@rentalapp.com',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ] else ...[
              const Text('Call us at:'),
              const SizedBox(height: 8),
              const SelectableText(
                '+1 (555) 123-4567',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Rental Management App',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.home_work, color: Colors.white, size: 32),
      ),
      children: [
        const SizedBox(height: 16),
        const Text(
          'A comprehensive rental management solution for landlords and tenants.',
        ),
        const SizedBox(height: 8),
        const Text('© 2024 Rental Management App. All rights reserved.'),
      ],
    );
  }
}
