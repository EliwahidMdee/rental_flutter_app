import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as fr;
import 'package:go_router/go_router.dart';

import '../presentation/auth/screens/login_screen.dart';
import '../presentation/auth/screens/register_screen.dart';
import '../presentation/auth/screens/forgot_password_screen.dart';
import '../presentation/auth/screens/splash_screen.dart';
import '../presentation/auth/providers/auth_provider.dart';
import '../core/storage/local_storage.dart';

import '../presentation/admin/dashboard/admin_dashboard_screen.dart';
import '../presentation/admin/payments/payment_approval_screen.dart';
import '../presentation/admin/reports/admin_reports_screen.dart';
import '../presentation/landlord/dashboard/landlord_dashboard_screen.dart';
import '../presentation/landlord/properties/screens/property_list_screen.dart';
import '../presentation/landlord/properties/screens/property_detail_screen.dart';
import '../presentation/landlord/tenants/screens/tenant_list_screen.dart';
import '../presentation/tenant/dashboard/tenant_dashboard_screen.dart';
import '../presentation/tenant/payments/screens/payment_history_screen.dart';
import '../presentation/tenant/payments/screens/make_payment_screen.dart';
import '../presentation/tenant/lease/screens/lease_detail_screen.dart';
import '../presentation/tenant/maintenance/screens/maintenance_request_screen.dart';
import '../presentation/tenant/maintenance/screens/maintenance_history_screen.dart';
import '../presentation/common/screens/settings_screen.dart';
import '../presentation/common/screens/notifications_screen.dart';
import '../presentation/common/screens/conversations_screen.dart';
import '../presentation/common/screens/messages_screen.dart';
import '../presentation/common/screens/user_profile_screen.dart';
import '../presentation/common/screens/help_support_screen.dart';
import '../presentation/common/screens/terms_conditions_screen.dart';
import '../presentation/common/screens/privacy_policy_screen.dart';
import '../presentation/common/widgets/app_shell.dart';

/// Router Provider
/// 
/// Manages navigation and route configuration based on authentication state
final splashShownProvider = fr.StateProvider<bool>((ref) => false);

final routerProvider = fr.Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final splashShown = ref.watch(splashShownProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isOnSplash = state.uri.path == '/splash';
      final isOnLogin = state.uri.path == '/login';

      // Restrict navigation to splash after initial load
      if (isOnSplash && splashShown) {
        return '/login';
      }

      // Only redirect if not authenticated and not on login or splash
      if (!isAuthenticated && !isOnLogin && !isOnSplash) {
        return '/login';
      }
      // If authenticated and on login, go to dashboard
      if (isAuthenticated && isOnLogin) {
        final user = authState.user;
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
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ShellRoute ensures the AppShell (with bottom nav) wraps all inner pages
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child, currentLocation: state.uri.toString()),
        routes: [
          // Admin Routes
          GoRoute(
            path: '/admin',
            builder: (context, state) => const AdminDashboardScreen(),
            routes: [
              GoRoute(
                path: 'reports',
                builder: (context, state) => const AdminReportsScreen(),
              ),
              GoRoute(
                path: 'payments',
                builder: (context, state) => const PaymentApprovalScreen(),
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
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return PropertyDetailScreen(propertyId: id);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'tenants',
                builder: (context, state) => const TenantListScreen(),
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
                builder: (context, state) => const MakePaymentScreen(),
              ),
              GoRoute(
                path: 'history',
                builder: (context, state) => const PaymentHistoryScreen(),
              ),
              GoRoute(
                path: 'lease',
                builder: (context, state) => const LeaseDetailScreen(),
              ),
              GoRoute(
                path: 'maintenance',
                builder: (context, state) => const MaintenanceRequestScreen(),
              ),
              GoRoute(
                path: 'maintenance-history',
                builder: (context, state) => const MaintenanceHistoryScreen(),
              ),
              GoRoute(
                path: 'notifications',
                builder: (context, state) => const NotificationsScreen(),
              ),
            ],
          ),

          // Messages (shared across all roles)
          GoRoute(
            path: '/conversations',
            builder: (context, state) => const ConversationsScreen(),
          ),
          GoRoute(
            path: '/messages/:id',
            builder: (context, state) => const MessagesScreen(),
          ),

          // Notifications (shared across all roles)
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),

          // Settings (shared across all roles)
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),

          // Profile (shared across all roles)
          GoRoute(
            path: '/profile',
            builder: (context, state) => const UserProfileScreen(),
          ),

          // Help & Support
          GoRoute(
            path: '/help',
            builder: (context, state) => const HelpSupportScreen(),
          ),

          // Terms & Conditions
          GoRoute(
            path: '/terms',
            builder: (context, state) => const TermsConditionsScreen(),
          ),

          // Privacy Policy
          GoRoute(
            path: '/privacy',
            builder: (context, state) => const PrivacyPolicyScreen(),
          ),
        ],
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
              state.uri.toString(),
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
final themeModeProvider = fr.StateProvider<ThemeMode>((ref) => ThemeMode.system);
