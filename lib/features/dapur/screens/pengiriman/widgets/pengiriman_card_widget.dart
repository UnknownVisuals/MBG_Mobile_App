import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/pengiriman_controller.dart';
import '../../../models/pengiriman_model.dart';
import 'pengiriman_info_item_widget.dart';
import 'pengiriman_timeline_item_widget.dart';

/// Card widget displaying pengiriman information
class PengirimanCardWidget extends StatelessWidget {
  final PengirimanController controller;
  final PengirimanModel pengiriman;
  final VoidCallback onTapDetails;
  final VoidCallback onShowQR;
  final VoidCallback? onDelete;

  const PengirimanCardWidget({
    super.key,
    required this.controller,
    required this.pengiriman,
    required this.onTapDetails,
    required this.onShowQR,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = controller.getStatusColor(pengiriman.status);
    final statusText = controller.getStatusText(pengiriman.status);
    final statusIcon = controller.getStatusIcon(pengiriman.status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTapDetails,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with school name and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pengiriman.sekolahNama ?? 'Sekolah',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                pengiriman.sekolahAlamat ??
                                    'Alamat tidak tersedia',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Tray and Keranjang info
              Row(
                children: [
                  Expanded(
                    child: PengirimanInfoItemWidget(
                      icon: Iconsax.box,
                      label: 'Tray',
                      value: '${pengiriman.jumlahTray}',
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: PengirimanInfoItemWidget(
                      icon: Iconsax.box_1,
                      label: 'Keranjang',
                      value: '${pengiriman.jumlahKeranjang}',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              // Timeline
              if (pengiriman.waktuDiambil != null ||
                  pengiriman.waktuDiterima != null) ...[
                const SizedBox(height: 12),
                if (pengiriman.waktuDiambil != null)
                  PengirimanTimelineItemWidget(
                    label: 'Diambil Driver',
                    time: pengiriman.waktuDiambil!,
                    color: Colors.blue,
                    additionalInfo: pengiriman.driverNama,
                  ),
                if (pengiriman.waktuDiterima != null)
                  PengirimanTimelineItemWidget(
                    label: 'Diterima Sekolah',
                    time: pengiriman.waktuDiterima!,
                    color: Colors.green,
                  ),
              ],
              const SizedBox(height: 12),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onShowQR,
                      icon: const Icon(Iconsax.scan_barcode, size: 18),
                      label: const Text('QR Code'),
                    ),
                  ),
                  if (pengiriman.status == 'PENDING' && onDelete != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Iconsax.trash, color: Colors.red),
                      tooltip: 'Hapus',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
