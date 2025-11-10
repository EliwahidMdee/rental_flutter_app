import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/payment_model.dart';

/// Payment Card
/// 
/// Displays payment information in a card format

class PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final VoidCallback? onTap;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool showActions;

  const PaymentCard({
    super.key,
    required this.payment,
    this.onTap,
    this.onApprove,
    this.onReject,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tenant Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.tenant?.name ?? 'Unknown Tenant',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (payment.property != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            payment.property!.name,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(payment.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getStatusText(payment.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(payment.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Amount
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              
              // Payment Details
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(payment.paymentDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.payment, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    _formatPaymentMethod(payment.paymentMethod),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              
              // Notes
              if (payment.notes != null) ...[
                const SizedBox(height: 8),
                Text(
                  payment.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              // Action Buttons
              if (showActions && payment.isPending) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReject,
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onApprove,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  String _formatPaymentMethod(String method) {
    return method.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'partial':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      case 'partial':
        return 'Partial';
      default:
        return status.toUpperCase();
    }
  }
}
