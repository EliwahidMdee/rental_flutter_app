/// User Model
/// 
/// Represents a user in the system with role information

class UserModel {
  final int id;
  final String email;
  final String name;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final List<RoleModel> roles;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.firstName,
    this.lastName,
    this.profilePicture,
    required this.roles,
    this.createdAt,
  });

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      profilePicture: json['profile_picture'] as String?,
      roles: (json['roles'] as List?)
              ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
      'roles': roles.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
    };
  }

  /// Full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return name;
  }

  /// Primary role
  String? get primaryRole => roles.isNotEmpty ? roles.first.name : null;

  /// Check if user has specific role
  bool hasRole(String roleName) {
    return roles.any((role) => role.name.toLowerCase() == roleName.toLowerCase());
  }

  /// Role check helpers
  bool get isAdmin => hasRole('admin');
  bool get isLandlord => hasRole('landlord');
  bool get isTenant => hasRole('tenant');

  /// Copy with
  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? firstName,
    String? lastName,
    String? profilePicture,
    List<RoleModel>? roles,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      roles: roles ?? this.roles,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Role Model
class RoleModel {
  final int id;
  final String name;
  final String? displayName;

  const RoleModel({
    required this.id,
    required this.name,
    this.displayName,
  });

  /// Create from JSON
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as int,
      name: json['name'] as String,
      displayName: json['display_name'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
    };
  }
}
