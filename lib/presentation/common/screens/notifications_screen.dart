import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';
import '../widgets/empty_state.dart';

/// Notifications Screen
/// 
/// Displays all notifications for the user

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch notifications from provider
    // For now, using mock data
    final mockNotifications = _getMockNotifications();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
          ),
        ],
      ),
      body: mockNotifications.isEmpty
          ? EmptyState(
              message: 'No notifications',
              subtitle: 'You\'re all caught up!',
              icon: Icons.notifications_none,
            )
          : ListView.builder(
              itemCount: mockNotifications.length,
              itemBuilder: (context, index) {
                final notification = mockNotifications[index];
                return _buildNotificationTile(context, notification);
              },
            ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, Map<String, dynamic> notification) {
    final isRead = notification['read'] as bool;
    final type = notification['type'] as String;
    
    return Dismissible(
      key: Key(notification['id'].toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      },
      child: Container(
        color: isRead ? null : Colors.blue.shade50,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getNotificationColor(type).withOpacity(0.2),
            child: Icon(
              _getNotificationIcon(type),
              color: _getNotificationColor(type),
            ),
          ),
          title: Text(
            notification['title'] as String,
            style: TextStyle(
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification['body'] as String),
              const SizedBox(height: 4),
              Text(
                _formatTime(notification['createdAt'] as String),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          trailing: !isRead
              ? Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            _showNotificationDetail(context, notification);
          },
        ),
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
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
                    Icon(
                      _getNotificationIcon(notification['type'] as String),
                      color: _getNotificationColor(notification['type'] as String),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        notification['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTime(notification['createdAt'] as String),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                Text(
                  notification['body'] as String,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'rent_due':
        return Icons.calendar_today;
      case 'payment_received':
        return Icons.payments;
      case 'lease_expiring':
        return Icons.event_busy;
      case 'maintenance_request':
        return Icons.build;
      case 'message':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'rent_due':
        return Colors.orange;
      case 'payment_received':
        return Colors.green;
      case 'lease_expiring':
        return Colors.red;
      case 'maintenance_request':
        return Colors.blue;
      case 'message':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  List<Map<String, dynamic>> _getMockNotifications() {
    return [
      {
        'id': 1,
        'title': 'Rent Payment Due',
        'body': 'Your rent payment of \$1,200 is due on Dec 1, 2024',
        'type': 'rent_due',
        'read': false,
        'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 2,
        'title': 'Payment Approved',
        'body': 'Your payment of \$1,200 for November has been approved',
        'type': 'payment_received',
        'read': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 3,
        'title': 'Lease Expiring Soon',
        'body': 'Your lease agreement will expire in 30 days',
        'type': 'lease_expiring',
        'read': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        'id': 4,
        'title': 'New Message',
        'body': 'You have a new message from your landlord',
        'type': 'message',
        'read': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      },
    ];
  }
}
