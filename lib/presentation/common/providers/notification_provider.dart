import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../auth/providers/auth_provider.dart';
import 'property_provider.dart';

/// Notification Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return NotificationRepository(apiClient, networkInfo);
});

/// Notifications List Provider
final notificationsProvider = FutureProvider.autoDispose.family<List<NotificationModel>, NotificationFilters?>(
  (ref, filters) async {
    final repository = ref.watch(notificationRepositoryProvider);
    return repository.getNotifications(
      read: filters?.read,
      type: filters?.type,
    );
  },
);

/// Unread Notifications Count Provider
final unreadNotificationsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  final notifications = await repository.getNotifications(read: false);
  return notifications.length;
});

/// Notification Detail Provider
final notificationDetailProvider = FutureProvider.autoDispose.family<NotificationModel, int>(
  (ref, notificationId) async {
    final repository = ref.watch(notificationRepositoryProvider);
    return repository.getNotificationById(notificationId);
  },
);

/// Notification Filters
class NotificationFilters {
  final bool? read;
  final String? type;
  
  NotificationFilters({
    this.read,
    this.type,
  });
}
