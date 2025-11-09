import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/property_model.dart';
import '../../../common/providers/property_provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';

/// Add/Edit Property Screen
/// 
/// Form for creating or editing properties

class PropertyFormScreen extends ConsumerStatefulWidget {
  final int? propertyId; // null for add, int for edit
  
  const PropertyFormScreen({
    super.key,
    this.propertyId,
  });

  @override
  ConsumerState<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends ConsumerState<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _rentController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _squareFeetController = TextEditingController();
  
  String _selectedStatus = 'available';
  List<String> _amenities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null) {
      _loadProperty();
    }
  }

  Future<void> _loadProperty() async {
    // TODO: Load property data if editing
    // For now, this is a placeholder
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _rentController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _squareFeetController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final property = PropertyModel(
        id: widget.propertyId ?? 0,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        landlordId: 1, // TODO: Get from auth state
        address: _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
        state: _stateController.text.trim().isEmpty ? null : _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim().isEmpty ? null : _postalCodeController.text.trim(),
        rent: double.parse(_rentController.text),
        bedrooms: int.parse(_bedroomsController.text),
        bathrooms: int.parse(_bathroomsController.text),
        squareFeet: _squareFeetController.text.isEmpty ? null : double.parse(_squareFeetController.text),
        status: _selectedStatus,
        amenities: _amenities,
        images: const [],
        createdAt: DateTime.now().toIso8601String(),
      );

      // TODO: Call repository to save
      // await ref.read(propertyRepositoryProvider).createProperty(property);

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.propertyId == null ? 'Property added successfully' : 'Property updated successfully'),
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
        title: Text(widget.propertyId == null ? 'Add Property' : 'Edit Property'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Information
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _nameController,
              label: 'Property Name',
              hint: 'e.g., Sunset Apartment',
              validator: (value) => Validators.required(value, fieldName: 'Property name'),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe the property',
              maxLines: 4,
              validator: (value) => Validators.required(value, fieldName: 'Description'),
            ),
            const SizedBox(height: 24),

            // Location
            Text(
              'Location',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _addressController,
              label: 'Street Address',
              hint: '123 Main St',
              validator: (value) => Validators.required(value, fieldName: 'Address'),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _cityController,
                    label: 'City',
                    hint: 'City',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _stateController,
                    label: 'State',
                    hint: 'State',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _postalCodeController,
              label: 'Postal Code',
              hint: '12345',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Property Details
            Text(
              'Property Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _rentController,
              label: 'Monthly Rent',
              hint: '1200',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.attach_money,
              validator: Validators.number,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _bedroomsController,
                    label: 'Bedrooms',
                    hint: '2',
                    keyboardType: TextInputType.number,
                    validator: Validators.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _bathroomsController,
                    label: 'Bathrooms',
                    hint: '2',
                    keyboardType: TextInputType.number,
                    validator: Validators.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _squareFeetController,
              label: 'Square Feet (Optional)',
              hint: '1000',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Status Dropdown
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'available', child: Text('Available')),
                DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
                DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
            const SizedBox(height: 24),

            // Amenities
            Text(
              'Amenities',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Select amenities available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Parking',
                'Gym',
                'Pool',
                'Laundry',
                'Pet Friendly',
                'Balcony',
                'Air Conditioning',
                'Heating',
              ].map((amenity) {
                final isSelected = _amenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _amenities.add(amenity);
                      } else {
                        _amenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Save Button
            CustomButton(
              text: widget.propertyId == null ? 'Add Property' : 'Save Changes',
              onPressed: _isLoading ? null : _handleSave,
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
