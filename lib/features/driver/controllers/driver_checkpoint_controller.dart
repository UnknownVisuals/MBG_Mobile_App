import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_menu_harian_model.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_menu_planning_model.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_sekolah_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';

class DriverCheckpointController extends GetxController {
  // Dependencies
  final DriverService _driverService = Get.find<DriverService>();

  // Data Variables
  RxList<DriverSekolahModel> sekolahList = <DriverSekolahModel>[].obs;
  RxList<DriverMenuPlanningModel> menuPlanningList =
      <DriverMenuPlanningModel>[].obs;
  RxList<DriverMenuHarianModel> menuHarianList = <DriverMenuHarianModel>[].obs;

  // Selected Variables
  Rx<String?> selectedSekolahId = Rx<String?>(null);
  Rx<String?> selectedMenuPlanningId = Rx<String?>(null);
  Rx<String?> selectedMenuHarianId = Rx<String?>(null);

  // State Variables
  RxBool isSekolahLoading = false.obs;
  RxBool isMenuPlanningLoading = false.obs;
  RxBool isMenuHarianLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchAllSekolah();
  }

  // ===============
  // GET ALL SEKOLAH
  // ===============
  Future<void> fetchAllSekolah() async {
    try {
      isSekolahLoading.value = true;
      final data = await _driverService.getAllSekolah();
      sekolahList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data sekolah',
        message: e.toString(),
      );
    } finally {
      isSekolahLoading.value = false;
    }
  }

  Future<void> selectSekolah(String? sekolahId) async {
    selectedSekolahId.value = sekolahId;
    selectedMenuPlanningId.value = null;
    selectedMenuHarianId.value = null;

    menuPlanningList.clear();
    menuHarianList.clear();

    if (sekolahId != null) {
      await fetchMenuPlanningBySekolah(sekolahId);
    }
  }

  // ===================================
  // GET ALL MENU PLANNING BY SEKOLAH ID
  // ===================================
  Future<void> fetchAllMenuPlanning() async {
    try {
      isMenuPlanningLoading.value = true;
      final data = await _driverService.getAllMenuPlanning();
      menuPlanningList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data menu planning',
        message: e.toString(),
      );
    } finally {
      isMenuPlanningLoading.value = false;
    }
  }

  Future<void> fetchMenuPlanningBySekolah(String sekolahId) async {
    try {
      isMenuPlanningLoading.value = true;
      final data = await _driverService.getMenuPlanningBySekolah(sekolahId);
      menuPlanningList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data menu planning',
        message: e.toString(),
      );
    } finally {
      isMenuPlanningLoading.value = false;
    }
  }

  Future<void> selectMenuPlanning(String? planningId) async {
    selectedMenuPlanningId.value = planningId;
    selectedMenuHarianId.value = null;
    menuHarianList.clear();

    if (planningId != null) {
      await fetchMenuHarian(planningId: planningId);
    }
  }

  // ===================================
  // GET MENU HARIAN BY MENU PLANNING ID
  // ===================================

  Future<void> fetchMenuHarian({required String planningId}) async {
    try {
      isMenuHarianLoading.value = true;
      final data = await _driverService.getMenuHarianByPlanning(planningId);
      menuHarianList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data menu harian',
        message: e.toString(),
      );
    } finally {
      isMenuHarianLoading.value = false;
    }
  }

  void selectMenuHarian(String? menuHarianId) {
    selectedMenuHarianId.value = menuHarianId;
  }

  /// Returns the list of user roles allowed to perform a checkpoint type.
  List<String> getCheckpointRoles(String checkpointType) {
    switch (checkpointType) {
      case 'MULAI_MEMASAK':
      case 'SELESAI_MEMASAK':
      case 'SELESAI_PACKING':
        return ['PIC_DAPUR'];
      case 'SCHOOL_TO_DRIVER_RETURN':
      case 'DRIVER_TO_KITCHEN':
        return ['DRIVER'];
      case 'KITCHEN_RECEIVED':
      case 'WASHING_COMPLETE':
        return ['PIC_DAPUR'];
      default:
        return const <String>[];
    }
  }

  /// Checks whether the given user role can perform the checkpoint type.
  bool canUserPerformCheckpoint(String userRole, String checkpointType) {
    return getCheckpointRoles(checkpointType).contains(userRole);
  }
}
