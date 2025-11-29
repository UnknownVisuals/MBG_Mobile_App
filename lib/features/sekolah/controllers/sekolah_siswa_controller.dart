import 'dart:io';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_siswa_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';

class SekolahSiswaController extends GetxController {
  SekolahSiswaController({
    SekolahService? sekolahService,
    UserController? userController,
    SekolahKelasController? kelasController,
  }) : _sekolahService = sekolahService ?? Get.find<SekolahService>(),
       _userController = userController ?? Get.find<UserController>(),
       _kelasController = kelasController ?? Get.find<SekolahKelasController>();

  final SekolahService _sekolahService;
  final UserController _userController;
  final SekolahKelasController _kelasController;

  RxList<SekolahSiswaModel> siswaList = <SekolahSiswaModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString deletingSiswaId = RxnString();

  String? get sekolahId =>
      _userController.userModel.value?.sekolahAsPIC?.first.id;

  @override
  void onInit() {
    super.onInit();
    ever<UserModel?>(_userController.userModel, (_) => _loadSiswa());
    _loadSiswa();
  }

  Future<void> _loadSiswa() async {
    final id = sekolahId;
    if (id == null || id.isEmpty) return;
    await fetchSiswa(id);
  }

  Future<void> refreshSiswa() async {
    await _loadSiswa();
  }

  Future<void> fetchSiswa(String sekolahId) async {
    try {
      isLoading.value = true;
      final data = await _sekolahService.getSiswaBySekolah(sekolahId);
      siswaList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat siswa',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSiswa({
    required String nama,
    required String nis,
    required String jenisKelamin,
    required int umur,
    required double tinggiBadan,
    required double beratBadan,
    required String kelasId,
    required File foto,
  }) async {
    final id = sekolahId;
    if (id == null || id.isEmpty) {
      MBGLoaders.errorSnackBar(
        title: 'Sekolah Tidak Ditemukan',
        message: 'Tidak ada sekolah yang terdaftar untuk pengguna',
      );
      return;
    }

    try {
      isLoading.value = true;

      await _sekolahService.createSiswa(
        sekolahId: id,
        nama: nama,
        nis: nis,
        kelasId: kelasId,
        jenisKelamin: jenisKelamin,
        umur: umur,
        tinggiBadan: tinggiBadan,
        beratBadan: beratBadan,
        foto: foto,
      );

      await fetchSiswa(id);

      MBGLoaders.successSnackBar(
        title: 'Siswa Ditambahkan',
        message: 'Data siswa berhasil tersimpan.',
      );

      if (Get.isRegistered<CameraController>()) {
        Get.find<CameraController>().clearImage();
      }
      _kelasController.refreshKelas();
      Get.back();
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal menambahkan siswa',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSiswa({
    required String siswaId,
    required String nama,
    required String nis,
    required String jenisKelamin,
    required int umur,
    required double tinggiBadan,
    required double beratBadan,
    required String kelasId,
    File? foto,
  }) async {
    final id = sekolahId;
    if (id == null || id.isEmpty) {
      MBGLoaders.errorSnackBar(
        title: 'Sekolah Tidak Ditemukan',
        message: 'Tidak ada sekolah yang terdaftar untuk pengguna',
      );
      return;
    }

    try {
      isLoading.value = true;

      await _sekolahService.updateSiswa(
        siswaId: siswaId,
        nama: nama,
        nis: nis,
        kelasId: kelasId,
        jenisKelamin: jenisKelamin,
        umur: umur,
        tinggiBadan: tinggiBadan,
        beratBadan: beratBadan,
        foto: foto,
      );

      await fetchSiswa(id);

      MBGLoaders.successSnackBar(
        title: 'Data Diperbarui',
        message: 'Perubahan siswa tersimpan.',
      );

      if (Get.isRegistered<CameraController>()) {
        Get.find<CameraController>().clearImage();
      }
      _kelasController.refreshKelas();
      Get.back();
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memperbarui siswa',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSiswa(String siswaId) async {
    final id = sekolahId;
    if (id == null || id.isEmpty) {
      MBGLoaders.errorSnackBar(
        title: 'Sekolah Tidak Ditemukan',
        message: 'Tidak ada sekolah yang terdaftar untuk pengguna',
      );
      return;
    }

    try {
      deletingSiswaId.value = siswaId;
      isLoading.value = true;

      await _sekolahService.deleteSiswa(siswaId);

      await fetchSiswa(id);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      MBGLoaders.successSnackBar(
        title: 'Siswa Dihapus',
        message: 'Data siswa berhasil dihapus.',
      );
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal menghapus siswa',
        message: e.toString(),
      );
    } finally {
      deletingSiswaId.value = null;
      isLoading.value = false;
    }
  }
}
