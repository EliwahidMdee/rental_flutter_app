import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

/// Property Model
/// 
/// Represents a rental property in the system

@JsonSerializable()
class PropertyModel {
  final int id;
  final String name;
  final String description;
  @JsonKey(name: 'landlord_id')
  final int landlordId;
  final String address;
  final String? city;
  final String? state;
  final String? country;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  final double rent;
  final String currency;
  final int bedrooms;
  final int bathrooms;
  @JsonKey(name: 'square_feet')
  final double? squareFeet;
  final String status; // available, occupied, maintenance, inactive
  final List<String> amenities;
  final List<String> images;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  
  PropertyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.landlordId,
    required this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    required this.rent,
    this.currency = 'USD',
    required this.bedrooms,
    required this.bathrooms,
    this.squareFeet,
    this.status = 'available',
    this.amenities = const [],
    this.images = const [],
    required this.createdAt,
    this.updatedAt,
  });
  
  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);
  
  /// Full address string
  String get fullAddress {
    final parts = [address, city, state, country]
        .where((p) => p != null && p.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
  
  /// Check if property is available
  bool get isAvailable => status == 'available';
  
  /// Check if property is occupied
  bool get isOccupied => status == 'occupied';
  
  /// Primary image
  String? get primaryImage => images.isNotEmpty ? images.first : null;
  
  PropertyModel copyWith({
    int? id,
    String? name,
    String? description,
    int? landlordId,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? rent,
    String? currency,
    int? bedrooms,
    int? bathrooms,
    double? squareFeet,
    String? status,
    List<String>? amenities,
    List<String>? images,
    String? createdAt,
    String? updatedAt,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      landlordId: landlordId ?? this.landlordId,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      rent: rent ?? this.rent,
      currency: currency ?? this.currency,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      squareFeet: squareFeet ?? this.squareFeet,
      status: status ?? this.status,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
