import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';

class DriverController extends GetxController {
  DriverController({DriverService? driverService})
    : _driverService = driverService ?? Get.find<DriverService>();

  // Data variables
  final RxList<DriverDeliveryModel> deliveries = <DriverDeliveryModel>[].obs;

  // State variables
  final RxInt drawerSelectedIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Data variables
  final RxString scannedQrCode = ''.obs;

  // State variables
  final RxBool isScanning = false.obs;

  final DriverService _driverService;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveries();
  }

  // ========================
  // Get Pengiriman by Driver
  // ========================

  Future<void> fetchDeliveries() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await _driverService.getMyDeliveries();
      deliveries.assignAll(results);
    } catch (error) {
      errorMessage.value = error.toString();
      Get.log('DriverController.fetchDeliveries error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // ===================
  // QR Code Scan & Post
  // ===================

  Future<DriverDeliveryModel> scanDriverQrCode(String qrCodeId) async {
    try {
      isScanning.value = true;
      final delivery = await _driverService.scanDriverQR(qrCodeId);
      scannedQrCode.value = qrCodeId;
      // Update the delivery in the list
      final index = deliveries.indexWhere((d) => d.id == delivery.id);
      if (index != -1) {
        deliveries[index] = delivery;
        deliveries.refresh();
      } else {
        deliveries.insert(0, delivery);
      }
      return delivery;
    } catch (error) {
      Get.log('DriverController.scanDriverQrCode error: $error');
      rethrow;
    } finally {
      isScanning.value = false;
    }
  }

  Future<void> handleScannedQrCode(String qrCodeId) async {
    final normalizedCode = qrCodeId.trim();
    if (normalizedCode.isEmpty) {
      MBGLoaders.errorSnackBar(
        title: 'QR tidak valid',
        message: 'Kode QR tidak boleh kosong.',
      );
      return;
    }

    try {
      MBGLoadingOverlay.show();
      await scanDriverQrCode(normalizedCode);
      await fetchDeliveries();
      MBGLoadingOverlay.hide();
      Get.back();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Status pengiriman diperbarui.',
      );
    } catch (error) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal memindai',
        message: error.toString(),
      );
      rethrow;
    }
  }
}
