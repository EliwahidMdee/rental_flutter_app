import '../models/notification_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/local_storage.dart';

/// Notification Repository
/// 
/// Handles notification data operations with caching

class NotificationRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  
  NotificationRepository(this._apiClient, this._networkInfo);
  
  /// Get all notifications for the current user
  Future<List<NotificationModel>> getNotifications({
    bool? read,
    String? type,
    int page = 1,
    int perPage = 20,
  }) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(
        ApiEndpoints.notifications,
        queryParameters: {
          if (read != null) 'read': read,
          if (type != null) 'type': type,
          'page': page,
          'per_page': perPage,
        },
      );
      
      final notifications = (response.data['data'] as List)
          .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Cache notifications
      final box = LocalStorage.notificationsBox;
      for (final notification in notifications) {
        await box.put(notification.id.toString(), notification.toJson());
      }
      
      return notifications;
    } else {
      // Return cached notifications
      return _getCachedNotifications();
    }
  }
  
  /// Get notification by ID
  Future<NotificationModel> getNotificationById(int id) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(ApiEndpoints.notificationDetail(id));
      final notification = NotificationModel.fromJson(response.data['data'] as Map<String, dynamic>);
      
      // Cache notification
      final box = LocalStorage.notificationsBox;
      await box.put(id.toString(), notification.toJson());
      
      return notification;
    } else {
      // Return cached notification
      final box = LocalStorage.notificationsBox;
      final data = box.get(id.toString());
      if (data == null) throw Exception('Notification not found in cache');
      
      return NotificationModel.fromJson(Map<String, dynamic>.from(data as Map));
    }
  }
  
  /// Mark notification as read
  Future<void> markAsRead(int id) async {
    await _apiClient.put(ApiEndpoints.markNotificationRead(id));
    
    // Update cached notification
    final box = LocalStorage.notificationsBox;
    final data = box.get(id.toString());
    if (data != null) {
      final notification = NotificationModel.fromJson(Map<String, dynamic>.from(data as Map));
      await box.put(id.toString(), notification.copyWith(read: true).toJson());
    }
  }
  
  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    await _apiClient.put(ApiEndpoints.markAllNotificationsRead);
    
    // Update cached notifications
    final box = LocalStorage.notificationsBox;
    for (final key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        final notification = NotificationModel.fromJson(Map<String, dynamic>.from(data as Map));
        await box.put(key, notification.copyWith(read: true).toJson());
      }
    }
  }
  
  /// Get cached notifications
  List<NotificationModel> _getCachedNotifications() {
    final box = LocalStorage.notificationsBox;
    return box.values
        .map((json) => NotificationModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }
}
