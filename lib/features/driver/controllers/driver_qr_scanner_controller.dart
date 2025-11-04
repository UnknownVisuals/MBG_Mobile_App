import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_qr_scanner/driver_qr_scanner_screen.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DriverQrScannerController extends GetxController {
  DriverQrScannerController()
    : _driverService = Get.find<DriverService>(),
      _sekolahService = Get.find<SekolahService>();

  final DriverService _driverService;
  final SekolahService _sekolahService;

  final RxBool isProcessing = false.obs;

  bool beginProcessing() {
    if (isProcessing.value) return false;
    isProcessing.value = true;
    return true;
  }

  void endProcessing() {
    isProcessing.value = false;
  }

  Future<DriverDeliveryModel?> fetchDeliveryByQr(String code) async {
    try {
      return await _driverService.getDeliveryByQR(code);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat data pengiriman: $e',
      );
      return null;
    }
  }

  Future<DriverDeliveryModel?> confirmScan(String code, ScanMode mode) async {
    try {
      if (mode == ScanMode.driver) {
        final delivery = await _driverService.scanDriverQR(code);
        MBGLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Pengiriman berhasil diambil!',
        );
        return delivery;
      }
      final delivery = await _sekolahService.scanSekolahQR(code);
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengiriman berhasil diterima!',
      );
      return delivery;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memproses QR: $e',
      );
      return null;
    }
  }
}
