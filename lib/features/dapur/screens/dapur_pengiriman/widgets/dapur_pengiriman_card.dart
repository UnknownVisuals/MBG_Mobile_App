import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurPengirimanCard extends StatelessWidget {
  const DapurPengirimanCard({super.key, required this.pengiriman});

  final PengirimanModel pengiriman;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(pengiriman.status);
    final statusText = _getStatusText(pengiriman.status);
    final statusIcon = _getStatusIcon(pengiriman.status);

    return Container(
      margin: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: MBGColors.light,
        border: Border.all(color: MBGColors.borderPrimary),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with school name and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pengiriman.sekolahNama ?? 'Sekolah',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        pengiriman.sekolahAlamat ?? '-',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MBGColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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

            const Divider(height: MBGSizes.spaceBtwSections),

            // Tray and Keranjang info
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
                    decoration: BoxDecoration(
                      color: MBGColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.box,
                          size: MBGSizes.iconMd,
                          color: MBGColors.primary,
                        ),
                        const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tray',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: MBGColors.textSecondary),
                            ),
                            Text(
                              '${pengiriman.jumlahTray}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MBGColors.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
                    decoration: BoxDecoration(
                      color: MBGColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.box_1,
                          size: MBGSizes.iconMd,
                          color: MBGColors.success,
                        ),
                        const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keranjang',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: MBGColors.textSecondary),
                            ),
                            Text(
                              '${pengiriman.jumlahKeranjang}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MBGColors.success,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.spaceBtwItems),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
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
                if (pengiriman.status == 'PENDING') ...[
                  const SizedBox(width: MBGSizes.spaceBtwItems),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.trash, color: MBGColors.error),
                    tooltip: 'Hapus',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'IN_TRANSIT':
      case 'DIAMBIL':
      case 'SEDANG_DIJEMPUT':
        return Colors.blue;
      case 'DITERIMA':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'Pending';
      case 'IN_TRANSIT':
        return 'Dalam Perjalanan';
      case 'DIAMBIL':
        return 'Diambil';
      case 'SEDANG_DIJEMPUT':
        return 'Sedang Dijemput';
      case 'DITERIMA':
        return 'Diterima';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Iconsax.clock;
      case 'IN_TRANSIT':
      case 'DIAMBIL':
      case 'SEDANG_DIJEMPUT':
        return Iconsax.truck_fast;
      case 'DITERIMA':
        return Iconsax.tick_circle;
      default:
        return Iconsax.info_circle;
    }
  }
}
