import 'package:flutter_test/flutter_test.dart';
import 'package:rental_flutter_app/data/models/user_model.dart';
import 'package:rental_flutter_app/data/models/property_model.dart';
import 'package:rental_flutter_app/data/models/payment_model.dart';

class MockData {
  // Mock Users
  static final adminUser = UserModel(
    id: '1',
    name: 'Admin User',
    email: 'admin@example.com',
    role: UserRole.admin,
    createdAt: DateTime(2024, 1, 1),
  );

  static final landlordUser = UserModel(
    id: '2',
    name: 'John Landlord',
    email: 'landlord@example.com',
    role: UserRole.landlord,
    phone: '1234567890',
    createdAt: DateTime(2024, 1, 1),
  );

  static final tenantUser = UserModel(
    id: '3',
    name: 'Jane Tenant',
    email: 'tenant@example.com',
    role: UserRole.tenant,
    phone: '0987654321',
    createdAt: DateTime(2024, 1, 1),
  );

  // Mock Properties
  static final property1 = PropertyModel(
    id: '1',
    name: 'Modern Apartment',
    description: 'Beautiful 2-bedroom apartment in downtown',
    address: '123 Main St',
    city: 'New York',
    state: 'NY',
    postalCode: '10001',
    rent: 2500.0,
    bedrooms: 2,
    bathrooms: 2,
    squareFeet: 1200,
    status: PropertyStatus.available,
    amenities: ['Parking', 'Pool', 'Gym'],
    images: ['https://example.com/image1.jpg'],
    landlordId: '2',
    createdAt: DateTime(2024, 1, 1),
  );

  static final property2 = PropertyModel(
    id: '2',
    name: 'Cozy Studio',
    description: 'Perfect for single occupancy',
    address: '456 Oak Ave',
    city: 'Los Angeles',
    state: 'CA',
    postalCode: '90001',
    rent: 1500.0,
    bedrooms: 1,
    bathrooms: 1,
    squareFeet: 600,
    status: PropertyStatus.occupied,
    amenities: ['WiFi', 'Laundry'],
    images: ['https://example.com/image2.jpg'],
    landlordId: '2',
    createdAt: DateTime(2024, 1, 1),
  );

  // Mock Payments
  static final payment1 = PaymentModel(
    id: '1',
    tenantId: '3',
    propertyId: '1',
    amount: 2500.0,
    paymentDate: DateTime(2024, 1, 15),
    paymentMethod: PaymentMethod.bankTransfer,
    status: PaymentStatus.completed,
    notes: 'January rent payment',
    createdAt: DateTime(2024, 1, 15),
  );

  static final payment2 = PaymentModel(
    id: '2',
    tenantId: '3',
    propertyId: '1',
    amount: 2500.0,
    paymentDate: DateTime(2024, 2, 15),
    paymentMethod: PaymentMethod.card,
    status: PaymentStatus.pending,
    notes: 'February rent payment',
    createdAt: DateTime(2024, 2, 15),
  );

  // Mock API Responses
  static final loginResponse = {
    'user': {
      'id': '3',
      'name': 'Jane Tenant',
      'email': 'tenant@example.com',
      'role': 'tenant',
      'phone': '0987654321',
      'createdAt': '2024-01-01T00:00:00Z',
    },
    'token': 'mock_auth_token_12345',
  };

  static final propertiesResponse = {
    'properties': [
      {
        'id': '1',
        'name': 'Modern Apartment',
        'description': 'Beautiful 2-bedroom apartment in downtown',
        'address': '123 Main St',
        'city': 'New York',
        'state': 'NY',
        'postalCode': '10001',
        'rent': 2500.0,
        'bedrooms': 2,
        'bathrooms': 2,
        'squareFeet': 1200,
        'status': 'available',
        'amenities': ['Parking', 'Pool', 'Gym'],
        'images': ['https://example.com/image1.jpg'],
        'landlordId': '2',
        'createdAt': '2024-01-01T00:00:00Z',
      },
    ],
  };

  static final paymentsResponse = {
    'payments': [
      {
        'id': '1',
        'tenantId': '3',
        'propertyId': '1',
        'amount': 2500.0,
        'paymentDate': '2024-01-15T00:00:00Z',
        'paymentMethod': 'bank_transfer',
        'status': 'completed',
        'notes': 'January rent payment',
        'createdAt': '2024-01-15T00:00:00Z',
      },
    ],
  };
}
