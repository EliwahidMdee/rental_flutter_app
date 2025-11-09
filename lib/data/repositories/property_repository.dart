import '../models/property_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/api_constants.dart';
import '../../core/storage/local_storage.dart';

/// Property Repository
/// 
/// Handles property data operations with caching

class PropertyRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;
  
  PropertyRepository(this._apiClient, this._networkInfo);
  
  /// Get all properties with optional filters
  Future<List<PropertyModel>> getProperties({
    String? status,
    int? landlordId,
    String? city,
    double? minRent,
    double? maxRent,
    int? bedrooms,
    int page = 1,
    int perPage = 15,
  }) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(
        ApiEndpoints.properties,
        queryParameters: {
          if (status != null) 'status': status,
          if (landlordId != null) 'landlord_id': landlordId,
          if (city != null) 'city': city,
          if (minRent != null) 'min_rent': minRent,
          if (maxRent != null) 'max_rent': maxRent,
          if (bedrooms != null) 'bedrooms': bedrooms,
          'page': page,
          'per_page': perPage,
        },
      );
      
      final properties = (response.data['data'] as List)
          .map((json) => PropertyModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Cache properties
      final box = LocalStorage.propertiesBox;
      for (final property in properties) {
        await box.put(property.id.toString(), property.toJson());
      }
      
      return properties;
    } else {
      // Return cached properties
      return _getCachedProperties();
    }
  }
  
  /// Get property by ID
  Future<PropertyModel> getPropertyById(int id) async {
    final isOnline = await _networkInfo.isConnected;
    
    if (isOnline) {
      final response = await _apiClient.get(ApiEndpoints.propertyDetail(id));
      final property = PropertyModel.fromJson(response.data['data'] as Map<String, dynamic>);
      
      // Cache property
      final box = LocalStorage.propertiesBox;
      await box.put(id.toString(), property.toJson());
      
      return property;
    } else {
      // Return cached property
      final box = LocalStorage.propertiesBox;
      final data = box.get(id.toString());
      if (data == null) throw Exception('Property not found in cache');
      
      return PropertyModel.fromJson(Map<String, dynamic>.from(data as Map));
    }
  }
  
  /// Create new property
  Future<PropertyModel> createProperty(PropertyModel property) async {
    final response = await _apiClient.post(
      ApiEndpoints.properties,
      data: property.toJson(),
    );
    
    return PropertyModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
  
  /// Update property
  Future<PropertyModel> updateProperty(int id, PropertyModel property) async {
    final response = await _apiClient.put(
      ApiEndpoints.propertyDetail(id),
      data: property.toJson(),
    );
    
    return PropertyModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
  
  /// Delete property
  Future<void> deleteProperty(int id) async {
    await _apiClient.delete(ApiEndpoints.propertyDetail(id));
    
    // Remove from cache
    final box = LocalStorage.propertiesBox;
    await box.delete(id.toString());
  }
  
  /// Upload property images
  Future<List<String>> uploadImages(int propertyId, List<String> imagePaths) async {
    final imageUrls = <String>[];
    
    for (final imagePath in imagePaths) {
      final response = await _apiClient.uploadFile(
        ApiEndpoints.propertyImages(propertyId),
        imagePath,
        fieldName: 'image',
      );
      
      final imageUrl = response.data['data']['url'] as String;
      imageUrls.add(imageUrl);
    }
    
    return imageUrls;
  }
  
  /// Get cached properties
  List<PropertyModel> _getCachedProperties() {
    final box = LocalStorage.propertiesBox;
    return box.values
        .map((json) => PropertyModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }
}
