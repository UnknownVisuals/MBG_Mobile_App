import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mbg_mobile_app/utils/http/sekolah_service.dart';

class ReceiveDeliveryScreen extends StatefulWidget {
  const ReceiveDeliveryScreen({super.key});

  @override
  State<ReceiveDeliveryScreen> createState() => _ReceiveDeliveryScreenState();
}

class _ReceiveDeliveryScreenState extends State<ReceiveDeliveryScreen> {
  final MobileScannerController controller = MobileScannerController();
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
      // Scan the QR code ID to mark delivery as received
      final pengiriman = await _sekolahService.scanSekolahQR(code);

      Get.back(result: pengiriman);
      Get.snackbar(
        'Success',
        'Delivery received successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to scan QR: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Resume camera for retry
      await Future.delayed(const Duration(seconds: 2));
      controller.start();
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Delivery'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _onDetect),
          // Overlay with scanning area
          CustomPaint(painter: ScannerOverlay(), child: Container()),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          // Bottom info panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Scan delivery QR code',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isProcessing ? 'Processing...' : 'Ready to scan',
                      style: TextStyle(
                        color: _isProcessing ? Colors.orange : Colors.green,
                        fontSize: 14,
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
