import '../models/payment_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/local_storage.dart';

/// Payment Repository
/// 
/// Handles payment operations with offline support

class PaymentRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  
  PaymentRepository(this._apiClient, this._networkInfo);
  
  /// Get all payments with filters
  Future<List<PaymentModel>> getPayments({
    String? status,
    int? tenantId,
    int? propertyId,
    int page = 1,
    int perPage = 15,
  }) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(
        ApiEndpoints.payments,
        queryParameters: {
          if (status != null) 'status': status,
          if (tenantId != null) 'tenant_id': tenantId,
          if (propertyId != null) 'property_id': propertyId,
          'page': page,
          'per_page': perPage,
        },
      );
      
      final payments = (response.data['data'] as List)
          .map((json) => PaymentModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Cache payments
      final box = LocalStorage.paymentsBox;
      for (final payment in payments) {
        await box.put(payment.id.toString(), payment.toJson());
      }
      
      return payments;
    } else {
      return _getCachedPayments();
    }
  }
  
  /// Get pending payments
  Future<List<PaymentModel>> getPendingPayments() async {
    final response = await _apiClient.get(ApiEndpoints.pendingPayments);
    
    return (response.data['data'] as List)
        .map((json) => PaymentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
  
  /// Get payment by ID
  Future<PaymentModel> getPaymentById(int id) async {
    final response = await _apiClient.get(ApiEndpoints.paymentDetail(id));
    return PaymentModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
  
  /// Create new payment
  Future<PaymentModel> createPayment({
    required int tenantId,
    required int propertyId,
    int? leaseId,
    required double amount,
    required String paymentDate,
    required String paymentMethod,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.payments,
      data: {
        'tenant_id': tenantId,
        'property_id': propertyId,
        if (leaseId != null) 'lease_id': leaseId,
        'amount': amount,
        'payment_date': paymentDate,
        'payment_method': paymentMethod,
        if (notes != null) 'notes': notes,
      },
    );
    
    return PaymentModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
  
  /// Verify/approve payment
  Future<PaymentModel> verifyPayment(int id) async {
    final response = await _apiClient.post(ApiEndpoints.verifyPayment(id));
    return PaymentModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
  
  /// Reject payment
  Future<PaymentModel> rejectPayment(int id, String reason) async {
    final response = await _apiClient.post(
      ApiEndpoints.rejectPayment(id),
      data: {'reason': reason},
    );
    return PaymentModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
  
  /// Get cached payments
  List<PaymentModel> _getCachedPayments() {
    final box = LocalStorage.paymentsBox;
    return box.values
        .map((json) => PaymentModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }
}
