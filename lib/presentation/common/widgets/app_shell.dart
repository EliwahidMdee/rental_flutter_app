import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../auth/providers/auth_provider.dart';

/// App Shell
/// 
/// Provides the main app structure with bottom navigation

class AppShell extends ConsumerWidget {
  final Widget child;
  final String currentLocation;

  const AppShell({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    // Don't show bottom nav for auth screens
    if (user == null) {
      return child;
    }

    // Determine which bottom nav items to show based on user role
    final items = _getBottomNavItems(user.role);
    final currentIndex = _getCurrentIndex(currentLocation, user.role);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index, user.role),
        items: items,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: AppTheme.bottomNavBlue,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavItems(String role) {
    if (role == 'admin') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Payments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else if (role == 'landlord') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'Properties',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Tenants',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    } else {
      // Tenant
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Payments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build),
          label: 'Maintenance',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
  }

  int _getCurrentIndex(String location, String role) {
    if (role == 'admin') {
      if (location.startsWith('/admin/reports')) return 1;
      if (location.startsWith('/admin/payments')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0;
    } else if (role == 'landlord') {
      if (location.startsWith('/landlord/properties')) return 1;
      if (location.startsWith('/landlord/tenants')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0;
    } else {
      // Tenant
      if (location.startsWith('/tenant/payment') || location.startsWith('/tenant/history')) return 1;
      if (location.startsWith('/tenant/maintenance')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index, String role) {
    if (role == 'admin') {
      switch (index) {
        case 0:
          context.go('/admin');
          break;
        case 1:
          context.go('/admin/reports');
          break;
        case 2:
          context.go('/admin/payments');
          break;
        case 3:
          context.go('/profile');
          break;
      }
    } else if (role == 'landlord') {
      switch (index) {
        case 0:
          context.go('/landlord');
          break;
        case 1:
          context.go('/landlord/properties');
          break;
        case 2:
          context.go('/landlord/tenants');
          break;
        case 3:
          context.go('/profile');
          break;
      }
    } else {
      // Tenant
      switch (index) {
        case 0:
          context.go('/tenant');
          break;
        case 1:
          context.go('/tenant/history');
          break;
        case 2:
          context.go('/tenant/maintenance');
          break;
        case 3:
          context.go('/profile');
          break;
      }
    }
  }
}
