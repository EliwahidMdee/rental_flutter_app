import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

/// Notification Model
/// 
/// Represents a notification in the system

@JsonSerializable()
class NotificationModel {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String title;
  final String body;
  final String type; // rent_due, payment_received, lease_expiring, maintenance_request, message, general
  final bool read;
  final Map<String, dynamic>? data;
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.read = false,
    this.data,
    required this.createdAt,
  });
  
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
  
  NotificationModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    String? type,
    bool? read,
    Map<String, dynamic>? data,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      read: read ?? this.read,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
