import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/report_repository.dart';
import '../../auth/providers/auth_provider.dart';
import 'property_provider.dart';

/// Report Repository Provider
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return ReportRepository(apiClient, networkInfo);
});

/// Revenue Report Provider
final revenueReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, ReportFilters?>(
  (ref, filters) async {
    final repository = ref.watch(reportRepositoryProvider);
    return repository.getRevenueReport(
      startDate: filters?.startDate,
      endDate: filters?.endDate,
      propertyId: filters?.propertyId,
    );
  },
);

/// Expenses Report Provider
final expensesReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, ReportFilters?>(
  (ref, filters) async {
    final repository = ref.watch(reportRepositoryProvider);
    return repository.getExpensesReport(
      startDate: filters?.startDate,
      endDate: filters?.endDate,
      propertyId: filters?.propertyId,
    );
  },
);

/// Occupancy Report Provider
final occupancyReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, ReportFilters?>(
  (ref, filters) async {
    final repository = ref.watch(reportRepositoryProvider);
    return repository.getOccupancyReport(
      startDate: filters?.startDate,
      endDate: filters?.endDate,
      propertyId: filters?.propertyId,
    );
  },
);

/// Balance Sheet Provider
final balanceSheetProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String?>(
  (ref, asOfDate) async {
    final repository = ref.watch(reportRepositoryProvider);
    return repository.getBalanceSheet(asOfDate: asOfDate);
  },
);

/// Profit Loss Provider
final profitLossProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, DateRangeFilter?>(
  (ref, filter) async {
    final repository = ref.watch(reportRepositoryProvider);
    return repository.getProfitLoss(
      startDate: filter?.startDate,
      endDate: filter?.endDate,
    );
  },
);

/// Tenant Report Provider
final tenantReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, TenantReportFilter?>(
  (ref, filter) async {
    final repository = ref.watch(reportRepositoryProvider);
    return repository.getTenantReport(
      tenantId: filter?.tenantId,
      startDate: filter?.startDate,
      endDate: filter?.endDate,
    );
  },
);

/// Property Report Provider
final propertyReportProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, PropertyReportFilter?>(
  (ref, filter) async {
    final repository = ref.watch(reportRepositoryProvider);
    return repository.getPropertyReport(
      propertyId: filter?.propertyId,
      startDate: filter?.startDate,
      endDate: filter?.endDate,
    );
  },
);

/// Report Filters
class ReportFilters {
  final String? startDate;
  final String? endDate;
  final int? propertyId;
  
  ReportFilters({
    this.startDate,
    this.endDate,
    this.propertyId,
  });
}

class DateRangeFilter {
  final String? startDate;
  final String? endDate;
  
  DateRangeFilter({
    this.startDate,
    this.endDate,
  });
}

class TenantReportFilter {
  final int? tenantId;
  final String? startDate;
  final String? endDate;
  
  TenantReportFilter({
    this.tenantId,
    this.startDate,
    this.endDate,
  });
}

class PropertyReportFilter {
  final int? propertyId;
  final String? startDate;
  final String? endDate;
  
  PropertyReportFilter({
    this.propertyId,
    this.startDate,
    this.endDate,
  });
}
