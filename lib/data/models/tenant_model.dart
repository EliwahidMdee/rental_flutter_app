import 'package:json_annotation/json_annotation.dart';

part 'tenant_model.g.dart';

/// Tenant Model
/// 
/// Represents a tenant in the system

@JsonSerializable()
class TenantModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  final String? occupation;
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  // Current lease info (if any)
  @JsonKey(name: 'current_lease')
  final LeaseSummary? currentLease;
  
  TenantModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.dateOfBirth,
    this.occupation,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.createdAt,
    this.updatedAt,
    this.currentLease,
  });
  
  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TenantModelToJson(this);
  
  TenantModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? dateOfBirth,
    String? occupation,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? createdAt,
    String? updatedAt,
    LeaseSummary? currentLease,
  }) {
    return TenantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      occupation: occupation ?? this.occupation,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentLease: currentLease ?? this.currentLease,
    );
  }
}

@JsonSerializable()
class LeaseSummary {
  final int id;
  @JsonKey(name: 'property_id')
  final int propertyId;
  @JsonKey(name: 'property_name')
  final String propertyName;
  @JsonKey(name: 'monthly_rent')
  final double monthlyRent;
  final String status;
  
  LeaseSummary({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.monthlyRent,
    required this.status,
  });
  
  factory LeaseSummary.fromJson(Map<String, dynamic> json) =>
      _$LeaseSummaryFromJson(json);
  
  Map<String, dynamic> toJson() => _$LeaseSummaryToJson(this);
}
