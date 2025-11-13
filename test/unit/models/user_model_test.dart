import 'package:flutter_test/flutter_test.dart';
import 'package:rental_management_app/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create user from JSON', () {
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'tenant',
        'phone': '1234567890',
        'createdAt': '2024-01-01T00:00:00Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.role, UserRole.tenant);
      expect(user.phone, '1234567890');
    });

    test('should convert user to JSON', () {
      final user = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: UserRole.tenant,
        phone: '1234567890',
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['role'], 'tenant');
      expect(json['phone'], '1234567890');
    });

    test('should check if user is admin', () {
      final admin = UserModel(
        id: '1',
        name: 'Admin User',
        email: 'admin@example.com',
        role: UserRole.admin,
        createdAt: DateTime.now(),
      );

      expect(admin.isAdmin, true);
      expect(admin.isLandlord, false);
      expect(admin.isTenant, false);
    });

    test('should check if user is landlord', () {
      final landlord = UserModel(
        id: '1',
        name: 'Landlord User',
        email: 'landlord@example.com',
        role: UserRole.landlord,
        createdAt: DateTime.now(),
      );

      expect(landlord.isAdmin, false);
      expect(landlord.isLandlord, true);
      expect(landlord.isTenant, false);
    });

    test('should check if user is tenant', () {
      final tenant = UserModel(
        id: '1',
        name: 'Tenant User',
        email: 'tenant@example.com',
        role: UserRole.tenant,
        createdAt: DateTime.now(),
      );

      expect(tenant.isAdmin, false);
      expect(tenant.isLandlord, false);
      expect(tenant.isTenant, true);
    });

    test('should handle missing optional fields', () {
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'tenant',
        'createdAt': '2024-01-01T00:00:00Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.phone, null);
      expect(user.avatarUrl, null);
    });
  });
}
