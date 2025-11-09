import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/payment_model.dart';
import '../../../common/providers/payment_provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';

/// Make Payment Screen
/// 
/// Allows tenants to submit rent payments

class MakePaymentScreen extends ConsumerStatefulWidget {
  const MakePaymentScreen({super.key});

  @override
  ConsumerState<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends ConsumerState<MakePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _paymentMethod = 'bank_transfer';
  DateTime _paymentDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    
    if (picked != null && picked != _paymentDate) {
      setState(() => _paymentDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Call payment repository
      // final repository = ref.read(paymentRepositoryProvider);
      // await repository.createPayment(
      //   tenantId: currentUserId,
      //   propertyId: currentPropertyId,
      //   amount: double.parse(_amountController.text),
      //   paymentDate: _paymentDate.toIso8601String(),
      //   paymentMethod: _paymentMethod,
      //   notes: _notesController.text.isEmpty ? null : _notesController.text,
      // );

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment submitted successfully! Waiting for approval.'),
          backgroundColor: Colors.green,
        ),
      );
      
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Payment Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Payment Information',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your monthly rent: \$1,200.00',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due date: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Amount Field
            CustomTextField(
              controller: _amountController,
              label: 'Payment Amount',
              hint: '1200.00',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.attach_money,
              validator: Validators.compose([
                Validators.required,
                Validators.number,
                (value) => Validators.minValue(value, 0.01),
              ]),
            ),
            const SizedBox(height: 16),

            // Payment Date
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Payment Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  DateFormat('MMM dd, yyyy').format(_paymentDate),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Method
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: InputDecoration(
                labelText: 'Payment Method',
                prefixIcon: const Icon(Icons.payment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'bank_transfer',
                  child: Text('Bank Transfer'),
                ),
                DropdownMenuItem(
                  value: 'cash',
                  child: Text('Cash'),
                ),
                DropdownMenuItem(
                  value: 'card',
                  child: Text('Credit/Debit Card'),
                ),
                DropdownMenuItem(
                  value: 'mobile_money',
                  child: Text('Mobile Money'),
                ),
                DropdownMenuItem(
                  value: 'cheque',
                  child: Text('Cheque'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _paymentMethod = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Notes
            CustomTextField(
              controller: _notesController,
              label: 'Notes (Optional)',
              hint: 'Add any additional information',
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Information Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your payment will be reviewed by the landlord before approval.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            CustomButton(
              text: 'Submit Payment',
              icon: Icons.send,
              onPressed: _isLoading ? null : _handleSubmit,
              isLoading: _isLoading,
              width: double.infinity,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
