// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      landlordId: json['landlord_id'] as int,
      address: json['address'] as String,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
      rent: (json['rent'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      squareFeet: (json['square_feet'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'available',
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'landlord_id': instance.landlordId,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postal_code': instance.postalCode,
      'rent': instance.rent,
      'currency': instance.currency,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'square_feet': instance.squareFeet,
      'status': instance.status,
      'amenities': instance.amenities,
      'images': instance.images,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
