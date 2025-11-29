import 'dart:async';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_checkpoint_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_harian_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_pengiriman_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_pengiriman_model.dart';

class DapurDashboardController extends GetxController {
  final Rx<DateTime> _currentTime = DateTime.now().obs;
  Timer? _ticker;
  final UserController _userController = Get.find<UserController>();

  // Dependencies
  // Ensure DapurMenuPlanningController is initialized first as MenuHarian depends on it
  final DapurMenuPlanningController _menuPlanningController = Get.put(
    DapurMenuPlanningController(),
  );
  final DapurMenuHarianController _menuHarianController = Get.put(
    DapurMenuHarianController(),
  );
  final DapurCheckpointController _checkpointController = Get.put(
    DapurCheckpointController(),
  );
  final DapurPengirimanController _pengirimanController = Get.put(
    DapurPengirimanController(),
  );

  final Rx<UserDapurAsPIC?> selectedDapur = Rx<UserDapurAsPIC?>(null);

  DateTime get currentTime => _currentTime.value;
  List<UserDapurAsPIC> get dapurOptions =>
      _userController.userModel.value?.dapurAsPIC ?? [];

  // Computed Properties

  // 1. Today's Menus
  List<DapurMenuHarianModel> get todayMenus {
    final today = DateTime.now();
    return _menuHarianController.menuHarianList.where((menu) {
      if (menu.tanggal == null) return false;
      return menu.tanggal!.year == today.year &&
          menu.tanggal!.month == today.month &&
          menu.tanggal!.day == today.day;
    }).toList();
  }

  // 2. Pending Deliveries
  List<DapurPengirimanModel> get pendingDeliveries {
    return _pengirimanController.pengirimanList.where((p) {
      final status = p.status?.toUpperCase() ?? '';
      return status == 'PENDING' || status == 'PROSES' || status == 'DIKIRIM';
    }).toList();
  }

  // 3. Cooking Progress
  double get cookingProgress {
    if (todayMenus.isEmpty) return 0.0;

    // Use checkpoints from the current menu if it matches one of today's menus
    if (_checkpointController.currentMenuHarianId.value != null &&
        todayMenus.any(
          (m) => m.id == _checkpointController.currentMenuHarianId.value,
        )) {
      if (_checkpointController.totalCount == 0) return 0.0;
      return (_checkpointController.completedCount /
              _checkpointController.totalCount) *
          100;
    }

    return 0.0;
  }

  int get completedCheckpointsCount {
    if (_checkpointController.currentMenuHarianId.value != null &&
        todayMenus.any(
          (m) => m.id == _checkpointController.currentMenuHarianId.value,
        )) {
      return _checkpointController.completedCount;
    }
    return 0;
  }

  @override
  void onInit() {
    super.onInit();
    ever(_userController.userModel, (_) => _ensureSelectedDapur());
    _ensureSelectedDapur();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime.value = DateTime.now();
    });

    // Auto-select first menu of today for checkpoint tracking if available
    ever(_menuHarianController.menuHarianList, (_) {
      if (todayMenus.isNotEmpty &&
          _checkpointController.currentMenuHarianId.value == null) {
        _checkpointController.initializeWithMenuId(todayMenus.first.id);
      }
    });

    // Listen to selectedDapur changes to refresh data in other controllers
    ever(selectedDapur, (dapur) {
      if (dapur != null) {
        // Here we could trigger refreshes if needed, but most controllers
        // already listen to userModel or have their own init logic.
        // However, PengirimanController might need a refresh if it depends on Sekolah ID
        // which might be related to Dapur.
        // For now, we assume the other controllers are self-sufficient or linked via userModel.
      }
    });
  }

  void _ensureSelectedDapur() {
    final available = dapurOptions;
    if (available.isEmpty) {
      selectedDapur.value = null;
      return;
    }

    final current = selectedDapur.value;
    if (current == null ||
        !available.any((option) => option.id == current.id)) {
      selectedDapur.value = available.first;
    }
  }

  void selectDapurById(String? id) {
    if (id == null) return;
    final available = dapurOptions;
    if (available.isEmpty) {
      selectedDapur.value = null;
      return;
    }

    final match = available.firstWhere(
      (item) => item.id == id,
      orElse: () => available.first,
    );
    selectedDapur.value = match;
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
