import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_tray_return_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class SekolahTrayReturnCard extends StatelessWidget {
  const SekolahTrayReturnCard({super.key, required this.item});

  final SekolahTrayReturnModel item;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);
    final theme = Theme.of(context);
    final statusColor = item.statusColor;
    final statusText = item.statusLabel;

    // Icon based on status is not in the model extension, adding local helper or just use generic
    // Using generic logic similar to DapurPengirimanCard or just the statusColor
    IconData statusIcon = Iconsax.info_circle;
    if (item.normalizedStatus == SekolahTrayReturnStatus.menungguPickup) {
      statusIcon = Iconsax.clock;
    }
    if (item.normalizedStatus == SekolahTrayReturnStatus.sedangReturn) {
      statusIcon = Iconsax.truck_fast;
    }
    if (item.normalizedStatus == SekolahTrayReturnStatus.sampaiDapur) {
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
            // --- HEADER: ID & Status ---
            Text(
              'ID: ${item.qrCodeId}',
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

            if (item.driver != null) ...[
              Row(
                children: [
                  const Icon(Iconsax.user, size: MBGSizes.iconSm),
                  const SizedBox(width: MBGSizes.xs),
                  Expanded(
                    child: Text(
                      '${item.driver!.name}${item.driver!.nomorTelepon != null ? ' • ${item.driver!.nomorTelepon}' : ''}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems),
            ],

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // QR Preview - Only show if MENUNGGU_PICKUP
                if (item.normalizedStatus ==
                    SekolahTrayReturnStatus.menungguPickup) ...[
                  GestureDetector(
                    onTap: () => _showQRCodeDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(MBGSizes.xs),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode
                              ? MBGColors.darkGrey
                              : MBGColors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          MBGSizes.borderRadiusMd,
                        ),
                        color: Colors.white, // QR usually needs white bg
                      ),
                      height: 70,
                      width: 70,
                      child: Center(
                        child: PrettyQrView.data(
                          data: item.qrCodeId,
                          errorCorrectLevel: QrErrorCorrectLevel.M,
                          decoration: const PrettyQrDecoration(
                            shape: PrettyQrSmoothSymbol(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                ],

                // Info Boxes
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _infoBox(
                              theme,
                              'Jumlah Tray',
                              '${item.jumlahTray}',
                              MBGColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // --- WAKTU ---
            Row(
              children: [
                const Icon(Iconsax.calendar_1, size: MBGSizes.iconSm),
                const SizedBox(width: MBGSizes.xs),
                Expanded(
                  child: Text(
                    'Dibuat ${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(item.waktuSubmit.toLocal())}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),

            if (item.waktuSampaiDapur != null) ...[
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
                      'Selesai ${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(item.waktuSampaiDapur!.toLocal())}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: MBGColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (item.driver != null && item.driver!.nomorKendaraan != null) ...[
              const SizedBox(height: MBGSizes.spaceBtwItems / 2),
              Row(
                children: [
                  const Icon(Iconsax.car, size: MBGSizes.iconSm),
                  const SizedBox(width: MBGSizes.xs),
                  Text(
                    item.driver!.nomorKendaraan!,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],

            if (item.keterangan != null && item.keterangan!.isNotEmpty) ...[
              const SizedBox(height: MBGSizes.spaceBtwItems),
              Text(
                'Catatan: ${item.keterangan}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
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
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
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
                    alpha: 0.8,
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
                'Tunjukkan QR ini kepada Driver saat pengambilan tray.',
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
