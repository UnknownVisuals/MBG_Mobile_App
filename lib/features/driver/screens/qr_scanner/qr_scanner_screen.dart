import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../utils/http/driver_service.dart';
import '../../../../utils/http/sekolah_service.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../dapur/models/pengiriman_model.dart';
import 'widgets/qr_detail_item_widget.dart';

enum ScanMode { driver, sekolah }

class QRScannerScreen extends StatefulWidget {
  final ScanMode mode;

  const QRScannerScreen({super.key, this.mode = ScanMode.driver});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final DriverService _driverService = Get.find<DriverService>();
  final SekolahService _sekolahService = Get.find<SekolahService>();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _isProcessing = true);
    controller.stop();

    try {
      // First, get delivery details by QR
      final pengiriman = await _driverService.getDeliveryByQR(code);

      // Show delivery details and confirm action
      if (!mounted) return;

      final confirmed = await _showDeliveryConfirmationDialog(pengiriman);

      if (confirmed == true) {
        // Perform the scan based on mode
        PengirimanModel scannedPengiriman;
        if (widget.mode == ScanMode.driver) {
          scannedPengiriman = await _driverService.scanDriverQR(code);
          MBGLoaders.successSnackBar(
            title: 'Berhasil',
            message: 'Pengiriman berhasil diambil!',
          );
        } else {
          scannedPengiriman = await _sekolahService.scanSekolahQR(code);
          MBGLoaders.successSnackBar(
            title: 'Berhasil',
            message: 'Pengiriman berhasil diterima!',
          );
        }

        Get.back(result: scannedPengiriman);
      } else {
        // User cancelled, resume scanning
        controller.start();
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memindai QR: $e',
      );

      // Resume camera for retry
      await Future.delayed(const Duration(seconds: 2));
      controller.start();
      setState(() => _isProcessing = false);
    }
  }

  Future<bool?> _showDeliveryConfirmationDialog(PengirimanModel pengiriman) {
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
              QRDetailItemWidget(
                label: 'Sekolah',
                value: pengiriman.sekolahNama ?? '-',
              ),
              QRDetailItemWidget(
                label: 'Alamat',
                value: pengiriman.sekolahAlamat ?? '-',
              ),
              QRDetailItemWidget(
                label: 'Jumlah Tray',
                value: '${pengiriman.jumlahTray}',
              ),
              QRDetailItemWidget(
                label: 'Jumlah Keranjang',
                value: '${pengiriman.jumlahKeranjang}',
              ),
              QRDetailItemWidget(
                label: 'Status',
                value: _getStatusText(pengiriman.status),
              ),
              if (pengiriman.waktuDiambil != null)
                QRDetailItemWidget(
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

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'Menunggu Pengambilan';
      case 'DIAMBIL':
        return 'Sedang Dikirim';
      case 'DITERIMA':
        return 'Sudah Diterima';
      default:
        return status;
    }
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
              controller.torchEnabled ? Iconsax.flash : Iconsax.flash_slash,
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Iconsax.camera),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _onDetect),
          // Overlay with instructions
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top instruction
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
              // Bottom hints
              Container(
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
                    if (_isProcessing) ...[
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
              ),
            ],
          ),
          // Scan area guide
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
