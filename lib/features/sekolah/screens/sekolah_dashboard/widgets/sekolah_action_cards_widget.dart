import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

/// Sekolah Action Cards — hanya untuk tampilan UI
class SekolahActionCardsWidget extends StatelessWidget {
  const SekolahActionCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // === Card 1: Absensi Hari Ini ===
        Expanded(
          child: _ActionCard(
            title: 'Absensi Hari Ini',
            icon: Iconsax.user_tick,
            color: MBGColors.primary,
            onTap: () {},
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        // === Card 2: Menu Hari Ini ===
        Expanded(
          child: _ActionCard(
            title: 'Menu Hari Ini',
            icon: Iconsax.note,
            color: MBGColors.success,
            onTap: () {},
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        // === Card 3: Pengiriman ===
        Expanded(
          child: _ActionCard(
            title: 'Pengiriman',
            icon: Iconsax.truck,
            color: MBGColors.warning,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: MBGSizes.md,
          horizontal: MBGSizes.sm,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(MBGSizes.cardRadiusMd),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: MBGSizes.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
