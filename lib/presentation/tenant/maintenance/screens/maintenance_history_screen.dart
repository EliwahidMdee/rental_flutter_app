import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

/// Maintenance History Screen
/// 
/// View all maintenance requests and their status

class MaintenanceHistoryScreen extends ConsumerStatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  ConsumerState<MaintenanceHistoryScreen> createState() => _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends ConsumerState<MaintenanceHistoryScreen> {
  String? _filterStatus;

  // Mock data - replace with provider
  final List<MaintenanceRequest> _requests = [
    MaintenanceRequest(
      id: 1,
      title: 'Leaking faucet in kitchen',
      category: 'Plumbing',
      urgency: 'high',
      status: 'in_progress',
      location: 'Kitchen',
      description: 'The kitchen faucet has been dripping continuously...',
      requestedDate: DateTime.now().subtract(const Duration(days: 2)),
      assignedTo: 'Mike Johnson',
    ),
    MaintenanceRequest(
      id: 2,
      title: 'AC not cooling properly',
      category: 'Cooling',
      urgency: 'medium',
      status: 'completed',
      location: 'Living Room',
      description: 'Air conditioner is running but not cooling the room...',
      requestedDate: DateTime.now().subtract(const Duration(days: 10)),
      completedDate: DateTime.now().subtract(const Duration(days: 5)),
      assignedTo: 'Sarah Williams',
    ),
    MaintenanceRequest(
      id: 3,
      title: 'Broken door lock',
      category: 'Doors/Windows',
      urgency: 'emergency',
      status: 'pending',
      location: 'Main entrance',
      description: 'Front door lock is jammed and cannot be opened...',
      requestedDate: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    MaintenanceRequest(
      id: 4,
      title: 'Light fixture not working',
      category: 'Electrical',
      urgency: 'low',
      status: 'cancelled',
      location: 'Bedroom 2',
      description: 'Ceiling light stopped working suddenly...',
      requestedDate: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRequests = _filterStatus == null
        ? _requests
        : _requests.where((r) => r.status == _filterStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: filteredRequests.isEmpty
          ? const EmptyState(
              message: 'No maintenance requests',
              subtitle: 'Submit a new request to get started',
              icon: Icons.build_outlined,
            )
          : RefreshIndicator(
              onRefresh: () async {
                // TODO: Refresh data
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) {
                  final request = filteredRequests[index];
                  return _buildRequestCard(context, request);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tenant/maintenance'),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, MaintenanceRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showRequestDetail(context, request),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      request.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(request.status),
                ],
              ),
              const SizedBox(height: 8),

              // Category and Urgency
              Row(
                children: [
                  Chip(
                    label: Text(request.category),
                    avatar: const Icon(Icons.category, size: 16),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor(request.urgency).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.priority_high,
                          size: 14,
                          color: _getUrgencyColor(request.urgency),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          request.urgency.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getUrgencyColor(request.urgency),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    request.location,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Requested ${Formatters.relativeTime(request.requestedDate)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // Assigned to
              if (request.assignedTo != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Assigned to ${request.assignedTo}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'in_progress':
        color = Colors.blue;
        label = 'In Progress';
        break;
      case 'completed':
        color = Colors.green;
        label = 'Completed';
        break;
      case 'cancelled':
        color = Colors.grey;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.deepOrange;
      case 'emergency':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('All', null),
            _buildFilterOption('Pending', 'pending'),
            _buildFilterOption('In Progress', 'in_progress'),
            _buildFilterOption('Completed', 'completed'),
            _buildFilterOption('Cancelled', 'cancelled'),
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

  Widget _buildFilterOption(String label, String? value) {
    return RadioListTile<String?>(
      title: Text(label),
      value: value,
      groupValue: _filterStatus,
      onChanged: (newValue) {
        setState(() => _filterStatus = newValue);
        Navigator.pop(context);
      },
    );
  }

  void _showRequestDetail(BuildContext context, MaintenanceRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                request.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Status
              Row(
                children: [
                  _buildStatusBadge(request.status),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor(request.urgency).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.urgency.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getUrgencyColor(request.urgency),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Details
              _buildDetailRow(Icons.category, 'Category', request.category),
              _buildDetailRow(Icons.location_on, 'Location', request.location),
              _buildDetailRow(
                Icons.calendar_today,
                'Requested',
                Formatters.formatDate(request.requestedDate),
              ),
              if (request.assignedTo != null)
                _buildDetailRow(Icons.person, 'Assigned To', request.assignedTo!),
              if (request.completedDate != null)
                _buildDetailRow(
                  Icons.check_circle,
                  'Completed',
                  Formatters.formatDate(request.completedDate!),
                ),
              const SizedBox(height: 24),

              // Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(request.description),
              const SizedBox(height: 24),

              // Actions
              if (request.status == 'pending')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _cancelRequest(request);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelRequest(MaintenanceRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text('Are you sure you want to cancel this maintenance request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Cancel request via API
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request cancelled')),
              );
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// Maintenance Request Model
class MaintenanceRequest {
  final int id;
  final String title;
  final String category;
  final String urgency;
  final String status;
  final String location;
  final String description;
  final DateTime requestedDate;
  final DateTime? completedDate;
  final String? assignedTo;

  MaintenanceRequest({
    required this.id,
    required this.title,
    required this.category,
    required this.urgency,
    required this.status,
    required this.location,
    required this.description,
    required this.requestedDate,
    this.completedDate,
    this.assignedTo,
  });
}
