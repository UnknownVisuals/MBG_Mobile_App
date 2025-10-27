import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Widget displayed when no dapur is selected
class NoDapurSelectedWidget extends StatelessWidget {
  const NoDapurSelectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.building_4, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Silakan pilih dapur untuk melihat pengiriman.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tentukan dapur aktif melalui menu di kiri sebelum mengelola pengiriman.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
