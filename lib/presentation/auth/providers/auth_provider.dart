import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user_model.dart';
import '../../../core/storage/secure_storage.dart';

/// Authentication State
enum AuthStatus { initial, loading, authenticated, unauthenticated }

/// Auth Result
sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  final UserModel user;
  const AuthSuccess(this.user);
}

class AuthFailure extends AuthResult {
  final String message;
  const AuthFailure(this.message);
}

/// Auth State Class
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final token = await SecureStorage.getAuthToken();
      
      if (token != null) {
        // TODO: Fetch user data from API or cache
        // For now, create a mock user
        final user = UserModel(
          id: 1,
          email: 'user@example.com',
          name: 'Test User',
          roles: [const RoleModel(id: 1, name: 'tenant')],
        );

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  /// Login with email and password
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // TODO: Call API to login
      // For now, mock a successful login
      await Future.delayed(const Duration(seconds: 2));

      // Mock user based on email
      final String role;
      if (email.contains('admin')) {
        role = 'admin';
      } else if (email.contains('landlord')) {
        role = 'landlord';
      } else {
        role = 'tenant';
      }

      final user = UserModel(
        id: 1,
        email: email,
        name: email.split('@')[0],
        roles: [RoleModel(id: 1, name: role)],
      );

      // Save token
      await SecureStorage.saveAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );

      return AuthSuccess(user);
    } catch (e) {
      final errorMessage = 'Login failed: ${e.toString()}';
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: errorMessage,
      );
      return AuthFailure(errorMessage);
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // TODO: Call API to logout
      await SecureStorage.deleteAuthToken();

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    }
  }
}

/// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
