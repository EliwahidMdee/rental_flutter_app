import '../models/tenant_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/local_storage.dart';

/// Tenant Repository
/// 
/// Handles tenant data operations with caching

class TenantRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  
  TenantRepository(this._apiClient, this._networkInfo);
  
  /// Get all tenants with optional filters
  Future<List<TenantModel>> getTenants({
    int? landlordId,
    int? propertyId,
    String? search,
    int page = 1,
    int perPage = 15,
  }) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(
        ApiEndpoints.tenants,
        queryParameters: {
          if (landlordId != null) 'landlord_id': landlordId,
          if (propertyId != null) 'property_id': propertyId,
          if (search != null) 'search': search,
          'page': page,
          'per_page': perPage,
        },
      );
      
      final tenants = (response.data['data'] as List)
          .map((json) => TenantModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Cache tenants
      final box = LocalStorage.tenantsBox;
      for (final tenant in tenants) {
        await box.put(tenant.id.toString(), tenant.toJson());
      }
      
      return tenants;
    } else {
      // Return cached tenants
      return _getCachedTenants();
    }
  }
  
  /// Get tenant by ID
  Future<TenantModel> getTenantById(int id) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(ApiEndpoints.tenantDetail(id));
      final tenant = TenantModel.fromJson(response.data['data'] as Map<String, dynamic>);
      
      // Cache tenant
      final box = LocalStorage.tenantsBox;
      await box.put(id.toString(), tenant.toJson());
      
      return tenant;
    } else {
      // Return cached tenant
      final box = LocalStorage.tenantsBox;
      final data = box.get(id.toString());
      if (data == null) throw Exception('Tenant not found in cache');
      
      return TenantModel.fromJson(Map<String, dynamic>.from(data as Map));
    }
  }
  
  /// Get cached tenants
  List<TenantModel> _getCachedTenants() {
    final box = LocalStorage.tenantsBox;
    return box.values
        .map((json) => TenantModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }
}
