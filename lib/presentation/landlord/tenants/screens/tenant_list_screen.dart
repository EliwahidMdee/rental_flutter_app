import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/loading_indicator.dart';
import '../../../common/widgets/error_display.dart';
import '../../../common/widgets/empty_state.dart';

/// Tenant List Screen
/// 
/// Displays list of all tenants for landlord

class TenantListScreen extends ConsumerWidget {
  const TenantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch tenants from provider
    // For now, using mock data
    final mockTenants = _getMockTenants();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: mockTenants.isEmpty
          ? const EmptyState(
              message: 'No tenants yet',
              subtitle: 'Tenants will appear here once properties are occupied',
              icon: Icons.people_outline,
            )
          : RefreshIndicator(
              onRefresh: () async {
                // Refresh tenants
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: mockTenants.length,
                itemBuilder: (context, index) {
                  final tenant = mockTenants[index];
                  return _buildTenantCard(context, tenant);
                },
              ),
            ),
    );
  }

  Widget _buildTenantCard(BuildContext context, Map<String, dynamic> tenant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showTenantDetail(context, tenant);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                child: Text(
                  tenant['name'].substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenant['name'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.home, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tenant['property'],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.email, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          tenant['email'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(tenant['status']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  tenant['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(tenant['status']),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTenantDetail(BuildContext context, Map<String, dynamic> tenant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      child: Text(
                        tenant['name'].substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tenant['name'],
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            tenant['status'],
                            style: TextStyle(
                              color: _getStatusColor(tenant['status']),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                _buildDetailRow(context, Icons.home, 'Property', tenant['property']),
                _buildDetailRow(context, Icons.email, 'Email', tenant['email']),
                _buildDetailRow(context, Icons.phone, 'Phone', tenant['phone']),
                _buildDetailRow(context, Icons.calendar_today, 'Move-in Date', tenant['moveInDate']),
                _buildDetailRow(context, Icons.attach_money, 'Monthly Rent', tenant['rent']),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Messaging feature coming soon')),
                          );
                        },
                        icon: const Icon(Icons.message),
                        label: const Text('Message'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View history feature coming soon')),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: const Text('History'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'inactive':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getMockTenants() {
    return [
      {
        'name': 'John Doe',
        'property': 'Sunset Apartment #101',
        'email': 'john.doe@example.com',
        'phone': '+1 (555) 123-4567',
        'status': 'Active',
        'moveInDate': 'Jan 1, 2024',
        'rent': '\$1,200',
      },
      {
        'name': 'Jane Smith',
        'property': 'Garden View #205',
        'email': 'jane.smith@example.com',
        'phone': '+1 (555) 234-5678',
        'status': 'Active',
        'moveInDate': 'Feb 15, 2024',
        'rent': '\$1,500',
      },
      {
        'name': 'Bob Johnson',
        'property': 'City Plaza #302',
        'email': 'bob.j@example.com',
        'phone': '+1 (555) 345-6789',
        'status': 'Active',
        'moveInDate': 'Mar 10, 2024',
        'rent': '\$900',
      },
    ];
  }
}
