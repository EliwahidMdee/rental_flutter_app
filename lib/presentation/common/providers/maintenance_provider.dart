import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/maintenance_model.dart';
import '../../../data/repositories/maintenance_repository.dart';
import '../../auth/providers/auth_provider.dart';
import 'property_provider.dart';

/// Maintenance Repository Provider
final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return MaintenanceRepository(apiClient, networkInfo);
});

/// Maintenance Requests List Provider
final maintenanceRequestsProvider = FutureProvider.autoDispose.family<List<MaintenanceModel>, MaintenanceFilters?>(
  (ref, filters) async {
    final repository = ref.watch(maintenanceRepositoryProvider);
    return repository.getMaintenanceRequests(
      tenantId: filters?.tenantId,
      propertyId: filters?.propertyId,
      status: filters?.status,
      priority: filters?.priority,
    );
  },
);

/// Maintenance Request Detail Provider
final maintenanceDetailProvider = FutureProvider.autoDispose.family<MaintenanceModel, int>(
  (ref, maintenanceId) async {
    final repository = ref.watch(maintenanceRepositoryProvider);
    return repository.getMaintenanceById(maintenanceId);
  },
);

/// Current User Maintenance Requests Provider (for tenants)
final currentUserMaintenanceProvider = FutureProvider.autoDispose<List<MaintenanceModel>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.user;
  
  if (user == null || !user.isTenant) {
    return [];
  }
  
  final repository = ref.watch(maintenanceRepositoryProvider);
  return repository.getMaintenanceRequests(tenantId: user.id);
});

/// Pending Maintenance Count Provider
final pendingMaintenanceCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repository = ref.watch(maintenanceRepositoryProvider);
  final requests = await repository.getMaintenanceRequests(status: 'pending');
  return requests.length;
});

/// Maintenance Filters
class MaintenanceFilters {
  final int? tenantId;
  final int? propertyId;
  final String? status;
  final String? priority;
  
  MaintenanceFilters({
    this.tenantId,
    this.propertyId,
    this.status,
    this.priority,
  });
}
