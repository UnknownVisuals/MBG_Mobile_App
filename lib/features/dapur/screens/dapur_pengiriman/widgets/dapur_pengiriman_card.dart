import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/widgets/image_preview_dialog.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_pengiriman_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_pengiriman_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_pengiriman/widgets/dapur_pengiriman_delete.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurPengirimanCard extends StatelessWidget {
  const DapurPengirimanCard({super.key, required this.pengiriman});

  final DapurPengirimanModel pengiriman;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(pengiriman.status!);
    final statusText = _getStatusText(pengiriman.status!);
    final statusIcon = _getStatusIcon(pengiriman.status!);

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: theme.cardColor, // 🟢 Adaptif Light/Dark
        border: Border.all(color: theme.dividerColor), // 🟢 Adaptif
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER SEKOLAH ---
            Text(
              pengiriman.sekolahNama ?? 'Sekolah',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                Icon(
                  Iconsax.location,
                  size: MBGSizes.iconSm,
                  color: theme.iconTheme.color?.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    pengiriman.sekolahAlamat ?? '---',
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

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // --- STATUS CHIP ---
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

            const SizedBox(height: MBGSizes.spaceBtwSections),

            // --- TRAY & KERANJANG ---
            Row(
              children: [
                Expanded(
                  child: _infoBox(
                    theme,
                    'Tray',
                    pengiriman.jumlahTray!,
                    MBGColors.primary,
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: _infoBox(
                    theme,
                    'Keranjang',
                    pengiriman.jumlahKeranjang!,
                    MBGColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // --- WAKTU ---
            Container(
              padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.calendar_1,
                    size: MBGSizes.iconSm,
                    color: theme.iconTheme.color,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(pengiriman.createdAt!.toLocal()),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // --- BUTTON BAR ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (pengiriman.qrCodeUrl!.isNotEmpty) {
                        MBGImagePreviewDialog.showData(
                          context: context,
                          imageData: pengiriman.qrCodeUrl!,
                        );
                      }
                    },
                    icon: Icon(
                      Iconsax.scan_barcode,
                      color: theme.iconTheme.color,
                    ),
                    label: Text('QR Code'),
                  ),
                ),
                if (_isPendingStatus(pengiriman.status!)) ...[
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  IconButton(
                    onPressed: () {
                      final controller = Get.find<DapurPengirimanController>();
                      showDialog(
                        context: context,
                        builder: (_) => DapurPengirimanDelete(
                          pengirimanId: pengiriman.id,
                          controller: controller,
                        ),
                      );
                    },
                    icon: const Icon(Iconsax.trash, color: MBGColors.error),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget helper untuk tray & keranjang ---
  Widget _infoBox(ThemeData theme, String title, int value, Color brandColor) {
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
                '$value',
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

  // --- STATUS COLOR / TEXT / ICON ---
  Color _getStatusColor(String s) {
    switch (s.toUpperCase()) {
      case 'PENDING':
      case 'MENUNGGU_PENGIRIMAN':
      case 'MENUNGGU_PENGAMBILAN':
        return Colors.orange;
      case 'IN_TRANSIT':
      case 'DIAMBIL':
      case 'SEDANG_DIJEMPUT':
      case 'SEDANG_DIANTAR':
      case 'DIANTAR':
        return Colors.blue;
      case 'DITERIMA':
      case 'SELESAI':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String s) {
    switch (s.toUpperCase()) {
      case 'PENDING':
      case 'MENUNGGU_PENGAMBILAN':
        return 'Menunggu Pengambilan';
      case 'MENUNGGU_PENGIRIMAN':
        return 'Menunggu Pengiriman';
      case 'IN_TRANSIT':
        return 'Dalam Perjalanan';
      case 'DIAMBIL':
        return 'Diambil';
      case 'SEDANG_DIJEMPUT':
        return 'Sedang Dijemput';
      case 'SEDANG_DIANTAR':
      case 'DIANTAR':
        return 'Sedang Diantar';
      case 'TELAH_SAMPAI':
        return 'Telah Sampai';
      case 'DITERIMA':
        return 'Diterima';
      case 'SELESAI':
        return 'Selesai';
    }
    return s;
  }

  IconData _getStatusIcon(String s) {
    switch (s.toUpperCase()) {
      case 'PENDING':
      case 'MENUNGGU_PENGIRIMAN':
      case 'MENUNGGU_PENGAMBILAN':
        return Iconsax.clock;
      case 'IN_TRANSIT':
      case 'DIAMBIL':
      case 'SEDANG_DIJEMPUT':
      case 'SEDANG_DIANTAR':
      case 'DIANTAR':
        return Iconsax.truck_fast;
      case 'DITERIMA':
      case 'SELESAI':
        return Iconsax.tick_circle;
      default:
        return Iconsax.info_circle;
    }
  }

  bool _isPendingStatus(String s) {
    return [
      'PENDING',
      'MENUNGGU_PENGIRIMAN',
      'MENUNGGU_PENGAMBILAN',
    ].contains(s.toUpperCase());
  }
}
