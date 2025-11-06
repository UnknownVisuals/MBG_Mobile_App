import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_sekolah_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';

class DapurMenuPlanningController extends GetxController {
  // Dependencies
  final DapurService _dapurService = Get.find<DapurService>();

  // Data Variables
  RxList<DapurSekolahModel> sekolahList = <DapurSekolahModel>[].obs;
  RxList<DapurMenuPlanningModel> menuPlanningList =
      <DapurMenuPlanningModel>[].obs;
  Rx<String?> selectedMenuPlanningId = Rx<String?>(null);

  // State Variables
  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await Future.wait([fetchAllSekolah(), fetchAllMenuPlanning()]);
  }

  // ==========================
  // REFRESH MENU PLANNING DATA
  // ==========================

  Future<void> refreshMenuPlanning() async {
    await fetchAllMenuPlanning();
  }

  // ====================
  // SELECT MENU PLANNING
  // ====================
  void selectMenuPlanning(String planningId) {
    selectedMenuPlanningId.value = planningId;
  }

  // ===============
  // GET ALL SEKOLAH
  // ===============

  Future<void> fetchAllSekolah() async {
    try {
      isLoading.value = true;
      final data = await _dapurService.getAllSekolah();
      sekolahList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data sekolah',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ====================
  // CREATE MENU PLANNING
  // ====================
  Future<void> createMenuPlanning({
    required int mingguanKe,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String sekolahId,
  }) async {
    try {
      isLoading.value = true;

      await _dapurService.createMenuPlanning({
        'mingguanKe': mingguanKe,
        'tanggalMulai': tanggalMulai.toIso8601String().split('T')[0],
        'tanggalSelesai': tanggalSelesai.toIso8601String().split('T')[0],
        'sekolahId': sekolahId,
      });

      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Menu planning berhasil dibuat',
      );

      await fetchAllMenuPlanning();
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal membuat menu planning',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =====================
  // GET ALL MENU PLANNING
  // =====================
  Future<void> fetchAllMenuPlanning() async {
    try {
      isLoading.value = true;
      final data = await _dapurService.getAllMenuPlanning();
      menuPlanningList.assignAll(data);

      if (data.isNotEmpty && selectedMenuPlanningId.value == null) {
        selectedMenuPlanningId.value = data.first.id;
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data menu planning',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================
  // GET MENU PLANNING BY SEKOLAH
  // ============================
  Future<void> fetchMenuPlanningSekolah({required String sekolahId}) async {
    try {
      isLoading.value = true;
      final data = await _dapurService.getMenuPlanningBySekolahId(sekolahId);
      menuPlanningList.assignAll(data);

      if (data.isNotEmpty && selectedMenuPlanningId.value == null) {
        selectedMenuPlanningId.value = data.first.id;
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data menu planning',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ====================
  // DELETE MENU PLANNING
  // ====================
  Future<void> deleteMenuPlanning({required String planningId}) async {
    try {
      isLoading.value = true;

      await _dapurService.deleteMenuPlanning(planningId);

      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Menu planning berhasil dihapus',
      );

      await fetchAllMenuPlanning();
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal menghapus menu planning',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
