import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_tray_return_model.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_tray_return/widgets/driver_tray_return_tracking.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class DriverTrayReturnCard extends StatelessWidget {
  const DriverTrayReturnCard({super.key, required this.item});

  final DriverTrayReturnModel item;

  @override
  Widget build(BuildContext context) {
    // Determine status relative properties
    final status = item.normalizedStatus;
    final statusColor = item.statusColor;
    final statusLabel = item.statusLabel;

    // Status Icon
    IconData statusIcon = Iconsax.info_circle;
    if (status == DriverTrayReturnStatus.menungguPickup) {
      statusIcon = Iconsax.clock;
    }
    if (status == DriverTrayReturnStatus.sedangReturn) {
      statusIcon = Iconsax.truck_fast;
    }
    if (status == DriverTrayReturnStatus.sampaiDapur) {
      statusIcon = Iconsax.tick_circle;
    }

    final sekolah = item.sekolah;
    final alamat = sekolah.alamat ?? 'Alamat belum tersedia';
    final isDarkMode = MBGHelperFunctions.isDarkMode(context);

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
            // School Name
            Text(
              sekolah.nama,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems / 2),

            // Address
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

            // Status Chip
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

            // Metrics
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _MetricTile(
                    icon: Iconsax.box,
                    label: 'Jumlah Tray',
                    value: '${item.jumlahTray}',
                    color: MBGColors.primary,
                  ),
                  if (item.jumlahTrayDiterimaDriver != null) ...[
                    const SizedBox(width: MBGSizes.spaceBtwItems),
                    _MetricTile(
                      icon: Iconsax.box_tick,
                      label: 'Tray Diambil',
                      value: '${item.jumlahTrayDiterimaDriver}',
                      color: MBGColors.success,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // Timestamp
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
                      ).format(item.waktuSubmit.toLocal()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showQRCodeDialog(context),
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
                      if (item.driverId != null) {
                        Get.to(
                          () => DriverTrayReturnTracking(trayReturn: item),
                        );
                      } else {
                        MBGLoaders.successSnackBar(
                          title: 'Tracking Driver',
                          message: 'Fitur tracking akan segera hadir',
                        );
                      }
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

  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scan QR Pengembalian',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),
              Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(MBGSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                ),
                child: PrettyQrView.data(
                  data: item.qrCodeId,
                  errorCorrectLevel: QrErrorCorrectLevel.H,
                  decoration: const PrettyQrDecoration(
                    shape: PrettyQrSmoothSymbol(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              Text(
                item.qrCodeId,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),
              Text(
                'Tunjukkan QR ini kepada Dapur saat pengantaran tray.',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
