import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

/// Payment Model
/// 
/// Represents a payment transaction in the system

@JsonSerializable()
class PaymentModel {
  final int id;
  @JsonKey(name: 'tenant_id')
  final int tenantId;
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @JsonKey(name: 'lease_id')
  final int? leaseId;
  final double amount;
  final String currency;
  @JsonKey(name: 'payment_date')
  final String paymentDate;
  @JsonKey(name: 'payment_method')
  final String paymentMethod; // cash, card, bank_transfer, mobile_money, cheque
  final String status; // pending, paid, rejected, partial
  final String? notes;
  @JsonKey(name: 'receipt_url')
  final String? receiptUrl;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  // Relationships
  final TenantSummary? tenant;
  final PropertySummary? property;
  
  PaymentModel({
    required this.id,
    required this.tenantId,
    this.propertyId,
    this.leaseId,
    required this.amount,
    this.currency = 'USD',
    required this.paymentDate,
    required this.paymentMethod,
    required this.status,
    this.notes,
    this.receiptUrl,
    required this.createdAt,
    this.updatedAt,
    this.tenant,
    this.property,
  });
  
  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
  
  /// Payment status checks
  bool get isPending => status == 'pending';
  bool get isPaid => status == 'paid';
  bool get isRejected => status == 'rejected';
  bool get isPartial => status == 'partial';
  
  /// Display formatted amount
  String get formattedAmount => '\$$amount';
  
  PaymentModel copyWith({
    int? id,
    int? tenantId,
    int? propertyId,
    int? leaseId,
    double? amount,
    String? currency,
    String? paymentDate,
    String? paymentMethod,
    String? status,
    String? notes,
    String? receiptUrl,
    String? createdAt,
    String? updatedAt,
    TenantSummary? tenant,
    PropertySummary? property,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      propertyId: propertyId ?? this.propertyId,
      leaseId: leaseId ?? this.leaseId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tenant: tenant ?? this.tenant,
      property: property ?? this.property,
    );
  }
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
