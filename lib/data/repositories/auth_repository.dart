import '../models/user_model.dart';
import '../models/property_model.dart';
import '../models/payment_model.dart';
import '../models/lease_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/local_storage.dart';

/// Auth Repository
/// 
/// Handles authentication operations

class AuthRepository {
  final ApiClient _apiClient;
  
  AuthRepository(this._apiClient);
  
  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    print('AuthRepository: login called with email: ' + email);
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
        'device_name': 'mobile',
      },
    );
    print('AuthRepository: login API response: ' + response.data.toString());
    final data = response.data['data'] ?? response.data;
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    
    // Store token and user data
    await SecureStorage.saveAuthToken(token);
    await LocalStorage.save('settings', 'user_data', user.toJson());
    
    return {
      'token': token,
      'user': user,
    };
  }
  
  /// Register new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    required List<String> roles,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'name': name,
        if (phone != null) 'phone': phone,
        'roles': roles,
      },
    );
    
    final data = response.data['data'] ?? response.data;
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    
    await SecureStorage.saveAuthToken(token);
    await LocalStorage.save('settings', 'user_data', user.toJson());
    
    return {
      'token': token,
      'user': user,
    };
  }
  
  /// Get current user
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.currentUser);
    final user = UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    
    // Update cached user
    await LocalStorage.save('settings', 'user_data', user.toJson());
    
    return user;
  }
  
  /// Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } finally {
      await SecureStorage.clearAll();
      await LocalStorage.clearAll();
    }
  }
  
  /// Get cached user
  Future<UserModel?> getCachedUser() async {
    final userData = await LocalStorage.get('settings', 'user_data');
    if (userData == null) return null;
    
    return UserModel.fromJson(Map<String, dynamic>.from(userData as Map));
  }
  
  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getAuthToken();
    return token != null;
  }
  
  /// Forgot password
  Future<void> forgotPassword(String email) async {
    await _apiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }
  
  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    await _apiClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'email': email,
        'token': token,
        'password': password,
      },
    );
  }
}
