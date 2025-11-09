import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/auth/screens/login_screen.dart';
import '../presentation/auth/screens/splash_screen.dart';
import '../presentation/auth/providers/auth_provider.dart';

import '../presentation/admin/dashboard/admin_dashboard_screen.dart';
import '../presentation/landlord/dashboard/landlord_dashboard_screen.dart';
import '../presentation/landlord/properties/screens/property_list_screen.dart';
import '../presentation/tenant/dashboard/tenant_dashboard_screen.dart';
import '../presentation/tenant/payments/screens/payment_history_screen.dart';
import '../presentation/common/screens/settings_screen.dart';

/// Router Provider
/// 
/// Manages navigation and route configuration based on authentication state
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isOnAuthPage = state.location == '/login' || 
                          state.location == '/splash';
      
      // Redirect to login if not authenticated and not on auth page
      if (!isAuthenticated && !isOnAuthPage) {
        return '/login';
      }
      
      // Redirect to appropriate dashboard if authenticated and on auth page
      if (isAuthenticated && isOnAuthPage) {
        final user = authState.valueOrNull;
        if (user == null) return '/login';
        
        if (user.isAdmin) return '/admin';
        if (user.isLandlord) return '/landlord';
        if (user.isTenant) return '/tenant';
      }
      
      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Admin Routes
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'reports',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Admin Reports')),
            ),
          ),
          GoRoute(
            path: 'payments',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Payment Approvals')),
            ),
          ),
          GoRoute(
            path: 'management',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('User Management')),
            ),
          ),
        ],
      ),
      
      // Landlord Routes
      GoRoute(
        path: '/landlord',
        builder: (context, state) => const LandlordDashboardScreen(),
        routes: [
          GoRoute(
            path: 'properties',
            builder: (context, state) => const PropertyListScreen(),
          ),
          GoRoute(
            path: 'tenants',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Tenants')),
            ),
          ),
          GoRoute(
            path: 'payments',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Payments')),
            ),
          ),
        ],
      ),
      
      // Tenant Routes
      GoRoute(
        path: '/tenant',
        builder: (context, state) => const TenantDashboardScreen(),
        routes: [
          GoRoute(
            path: 'payment',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Make Payment')),
            ),
          ),
          GoRoute(
            path: 'history',
            builder: (context, state) => const PaymentHistoryScreen(),
          ),
          GoRoute(
            path: 'lease',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Lease Details')),
            ),
          ),
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Notifications')),
            ),
          ),
        ],
      ),
      
      // Settings (shared across all roles)
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.location,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Theme Mode Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
