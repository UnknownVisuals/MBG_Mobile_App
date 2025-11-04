import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class SekolahMenuViewController extends GetxController {
  SekolahMenuViewController()
    : _sekolahService = Get.find<SekolahService>(),
      _userController = Get.find<UserController>();

  final SekolahService _sekolahService;
  final UserController _userController;

  final RxList<DapurMenuPlanningModel> menus = <DapurMenuPlanningModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadMenus() async {
    final sekolahId = _sekolahId;
    if (sekolahId == null) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Anda tidak memiliki akses ke sekolah',
      );
      menus.clear();
      return;
    }

    try {
      isLoading.value = true;
      final result = await _sekolahService.getMenuBySekolah(sekolahId);
      menus.assignAll(result);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat menu: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMenus() async {
    await loadMenus();
  }

  String? get _sekolahId {
    final sekolahAsPic = _userController.userModel.value?.sekolahAsPIC;
    if (sekolahAsPic == null || sekolahAsPic.isEmpty) return null;
    return sekolahAsPic.first.id;
  }

  @override
  void onInit() {
    super.onInit();
    loadMenus();
  }
}
