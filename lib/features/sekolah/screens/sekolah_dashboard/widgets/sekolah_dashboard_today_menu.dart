import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Widget untuk menampilkan menu hari ini (UI Only)
class SekolahDashboardTodayMenu extends StatelessWidget {
  const SekolahDashboardTodayMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Hari Ini',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: MBGSizes.spaceBtwItems),
        Container(
          padding: const EdgeInsets.all(MBGSizes.md),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Iconsax.note, color: MBGColors.primary, size: 28),
                  const SizedBox(width: MBGSizes.sm),
                  Text(
                    'Nasi Ayam & Sayur Sop',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.sm),
              Text(
                'Kalori: 450 kkal | Protein: 25g | Karbo: 55g',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
