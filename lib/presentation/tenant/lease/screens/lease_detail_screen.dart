import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/loading_indicator.dart';
import '../../../common/widgets/error_display.dart';
import '../../../common/widgets/custom_button.dart';

/// Lease Detail Screen
/// 
/// Displays lease agreement details for tenants

class LeaseDetailScreen extends ConsumerWidget {
  const LeaseDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch lease data from provider
    // For now, using mock data
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lease Agreement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading lease document...')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Property Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.home_work,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sunset Apartment',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '123 Main St, New York, NY',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lease Status
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Lease',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your lease is currently active',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Lease Details
          Text(
            'Lease Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          _buildInfoRow(context, 'Start Date', 'Jan 1, 2024'),
          const Divider(),
          _buildInfoRow(context, 'End Date', 'Dec 31, 2024'),
          const Divider(),
          _buildInfoRow(context, 'Monthly Rent', '\$1,200.00'),
          const Divider(),
          _buildInfoRow(context, 'Security Deposit', '\$1,200.00'),
          const Divider(),
          _buildInfoRow(context, 'Lease Duration', '12 months'),
          const Divider(),
          _buildInfoRow(context, 'Payment Due Date', '1st of every month'),
          const SizedBox(height: 24),

          // Tenant Information
          Text(
            'Tenant Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          _buildInfoRow(context, 'Name', 'John Doe'),
          const Divider(),
          _buildInfoRow(context, 'Email', 'john.doe@example.com'),
          const Divider(),
          _buildInfoRow(context, 'Phone', '+1 (555) 123-4567'),
          const SizedBox(height: 24),

          // Landlord Information
          Text(
            'Landlord Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          _buildInfoRow(context, 'Name', 'Jane Smith'),
          const Divider(),
          _buildInfoRow(context, 'Email', 'jane.smith@example.com'),
          const Divider(),
          _buildInfoRow(context, 'Phone', '+1 (555) 987-6543'),
          const SizedBox(height: 24),

          // Terms & Conditions
          Text(
            'Terms & Conditions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTermItem('Rent is due on the 1st of each month'),
                  _buildTermItem('No pets allowed on the premises'),
                  _buildTermItem('Tenant is responsible for utilities'),
                  _buildTermItem('30 days notice required for lease termination'),
                  _buildTermItem('Property must be returned in good condition'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Actions
          CustomButton(
            text: 'Download Lease Document',
            icon: Icons.download,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download feature coming soon')),
              );
            },
            width: double.infinity,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Contact Landlord',
            icon: Icons.message,
            isOutlined: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Messaging feature coming soon')),
              );
            },
            width: double.infinity,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
