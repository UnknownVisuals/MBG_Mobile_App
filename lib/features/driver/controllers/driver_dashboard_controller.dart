import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/pengiriman_model.dart';
import 'package:mbg_mobile_app/utils/http/dapur_service.dart';

class DriverDashboardController extends GetxController {
  final DapurService _dapurService = Get.find<DapurService>();

  // Observable variables
  final RxList<PengirimanModel> pendingDeliveries = <PengirimanModel>[].obs;
  final RxList<PengirimanModel> completedDeliveries = <PengirimanModel>[].obs;
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
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all deliveries for driver
  Future<void> fetchDeliveries() async {
    try {
      // TODO: Use getDriverPengiriman() when available in service
      // For now, using getAllPengiriman() - should be filtered by driver on backend
      final deliveries = await _dapurService.getAllPengiriman();

      // Separate pending and completed deliveries
      pendingDeliveries.value = deliveries
          .where((d) => d.status == 'PENDING' || d.status == 'IN_TRANSIT')
          .toList();

      completedDeliveries.value = deliveries
          .where((d) => d.status == 'DELIVERED')
          .toList();

      // Filter completed today
      final today = DateTime.now();
      final completedToday = completedDeliveries.where((d) {
        return d.createdAt.year == today.year &&
            d.createdAt.month == today.month &&
            d.createdAt.day == today.day;
      }).toList();

      pendingCount.value = pendingDeliveries.length;
      completedTodayCount.value = completedToday.length;
      totalDeliveriesCount.value = deliveries.length;
    } catch (e) {
      print('Error fetching deliveries: $e');
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }
}
