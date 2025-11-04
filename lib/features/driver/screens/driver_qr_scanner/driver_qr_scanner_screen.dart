import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_qr_scanner_controller.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_qr_scanner/widgets/driver_qr_detail_item.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

enum ScanMode { driver, sekolah }

class DriverQrScannerScreen extends StatefulWidget {
  const DriverQrScannerScreen({super.key, this.mode = ScanMode.driver});

  final ScanMode mode;

  @override
  State<DriverQrScannerScreen> createState() => _DriverQrScannerScreenState();
}

class _DriverQrScannerScreenState extends State<DriverQrScannerScreen> {
  final MobileScannerController scannerController = MobileScannerController();
  late final DriverQrScannerController qrController;

  @override
  void initState() {
    super.initState();
    qrController = Get.find<DriverQrScannerController>();
  }

  @override
  void dispose() {
    qrController.endProcessing();
    scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (!qrController.beginProcessing()) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      qrController.endProcessing();
      return;
    }

    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) {
      qrController.endProcessing();
      return;
    }

    scannerController.stop();

    try {
      final result = await qrController.fetchDeliveryByQr(code);
      if (result == null) {
        await _resumeScanning();
        return;
      }

      if (!mounted) {
        qrController.endProcessing();
        return;
      }

      final confirmed = await _showDeliveryConfirmationDialog(result);

      if (confirmed == true) {
        final delivery = await qrController.confirmScan(code, widget.mode);
        if (delivery != null) {
          qrController.endProcessing();
          if (mounted) {
            Get.back(result: delivery);
          }
          return;
        }
      }

      await _resumeScanning();
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memindai QR: $e',
      );
      await _resumeScanning(delay: const Duration(seconds: 2));
    }
  }

  Future<bool?> _showDeliveryConfirmationDialog(
    DriverDeliveryModel pengiriman,
  ) {
    final String title = widget.mode == ScanMode.driver
        ? 'Konfirmasi Pengambilan'
        : 'Konfirmasi Penerimaan';
    final String message = widget.mode == ScanMode.driver
        ? 'Apakah Anda yakin akan mengambil pengiriman ini?'
        : 'Apakah Anda yakin akan menerima pengiriman ini?';

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              widget.mode == ScanMode.driver
                  ? Iconsax.truck_fast
                  : Iconsax.building,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Divider(height: 24),
              DriverQrDetailItem(
                label: 'Sekolah',
                value: pengiriman.sekolahNama ?? '-',
              ),
              DriverQrDetailItem(
                label: 'Alamat',
                value: pengiriman.sekolahAlamat ?? '-',
              ),
              DriverQrDetailItem(
                label: 'Jumlah Tray',
                value: '${pengiriman.jumlahTray}',
              ),
              DriverQrDetailItem(
                label: 'Jumlah Keranjang',
                value: '${pengiriman.jumlahKeranjang}',
              ),
              DriverQrDetailItem(
                label: 'Status',
                value: _statusText(pengiriman.status),
              ),
              if (pengiriman.waktuDiambil != null)
                DriverQrDetailItem(
                  label: 'Diambil',
                  value: DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(pengiriman.waktuDiambil!),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(
              widget.mode == ScanMode.driver
                  ? Iconsax.tick_circle
                  : Iconsax.receipt,
            ),
            label: Text(widget.mode == ScanMode.driver ? 'Ambil' : 'Terima'),
          ),
        ],
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'Menunggu Pengambilan';
      case 'IN_TRANSIT':
      case 'DIAMBIL':
        return 'Sedang Dikirim';
      case 'DELIVERED':
      case 'DITERIMA':
        return 'Sudah Diterima';
      default:
        return status;
    }
  }

  Future<void> _resumeScanning({Duration? delay}) async {
    if (delay != null) {
      await Future.delayed(delay);
    }
    qrController.endProcessing();
    if (!mounted) return;
    await scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == ScanMode.driver
              ? 'Scan untuk Mengambil'
              : 'Scan untuk Menerima',
        ),
        actions: [
          IconButton(
            icon: Icon(
              scannerController.torchEnabled
                  ? Iconsax.flash
                  : Iconsax.flash_slash,
            ),
            onPressed: () => scannerController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Iconsax.camera),
            onPressed: () => scannerController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: scannerController, onDetect: _onDetect),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Colors.black.withOpacity(0.7),
                child: Column(
                  children: [
                    Icon(
                      widget.mode == ScanMode.driver
                          ? Iconsax.truck_fast
                          : Iconsax.receipt,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.mode == ScanMode.driver
                          ? 'Arahkan kamera ke QR Code\npengiriman untuk mengambil'
                          : 'Arahkan kamera ke QR Code\npengiriman untuk menerima',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final isProcessing = qrController.isProcessing.value;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.black.withOpacity(0.7),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.info_circle,
                            color: Colors.white.withOpacity(0.8),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pastikan QR Code terlihat jelas',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (isProcessing) ...[
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 8),
                        const Text(
                          'Memproses...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
