import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme.dart';
import '../../auth/providers/auth_provider.dart';

/// Tenant Dashboard Screen
class TenantDashboardScreen extends ConsumerWidget {
  const TenantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/tenant/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.tenantAccent,
                      child: Text(
                        user?.name[0].toUpperCase() ?? 'T',
                        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome back,', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(user?.name ?? 'Tenant', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Rent Status Card
            Card(
              color: AppTheme.tenantAccent.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rent Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Icon(Icons.check_circle, color: Colors.green.shade600),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Month:', style: TextStyle(fontSize: 16)),
                        Text('\$1,200', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.tenantAccent)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Due Date:', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text('Dec 1, 2024', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/tenant/payment'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.tenantAccent),
                        child: const Text('Pay Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildQuickAction(context, 'Payment\nHistory', Icons.history, () => context.push('/tenant/history')),
                _buildQuickAction(context, 'Lease\nDetails', Icons.description, () => context.push('/tenant/lease')),
                _buildQuickAction(context, 'Maintenance\nRequest', Icons.build, () {}),
                _buildQuickAction(context, 'Contact\nLandlord', Icons.message, () {}),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Payments
            const Text('Recent Payments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPaymentTile(context, 'Nov 2024', '\$1,200', 'Paid', Colors.green),
            _buildPaymentTile(context, 'Oct 2024', '\$1,200', 'Paid', Colors.green),
            _buildPaymentTile(context, 'Sep 2024', '\$1,200', 'Paid', Colors.green),
            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppTheme.tenantAccent),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTile(BuildContext context, String month, String amount, String status, Color statusColor) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.payment, color: statusColor),
        ),
        title: Text(month),
        subtitle: Text(status, style: TextStyle(color: statusColor)),
        trailing: Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
