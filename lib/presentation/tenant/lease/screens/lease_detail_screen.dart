import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/loading_indicator.dart';
import '../../../common/widgets/error_display.dart';
import '../../../common/widgets/empty_state.dart';
import '../../../common/providers/lease_provider.dart';
import '../../../../config/theme.dart';

/// Lease Detail Screen
/// 
/// Displays lease agreement details for tenants with real-time data

class LeaseDetailScreen extends ConsumerWidget {
  const LeaseDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaseAsync = ref.watch(currentUserLeaseProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lease Agreement'),
        elevation: 0,
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
      body: leaseAsync.when(
        data: (lease) {
          if (lease == null) {
            return const EmptyState(
              message: 'No Active Lease',
              subtitle: 'You do not have an active lease agreement at this time',
              icon: Icons.description_outlined,
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserLeaseProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Property Info Card with Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.tenantAccent.withOpacity(isDark ? 0.3 : 0.15),
                        AppTheme.accentPurple.withOpacity(isDark ? 0.2 : 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.tenantAccent.withOpacity(isDark ? 0.4 : 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.tenantAccent.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.tenantAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.home_work,
                            size: 32,
                            color: AppTheme.tenantAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lease.property?.name ?? 'Property',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (lease.property?.address != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  lease.property!.address!,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Lease Status Card
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: lease.isActive
                          ? [
                              AppTheme.successColor.withOpacity(isDark ? 0.3 : 0.15),
                              AppTheme.accentTeal.withOpacity(isDark ? 0.2 : 0.1),
                            ]
                          : [
                              AppTheme.warningColor.withOpacity(isDark ? 0.3 : 0.15),
                              AppTheme.accentOrange.withOpacity(isDark ? 0.2 : 0.1),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (lease.isActive ? AppTheme.successColor : AppTheme.warningColor)
                          .withOpacity(isDark ? 0.4 : 0.3),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          lease.isActive ? Icons.check_circle : Icons.info,
                          color: lease.isActive ? AppTheme.successColor : AppTheme.warningColor,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lease.status.toUpperCase(),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: lease.isActive ? AppTheme.successColor : AppTheme.warningColor,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lease.isActive
                                    ? 'Your lease is currently active'
                                    : 'Lease status: ${lease.status}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Lease Details Card
                _buildSectionTitle(context, 'Lease Information', Icons.description),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          'Start Date',
                          DateFormat.yMMMd().format(DateTime.parse(lease.startDate)),
                          Icons.calendar_today,
                          AppTheme.primaryColor,
                          isDark,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          'End Date',
                          DateFormat.yMMMd().format(DateTime.parse(lease.endDate)),
                          Icons.event,
                          AppTheme.errorColor,
                          isDark,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          'Monthly Rent',
                          '\$${lease.monthlyRent.toStringAsFixed(2)}',
                          Icons.attach_money,
                          AppTheme.successColor,
                          isDark,
                        ),
                        if (lease.securityDeposit != null) ...[
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Security Deposit',
                            '\$${lease.securityDeposit!.toStringAsFixed(2)}',
                            Icons.security,
                            AppTheme.infoColor,
                            isDark,
                          ),
                        ],
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          'Lease Duration',
                          _calculateDuration(lease.startDate, lease.endDate),
                          Icons.timelapse,
                          AppTheme.accentOrange,
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tenant Information Card
                if (lease.tenant != null) ...[
                  _buildSectionTitle(context, 'Tenant Information', Icons.person),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            'Tenant Name',
                            lease.tenant!.name,
                            Icons.person,
                            AppTheme.tenantAccent,
                            isDark,
                          ),
                          if (lease.tenant!.email != null) ...[
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              'Email',
                              lease.tenant!.email!,
                              Icons.email,
                              AppTheme.secondaryColor,
                              isDark,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Terms Section if available
                if (lease.terms != null && lease.terms!.isNotEmpty) ...[
                  _buildSectionTitle(context, 'Terms & Conditions', Icons.gavel),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        lease.terms!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Download Contract Button if available
                if (lease.contractUrl != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement download
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Downloading contract...')),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download Contract'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading lease details...'),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(currentUserLeaseProvider);
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  String _calculateDuration(String startDate, String endDate) {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final duration = end.difference(start);
    final months = (duration.inDays / 30).round();
    return '$months months';
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
