import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';

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

/// Providers
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  
  AuthNotifier(this._authRepository) : super(const AuthState());

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      
      if (isLoggedIn) {
        try {
          // Try to get current user from API
          final user = await _authRepository.getCurrentUser();
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          );
        } catch (e) {
          // Fallback to cached user
          final cachedUser = await _authRepository.getCachedUser();
          if (cachedUser != null) {
            state = state.copyWith(
              status: AuthStatus.authenticated,
              user: cachedUser,
            );
          } else {
            state = state.copyWith(status: AuthStatus.unauthenticated);
          }
        }
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
      final result = await _authRepository.login(
        email: email,
        password: password,
      );
      
      final user = result['user'] as UserModel;

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );

      return AuthSuccess(user);
    } on ApiException catch (e) {
      final errorMessage = e.message;
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: errorMessage,
      );
      return AuthFailure(errorMessage);
    } catch (e) {
      final errorMessage = 'Login failed: ${e.toString()}';
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: errorMessage,
      );
      return AuthFailure(errorMessage);
    }
  }

  /// Register new user
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    required List<String> roles,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
        roles: roles,
      );
      
      final user = result['user'] as UserModel;

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );

      return AuthSuccess(user);
    } on ApiException catch (e) {
      final errorMessage = e.message;
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: errorMessage,
      );
      return AuthFailure(errorMessage);
    } catch (e) {
      final errorMessage = 'Registration failed: ${e.toString()}';
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
      await _authRepository.logout();

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
  
  /// Forgot password
  Future<bool> forgotPassword(String email) async {
    try {
      await _authRepository.forgotPassword(email);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }
}

/// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
