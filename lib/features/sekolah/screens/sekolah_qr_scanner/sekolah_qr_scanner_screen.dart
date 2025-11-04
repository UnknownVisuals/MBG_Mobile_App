import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Halaman QR Scanner Sekolah (versi dummy)
class SekolahQRScannerScreen extends StatelessWidget {
  const SekolahQRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner Sekolah'),
        backgroundColor: MBGColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Iconsax.scan_barcode,
            size: 120,
            color: Colors.grey,
          ),
          const SizedBox(height: MBGSizes.lg),
          Text(
            'Fitur Pemindaian QR Sekolah',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Arahkan kamera ke QR Code untuk memindai',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: MBGSizes.xl),

          // Tombol Dummy (simulasi hasil scan)
          ElevatedButton.icon(
            onPressed: () {
              // Dummy hasil scan
              const hasilScan = "QR12345-SEKOLAH";
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Hasil Scan: $hasilScan'),
                  backgroundColor: MBGColors.success,
                ),
              );
            },
            icon: const Icon(Iconsax.scan),
            label: const Text('Mulai Scan (Dummy)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MBGColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: MBGSizes.lg,
                vertical: MBGSizes.md,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
