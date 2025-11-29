import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_info_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';

class SekolahInfoController extends GetxController {
  final SekolahService _sekolahService = Get.find<SekolahService>();
  final UserController _userController = Get.find<UserController>();

  final Rx<SekolahInfoModel?> sekolahInfo = Rx<SekolahInfoModel?>(null);
  final RxBool isLoading = false.obs;

  String? get sekolahId {
    final sekolahList = _userController.userModel.value?.sekolahAsPIC;
    return (sekolahList != null && sekolahList.isNotEmpty)
        ? sekolahList.first.id
        : null;
  }

  @override
  void onInit() {
    super.onInit();
    ever(_userController.userModel, (_) => refreshSekolahInfo());
    refreshSekolahInfo();
  }

  Future<void> refreshSekolahInfo() async {
    final id = sekolahId;
    if (id != null) {
      await fetchSekolahInfo(id);
    }
  }

  Future<void> fetchSekolahInfo(String sekolahId) async {
    try {
      isLoading.value = true;
      final info = await _sekolahService.getSekolahInfo(sekolahId);
      sekolahInfo.value = info;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat informasi sekolah',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
