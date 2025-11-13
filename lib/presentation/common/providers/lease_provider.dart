import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/lease_model.dart';
import '../../../data/repositories/lease_repository.dart';
import '../../auth/providers/auth_provider.dart';
import 'property_provider.dart';

/// Lease Repository Provider
final leaseRepositoryProvider = Provider<LeaseRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return LeaseRepository(apiClient, networkInfo);
});

/// Leases List Provider
final leasesProvider = FutureProvider.autoDispose.family<List<LeaseModel>, LeaseFilters?>(
  (ref, filters) async {
    final repository = ref.watch(leaseRepositoryProvider);
    return repository.getLeases(
      tenantId: filters?.tenantId,
      landlordId: filters?.landlordId,
      propertyId: filters?.propertyId,
      status: filters?.status,
    );
  },
);

/// Lease Detail Provider
final leaseDetailProvider = FutureProvider.autoDispose.family<LeaseModel, int>(
  (ref, leaseId) async {
    final repository = ref.watch(leaseRepositoryProvider);
    return repository.getLeaseById(leaseId);
  },
);

/// Current User Lease Provider (for tenants)
final currentUserLeaseProvider = FutureProvider.autoDispose<LeaseModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.user;
  
  if (user == null || !user.isTenant) {
    return null;
  }
  
  final repository = ref.watch(leaseRepositoryProvider);
  final leases = await repository.getLeases(tenantId: user.id, status: 'active');
  
  return leases.isNotEmpty ? leases.first : null;
});

/// Lease Filters
class LeaseFilters {
  final int? tenantId;
  final int? landlordId;
  final int? propertyId;
  final String? status;
  
  LeaseFilters({
    this.tenantId,
    this.landlordId,
    this.propertyId,
    this.status,
  });
}
