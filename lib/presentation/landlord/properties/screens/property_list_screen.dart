import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/providers/property_provider.dart';
import '../../../common/widgets/property_card.dart';
import '../../../common/widgets/loading_indicator.dart';
import '../../../common/widgets/error_display.dart';
import '../../../common/widgets/empty_state.dart';

/// Property List Screen
/// 
/// Displays list of properties for landlord

class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final filters = _selectedStatus != null
        ? PropertyFilters(status: _selectedStatus)
        : null;
    
    final propertiesAsync = ref.watch(propertiesProvider(filters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: propertiesAsync.when(
        data: (properties) {
          if (properties.isEmpty) {
            return EmptyState(
              message: 'No properties found',
              subtitle: 'Add your first property to get started',
              icon: Icons.home_work_outlined,
              actionLabel: 'Add Property',
              onAction: () {
                // TODO: Navigate to add property screen
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(propertiesProvider(filters));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PropertyCard(
                    property: property,
                    onTap: () {
                      // TODO: Navigate to property detail
                    },
                    showStatus: true,
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading properties...'),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(propertiesProvider(filters));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add property screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add property feature coming soon')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Properties'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All'),
              leading: Radio<String?>(
                value: null,
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Available'),
              leading: Radio<String?>(
                value: 'available',
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Occupied'),
              leading: Radio<String?>(
                value: 'occupied',
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Maintenance'),
              leading: Radio<String?>(
                value: 'maintenance',
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
