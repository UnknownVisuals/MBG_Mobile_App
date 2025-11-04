// import 'dart:async';

// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
// import 'package:mbg_mobile_app/features/dapur/models/dapur_checkpoint_model.dart';
// import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
// import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
// import 'package:mbg_mobile_app/features/dapur/models/dapur_pengiriman_model.dart';
// import 'package:mbg_mobile_app/features/dapur/models/dapur_stock_model.dart';
// import 'package:mbg_mobile_app/utils/services/dapur_service.dart';

// class DapurDashboardController extends GetxController {
//   DapurService dapurService = Get.put(DapurService());
//   DapurController dapurController = Get.put(DapurController());
//   Timer? _clockTimer;

//   final RxList<DapurMenuPlanningModel> activeMenuPlans =
//       <DapurMenuPlanningModel>[].obs;
//   final RxList<DapurMenuHarianModel> todaysMenus = <DapurMenuHarianModel>[].obs;
//   final RxList<DapurCheckpointModel> todaysCheckpoints =
//       <DapurCheckpointModel>[].obs;
//   final RxList<PengirimanModel> pendingDeliveries = <PengirimanModel>[].obs;
//   final RxList<DapurStokModel> lowStockItems = <DapurStokModel>[].obs;

//   final RxBool isLoading = false.obs;
//   final RxInt activeMenuPlansCount = 0.obs;
//   final RxInt completedCheckpointsToday = 0.obs;
//   final RxInt pendingDeliveriesCount = 0.obs;
//   final RxInt lowStockCount = 0.obs;
//   final Rx<DateTime> currentTime = DateTime.now().obs;

//   @override
//   void onInit() {
//     super.onInit();
//     ever(dapurController.selectedDapur, (_) => fetchDashboardData());

//     _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       currentTime.value = DateTime.now();
//     });

//     if (dapurController.assignedDapur.isEmpty) {
//       dapurController.loadAssignedDapur();
//     } else {
//       fetchDashboardData();
//     }
//   }

//   @override
//   void onClose() {
//     _clockTimer?.cancel();
//     super.onClose();
//   }

//   Future<void> fetchDashboardData() async {
//     final dapurId = dapurController.selectedDapur.value?.id;

//     if (dapurId == null) {
//       _resetDashboardState();
//       return;
//     }

//     isLoading.value = true;
//     try {
//       await fetchActiveMenuPlans(dapurId);
//       await fetchTodaysMenus(dapurId);
//       await Future.wait([
//         fetchPendingDeliveries(dapurId),
//         fetchLowStockItems(dapurId),
//       ]);
//     } catch (e) {
//       Get.log('Error fetching dashboard data: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchActiveMenuPlans(String dapurId) async {
//     try {
//       final plannings = await dapurService.getAllMenuPlanning();
//       final now = DateTime.now();
//       activeMenuPlans.value = plannings.where((plan) {
//         if (plan.dapurId != dapurId) return false;
//         final start = plan.tanggalMulai.toLocal();
//         final end = plan.tanggalSelesai.toLocal();
//         return start.isBefore(now.add(const Duration(days: 7))) &&
//             end.isAfter(now.subtract(const Duration(days: 7)));
//       }).toList();
//       activeMenuPlansCount.value = activeMenuPlans.length;
//     } catch (e) {
//       Get.log('Error fetching active menu plans: $e');
//       activeMenuPlans.clear();
//       activeMenuPlansCount.value = 0;
//     }
//   }

//   // Future<void> fetchTodaysMenus(String dapurId) async {
//   //   try {
//   //     todaysMenus.clear();
//   //     todaysCheckpoints.clear();

//   //     final formatter = DateFormat('yyyy-MM-dd');
//   //     final todayDate = DateTime.now();
//   //     final today = formatter.format(todayDate);

//   //     for (final planning in activeMenuPlans) {
//   //       if (planning.dapurId != dapurId) continue;
//   //       final menus = await dapurService.getMenuHarianByPlanning(planning.id);

//   //       final todayMenus = menus.where((menu) {
//   //         final DateTime? parsed = DateTime.tryParse(
//   //           menu.tanggal.toIso8601String(),
//   //         );
//   //         if (parsed == null) {
//   //           return false;
//   //         }
//   //         final menuDate = formatter.format(parsed.toLocal());
//   //         return menuDate == today;
//   //       }).toList();

//   //       todaysMenus.addAll(todayMenus);

//   //       for (final menu in todayMenus) {
//   //         await fetchCheckpointsForMenu(menu.id, todayDate);
//   //       }
//   //     }

//   //     completedCheckpointsToday.value = todaysCheckpoints.length;
//   //   } catch (e) {
//   //     Get.log('Error fetching today\'s menus: $e');
//   //     todaysMenus.clear();
//   //     todaysCheckpoints.clear();
//   //     completedCheckpointsToday.value = 0;
//   //   }
//   // }

//   // Future<void> fetchCheckpointsForMenu(
//   //   String menuHarianId,
//   //   DateTime targetDate,
//   // ) async {
//   //   try {
//   //     final checkpoints = await dapurService.getCheckpointsByMenuHarian(
//   //       menuHarianId,
//   //     );
//   //     for (final checkpoint in checkpoints) {
//   //       if (_isSameDay(checkpoint.waktu, targetDate)) {
//   //         todaysCheckpoints.add(checkpoint);
//   //       }
//   //     }
//   //   } catch (e) {
//   //     Get.log('Error fetching checkpoints: $e');
//   //   }
//   // }

//   Future<void> fetchPendingDeliveries(String dapurId) async {
//     try {
//       final deliveries = await dapurService.getAllPengiriman();

//       const pendingStatuses = {
//         'PENDING',
//         'IN_TRANSIT',
//         'MENUNGGU_PENGIRIMAN',
//         'SEDANG_DIJEMPUT',
//       };

//       pendingDeliveries.value = deliveries.where((delivery) {
//         final statusMatch = pendingStatuses.contains(delivery.status);
//         return statusMatch && delivery.dapurId == dapurId;
//       }).toList();

//       pendingDeliveriesCount.value = pendingDeliveries.length;
//     } catch (e) {
//       Get.log('Error fetching pending deliveries: $e');
//       pendingDeliveries.clear();
//       pendingDeliveriesCount.value = 0;
//     }
//   }

//   Future<void> fetchLowStockItems(String dapurId) async {
//     try {
//       final stokItems = await dapurService.getAllStok(dapurId: dapurId);

//       lowStockItems.value = stokItems
//           .where((item) => item.stokKg < 10 && item.dapurId == dapurId)
//           .toList();
//       lowStockCount.value = lowStockItems.length;
//     } catch (e) {
//       Get.log('Error fetching low stock items: $e');
//       lowStockItems.clear();
//       lowStockCount.value = 0;
//     }
//   }

//   double getCookingProgress() {
//     if (todaysMenus.isEmpty) return 0.0;

//     final expectedCheckpoints = todaysMenus.length * 2;
//     if (expectedCheckpoints == 0) return 0.0;

//     final progress = (todaysCheckpoints.length / expectedCheckpoints) * 100;
//     return progress.clamp(0, 100).toDouble();
//   }

//   Future<void> refreshDashboard() async {
//     await dapurController.loadAssignedDapur(forceRefresh: true);
//   }

//   void _resetDashboardState() {
//     activeMenuPlans.clear();
//     todaysMenus.clear();
//     todaysCheckpoints.clear();
//     pendingDeliveries.clear();
//     lowStockItems.clear();
//     activeMenuPlansCount.value = 0;
//     completedCheckpointsToday.value = 0;
//     pendingDeliveriesCount.value = 0;
//     lowStockCount.value = 0;
//   }

//   bool _isSameDay(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }
// }
