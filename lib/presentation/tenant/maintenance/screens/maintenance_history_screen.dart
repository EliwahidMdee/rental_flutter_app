import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/loading_indicator.dart';
import '../../../common/widgets/empty_state.dart';
import '../../../common/widgets/error_display.dart';
import '../../../common/providers/maintenance_provider.dart';
import '../../../../config/theme.dart';

/// Maintenance History Screen
/// 
/// View all maintenance requests and their status with real-time data

class MaintenanceHistoryScreen extends ConsumerStatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  ConsumerState<MaintenanceHistoryScreen> createState() => _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends ConsumerState<MaintenanceHistoryScreen> {
  String? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final maintenanceAsync = ref.watch(currentUserMaintenanceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance History'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (status) {
              setState(() {
                _filterStatus = status == 'all' ? null : status;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Status')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
              const PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to create maintenance request
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create Request coming soon')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
      body: maintenanceAsync.when(
        data: (requests) {
          // Apply filter
          final filteredRequests = _filterStatus == null
              ? requests
              : requests.where((r) => r.status == _filterStatus).toList();

          if (filteredRequests.isEmpty) {
            return EmptyState(
              message: _filterStatus == null ? 'No Maintenance Requests' : 'No $_filterStatus Requests',
              subtitle: 'Your maintenance requests will appear here',
              icon: Icons.build_circle_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserMaintenanceProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRequests.length,
              itemBuilder: (context, index) {
                final request = filteredRequests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildMaintenanceCard(context, request, isDark),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading maintenance requests...'),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(currentUserMaintenanceProvider);
          },
        ),
      ),
    );
  }

  Widget _buildMaintenanceCard(BuildContext context, dynamic request, bool isDark) {
    final statusColor = _getStatusColor(request.status);
    final priorityColor = _getPriorityColor(request.priority);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(isDark ? 0.15 : 0.08),
            statusColor.withOpacity(isDark ? 0.1 : 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(isDark ? 0.3 : 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showRequestDetail(context, request);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        request.status.toUpperCase().replaceAll('_', ' '),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Priority badge
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getPriorityIcon(request.priority),
                        size: 16,
                        color: priorityColor,
                      ),
                    ),
                    const Spacer(),
                    // Date
                    Text(
                      DateFormat.MMMd().format(DateTime.parse(request.createdAt)),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  request.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  request.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer row
                Row(
                  children: [
                    // Category
                    if (request.category != null) ...[
                      Icon(
                        _getCategoryIcon(request.category!),
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        request.category!.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warningColor;
      case 'in_progress':
        return AppTheme.infoColor;
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return AppTheme.successColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'high':
        return AppTheme.accentOrange;
      case 'urgent':
      case 'emergency':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Icons.arrow_downward;
      case 'medium':
        return Icons.remove;
      case 'high':
        return Icons.arrow_upward;
      case 'urgent':
      case 'emergency':
        return Icons.priority_high;
      default:
        return Icons.info;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return Icons.water_drop;
      case 'electrical':
        return Icons.electrical_services;
      case 'hvac':
      case 'heating':
      case 'cooling':
        return Icons.ac_unit;
      case 'appliance':
      case 'appliances':
        return Icons.kitchen;
      case 'structural':
        return Icons.foundation;
      default:
        return Icons.build;
    }
  }

  void _showRequestDetail(BuildContext context, dynamic request) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(request.status);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
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

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                request.status.toUpperCase().replaceAll('_', ' '),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              request.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              request.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Details
            _buildDetailRow(context, 'Category', request.category ?? 'N/A', Icons.category, isDark),
            _buildDetailRow(context, 'Priority', request.priority.toUpperCase(), Icons.flag, isDark),
            _buildDetailRow(
              context,
              'Requested',
              DateFormat.yMMMd().format(DateTime.parse(request.createdAt)),
              Icons.calendar_today,
              isDark,
            ),
            if (request.scheduledDate != null)
              _buildDetailRow(
                context,
                'Scheduled',
                DateFormat.yMMMd().format(DateTime.parse(request.scheduledDate)),
                Icons.event,
                isDark,
              ),
            if (request.completedDate != null)
              _buildDetailRow(
                context,
                'Completed',
                DateFormat.yMMMd().format(DateTime.parse(request.completedDate)),
                Icons.check_circle,
                isDark,
              ),
            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
          ),
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
}
