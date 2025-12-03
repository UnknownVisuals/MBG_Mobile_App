import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_delivery_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_siswa_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_delivery_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';

class SekolahDashboardController extends GetxController {
  final Rx<DateTime> _currentTime = DateTime.now().obs;
  Timer? _ticker;
  final UserController _userController = Get.find<UserController>();
  final SekolahService _sekolahService = Get.find<SekolahService>();

  // Dependencies
  // NOTE: SekolahKelasController MUST be initialized before SekolahSiswaController
  // because SekolahSiswaController depends on SekolahKelasController.
  final SekolahKelasController _kelasController = Get.put(
    SekolahKelasController(),
  );
  final SekolahSiswaController _siswaController = Get.put(
    SekolahSiswaController(),
  );
  final SekolahDeliveryController _deliveryController = Get.put(
    SekolahDeliveryController(),
  );

  // Data
  final RxList<DapurMenuPlanningModel> menuList =
      <DapurMenuPlanningModel>[].obs;

  DateTime get currentTime => _currentTime.value;

  String? get sekolahId {
    final sekolahList = _userController.userModel.value?.sekolahAsPIC;
    return (sekolahList != null && sekolahList.isNotEmpty)
        ? sekolahList.first.id
        : null;
  }

  // Computed Properties
  int get totalSiswa => _siswaController.siswaList.length;
  int get totalKelas => _kelasController.kelasList.length;

  List<SekolahDeliveryModel> get pendingDeliveries {
    return _deliveryController.deliveries
        .where(
          (item) =>
              item.normalizedStatus == SekolahDeliveryStatus.pending ||
              item.normalizedStatus == SekolahDeliveryStatus.inTransit,
        )
        .toList();
  }

  DapurMenuPlanningModel? get todayMenu {
    final now = DateTime.now();
    try {
      return menuList.firstWhere((menu) {
        // Check if today is within the menu planning range
        if (menu.tanggalMulai == null || menu.tanggalSelesai == null) {
          return false;
        }

        final start = menu.tanggalMulai!;
        final end = menu.tanggalSelesai!;

        // Normalize dates to ignore time
        final today = DateTime(now.year, now.month, now.day);
        final startDate = DateTime(start.year, start.month, start.day);
        final endDate = DateTime(end.year, end.month, end.day);

        return (today.isAtSameMomentAs(startDate) ||
                today.isAfter(startDate)) &&
            (today.isAtSameMomentAs(endDate) || today.isBefore(endDate));
      });
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime.value = DateTime.now();
    });
    ever(_userController.userModel, (_) => refreshData());
  }

  Future<void> refreshData() async {
    final id = sekolahId;
    final futures = <Future>[
      _siswaController.refreshSiswa(),
      _kelasController.refreshKelas(),
      _deliveryController.refreshDeliveries(),
    ];

    if (id != null && id.isNotEmpty) {
      futures.add(_fetchMenu(id));
    }

    await Future.wait(futures);
  }

  Future<void> _fetchMenu(String id) async {
    try {
      final menus = await _sekolahService.getMenuBySekolah(id);
      menuList.assignAll(menus);
    } catch (e) {
      debugPrint('Gagal mengambil data menu: $e');
    }
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
