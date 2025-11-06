import 'package:flutter/material.dart';

class ReceiveDeliveryScreen extends StatelessWidget {
  const ReceiveDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Delivery'),
        backgroundColor: Colors.black,
        actions: const [
          Icon(Icons.flash_off),
          SizedBox(width: 8),
          Icon(Icons.cameraswitch_outlined),
          SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Placeholder untuk scanner (tidak pakai controller)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Icon(Icons.qr_code_2, color: Colors.white, size: 100),
            ),
          ),

          // Overlay hijau
          CustomPaint(painter: ScannerOverlay(), child: Container()),

          // Bottom info panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Scan delivery QR code',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ready to scan',
                      style: TextStyle(color: Colors.green, fontSize: 14),
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

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scanAreaSize = size.width * 0.7;
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2;

    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, top), backgroundPaint);
    canvas.drawRect(Rect.fromLTWH(0, top, left, scanAreaSize), backgroundPaint);
    canvas.drawRect(Rect.fromLTWH(left + scanAreaSize, top, left, scanAreaSize), backgroundPaint);
    canvas.drawRect(
      Rect.fromLTWH(0, top + scanAreaSize, size.width, size.height - top - scanAreaSize),
      backgroundPaint,
    );

    final bracketPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerLength = 30.0;

    // Garis pojok-pojok
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), bracketPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), bracketPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top),
        Offset(left + scanAreaSize - cornerLength, top), bracketPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top),
        Offset(left + scanAreaSize, top + cornerLength), bracketPaint);
    canvas.drawLine(Offset(left, top + scanAreaSize),
        Offset(left + cornerLength, top + scanAreaSize), bracketPaint);
    canvas.drawLine(Offset(left, top + scanAreaSize),
        Offset(left, top + scanAreaSize - cornerLength), bracketPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top + scanAreaSize),
        Offset(left + scanAreaSize - cornerLength, top + scanAreaSize), bracketPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top + scanAreaSize),
        Offset(left + scanAreaSize, top + scanAreaSize - cornerLength), bracketPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_receive_delivery_controller.dart';

// class ReceiveDeliveryScreen extends StatefulWidget {
//   const ReceiveDeliveryScreen({super.key});

//   @override
//   State<ReceiveDeliveryScreen> createState() => _ReceiveDeliveryScreenState();
// }

// class _ReceiveDeliveryScreenState extends State<ReceiveDeliveryScreen> {
//   final MobileScannerController scannerController = MobileScannerController();
//   late final SekolahReceiveDeliveryController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = Get.find<SekolahReceiveDeliveryController>();
//   }

//   @override
//   void dispose() {
//     controller.endProcessing();
//     scannerController.dispose();
//     super.dispose();
//   }

//   Future<void> _resumeScanning({Duration? delay}) async {
//     if (delay != null) {
//       await Future.delayed(delay);
//     }
//     controller.endProcessing();
//     if (!mounted) return;
//     await scannerController.start();
//   }

//   void _onDetect(BarcodeCapture capture) async {
//     if (!controller.beginProcessing()) return;

//     final barcodes = capture.barcodes;
//     if (barcodes.isEmpty) {
//       controller.endProcessing();
//       return;
//     }

//     final code = barcodes.first.rawValue;
//     if (code == null || code.isEmpty) {
//       controller.endProcessing();
//       return;
//     }

//     scannerController.stop();

//     try {
//       final pengiriman = await controller.confirmScan(code);
//       if (pengiriman != null) {
//         controller.endProcessing();
//         if (mounted) {
//           Get.back(result: pengiriman);
//         }
//         return;
//       }

//       await _resumeScanning();
//     } catch (_) {
//       await _resumeScanning(delay: const Duration(seconds: 2));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Receive Delivery'),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: Icon(
//               scannerController.torchEnabled ? Icons.flash_on : Icons.flash_off,
//             ),
//             onPressed: () => scannerController.toggleTorch(),
//           ),
//           IconButton(
//             icon: const Icon(Icons.cameraswitch_outlined),
//             onPressed: () => scannerController.switchCamera(),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(controller: scannerController, onDetect: _onDetect),
//           CustomPaint(painter: ScannerOverlay(), child: Container()),
//           Obx(
//             () => controller.isProcessing.value
//                 ? Container(
//                     color: Colors.black54,
//                     child: const Center(
//                       child: CircularProgressIndicator(color: Colors.white),
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 120,
//               color: Colors.black87,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.qr_code_scanner,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Scan delivery QR code',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                     const SizedBox(height: 4),
//                     Obx(() {
//                       final processing = controller.isProcessing.value;
//                       return Text(
//                         processing ? 'Processing...' : 'Ready to scan',
//                         style: TextStyle(
//                           color: processing ? Colors.orange : Colors.green,
//                           fontSize: 14,
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ScannerOverlay extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final scanAreaSize = size.width * 0.7;
//     final left = (size.width - scanAreaSize) / 2;
//     final top = (size.height - scanAreaSize) / 2;

//     final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);

//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, top), backgroundPaint);
//     canvas.drawRect(Rect.fromLTWH(0, top, left, scanAreaSize), backgroundPaint);
//     canvas.drawRect(
//       Rect.fromLTWH(left + scanAreaSize, top, left, scanAreaSize),
//       backgroundPaint,
//     );
//     canvas.drawRect(
//       Rect.fromLTWH(
//         0,
//         top + scanAreaSize,
//         size.width,
//         size.height - top - scanAreaSize,
//       ),
//       backgroundPaint,
//     );

//     final bracketPaint = Paint()
//       ..color = Colors.green
//       ..strokeWidth = 4
//       ..style = PaintingStyle.stroke;

//     const cornerLength = 30.0;

//     canvas.drawLine(
//       Offset(left, top),
//       Offset(left + cornerLength, top),
//       bracketPaint,
//     );
//     canvas.drawLine(
//       Offset(left, top),
//       Offset(left, top + cornerLength),
//       bracketPaint,
//     );

//     canvas.drawLine(
//       Offset(left + scanAreaSize, top),
//       Offset(left + scanAreaSize - cornerLength, top),
//       bracketPaint,
//     );
//     canvas.drawLine(
//       Offset(left + scanAreaSize, top),
//       Offset(left + scanAreaSize, top + cornerLength),
//       bracketPaint,
//     );

//     canvas.drawLine(
//       Offset(left, top + scanAreaSize),
//       Offset(left + cornerLength, top + scanAreaSize),
//       bracketPaint,
//     );
//     canvas.drawLine(
//       Offset(left, top + scanAreaSize),
//       Offset(left, top + scanAreaSize - cornerLength),
//       bracketPaint,
//     );

//     canvas.drawLine(
//       Offset(left + scanAreaSize, top + scanAreaSize),
//       Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
//       bracketPaint,
//     );
//     canvas.drawLine(
//       Offset(left + scanAreaSize, top + scanAreaSize),
//       Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
//       bracketPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
