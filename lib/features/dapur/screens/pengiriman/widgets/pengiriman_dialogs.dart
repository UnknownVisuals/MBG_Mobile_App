import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../controllers/pengiriman_controller.dart';
import '../../../models/pengiriman_model.dart';
import 'pengiriman_detail_row_widget.dart';

/// Helper class for pengiriman screen dialogs
class PengirimanDialogs {
  /// Show pengiriman details dialog
  static void showDetailsDialog(
    BuildContext context,
    PengirimanController controller,
    PengirimanModel pengiriman,
  ) {
    final statusColor = controller.getStatusColor(pengiriman.status);
    final statusText = controller.getStatusText(pengiriman.status);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.truck_fast, color: statusColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Detail Pengiriman',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(height: 24),
                PengirimanDetailRowWidget(
                  label: 'Sekolah',
                  value: pengiriman.sekolahNama ?? '-',
                ),
                PengirimanDetailRowWidget(
                  label: 'Alamat',
                  value: pengiriman.sekolahAlamat ?? '-',
                ),
                PengirimanDetailRowWidget(
                  label: 'Jumlah Tray',
                  value: '${pengiriman.jumlahTray}',
                ),
                PengirimanDetailRowWidget(
                  label: 'Jumlah Keranjang',
                  value: '${pengiriman.jumlahKeranjang}',
                ),
                PengirimanDetailRowWidget(
                  label: 'Status',
                  value: statusText,
                  color: statusColor,
                ),
                if (pengiriman.driverNama != null)
                  PengirimanDetailRowWidget(
                    label: 'Driver',
                    value: pengiriman.driverNama!,
                  ),
                if (pengiriman.waktuDiambil != null)
                  PengirimanDetailRowWidget(
                    label: 'Waktu Diambil',
                    value: _formatDateTime(pengiriman.waktuDiambil!),
                  ),
                if (pengiriman.waktuDiterima != null)
                  PengirimanDetailRowWidget(
                    label: 'Waktu Diterima',
                    value: _formatDateTime(pengiriman.waktuDiterima!),
                  ),
                PengirimanDetailRowWidget(
                  label: 'QR Code ID',
                  value: pengiriman.qrCodeId,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showQRCodeDialog(context, pengiriman);
                    },
                    icon: const Icon(Iconsax.scan_barcode),
                    label: const Text('Lihat QR Code'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show QR code dialog
  static void showQRCodeDialog(
    BuildContext context,
    PengirimanModel pengiriman,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QR Code Pengiriman',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                pengiriman.sekolahNama ?? 'Sekolah',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: QrImageView(
                  data: pengiriman.qrCodeId,
                  version: QrVersions.auto,
                  size: 250,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pengiriman.qrCodeId,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement share/print QR code
                      MBGLoaders.successSnackBar(
                        title: 'Info',
                        message: 'Fitur berbagi QR akan segera hadir',
                      );
                    },
                    icon: const Icon(Iconsax.share),
                    label: const Text('Bagikan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show delete confirmation dialog
  static void showDeleteConfirmation(
    BuildContext context,
    PengirimanController controller,
    PengirimanModel pengiriman,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengiriman'),
        content: Text(
          'Apakah Anda yakin ingin menghapus pengiriman ke ${pengiriman.sekolahNama}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.deletePengiriman(pengiriman);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }
}
