// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lease_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaseModel _$LeaseModelFromJson(Map<String, dynamic> json) => LeaseModel(
      id: (json['id'] as num).toInt(),
      propertyId: (json['property_id'] as num).toInt(),
      tenantId: (json['tenant_id'] as num).toInt(),
      landlordId: (json['landlord_id'] as num).toInt(),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      monthlyRent: (json['monthly_rent'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      securityDeposit: (json['security_deposit'] as num?)?.toDouble(),
      status: json['status'] as String,
      terms: json['terms'] as String?,
      contractUrl: json['contract_url'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      property: json['property'] == null
          ? null
          : PropertySummary.fromJson(json['property'] as Map<String, dynamic>),
      tenant: json['tenant'] == null
          ? null
          : TenantSummary.fromJson(json['tenant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeaseModelToJson(LeaseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'tenant_id': instance.tenantId,
      'landlord_id': instance.landlordId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'monthly_rent': instance.monthlyRent,
      'currency': instance.currency,
      'security_deposit': instance.securityDeposit,
      'status': instance.status,
      'terms': instance.terms,
      'contract_url': instance.contractUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'property': instance.property,
      'tenant': instance.tenant,
    };

PropertySummary _$PropertySummaryFromJson(Map<String, dynamic> json) =>
    PropertySummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$PropertySummaryToJson(PropertySummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
    };

TenantSummary _$TenantSummaryFromJson(Map<String, dynamic> json) =>
    TenantSummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$TenantSummaryToJson(TenantSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
