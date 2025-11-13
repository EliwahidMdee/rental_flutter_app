import '../models/lease_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/local_storage.dart';

/// Lease Repository
/// 
/// Handles lease data operations with caching

class LeaseRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  
  LeaseRepository(this._apiClient, this._networkInfo);
  
  /// Get all leases with optional filters
  Future<List<LeaseModel>> getLeases({
    int? tenantId,
    int? landlordId,
    int? propertyId,
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(
        ApiEndpoints.leases,
        queryParameters: {
          if (tenantId != null) 'tenant_id': tenantId,
          if (landlordId != null) 'landlord_id': landlordId,
          if (propertyId != null) 'property_id': propertyId,
          if (status != null) 'status': status,
          'page': page,
          'per_page': perPage,
        },
      );
      
      final leases = (response.data['data'] as List)
          .map((json) => LeaseModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Cache leases
      final box = LocalStorage.leasesBox;
      for (final lease in leases) {
        await box.put(lease.id.toString(), lease.toJson());
      }
      
      return leases;
    } else {
      // Return cached leases
      return _getCachedLeases();
    }
  }
  
  /// Get lease by ID
  Future<LeaseModel> getLeaseById(int id) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(ApiEndpoints.leaseDetail(id));
      final lease = LeaseModel.fromJson(response.data['data'] as Map<String, dynamic>);
      
      // Cache lease
      final box = LocalStorage.leasesBox;
      await box.put(id.toString(), lease.toJson());
      
      return lease;
    } else {
      // Return cached lease
      final box = LocalStorage.leasesBox;
      final data = box.get(id.toString());
      if (data == null) throw Exception('Lease not found in cache');
      
      return LeaseModel.fromJson(Map<String, dynamic>.from(data as Map));
    }
  }
  
  /// Get cached leases
  List<LeaseModel> _getCachedLeases() {
    final box = LocalStorage.leasesBox;
    return box.values
        .map((json) => LeaseModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }
}
