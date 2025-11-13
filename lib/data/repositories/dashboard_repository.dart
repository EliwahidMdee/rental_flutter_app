import '../models/dashboard_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/local_storage.dart';

/// Dashboard Repository
/// 
/// Handles dashboard data operations with caching

class DashboardRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  
  DashboardRepository(this._apiClient, this._networkInfo);
  
  /// Get dashboard statistics
  Future<DashboardModel> getDashboardStats() async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(ApiEndpoints.dashboardStats);
      final dashboard = DashboardModel.fromJson(response.data['data'] as Map<String, dynamic>);
      
      // Cache dashboard
      final box = LocalStorage.dashboardBox;
      await box.put('dashboard_stats', dashboard.toJson());
      
      return dashboard;
    } else {
      // Return cached dashboard
      final box = LocalStorage.dashboardBox;
      final data = box.get('dashboard_stats');
      if (data == null) throw Exception('Dashboard stats not found in cache');
      
      return DashboardModel.fromJson(Map<String, dynamic>.from(data as Map));
    }
  }
  
  /// Get general dashboard data
  Future<Map<String, dynamic>> getDashboard() async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(ApiEndpoints.dashboard);
      final data = response.data['data'] as Map<String, dynamic>;
      
      // Cache dashboard
      final box = LocalStorage.dashboardBox;
      await box.put('dashboard_data', data);
      
      return data;
    } else {
      // Return cached dashboard
      final box = LocalStorage.dashboardBox;
      final data = box.get('dashboard_data');
      if (data == null) throw Exception('Dashboard data not found in cache');
      
      return Map<String, dynamic>.from(data as Map);
    }
  }
}
