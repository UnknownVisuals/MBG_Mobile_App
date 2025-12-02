import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/widgets/driver_dashboard_delivery_tracking.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DriverDashboardDeliveryCard extends StatelessWidget {
  const DriverDashboardDeliveryCard({super.key, required this.delivery});

  final DriverDeliveryModel delivery;

  @override
  Widget build(BuildContext context) {
    final status = delivery.status;
    final statusColor = _statusColor(status!);
    final statusLabel = _statusText(status);
    final statusIcon = _statusIcon(status);
    final sekolahSummary = delivery.sekolah;
    final alamat = sekolahSummary!.alamat ?? 'Alamat belum tersedia';

    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
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
            Text(
              sekolahSummary.nama!,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems / 2),

            Row(
              children: [
                Icon(
                  Iconsax.location,
                  size: MBGSizes.iconSm,
                  color: MBGColors.textSecondary,
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                Expanded(
                  child: Text(
                    alamat,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MBGColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems / 2),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                border: Border.all(color: statusColor),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 12, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: MBGSizes.spaceBtwSections),

            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    icon: Iconsax.box,
                    label: 'Tray',
                    value: '${delivery.jumlahTray}',
                    color: MBGColors.primary,
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: _MetricTile(
                    icon: Iconsax.box_1,
                    label: 'Keranjang',
                    value: '${delivery.jumlahKeranjang}',
                    color: MBGColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            Container(
              padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
              decoration: BoxDecoration(
                color: MBGColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.calendar_1, size: MBGSizes.iconSm),
                  const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                  Expanded(
                    child: Text(
                      DateFormat(
                        'dd MMM yyyy, HH:mm',
                        'id_ID',
                      ).format(delivery.createdAt!.toLocal()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final qrCodeUrl = delivery.qrCodeUrl;
                      if (qrCodeUrl != null && qrCodeUrl.isNotEmpty) {
                        MBGImagePreviewDialog.showData(
                          context: context,
                          imageData: qrCodeUrl,
                        );
                      }
                    },
                    icon: const Icon(
                      Iconsax.scan_barcode,
                      size: MBGSizes.iconMd,
                    ),
                    label: Text(
                      'QR Code',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),

                const SizedBox(width: MBGSizes.spaceBtwItems),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final latitude = delivery.sekolah!.latitude;
                      final longitude = delivery.sekolah!.longitude;
                      if (latitude == null || longitude == null) {
                        MBGLoaders.errorSnackBar(
                          title: 'Lokasi belum tersedia',
                          message:
                              'Sekolah belum memiliki titik koordinat yang valid.',
                        );
                        return;
                      }

                      Get.to(
                        () =>
                            DriverDashboardDeliveryTracking(delivery: delivery),
                      );
                    },
                    icon: const Icon(
                      Iconsax.truck,
                      size: MBGSizes.iconMd,
                      color: MBGColors.white,
                    ),
                    label: Text(
                      'Mulai',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: MBGColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, size: MBGSizes.iconMd, color: color),
          const SizedBox(width: MBGSizes.spaceBtwItems / 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
}

Color _statusColor(String status) {
  switch (_normalizeStatus(status)) {
    case 'PENDING':
      return MBGColors.warning;
    case 'SEDANG DIANTAR':
    case 'IN_TRANSIT':
      return MBGColors.primary;
    case 'DELIVERED':
    case 'SELESAI':
      return MBGColors.success;
    default:
      return MBGColors.textSecondary;
  }
}

String _statusText(String status) {
  switch (_normalizeStatus(status)) {
    case 'PENDING':
      return 'Menunggu Pengantaran';
    case 'SEDANG DIANTAR':
    case 'IN_TRANSIT':
      return 'Sedang Diantar';
    case 'DELIVERED':
      return 'Terkirim';
    case 'SELESAI':
      return 'Selesai';
    default:
      return status;
  }
}

IconData _statusIcon(String status) {
  switch (_normalizeStatus(status)) {
    case 'PENDING':
      return Iconsax.clock;
    case 'SEDANG DIANTAR':
    case 'IN_TRANSIT':
      return Iconsax.truck_fast;
    case 'DELIVERED':
    case 'SELESAI':
      return Iconsax.tick_circle;
    default:
      return Iconsax.info_circle;
  }
}

String _normalizeStatus(String status) {
  return status.replaceAll('_', ' ').toUpperCase();
}
