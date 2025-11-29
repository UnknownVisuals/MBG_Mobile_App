import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

/// Header untuk Dashboard Sekolah (UI Only)
class SekolahDashboardHeader extends StatelessWidget {
  const SekolahDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Greeting + subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang,',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MBGColors.darkGrey),
              ),
              const SizedBox(height: 4),
              Text(
                'Dashboard Sekolah',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MBGColors.primary,
                ),
              ),
            ],
          ),
        ),

        // Notification Icon
        Container(
          padding: const EdgeInsets.all(MBGSizes.sm),
          decoration: BoxDecoration(
            color: MBGColors.light,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Iconsax.notification, color: MBGColors.primary),
        ),
      ],
    );
  }
}
