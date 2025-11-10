import 'package:json_annotation/json_annotation.dart';

part 'lease_model.g.dart';

/// Lease Model
/// 
/// Represents a lease agreement between landlord and tenant

@JsonSerializable()
class LeaseModel {
  final int id;
  @JsonKey(name: 'property_id')
  final int propertyId;
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  @JsonKey(name: 'landlord_id')
  final int landlordId;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  @JsonKey(name: 'monthly_rent')
  final double monthlyRent;
  final String currency;
  @JsonKey(name: 'security_deposit')
  final double? securityDeposit;
  final String status; // active, expired, pending, terminated
  final String? terms;
  @JsonKey(name: 'contract_url')
  final String? contractUrl;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  // Relationships
  final PropertySummary? property;
  final TenantSummary? tenant;
  
  LeaseModel({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.landlordId,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    this.currency = 'USD',
    this.securityDeposit,
    required this.status,
    this.terms,
    this.contractUrl,
    required this.createdAt,
    this.updatedAt,
    this.property,
    this.tenant,
  });
  
  factory LeaseModel.fromJson(Map<String, dynamic> json) =>
      _$LeaseModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$LeaseModelToJson(this);
  
  /// Lease status checks
  bool get isActive => status == 'active';
  bool get isExpired => status == 'expired';
  bool get isPending => status == 'pending';
  bool get isTerminated => status == 'terminated';
  
  /// Formatted rent
  String get formattedRent => '\$$monthlyRent/$currency';
  
  LeaseModel copyWith({
    int? id,
    int? propertyId,
    int? tenantId,
    int? landlordId,
    String? startDate,
    String? endDate,
    double? monthlyRent,
    String? currency,
    double? securityDeposit,
    String? status,
    String? terms,
    String? contractUrl,
    String? createdAt,
    String? updatedAt,
    PropertySummary? property,
    TenantSummary? tenant,
  }) {
    return LeaseModel(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      tenantId: tenantId ?? this.tenantId,
      landlordId: landlordId ?? this.landlordId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      currency: currency ?? this.currency,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      status: status ?? this.status,
      terms: terms ?? this.terms,
      contractUrl: contractUrl ?? this.contractUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      property: property ?? this.property,
      tenant: tenant ?? this.tenant,
    );
  }
}

// Import these from payment_model if needed
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
