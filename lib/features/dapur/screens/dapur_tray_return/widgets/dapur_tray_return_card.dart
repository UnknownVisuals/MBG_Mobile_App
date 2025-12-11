import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_tray_return_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class DapurTrayReturnCard extends StatelessWidget {
  const DapurTrayReturnCard({super.key, required this.item});

  final DapurTrayReturnModel item;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);
    final theme = Theme.of(context);
    final statusColor = item.statusColor;
    final statusText = item.statusLabel;

    IconData statusIcon = Iconsax.info_circle;
    if (item.normalizedStatus == DapurTrayReturnStatus.menungguPickup) {
      statusIcon = Iconsax.clock;
    }
    if (item.normalizedStatus == DapurTrayReturnStatus.sedangReturn) {
      statusIcon = Iconsax.truck_fast;
    }
    if (item.normalizedStatus == DapurTrayReturnStatus.sampaiDapur) {
      statusIcon = Iconsax.tick_circle;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: isDarkMode ? MBGColors.dark : MBGColors.light,
        border: Border.all(
          color: isDarkMode
              ? MBGColors.lightGrey.withValues(alpha: 0.4)
              : MBGColors.grey,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: Sekolah Name & Status ---
            Text(
              item.sekolah?.nama ?? 'Undetermined',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // Status Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                border: Border.all(color: statusColor),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            if (item.sekolah?.alamat != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Iconsax.location,
                    size: MBGSizes.iconSm,
                    color: isDarkMode
                        ? MBGColors.textWhite.withValues(alpha: 0.7)
                        : MBGColors.textPrimary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.sekolah!.alamat!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium!.color!.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // --- DRIVER INFO ---
            if (item.driver != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MBGColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.user,
                      size: 20,
                      color: MBGColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.driver!.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.driver!.nomorKendaraan != null)
                          Text(
                            item.driver!.nomorKendaraan!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
            ],

            // --- TRAY COUNTS ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _infoBox(
                    theme,
                    'Diminta',
                    '${item.jumlahTray}',
                    MBGColors.primary,
                  ),
                  if (item.jumlahTrayDiterimaDriver != null) ...[
                    const SizedBox(width: 8),
                    _infoBox(
                      theme,
                      'Pickup',
                      '${item.jumlahTrayDiterimaDriver}',
                      MBGColors.warning,
                    ),
                  ],
                  if (item.jumlahTrayDiterimaDapur != null) ...[
                    const SizedBox(width: 8),
                    _infoBox(
                      theme,
                      'Diterima',
                      '${item.jumlahTrayDiterimaDapur}',
                      MBGColors.success,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // --- WAKTU TIMELINE ---
            Container(
              padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
              decoration: BoxDecoration(
                color: MBGColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Column(
                children: [
                  _TimeRow(
                    label: 'Request',
                    time: item.waktuSubmit,
                    icon: Iconsax.send_1,
                    color: MBGColors.primary,
                  ),
                  if (item.waktuPickupDriver != null) ...[
                    const SizedBox(height: 4),
                    _TimeRow(
                      label: 'Pickup',
                      time: item.waktuPickupDriver!,
                      icon: Iconsax.truck_fast,
                      color: MBGColors.warning,
                    ),
                  ],
                  if (item.waktuSampaiDapur != null) ...[
                    const SizedBox(height: 4),
                    _TimeRow(
                      label: 'Selesai',
                      time: item.waktuSampaiDapur!,
                      icon: Iconsax.tick_circle,
                      color: MBGColors.success,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(
    ThemeData theme,
    String title,
    String value,
    Color brandColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: brandColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Iconsax.box, size: MBGSizes.iconMd, color: brandColor),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall!.color!.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: brandColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
  });

  final String label;
  final DateTime time;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: Text(
            DateFormat('dd MMM HH:mm', 'id_ID').format(time.toLocal()),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: 11),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
