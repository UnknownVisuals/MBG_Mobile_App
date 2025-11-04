import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_kelas_model.dart';
import 'package:mbg_mobile_app/utils/constants/image_strings.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/popups/full_screen_loader.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class SekolahKelasManagementController extends GetxController {
  SekolahKelasManagementController()
    : _sekolahService = Get.find<SekolahService>(),
      _userController = Get.find<UserController>();

  final SekolahService _sekolahService;
  final UserController _userController;

  final RxList<SekolahKelasModel> kelasList = <SekolahKelasModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> loadKelas() async {
    final sekolahId = _sekolahId;
    if (sekolahId == null) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Anda tidak memiliki akses ke sekolah',
      );
      kelasList.clear();
      return;
    }

    try {
      isLoading.value = true;
      final result = await _sekolahService.getKelasBySekolah(sekolahId);
      kelasList.assignAll(result);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat kelas: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshKelas() async {
    await loadKelas();
  }

  Future<void> createKelas({required String nama, required int tingkat}) async {
    final sekolahId = _sekolahId;
    if (sekolahId == null) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Anda tidak memiliki akses ke sekolah',
      );
      return;
    }

    MBGFullScreenLoader.openLoadingDialog(
      'Menyimpan kelas...',
      MBGImages.onBoardingImage1,
    );

    try {
      await _sekolahService.createKelas(sekolahId, {
        'nama': nama,
        'tingkat': tingkat,
      });
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kelas berhasil ditambahkan',
      );
      await loadKelas();
    } catch (e) {
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.errorSnackBar(title: 'Error', message: '$e');
    }
  }

  Future<void> updateKelas({
    required String id,
    required String nama,
    required int tingkat,
  }) async {
    MBGFullScreenLoader.openLoadingDialog(
      'Menyimpan perubahan...',
      MBGImages.onBoardingImage1,
    );

    try {
      await _sekolahService.updateKelas(id, {'nama': nama, 'tingkat': tingkat});
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kelas berhasil diperbarui',
      );
      await loadKelas();
    } catch (e) {
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.errorSnackBar(title: 'Error', message: '$e');
    }
  }

  Future<void> deleteKelas(SekolahKelasModel kelas) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus kelas "${kelas.nama}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    MBGFullScreenLoader.openLoadingDialog(
      'Menghapus kelas...',
      MBGImages.onBoardingImage1,
    );

    try {
      await _sekolahService.deleteKelas(kelas.id);
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Kelas berhasil dihapus',
      );
      await loadKelas();
    } catch (e) {
      MBGFullScreenLoader.stopLoading();
      MBGLoaders.errorSnackBar(title: 'Error', message: '$e');
    }
  }

  String? get _sekolahId {
    final sekolahAsPic = _userController.userModel.value?.sekolahAsPIC;
    if (sekolahAsPic == null || sekolahAsPic.isEmpty) return null;
    return sekolahAsPic.first.id;
  }

  @override
  void onInit() {
    super.onInit();
    loadKelas();
  }
}
