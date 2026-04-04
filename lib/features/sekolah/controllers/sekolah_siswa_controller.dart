import 'dart:io';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_siswa_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';

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
  final RxInt currentPage = 1.obs;
  final RxInt pageSize = 10.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;

  bool get canGoPreviousPage => currentPage.value > 1;
  bool get canGoNextPage => currentPage.value < totalPages.value;

  String? get sekolahId {
    final sekolahList = _userController.userModel.value?.sekolahAsPIC;
    return (sekolahList != null && sekolahList.isNotEmpty)
        ? sekolahList.first.id
        : null;
  }

  @override
  void onInit() {
    super.onInit();
    ever<UserModel?>(_userController.userModel, (_) => _loadSiswa());
    _loadSiswa();
  }

  Future<void> _loadSiswa() async {
    final id = sekolahId;
    if (id == null || id.isEmpty) return;
    await fetchSiswa(id, page: currentPage.value);
  }

  Future<void> refreshSiswa() async {
    await _loadSiswa();
  }

  Future<void> fetchSiswa(String sekolahId, {int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await _sekolahService.getSiswaBySekolah(
        sekolahId,
        page: page,
        limit: pageSize.value,
      );

      siswaList.assignAll(response.data);
      currentPage.value = response.pagination?.page ?? page;
      pageSize.value = response.pagination?.limit ?? pageSize.value;
      totalPages.value = response.pagination?.totalPages ?? 1;
      totalItems.value = response.pagination?.total ?? response.data.length;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat siswa',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> goToNextPage() async {
    final id = sekolahId;
    if (id == null || !canGoNextPage) return;
    await fetchSiswa(id, page: currentPage.value + 1);
  }

  Future<void> goToPreviousPage() async {
    final id = sekolahId;
    if (id == null || !canGoPreviousPage) return;
    await fetchSiswa(id, page: currentPage.value - 1);
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
      MBGLoadingOverlay.show();

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

      await fetchSiswa(id, page: currentPage.value);

      MBGLoadingOverlay.hide(); // Hide before navigation

      if (Get.isRegistered<CameraController>()) {
        Get.find<CameraController>().clearImage();
      }
      _kelasController.refreshKelas();
      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Siswa Ditambahkan',
        message: 'Data siswa berhasil tersimpan.',
      );
    } catch (e) {
      MBGLoadingOverlay.hide(); // Ensure hide on error
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
      MBGLoadingOverlay.show();

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

      await fetchSiswa(id, page: currentPage.value);

      MBGLoadingOverlay.hide(); // Hide before navigation

      if (Get.isRegistered<CameraController>()) {
        Get.find<CameraController>().clearImage();
      }
      _kelasController.refreshKelas();
      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Data Diperbarui',
        message: 'Perubahan siswa tersimpan.',
      );
    } catch (e) {
      MBGLoadingOverlay.hide(); // Ensure hide on error
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
      MBGLoadingOverlay.show();

      await _sekolahService.deleteSiswa(siswaId);

      await fetchSiswa(id, page: currentPage.value);
      if (siswaList.isEmpty && currentPage.value > 1) {
        await fetchSiswa(id, page: currentPage.value - 1);
      }

      MBGLoadingOverlay.hide(); // Hide before navigation

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      MBGLoaders.successSnackBar(
        title: 'Siswa Dihapus',
        message: 'Data siswa berhasil dihapus.',
      );
    } catch (e) {
      MBGLoadingOverlay.hide(); // Ensure hide on error
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
