import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_delivery_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_siswa_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_delivery_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
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
  final Rx<DapurMenuHarianModel?> todayMenuHarian = Rx<DapurMenuHarianModel?>(
    null,
  );

  DateTime get currentTime => _currentTime.value;

  String? get sekolahId {
    final sekolahList = _userController.userModel.value?.sekolahAsPIC;
    return (sekolahList != null && sekolahList.isNotEmpty)
        ? sekolahList.first.id
        : null;
  }

  // Computed Properties
  int get totalSiswa => _siswaController.totalItems.value;
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

  DapurMenuPlanningModel? get todayPlanning {
    final now = DateTime.now();
    try {
      return menuList.firstWhere((menu) {
        // Check if today is within the menu planning range
        if (menu.tanggalMulai == null || menu.tanggalSelesai == null) {
          return false;
        }

        final start = menu.tanggalMulai!.toLocal();
        final end = menu.tanggalSelesai!.toLocal();

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

      // Fetch today's menu details
      final planning = todayPlanning;
      if (planning != null) {
        final dailyMenus = await _sekolahService.getMenuHarianByPlanning(
          planning.id,
        );

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        try {
          final todayMenu = dailyMenus.firstWhere((menu) {
            if (menu.tanggal == null) return false;
            final menuDateLocal = menu.tanggal!.toLocal();
            final menuDate = DateTime(
              menuDateLocal.year,
              menuDateLocal.month,
              menuDateLocal.day,
            );
            return menuDate.isAtSameMomentAs(today);
          });
          todayMenuHarian.value = todayMenu;
        } catch (_) {
          todayMenuHarian.value = null;
        }
      } else {
        todayMenuHarian.value = null;
      }
    } catch (e) {
      debugPrint('Gagal mengambil data menu: $e');
      todayMenuHarian.value = null;
    }
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
