// lib/screens/business_detail_screen.dart
import 'package:business_card_app/features/business_discovery/data/models/business.dart';
import 'package:flutter/material.dart';

class BusinessDetailScreen extends StatelessWidget {
  final Business business;

  const BusinessDetailScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(business.name)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(
              context,
              Icons.business,
              'Business Name',
              business.name,
            ),
            const SizedBox(height: 24),
            _buildDetailItem(
              context,
              Icons.location_on,
              'Location',
              business.location,
            ),
            const SizedBox(height: 24),
            _buildDetailItem(
              context,
              Icons.phone,
              'Contact',
              business.contactNumber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 30),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ],
    );
  }
}
