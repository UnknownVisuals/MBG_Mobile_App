import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../utils/http/driver_service.dart';
import '../../../utils/http/sekolah_service.dart';
import '../../../utils/popups/loaders.dart';
import '../../dapur/models/pengiriman_model.dart';

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
              _buildDetailItem('Sekolah', pengiriman.sekolahNama ?? '-'),
              _buildDetailItem('Alamat', pengiriman.sekolahAlamat ?? '-'),
              _buildDetailItem('Jumlah Tray', '${pengiriman.jumlahTray}'),
              _buildDetailItem(
                'Jumlah Keranjang',
                '${pengiriman.jumlahKeranjang}',
              ),
              _buildDetailItem('Status', _getStatusText(pengiriman.status)),
              if (pengiriman.waktuDiambil != null)
                _buildDetailItem(
                  'Diambil',
                  DateFormat(
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

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
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
    final String title = widget.mode == ScanMode.driver
        ? 'Scan untuk Mengambil'
        : 'Scan untuk Menerima';
    final String instruction = widget.mode == ScanMode.driver
        ? 'Scan QR code pengiriman untuk mengambil'
        : 'Scan QR code pengiriman untuk menerima';

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.black),
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _onDetect),
          // Overlay with scanning area
          CustomPaint(painter: ScannerOverlay(), child: Container()),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Memproses...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          // Top info panel
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Icon(
                      widget.mode == ScanMode.driver
                          ? Iconsax.truck_fast
                          : Iconsax.receipt_1,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      instruction,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom info panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.scan_barcode,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Arahkan QR code ke dalam frame',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isProcessing ? 'Memproses...' : 'Siap memindai',
                      style: TextStyle(
                        color: _isProcessing ? Colors.orange : Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for scanner overlay
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;

    // Draw semi-transparent overlay
    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, top), backgroundPaint);
    canvas.drawRect(Rect.fromLTWH(0, top, left, scanAreaSize), backgroundPaint);
    canvas.drawRect(
      Rect.fromLTWH(left + scanAreaSize, top, left, scanAreaSize),
      backgroundPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        top + scanAreaSize,
        size.width,
        size.height - top - scanAreaSize,
      ),
      backgroundPaint,
    );

    // Draw corner brackets
    final Paint bracketPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const double cornerLength = 30;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      bracketPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize - cornerLength, top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize, top + cornerLength),
      bracketPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left + cornerLength, top + scanAreaSize),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left, top + scanAreaSize - cornerLength),
      bracketPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize),
      Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize),
      Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
