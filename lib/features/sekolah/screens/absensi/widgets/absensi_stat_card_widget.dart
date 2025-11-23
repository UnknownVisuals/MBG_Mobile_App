import 'package:flutter/material.dart';
import '../../../../../utils/constants/sizes.dart';

/// Stat card widget for absensi screen (theme-adaptive)
class AbsensiStatCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color; // tetap dipakai sebagai brand color indikator

  const AbsensiStatCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Background adaptif: tetap mengandung "color" tapi mengikuti mode
    final bgColor = Color.alphaBlend(
      color.withOpacity(0.08),
      colors.surface, // permukaan adaptif
    );

    return Container(
      padding: const EdgeInsets.all(MBGSizes.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
        border: Border.all(
          color: color.withOpacity(0.25), // tetap subtle
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: MBGSizes.sm),

          // TEXT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color, // identity highlight tetap
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant, // adaptif, lebih lembut
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
