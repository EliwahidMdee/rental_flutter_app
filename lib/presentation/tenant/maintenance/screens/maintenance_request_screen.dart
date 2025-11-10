import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';

/// Maintenance Request Screen
/// 
/// Allows tenants to submit maintenance requests

class MaintenanceRequestScreen extends ConsumerStatefulWidget {
  const MaintenanceRequestScreen({super.key});

  @override
  ConsumerState<MaintenanceRequestScreen> createState() => _MaintenanceRequestScreenState();
}

class _MaintenanceRequestScreenState extends ConsumerState<MaintenanceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedCategory = 'plumbing';
  String _selectedUrgency = 'medium';
  bool _isLoading = false;

  final List<String> _categories = [
    'plumbing',
    'electrical',
    'heating',
    'cooling',
    'appliances',
    'doors_windows',
    'flooring',
    'walls_ceiling',
    'pest_control',
    'other',
  ];

  final List<String> _urgencyLevels = [
    'low',
    'medium',
    'high',
    'emergency',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Submit a maintenance request and we\'ll address it promptly.',
                          style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              CustomTextField(
                controller: _titleController,
                label: 'Issue Title',
                prefixIcon: Icons.title,
                validator: Validators.required,
                hint: 'Brief description of the issue',
              ),
              const SizedBox(height: 16),

              // Category
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_formatCategoryName(category)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              const SizedBox(height: 16),

              // Location
              CustomTextField(
                controller: _locationController,
                label: 'Location',
                prefixIcon: Icons.location_on,
                validator: Validators.required,
                hint: 'e.g., Kitchen, Bathroom, Bedroom 1',
              ),
              const SizedBox(height: 16),

              // Urgency
              Text(
                'Urgency Level',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(
                    Icons.priority_high,
                    color: _getUrgencyColor(_selectedUrgency),
                  ),
                ),
                items: _urgencyLevels.map((urgency) {
                  return DropdownMenuItem(
                    value: urgency,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getUrgencyColor(urgency),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(_formatUrgencyName(urgency)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedUrgency = value!);
                },
              ),
              const SizedBox(height: 16),

              // Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Detailed Description',
                prefixIcon: Icons.description,
                validator: Validators.required,
                hint: 'Provide detailed information about the issue',
                maxLines: 6,
              ),
              const SizedBox(height: 16),

              // Photo Attachment
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo upload feature coming soon')),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Add Photos'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can attach photos to help explain the issue',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              CustomButton(
                text: 'Submit Request',
                onPressed: _submitRequest,
                isLoading: _isLoading,
                icon: Icons.send,
              ),
              const SizedBox(height: 8),
              Text(
                'We typically respond to maintenance requests within 24-48 hours',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatUrgencyName(String urgency) {
    return urgency[0].toUpperCase() + urgency.substring(1);
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.deepOrange;
      case 'emergency':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Submit to API
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: const Text('Request Submitted'),
        content: const Text(
          'Your maintenance request has been submitted successfully. '
          'You will receive updates via notifications.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
