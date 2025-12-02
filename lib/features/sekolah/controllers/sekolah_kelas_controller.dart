import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';

class SekolahKelasController extends GetxController {
  SekolahKelasController({
    SekolahService? sekolahService,
    UserController? userController,
  }) : _sekolahService = sekolahService ?? Get.find<SekolahService>(),
       _userController = userController ?? Get.find<UserController>();

  final SekolahService _sekolahService;
  final UserController _userController;

  RxList<SekolahKelasModel> kelasList = <SekolahKelasModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString deletingKelasId = RxnString();

  String? get sekolahId {
    final sekolahList = _userController.userModel.value?.sekolahAsPIC;
    return (sekolahList != null && sekolahList.isNotEmpty)
        ? sekolahList.first.id
        : null;
  }

  @override
  void onInit() {
    super.onInit();
    ever(_userController.userModel, (_) => _loadKelas());
    _loadKelas();
  }

  Future<void> _loadKelas() async {
    final id = sekolahId;
    if (id == null || id.isEmpty) return;
    await fetchKelas(id);
  }

  Future<void> refreshKelas() async {
    await _loadKelas();
  }

  Future<void> fetchKelas(String sekolahId) async {
    try {
      isLoading.value = true;
      final kelas = await _sekolahService.getKelasBySekolah(sekolahId);
      kelasList.assignAll(kelas);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat kelas',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addKelas({required String nama, required int tingkat}) async {
    final id = sekolahId;

    if (id == null) {
      MBGLoaders.errorSnackBar(
        title: 'Akses Ditolak',
        message: 'Tidak ada sekolah yang dipilih',
      );
      return;
    }

    try {
      MBGLoadingOverlay.show();

      final newKelas = await _sekolahService.createKelas(id, {
        'nama': nama,
        'tingkat': tingkat,
      });

      kelasList.insert(0, newKelas);

      MBGLoadingOverlay.hide();
      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Kelas Ditambahkan',
        message: 'Kelas $nama berhasil dibuat',
      );
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal menambahkan kelas',
        message: e.toString(),
      );
    }
  }

  Future<void> updateKelas({
    required String id,
    required String nama,
    required int tingkat,
  }) async {
    try {
      MBGLoadingOverlay.show();

      final updated = await _sekolahService.updateKelas(id, {
        'nama': nama,
        'tingkat': tingkat,
      });

      final index = kelasList.indexWhere((item) => item.id == id);

      if (index >= 0) {
        kelasList[index] = updated;
        kelasList.refresh();
      }

      MBGLoadingOverlay.hide();
      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Kelas Diperbarui',
        message: 'Perubahan berhasil disimpan',
      );
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal memperbarui kelas',
        message: e.toString(),
      );
    }
  }

  Future<void> deleteKelas(String id) async {
    try {
      MBGLoadingOverlay.show();

      await _sekolahService.deleteKelas(id);

      kelasList.removeWhere((item) => item.id == id);

      MBGLoadingOverlay.hide();
      Get.back(); // Close dialog

      MBGLoaders.successSnackBar(
        title: 'Kelas Dihapus',
        message: 'Kelas berhasil dihapus',
      );
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal menghapus kelas',
        message: e.toString(),
      );
    }
  }
}
