import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

import 'package:mbg_mobile_app/features/sekolah/models/sekolah_delivery_model.dart';

class SekolahDeliveryCard extends StatelessWidget {
  const SekolahDeliveryCard({super.key, required this.delivery});

  final SekolahDeliveryModel delivery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = MBGHelperFunctions.isDarkMode(context);
    final createdAt = delivery.waktuBuatQR.toLocal();
    final selesaiAt = delivery.waktuSampai?.toLocal();
    final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? MBGColors.dark : MBGColors.light,
        border: Border.all(
          color: isDarkMode
              ? MBGColors.lightGrey.withValues(alpha: 0.4)
              : MBGColors.borderPrimary,
        ),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    delivery.sekolah.nama,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: MBGSizes.spaceBtwItems / 2),
            if (delivery.driver != null)
              Row(
                children: [
                  const Icon(Iconsax.user, size: MBGSizes.iconSm),
                  const SizedBox(width: MBGSizes.xs),
                  Expanded(
                    child: Text(
                      '${delivery.driver!.name} • ${delivery.driver!.phone}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: MBGSizes.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  child: _metricTile(
                    label: 'Tray',
                    value: delivery.jumlahTray,
                    icon: Iconsax.box,
                    color: MBGColors.primary,
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: _metricTile(
                    label: 'Keranjang',
                    value: delivery.jumlahKeranjang,
                    icon: Iconsax.box_1,
                    color: MBGColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: MBGSizes.spaceBtwItems),
            Row(
              children: [
                const Icon(Iconsax.calendar_1, size: MBGSizes.iconSm),
                const SizedBox(width: MBGSizes.xs),
                Expanded(
                  child: Text(
                    'Dibuat ${formatter.format(createdAt)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            if (selesaiAt != null) ...[
              const SizedBox(height: MBGSizes.spaceBtwItems / 2),
              Row(
                children: [
                  Icon(
                    Iconsax.calendar_tick,
                    size: MBGSizes.iconSm,
                    color: MBGColors.success,
                  ),
                  const SizedBox(width: MBGSizes.xs),
                  Expanded(
                    child: Text(
                      'Sampai ${formatter.format(selesaiAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: MBGColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: MBGSizes.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: delivery.qrCodeUrl.isEmpty
                        ? null
                        : () {
                            MBGImagePreviewDialog.showData(
                              context: context,
                              imageData: delivery.qrCodeUrl,
                            );
                          },
                    icon: const Icon(Iconsax.scan_barcode),
                    label: const Text('Lihat QR'),
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: Text(
                    delivery.driver?.nomorKendaraan ??
                        'Nomor kendaraan belum tersedia',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricTile({
    required String label,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
      ),
      child: Row(
        children: [
          Icon(Iconsax.box, size: MBGSizes.iconMd, color: color),
          const SizedBox(width: MBGSizes.spaceBtwItems / 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: MBGSizes.fontSizeSm,
                ),
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: MBGSizes.fontSizeMd,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MBGSizes.sm,
        vertical: MBGSizes.xs,
      ),
      decoration: BoxDecoration(
        color: delivery.statusColor.withValues(alpha: 0.15),
        border: Border.all(color: delivery.statusColor),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
      ),
      child: Text(
        delivery.statusLabel,
        style: TextStyle(
          fontSize: MBGSizes.fontSizeSm,
          fontWeight: FontWeight.bold,
          color: delivery.statusColor,
        ),
      ),
    );
  }
}
