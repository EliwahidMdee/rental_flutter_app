import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/api_constants.dart';

/// Report Repository
/// 
/// Handles report data operations

class ReportRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  
  ReportRepository(this._apiClient, this._networkInfo);
  
  /// Get revenue report
  Future<Map<String, dynamic>> getRevenueReport({
    String? startDate,
    String? endDate,
    int? propertyId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.revenueReport,
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (propertyId != null) 'property_id': propertyId,
      },
    );
    
    return response.data['data'] as Map<String, dynamic>;
  }
  
  /// Get expenses report
  Future<Map<String, dynamic>> getExpensesReport({
    String? startDate,
    String? endDate,
    int? propertyId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.expensesReport,
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (propertyId != null) 'property_id': propertyId,
      },
    );
    
    return response.data['data'] as Map<String, dynamic>;
  }
  
  /// Get occupancy report
  Future<Map<String, dynamic>> getOccupancyReport({
    String? startDate,
    String? endDate,
    int? propertyId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.occupancyReport,
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (propertyId != null) 'property_id': propertyId,
      },
    );
    
    return response.data['data'] as Map<String, dynamic>;
  }
  
  /// Get balance sheet
  Future<Map<String, dynamic>> getBalanceSheet({
    String? asOfDate,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.balanceSheet,
      queryParameters: {
        if (asOfDate != null) 'as_of_date': asOfDate,
      },
    );
    
    return response.data['data'] as Map<String, dynamic>;
  }
  
  /// Get profit and loss report
  Future<Map<String, dynamic>> getProfitLoss({
    String? startDate,
    String? endDate,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.profitLoss,
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    
    return response.data['data'] as Map<String, dynamic>;
  }
  
  /// Get tenant report
  Future<Map<String, dynamic>> getTenantReport({
    int? tenantId,
    String? startDate,
    String? endDate,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.tenantReport,
      queryParameters: {
        if (tenantId != null) 'tenant_id': tenantId,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    
    return response.data['data'] as Map<String, dynamic>;
  }
  
  /// Get property report
  Future<Map<String, dynamic>> getPropertyReport({
    int? propertyId,
    String? startDate,
    String? endDate,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.propertyReport,
      queryParameters: {
        if (propertyId != null) 'property_id': propertyId,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    
    return response.data['data'] as Map<String, dynamic>;
  }
}
