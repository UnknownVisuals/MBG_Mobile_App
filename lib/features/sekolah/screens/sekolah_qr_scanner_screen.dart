import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/driver/screens/qr_scanner/qr_scanner_screen.dart';

class SekolahQRScannerScreen extends StatelessWidget {
  const SekolahQRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const QRScannerScreen(mode: ScanMode.sekolah);
  }
}
