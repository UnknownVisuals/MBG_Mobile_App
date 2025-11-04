import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_delivery_model.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';

class DriverDashboardController extends GetxController {
  final DriverService _driverService = Get.find<DriverService>();

  // Observable variables
  final RxList<DriverDeliveryModel> pendingDeliveries =
      <DriverDeliveryModel>[].obs;
  final RxList<DriverDeliveryModel> completedDeliveries =
      <DriverDeliveryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt pendingCount = 0.obs;
  final RxInt completedTodayCount = 0.obs;
  final RxInt totalDeliveriesCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Fetch all dashboard data
  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      await fetchDeliveries();
    } catch (e) {
      Get.log('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all deliveries for driver
  Future<void> fetchDeliveries() async {
    try {
      final deliveries = await _driverService.getMyDeliveries();

      // Separate pending and completed deliveries
      pendingDeliveries.value = deliveries
          .where(
            (d) =>
                d.status == 'PENDING' ||
                d.status == 'IN_TRANSIT' ||
                d.status == 'DIAMBIL',
          )
          .toList();

      completedDeliveries.value = deliveries
          .where((d) => d.status == 'DITERIMA' || d.status == 'DELIVERED')
          .toList();

      // Filter completed today
      final today = DateTime.now();
      final completedToday = completedDeliveries.where((d) {
        final completionTime = d.waktuDiterima ?? d.updatedAt;
        return completionTime.year == today.year &&
            completionTime.month == today.month &&
            completionTime.day == today.day;
      }).toList();

      pendingCount.value = pendingDeliveries.length;
      completedTodayCount.value = completedToday.length;
      totalDeliveriesCount.value = deliveries.length;
    } catch (e) {
      Get.log('Error fetching deliveries: $e');
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }
}
