import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Widget untuk menampilkan menu hari ini (UI Only)
class SekolahDashboardTodayMenu extends StatelessWidget {
  const SekolahDashboardTodayMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Hari Ini',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),

        // ====== CARD CONTAINER ADAPTIF ======
        Container(
          padding: const EdgeInsets.all(MBGSizes.md),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest, // adaptive M3 container
            borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
            border: Border.all(
              color: scheme.outline.withValues(alpha: 0.3), // soft border
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Iconsax.note,
                    size: 28,
                    color: scheme.primary, // adaptive icon color
                  ),
                  const SizedBox(width: MBGSizes.sm),
                  Text(
                    'Nasi Ayam & Sayur Sop',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.sm),

              Text(
                'Kalori: 450 kkal | Protein: 25g | Karbo: 55g',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant, // adaptive secondary text
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
