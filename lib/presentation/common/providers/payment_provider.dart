import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/payment_model.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../auth/providers/auth_provider.dart';
import 'property_provider.dart';

/// Payment Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return PaymentRepository(apiClient, networkInfo);
});

/// Payments List Provider
final paymentsProvider = FutureProvider.autoDispose.family<List<PaymentModel>, PaymentFilters?>(
  (ref, filters) async {
    final repository = ref.watch(paymentRepositoryProvider);
    return repository.getPayments(
      status: filters?.status,
      tenantId: filters?.tenantId,
      propertyId: filters?.propertyId,
    );
  },
);

/// Pending Payments Provider (for admins/landlords)
final pendingPaymentsProvider = FutureProvider.autoDispose<List<PaymentModel>>(
  (ref) async {
    final repository = ref.watch(paymentRepositoryProvider);
    return repository.getPendingPayments();
  },
);

/// Payment Detail Provider
final paymentDetailProvider = FutureProvider.autoDispose.family<PaymentModel, int>(
  (ref, paymentId) async {
    final repository = ref.watch(paymentRepositoryProvider);
    return repository.getPaymentById(paymentId);
  },
);

/// Payment Filters
class PaymentFilters {
  final String? status;
  final int? tenantId;
  final int? propertyId;
  
  PaymentFilters({
    this.status,
    this.tenantId,
    this.propertyId,
  });
}
