import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DriverMyDeliveriesController extends GetxController {
  DriverMyDeliveriesController() : _driverService = Get.find<DriverService>();

  final DriverService _driverService;

  final RxList<DriverDeliveryModel> deliveries = <DriverDeliveryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDeliveries();
  }

  Future<void> loadDeliveries() async {
    try {
      isLoading.value = true;
      final data = await _driverService.getMyDeliveries();
      deliveries.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat daftar pengiriman: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDeliveries() => loadDeliveries();

  void upsertDelivery(DriverDeliveryModel delivery) {
    final index = deliveries.indexWhere((item) => item.id == delivery.id);
    if (index == -1) {
      deliveries.insert(0, delivery);
    } else {
      deliveries[index] = delivery;
      deliveries.refresh();
    }
  }
}
