import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/checkpoint_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_harian_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_planning_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/pengiriman_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/stok_model.dart';
import 'package:mbg_mobile_app/utils/http/dapur_service.dart';

class DapurDashboardController extends GetxController {
  DapurDashboardController()
    : _dapurService = Get.find<DapurService>(),
      _dapurController = Get.find<DapurController>();

  final DapurService _dapurService;
  final DapurController _dapurController;

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
    ever(_dapurController.selectedDapur, (_) => fetchDashboardData());

    if (_dapurController.assignedDapur.isEmpty) {
      _dapurController.loadAssignedDapur();
    } else {
      fetchDashboardData();
    }
  }

  Future<void> fetchDashboardData() async {
    final dapurId = _dapurController.selectedDapur.value?.id;

    if (dapurId == null) {
      _resetDashboardState();
      return;
    }

    isLoading.value = true;
    try {
      await fetchActiveMenuPlans(dapurId);
      await fetchTodaysMenus(dapurId);
      await Future.wait([
        fetchPendingDeliveries(dapurId),
        fetchLowStockItems(dapurId),
      ]);
    } catch (e) {
      Get.log('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchActiveMenuPlans(String dapurId) async {
    try {
      final plannings = await _dapurService.getAllMenuPlanning();
      final now = DateTime.now();
      activeMenuPlans.value = plannings.where((plan) {
        if (plan.dapurId != dapurId) return false;
        final start = plan.tanggalMulai.toLocal();
        final end = plan.tanggalSelesai.toLocal();
        return start.isBefore(now.add(const Duration(days: 7))) &&
            end.isAfter(now.subtract(const Duration(days: 7)));
      }).toList();
      activeMenuPlansCount.value = activeMenuPlans.length;
    } catch (e) {
      Get.log('Error fetching active menu plans: $e');
      activeMenuPlans.clear();
      activeMenuPlansCount.value = 0;
    }
  }

  Future<void> fetchTodaysMenus(String dapurId) async {
    try {
      todaysMenus.clear();
      todaysCheckpoints.clear();

      final formatter = DateFormat('yyyy-MM-dd');
      final todayDate = DateTime.now();
      final today = formatter.format(todayDate);

      for (final planning in activeMenuPlans) {
        if (planning.dapurId != dapurId) continue;
        final menus = await _dapurService.getMenuHarianByPlanning(planning.id);

        final todayMenus = menus.where((menu) {
          final menuDate = formatter.format(menu.tanggal.toLocal());
          return menuDate == today;
        }).toList();

        todaysMenus.addAll(todayMenus);

        for (final menu in todayMenus) {
          await fetchCheckpointsForMenu(menu.id, todayDate);
        }
      }

      completedCheckpointsToday.value = todaysCheckpoints.length;
    } catch (e) {
      Get.log('Error fetching today\'s menus: $e');
      todaysMenus.clear();
      todaysCheckpoints.clear();
      completedCheckpointsToday.value = 0;
    }
  }

  Future<void> fetchCheckpointsForMenu(
    String menuHarianId,
    DateTime targetDate,
  ) async {
    try {
      final checkpoints = await _dapurService.getCheckpointsByMenuHarian(
        menuHarianId,
      );
      for (final checkpoint in checkpoints) {
        if (_isSameDay(checkpoint.waktu.toLocal(), targetDate)) {
          todaysCheckpoints.add(checkpoint);
        }
      }
    } catch (e) {
      Get.log('Error fetching checkpoints: $e');
    }
  }

  Future<void> fetchPendingDeliveries(String dapurId) async {
    try {
      final deliveries = await _dapurService.getAllPengiriman();

      const pendingStatuses = {
        'PENDING',
        'IN_TRANSIT',
        'MENUNGGU_PENGIRIMAN',
        'SEDANG_DIJEMPUT',
      };

      pendingDeliveries.value = deliveries.where((delivery) {
        final statusMatch = pendingStatuses.contains(delivery.status);
        return statusMatch && delivery.dapurId == dapurId;
      }).toList();

      pendingDeliveriesCount.value = pendingDeliveries.length;
    } catch (e) {
      Get.log('Error fetching pending deliveries: $e');
      pendingDeliveries.clear();
      pendingDeliveriesCount.value = 0;
    }
  }

  Future<void> fetchLowStockItems(String dapurId) async {
    try {
      final stokItems = await _dapurService.getAllStok();

      lowStockItems.value = stokItems
          .where((item) => item.stokKg < 10 && item.dapurId == dapurId)
          .toList();
      lowStockCount.value = lowStockItems.length;
    } catch (e) {
      Get.log('Error fetching low stock items: $e');
      lowStockItems.clear();
      lowStockCount.value = 0;
    }
  }

  double getCookingProgress() {
    if (todaysMenus.isEmpty) return 0.0;

    final expectedCheckpoints = todaysMenus.length * 2;
    if (expectedCheckpoints == 0) return 0.0;

    final progress = (todaysCheckpoints.length / expectedCheckpoints) * 100;
    return progress.clamp(0, 100).toDouble();
  }

  Future<void> refreshDashboard() async {
    await _dapurController.loadAssignedDapur(forceRefresh: true);
  }

  void _resetDashboardState() {
    activeMenuPlans.clear();
    todaysMenus.clear();
    todaysCheckpoints.clear();
    pendingDeliveries.clear();
    lowStockItems.clear();
    activeMenuPlansCount.value = 0;
    completedCheckpointsToday.value = 0;
    pendingDeliveriesCount.value = 0;
    lowStockCount.value = 0;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
