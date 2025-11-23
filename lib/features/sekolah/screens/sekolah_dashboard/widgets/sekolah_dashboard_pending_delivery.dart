import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Widget untuk menampilkan daftar pengiriman yang masih pending (UI Only)
class SekolahDashboardPendingDelivery extends StatelessWidget {
  const SekolahDashboardPendingDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: color.surface, // adaptif
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: color.shadow.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
        ],
        border: Border.all(
          color: color.outlineVariant.withOpacity(0.4), // adaptif
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Header ===
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MBGColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.truck_fast,
                  color: MBGColors.warning,
                  size: 22,
                ),
              ),
              const SizedBox(width: MBGSizes.spaceBtwItems),
              Text(
                'Pending Deliveries',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color.onSurface, // adaptif
                ),
              ),
            ],
          ),

          const SizedBox(height: MBGSizes.spaceBtwItems),

          // === List pengiriman dummy ===
          _PendingItem(
            name: 'Bahan Pokok Pagi',
            status: 'Dalam Perjalanan',
            icon: Iconsax.timer_1,
            color: MBGColors.warning,
          ),
          Divider(color: color.outlineVariant.withOpacity(0.4)),
          _PendingItem(
            name: 'Menu Siang',
            status: 'Belum Diterima',
            icon: Iconsax.truck_fast,
            color: MBGColors.info,
          ),
          Divider(color: color.outlineVariant.withOpacity(0.4)),
          _PendingItem(
            name: 'Tambahan Buah',
            status: 'Menunggu Konfirmasi',
            icon: Iconsax.archive_1,
            color: MBGColors.warning,
          ),
        ],
      ),
    );
  }
}

/// Item kecil untuk tiap pengiriman pending
class _PendingItem extends StatelessWidget {
  final String name;
  final String status;
  final IconData icon;
  final Color color;

  const _PendingItem({
    required this.name,
    required this.status,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        name,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: cs.onSurface, // adaptif
        ),
      ),
      subtitle: Text(
        status,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Iconsax.arrow_right_3,
        size: 18,
        color: cs.onSurfaceVariant, // adaptif
      ),
    );
  }
}
