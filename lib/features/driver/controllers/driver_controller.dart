import 'package:get/get.dart';

class DriverController extends GetxController {
  // Drawer navigation index
  final RxInt drawerSelectedIndex = 0.obs;

  // Observable variables
  final RxList<dynamic> deliveries = <dynamic>[].obs;
  final RxBool isLoading = false.obs;

  /// Fetch driver's deliveries
  Future<void> fetchDeliveries() async {
    try {
      isLoading.value = true;
      // TODO: Implement API call to fetch deliveries
      // final response = await httpHelper.getRequest('driver/pengiriman');
      // deliveries.value = response.data;
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  /// Scan QR code for pickup
  Future<void> scanDriverQR(String qrCodeId) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call
      // await httpHelper.postRequest('pengiriman/$qrCodeId/scan-driver', {});
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
