import 'dart:io';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DapurKaryawanController extends GetxController {
  // Dependencies
  final DapurService _dapurService = Get.find<DapurService>();

  // Getter for dapurId
  final UserModel userModel = Get.find<UserController>().userModel.value!;
  String get dapurId {
    return userModel.dapurAsPIC!.first.id;
  }

  // Data Variables
  RxList<DapurKaryawanModel> karyawanList = <DapurKaryawanModel>[].obs;

  // State Variables
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKaryawan(dapurId: dapurId);
  }

  // =====================
  // REFRESH KARYAWAN DATA
  // =====================
  Future<void> refreshKaryawan() async {
    await fetchKaryawan(dapurId: dapurId);
  }

  // =================
  // GET KARYAWAN DATA
  // =================
  Future<void> fetchKaryawan({required String dapurId}) async {
    try {
      isLoading.value = true;
      final data = await _dapurService.getAllKaryawanByDapur(dapurId);
      karyawanList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data karyawan',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =================
  // ADD KARYAWAN DATA
  // =================
  Future<void> addKaryawan({
    required String nama,
    required String posisi,
    required String jenisKelamin,
    required int umur,
    required File foto,
  }) async {
    try {
      isLoading.value = true;

      await _dapurService.createKaryawan(
        nama: nama,
        posisi: posisi,
        jenisKelamin: jenisKelamin,
        umur: umur,
        foto: foto,
        dapurId: dapurId,
      );

      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Karyawan Ditambahkan',
        message: 'Karyawan baru berhasil ditambahkan ke dapur',
      );

      if (Get.isRegistered<CameraController>()) {
        Get.find<CameraController>().clearImage();
      }

      await fetchKaryawan(dapurId: dapurId);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal menambahkan karyawan',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ====================
  // UPDATE KARYAWAN DATA
  // ====================
  Future<void> updateKaryawan({
    required String karyawanId,
    String? nama,
    String? posisi,
    KaryawanStatus? status,
    JenisKelamin? jenisKelamin,
    int? umur,
    File? foto,
  }) async {
    try {
      isLoading.value = true;

      await _dapurService.updateKaryawan(
        karyawanId: karyawanId,
        nama: nama,
        posisi: posisi,
        status: status,
        jenisKelamin: jenisKelamin,
        umur: umur,
        foto: foto,
      );

      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Karyawan Diperbarui',
        message: 'Data karyawan berhasil diperbarui.',
      );

      if (Get.isRegistered<CameraController>()) {
        Get.find<CameraController>().clearImage();
      }

      await fetchKaryawan(dapurId: dapurId);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memperbarui karyawan',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ====================
  // DELETE KARYAWAN DATA
  // ====================
  Future<void> deleteKaryawan({required String karyawanId}) async {
    try {
      isLoading.value = true;

      await _dapurService.deleteKaryawan(karyawanId);

      await fetchKaryawan(dapurId: dapurId);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      MBGLoaders.successSnackBar(
        title: 'Karyawan Dihapus',
        message: 'Karyawan berhasil dihapus dari dapur.',
      );
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal menghapus karyawan',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
