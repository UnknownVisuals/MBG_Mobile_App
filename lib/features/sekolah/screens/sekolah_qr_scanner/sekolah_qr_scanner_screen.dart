import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_qr_scanner/driver_qr_scanner_screen.dart';

class SekolahQRScannerScreen extends StatelessWidget {
  const SekolahQRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DriverQrScannerScreen(mode: ScanMode.sekolah);
  }
}
