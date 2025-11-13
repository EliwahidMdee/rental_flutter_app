import '../models/maintenance_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/local_storage.dart';

/// Maintenance Repository
/// 
/// Handles maintenance request data operations with caching

class MaintenanceRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  
  MaintenanceRepository(this._apiClient, this._networkInfo);
  
  /// Get all maintenance requests with optional filters
  Future<List<MaintenanceModel>> getMaintenanceRequests({
    int? tenantId,
    int? propertyId,
    String? status,
    String? priority,
    int page = 1,
    int perPage = 15,
  }) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(
        ApiEndpoints.maintenanceRequests,
        queryParameters: {
          if (tenantId != null) 'tenant_id': tenantId,
          if (propertyId != null) 'property_id': propertyId,
          if (status != null) 'status': status,
          if (priority != null) 'priority': priority,
          'page': page,
          'per_page': perPage,
        },
      );
      
      final requests = (response.data['data'] as List)
          .map((json) => MaintenanceModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Cache maintenance requests
      final box = LocalStorage.maintenanceBox;
      for (final request in requests) {
        await box.put(request.id.toString(), request.toJson());
      }
      
      return requests;
    } else {
      // Return cached maintenance requests
      return _getCachedMaintenanceRequests();
    }
  }
  
  /// Get maintenance request by ID
  Future<MaintenanceModel> getMaintenanceById(int id) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(ApiEndpoints.maintenanceDetail(id));
      final request = MaintenanceModel.fromJson(response.data['data'] as Map<String, dynamic>);
      
      // Cache maintenance request
      final box = LocalStorage.maintenanceBox;
      await box.put(id.toString(), request.toJson());
      
      return request;
    } else {
      // Return cached maintenance request
      final box = LocalStorage.maintenanceBox;
      final data = box.get(id.toString());
      if (data == null) throw Exception('Maintenance request not found in cache');
      
      return MaintenanceModel.fromJson(Map<String, dynamic>.from(data as Map));
    }
  }
  
  /// Create new maintenance request
  Future<MaintenanceModel> createMaintenanceRequest(MaintenanceModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.maintenanceRequests,
      data: request.toJson(),
    );
    
    return MaintenanceModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
  
  /// Update maintenance request
  Future<MaintenanceModel> updateMaintenanceRequest(int id, MaintenanceModel request) async {
    final response = await _apiClient.put(
      ApiEndpoints.maintenanceDetail(id),
      data: request.toJson(),
    );
    
    return MaintenanceModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
  
  /// Get cached maintenance requests
  List<MaintenanceModel> _getCachedMaintenanceRequests() {
    final box = LocalStorage.maintenanceBox;
    return box.values
        .map((json) => MaintenanceModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }
}
