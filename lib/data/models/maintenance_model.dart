import 'package:json_annotation/json_annotation.dart';

part 'maintenance_model.g.dart';

/// Maintenance Model
/// 
/// Represents a maintenance request in the system

@JsonSerializable()
class MaintenanceModel {
  final int id;
  @JsonKey(name: 'property_id')
  final int propertyId;
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  final String title;
  final String description;
  final String status; // pending, in_progress, completed, cancelled
  final String priority; // low, medium, high, urgent
  final String? category; // plumbing, electrical, hvac, appliance, structural, other
  @JsonKey(name: 'image_urls')
  final List<String>? imageUrls;
  @JsonKey(name: 'scheduled_date')
  final String? scheduledDate;
  @JsonKey(name: 'completed_date')
  final String? completedDate;
  final String? notes;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  // Relationships
  final PropertySummary? property;
  final TenantSummary? tenant;
  
  MaintenanceModel({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.title,
    required this.description,
    required this.status,
    this.priority = 'medium',
    this.category,
    this.imageUrls,
    this.scheduledDate,
    this.completedDate,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.property,
    this.tenant,
  });
  
  factory MaintenanceModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$MaintenanceModelToJson(this);
  
  /// Status checks
  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  
  MaintenanceModel copyWith({
    int? id,
    int? propertyId,
    int? tenantId,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? category,
    List<String>? imageUrls,
    String? scheduledDate,
    String? completedDate,
    String? notes,
    String? createdAt,
    String? updatedAt,
    PropertySummary? property,
    TenantSummary? tenant,
  }) {
    return MaintenanceModel(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      tenantId: tenantId ?? this.tenantId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedDate: completedDate ?? this.completedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      property: property ?? this.property,
      tenant: tenant ?? this.tenant,
    );
  }
}

@JsonSerializable()
class PropertySummary {
  final int id;
  final String name;
  final String? address;
  
  PropertySummary({required this.id, required this.name, this.address});
  
  factory PropertySummary.fromJson(Map<String, dynamic> json) =>
      _$PropertySummaryFromJson(json);
  
  Map<String, dynamic> toJson() => _$PropertySummaryToJson(this);
}

@JsonSerializable()
class TenantSummary {
  final int id;
  final String name;
  final String? email;
  
  TenantSummary({required this.id, required this.name, this.email});
  
  factory TenantSummary.fromJson(Map<String, dynamic> json) =>
      _$TenantSummaryFromJson(json);
  
  Map<String, dynamic> toJson() => _$TenantSummaryToJson(this);
}
