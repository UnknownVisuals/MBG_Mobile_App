import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/checkpoint_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_harian_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_planning_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/pengiriman_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/stok_model.dart';
import 'package:mbg_mobile_app/utils/http/dapur_service.dart';
import 'package:intl/intl.dart';

class DapurDashboardController extends GetxController {
  final DapurService _dapurService = Get.find<DapurService>();

  // Observable variables
  final RxList<MenuPlanningModel> activeMenuPlans = <MenuPlanningModel>[].obs;
  final RxList<MenuHarianModel> todaysMenus = <MenuHarianModel>[].obs;
  final RxList<CheckpointModel> todaysCheckpoints = <CheckpointModel>[].obs;
  final RxList<PengirimanModel> pendingDeliveries = <PengirimanModel>[].obs;
  final RxList<StokModel> lowStockItems = <StokModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt activeMenuPlansCount = 0.obs;
  final RxInt completedCheckpointsToday = 0.obs;
  final RxInt pendingDeliveriesCount = 0.obs;
  final RxInt lowStockCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Fetch all dashboard data
  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchActiveMenuPlans(),
        fetchTodaysMenus(),
        fetchPendingDeliveries(),
        fetchLowStockItems(),
      ]);
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch active menu plans (current week)
  Future<void> fetchActiveMenuPlans() async {
    try {
      final plannings = await _dapurService.getAllMenuPlanning();

      // Filter for current week
      final now = DateTime.now();
      activeMenuPlans.value = plannings.where((plan) {
        return plan.tanggalMulai.isBefore(now.add(Duration(days: 7))) &&
            plan.tanggalSelesai.isAfter(now.subtract(Duration(days: 7)));
      }).toList();

      activeMenuPlansCount.value = activeMenuPlans.length;
    } catch (e) {
      print('Error fetching active menu plans: $e');
    }
  }

  /// Fetch today's menus and their checkpoints
  Future<void> fetchTodaysMenus() async {
    try {
      todaysMenus.clear();
      todaysCheckpoints.clear();

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      for (var planning in activeMenuPlans) {
        final menus = await _dapurService.getMenuHarianByPlanning(planning.id);

        // Filter for today
        final todayMenus = menus.where((menu) {
          final menuDate = DateFormat('yyyy-MM-dd').format(menu.tanggal);
          return menuDate == today;
        }).toList();

        todaysMenus.addAll(todayMenus);

        // Fetch checkpoints for today's menus
        for (var menu in todayMenus) {
          await fetchCheckpointsForMenu(menu.id);
        }
      }

      completedCheckpointsToday.value = todaysCheckpoints.length;
    } catch (e) {
      print('Error fetching today\'s menus: $e');
    }
  }

  /// Fetch checkpoints for a menu
  Future<void> fetchCheckpointsForMenu(String menuHarianId) async {
    try {
      final checkpoints = await _dapurService.getCheckpointsByMenuHarian(
        menuHarianId,
      );
      todaysCheckpoints.addAll(checkpoints);
    } catch (e) {
      print('Error fetching checkpoints: $e');
    }
  }

  /// Fetch pending deliveries
  Future<void> fetchPendingDeliveries() async {
    try {
      final deliveries = await _dapurService.getAllPengiriman();

      // Filter for pending and in-transit
      pendingDeliveries.value = deliveries.where((delivery) {
        return delivery.status == 'PENDING' || delivery.status == 'IN_TRANSIT';
      }).toList();

      pendingDeliveriesCount.value = pendingDeliveries.length;
    } catch (e) {
      print('Error fetching pending deliveries: $e');
    }
  }

  /// Fetch low stock items (stock < 10kg)
  Future<void> fetchLowStockItems() async {
    try {
      final stokItems = await _dapurService.getAllStok();

      // Filter for low stock
      lowStockItems.value = stokItems
          .where((item) => item.stokKg < 10)
          .toList();
      lowStockCount.value = lowStockItems.length;
    } catch (e) {
      print('Error fetching low stock items: $e');
    }
  }

  /// Get cooking progress percentage for today
  double getCookingProgress() {
    if (todaysMenus.isEmpty) return 0.0;

    // Expected checkpoints per menu: at least MULAI_MEMASAK and SELESAI_MEMASAK
    final expectedCheckpoints = todaysMenus.length * 2;
    if (expectedCheckpoints == 0) return 0.0;

    final progress = (todaysCheckpoints.length / expectedCheckpoints) * 100;
    return progress > 100 ? 100 : progress;
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }
}
