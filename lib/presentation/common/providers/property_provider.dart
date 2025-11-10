import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/property_model.dart';
import '../../../data/repositories/property_repository.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../auth/providers/auth_provider.dart';

/// Network Info Provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo(Connectivity());
});

/// Property Repository Provider
final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return PropertyRepository(apiClient, networkInfo);
});

/// Property List Provider
final propertiesProvider = FutureProvider.autoDispose.family<List<PropertyModel>, PropertyFilters?>(
  (ref, filters) async {
    final repository = ref.watch(propertyRepositoryProvider);
    return repository.getProperties(
      status: filters?.status,
      landlordId: filters?.landlordId,
      city: filters?.city,
      minRent: filters?.minRent,
      maxRent: filters?.maxRent,
      bedrooms: filters?.bedrooms,
    );
  },
);

/// Property Detail Provider
final propertyDetailProvider = FutureProvider.autoDispose.family<PropertyModel, int>(
  (ref, propertyId) async {
    final repository = ref.watch(propertyRepositoryProvider);
    return repository.getPropertyById(propertyId);
  },
);

/// Property Filters
class PropertyFilters {
  final String? status;
  final int? landlordId;
  final String? city;
  final double? minRent;
  final double? maxRent;
  final int? bedrooms;
  
  PropertyFilters({
    this.status,
    this.landlordId,
    this.city,
    this.minRent,
    this.maxRent,
    this.bedrooms,
  });
}
