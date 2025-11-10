import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/providers/payment_provider.dart';
import '../../../common/widgets/payment_card.dart';
import '../../../common/widgets/loading_indicator.dart';
import '../../../common/widgets/error_display.dart';
import '../../../common/widgets/empty_state.dart';

/// Payment Approval Screen (Admin/Landlord)
/// 
/// Screen for approving or rejecting pending payments

class PaymentApprovalScreen extends ConsumerWidget {
  const PaymentApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingPaymentsAsync = ref.watch(pendingPaymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Payments'),
      ),
      body: pendingPaymentsAsync.when(
        data: (payments) {
          if (payments.isEmpty) {
            return EmptyState(
              message: 'No pending payments',
              subtitle: 'All payments have been processed',
              icon: Icons.check_circle_outline,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(pendingPaymentsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PaymentCard(
                    payment: payment,
                    showActions: true,
                    onApprove: () => _handleApprove(context, ref, payment.id),
                    onReject: () => _handleReject(context, ref, payment.id),
                  ),
                );
              },
            ),
          );
        },
        loading: () => LoadingIndicator(message: 'Loading pending payments...'),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(pendingPaymentsProvider);
          },
        ),
      ),
    );
  }

  Future<void> _handleApprove(BuildContext context, WidgetRef ref, int paymentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Payment'),
        content: const Text('Are you sure you want to approve this payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        // TODO: Call API to approve payment
        // await ref.read(paymentRepositoryProvider).verifyPayment(paymentId);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment approved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        ref.invalidate(pendingPaymentsProvider);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleReject(BuildContext context, WidgetRef ref, int paymentId) async {
    final TextEditingController reasonController = TextEditingController();
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final reason = reasonController.text;
      if (reason.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please provide a reason for rejection'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      try {
        // TODO: Call API to reject payment
        // await ref.read(paymentRepositoryProvider).rejectPayment(paymentId, reason);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment rejected'),
            backgroundColor: Colors.red,
          ),
        );
        
        ref.invalidate(pendingPaymentsProvider);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    
    reasonController.dispose();
  }
}
