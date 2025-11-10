import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/property_model.dart';
import '../../../config/theme.dart';

/// Property Card
/// 
/// Displays property information in a card format

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback? onTap;
  final bool showStatus;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: property.primaryImage != null
                  ? CachedNetworkImage(
                      imageUrl: property.primaryImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.home_work,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.home_work,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
            
            // Property Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showStatus)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(property.status).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            property.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(property.status),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Address
                  Text(
                    property.address,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Details
                  Row(
                    children: [
                      Icon(Icons.bed_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${property.bedrooms} Beds',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.bathtub_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${property.bathrooms} Baths',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Rent
                  Text(
                    '\$${property.rent.toStringAsFixed(0)}/month',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.landlordAccent,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'occupied':
        return Colors.blue;
      case 'maintenance':
        return Colors.orange;
      case 'inactive':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
