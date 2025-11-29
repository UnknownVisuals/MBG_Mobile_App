import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Widget untuk menampilkan menu hari ini (UI Only)
class SekolahDashboardTodayMenu extends StatelessWidget {
  const SekolahDashboardTodayMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SekolahDashboardController>();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Obx(() {
      final menu = controller.todayMenu;

      if (menu == null) {
        return const SizedBox.shrink();
      }

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
                    Expanded(
                      child: Text(
                        'Minggu ke-${menu.mingguanKe ?? 1}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MBGSizes.sm),

                Text(
                  'Menu dari Dapur: ${menu.dapur?.nama ?? "Unknown"}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant, // adaptive secondary text
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
