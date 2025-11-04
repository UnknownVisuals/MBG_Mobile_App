import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';

class DriverController extends GetxController {
  final DriverService _driverService = Get.find<DriverService>();
  // Drawer navigation index
  final RxInt drawerSelectedIndex = 0.obs;

  // Observable variables
  final RxList<DriverDeliveryModel> deliveries = <DriverDeliveryModel>[].obs;
  final RxBool isLoading = false.obs;

  /// Fetch driver's deliveries
  Future<void> fetchDeliveries() async {
    try {
      isLoading.value = true;
      final data = await _driverService.getMyDeliveries();
      deliveries.assignAll(data);
    } catch (e) {
      Get.log('Error fetching deliveries: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Scan QR code for pickup
  Future<DriverDeliveryModel?> scanDriverQR(String qrCodeId) async {
    try {
      isLoading.value = true;
      final delivery = await _driverService.scanDriverQR(qrCodeId);
      final index = deliveries.indexWhere((item) => item.id == delivery.id);
      if (index == -1) {
        deliveries.insert(0, delivery);
      } else {
        deliveries[index] = delivery;
        deliveries.refresh();
      }
      return delivery;
    } catch (e) {
      Get.log('Error scanning driver QR: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
