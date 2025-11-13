// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      id: (json['id'] as num).toInt(),
      tenantId: (json['tenant_id'] as num).toInt(),
      propertyId: (json['property_id'] as num?)?.toInt(),
      leaseId: (json['lease_id'] as num?)?.toInt(),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      paymentDate: json['payment_date'] as String,
      paymentMethod: json['payment_method'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      tenant: json['tenant'] == null
          ? null
          : TenantSummary.fromJson(json['tenant'] as Map<String, dynamic>),
      property: json['property'] == null
          ? null
          : PropertySummary.fromJson(json['property'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'property_id': instance.propertyId,
      'lease_id': instance.leaseId,
      'amount': instance.amount,
      'currency': instance.currency,
      'payment_date': instance.paymentDate,
      'payment_method': instance.paymentMethod,
      'status': instance.status,
      'notes': instance.notes,
      'receipt_url': instance.receiptUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'tenant': instance.tenant,
      'property': instance.property,
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
