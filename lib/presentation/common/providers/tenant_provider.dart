import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/tenant_model.dart';
import '../../../data/repositories/tenant_repository.dart';
import '../../auth/providers/auth_provider.dart';
import 'property_provider.dart';

/// Tenant Repository Provider
final tenantRepositoryProvider = Provider<TenantRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return TenantRepository(apiClient, networkInfo);
});

/// Tenants List Provider
final tenantsProvider = FutureProvider.autoDispose.family<List<TenantModel>, TenantFilters?>(
  (ref, filters) async {
    final repository = ref.watch(tenantRepositoryProvider);
    return repository.getTenants(
      landlordId: filters?.landlordId,
      propertyId: filters?.propertyId,
      search: filters?.search,
    );
  },
);

/// Tenant Detail Provider
final tenantDetailProvider = FutureProvider.autoDispose.family<TenantModel, int>(
  (ref, tenantId) async {
    final repository = ref.watch(tenantRepositoryProvider);
    return repository.getTenantById(tenantId);
  },
);

/// Landlord Tenants Provider (for landlords)
final landlordTenantsProvider = FutureProvider.autoDispose<List<TenantModel>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.user;
  
  if (user == null || !user.isLandlord) {
    return [];
  }
  
  final repository = ref.watch(tenantRepositoryProvider);
  return repository.getTenants(landlordId: user.id);
});

/// Tenant Filters
class TenantFilters {
  final int? landlordId;
  final int? propertyId;
  final String? search;
  
  TenantFilters({
    this.landlordId,
    this.propertyId,
    this.search,
  });
}
