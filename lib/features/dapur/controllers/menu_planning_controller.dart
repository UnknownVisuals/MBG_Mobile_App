import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_harian_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_planning_model.dart';
import 'package:mbg_mobile_app/utils/http/dapur_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:intl/intl.dart';

class MenuPlanningController extends GetxController {
  final DapurService _dapurService = Get.find<DapurService>();

  // Observable variables
  final RxList<MenuPlanningModel> menuPlannings = <MenuPlanningModel>[].obs;
  final Rx<MenuPlanningModel?> selectedPlanning = Rx<MenuPlanningModel?>(null);
  final RxList<MenuHarianModel> menuHarians = <MenuHarianModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMenuHarian = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenuPlannings();
  }

  /// Fetch all menu plannings
  Future<void> fetchMenuPlannings() async {
    try {
      isLoading.value = true;
      final plannings = await _dapurService.getAllMenuPlanning();
      menuPlannings.value = plannings;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch menu plannings: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch menu harian for selected planning
  Future<void> fetchMenuHarian(String planningId) async {
    try {
      isLoadingMenuHarian.value = true;
      final menus = await _dapurService.getMenuHarianByPlanning(planningId);
      menuHarians.value = menus;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch menu harian: ${e.toString()}',
      );
    } finally {
      isLoadingMenuHarian.value = false;
    }
  }

  /// Create new menu planning
  Future<bool> createMenuPlanning({
    required int mingguanKe,
    required DateTime tanggalMulai,
    required DateTime tanggalSelesai,
    required String sekolahId,
  }) async {
    try {
      isLoading.value = true;

      final dateFormat = DateFormat('yyyy-MM-dd');

      await _dapurService.createMenuPlanning({
        'mingguanKe': mingguanKe,
        'tanggalMulai': dateFormat.format(tanggalMulai),
        'tanggalSelesai': dateFormat.format(tanggalSelesai),
        'sekolahId': sekolahId,
      });

      MBGLoaders.successSnackBar(
        title: 'Success',
        message: 'Menu planning created successfully',
      );

      await fetchMenuPlannings();
      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to create menu planning: ${e.toString()}',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Create menu harian
  Future<bool> createMenuHarian({
    required String planningId,
    required DateTime tanggal,
    required String namaMenu,
    required double biayaPerTray,
    required String jamMulaiMasak,
    required String jamSelesaiMasak,
    required double kalori,
    required double protein,
    required double karbohidrat,
    required double lemak,
  }) async {
    try {
      isLoadingMenuHarian.value = true;

      final dateFormat = DateFormat('yyyy-MM-dd');

      await _dapurService.createMenuHarian(planningId, {
        'tanggal': dateFormat.format(tanggal),
        'namaMenu': namaMenu,
        'biayaPerTray': biayaPerTray,
        'jamMulaiMasak': jamMulaiMasak,
        'jamSelesaiMasak': jamSelesaiMasak,
        'kalori': kalori,
        'protein': protein,
        'karbohidrat': karbohidrat,
        'lemak': lemak,
      });

      MBGLoaders.successSnackBar(
        title: 'Success',
        message: 'Menu harian created successfully',
      );

      await fetchMenuHarian(planningId);
      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to create menu harian: ${e.toString()}',
      );
      return false;
    } finally {
      isLoadingMenuHarian.value = false;
    }
  }

  /// Select a planning to view its menu harian
  void selectPlanning(MenuPlanningModel planning) {
    selectedPlanning.value = planning;
    fetchMenuHarian(planning.id);
  }

  /// Clear selected planning
  void clearSelection() {
    selectedPlanning.value = null;
    menuHarians.clear();
  }
}
