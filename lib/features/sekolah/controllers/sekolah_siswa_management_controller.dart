import 'dart:io';

import 'package:get/get.dart';

import '../../../utils/popups/loaders.dart';
import '../../authentication/controllers/user_controller.dart';
import '../models/sekolah_alergi_model.dart';
import '../models/sekolah_kelas_model.dart';
import '../models/sekolah_siswa_model.dart';
import '../../../utils/services/sekolah_service.dart';

class SekolahSiswaManagementController extends GetxController {
  SekolahSiswaManagementController({
    SekolahService? sekolahService,
    UserController? userController,
  }) : _sekolahService = sekolahService ?? Get.find<SekolahService>(),
       _userController = userController ?? Get.find<UserController>();

  final SekolahService _sekolahService;
  final UserController _userController;

  final RxList<SekolahSiswaModel> siswaList = <SekolahSiswaModel>[].obs;
  final RxList<SekolahKelasModel> kelasList = <SekolahKelasModel>[].obs;
  final RxBool isLoading = false.obs;

  String? get _sekolahId {
    final sekolahAsPic = _userController.userModel.value?.sekolahAsPIC;
    if (sekolahAsPic == null || sekolahAsPic.isEmpty) {
      return null;
    }
    return sekolahAsPic.first.id;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final sekolahId = _sekolahId;
      if (sekolahId == null) {
        throw Exception('Anda tidak memiliki akses ke sekolah');
      }
      final siswa = await _sekolahService.getSiswaBySekolah(sekolahId);
      final kelas = await _sekolahService.getKelasBySekolah(sekolahId);
      siswaList.assignAll(siswa);
      kelasList.assignAll(kelas);
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() => loadData();

  Future<bool> deleteSiswa(SekolahSiswaModel siswa) async {
    try {
      await _sekolahService.deleteSiswa(siswa.id);
      siswaList.removeWhere((item) => item.id == siswa.id);
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Siswa berhasil dihapus',
      );
      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return false;
    }
  }

  Future<List<SekolahAlergiModel>> fetchAlergi(String siswaId) async {
    try {
      return await _sekolahService.getAlergiBySiswa(siswaId);
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return <SekolahAlergiModel>[];
    }
  }

  Future<bool> addAlergi(String siswaId, String namaAlergi) async {
    try {
      await _sekolahService.addAlergi(siswaId, namaAlergi);
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Alergi berhasil ditambahkan',
      );
      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return false;
    }
  }

  Future<bool> deleteAlergi(String alergiId) async {
    try {
      await _sekolahService.deleteAlergi(alergiId);
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Alergi berhasil dihapus',
      );
      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return false;
    }
  }

  Future<bool> createSiswa({
    required String kelasId,
    required String nama,
    required String nis,
    required int umur,
    required String jenisKelamin,
    required double tinggiBadan,
    required double beratBadan,
    File? foto,
  }) async {
    try {
      final sekolahId = _sekolahId;
      if (sekolahId == null) {
        throw Exception('Anda tidak memiliki akses ke sekolah');
      }

      await _sekolahService.createSiswa(
        sekolahId: sekolahId,
        kelasId: kelasId,
        nama: nama,
        nis: nis,
        umur: umur,
        jenisKelamin: jenisKelamin,
        tinggiBadan: tinggiBadan,
        beratBadan: beratBadan,
        foto: foto,
      );

      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Siswa berhasil ditambahkan',
      );

      await loadData();
      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return false;
    }
  }
}
