import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/dashboard_model.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../auth/providers/auth_provider.dart';
import 'property_provider.dart';

/// Dashboard Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return DashboardRepository(apiClient, networkInfo);
});

/// Dashboard Stats Provider
final dashboardStatsProvider = FutureProvider.autoDispose<DashboardModel>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getDashboardStats();
});

/// General Dashboard Data Provider
final dashboardDataProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getDashboard();
});
