import 'package:json_annotation/json_annotation.dart';

part 'dashboard_model.g.dart';

/// Dashboard Model
/// 
/// Represents dashboard statistics and data

@JsonSerializable()
class DashboardModel {
  @JsonKey(name: 'total_properties')
  final int totalProperties;
  @JsonKey(name: 'total_tenants')
  final int totalTenants;
  @JsonKey(name: 'occupied_units')
  final int occupiedUnits;
  @JsonKey(name: 'vacant_units')
  final int vacantUnits;
  @JsonKey(name: 'occupancy_rate')
  final double occupancyRate;
  @JsonKey(name: 'monthly_revenue')
  final double monthlyRevenue;
  @JsonKey(name: 'pending_payments')
  final int pendingPayments;
  @JsonKey(name: 'maintenance_requests')
  final int maintenanceRequests;
  @JsonKey(name: 'recent_payments')
  final List<PaymentSummary>? recentPayments;
  @JsonKey(name: 'upcoming_lease_renewals')
  final int? upcomingLeaseRenewals;
  
  DashboardModel({
    required this.totalProperties,
    required this.totalTenants,
    required this.occupiedUnits,
    required this.vacantUnits,
    required this.occupancyRate,
    required this.monthlyRevenue,
    required this.pendingPayments,
    required this.maintenanceRequests,
    this.recentPayments,
    this.upcomingLeaseRenewals,
  });
  
  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$DashboardModelToJson(this);
}

@JsonSerializable()
class PaymentSummary {
  final int id;
  @JsonKey(name: 'tenant_name')
  final String tenantName;
  final double amount;
  final String status;
  @JsonKey(name: 'payment_date')
  final String paymentDate;
  
  PaymentSummary({
    required this.id,
    required this.tenantName,
    required this.amount,
    required this.status,
    required this.paymentDate,
  });
  
  factory PaymentSummary.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaymentSummaryToJson(this);
}
