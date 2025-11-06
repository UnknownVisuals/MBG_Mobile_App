import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_harian_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';

class DapurMenuHarianController extends GetxController {
  // Dependencies
  final DapurService _dapurService = Get.find<DapurService>();
  final DapurMenuPlanningController _dapurMenuPlanningController =
      Get.find<DapurMenuPlanningController>();

  // Data Variables
  RxList<DapurMenuHarianModel> menuHarianList = <DapurMenuHarianModel>[].obs;

  // State Variables
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to selected menu planning changes
    ever(_dapurMenuPlanningController.selectedMenuPlanningId, (planningId) {
      if (planningId != null) {
        fetchMenuHarian(planningId: planningId);
      } else {
        menuHarianList.clear();
      }
    });

    // Fetch immediately if already selected
    final planningId =
        _dapurMenuPlanningController.selectedMenuPlanningId.value;
    if (planningId != null) {
      fetchMenuHarian(planningId: planningId);
    }
  }

  // ========================
  // REFRESH MENU HARIAN DATA
  // ========================
  Future<void> refreshMenuHarian() async {
    final planningId =
        _dapurMenuPlanningController.selectedMenuPlanningId.value;
    if (planningId != null) {
      await fetchMenuHarian(planningId: planningId);
    }
  }

  // ==================
  // CREATE MENU HARIAN
  // ==================
  Future<void> createMenuHarian({
    required String planningId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      isLoading.value = true;

      await _dapurService.createMenuHarian(planningId, payload);

      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Menu harian berhasil ditambahkan',
      );

      await fetchMenuHarian(planningId: planningId);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal menambahkan menu harian',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================
  // GET MENU HARIAN BY PLANNING
  // ===========================
  Future<void> fetchMenuHarian({required String planningId}) async {
    try {
      isLoading.value = true;
      final data = await _dapurService.getMenuHarianByPlanning(planningId);
      menuHarianList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data menu harian',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
