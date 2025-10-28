import 'dart:io';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/models/user_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/utils/http/http_client.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class DapurKaryawanController extends GetxController {
  // Dependencies
  final MBGHttpHelper httpHelper = Get.put(MBGHttpHelper());

  final UserModel userModel = Get.find<UserController>().user.value!;
  String get dapurId => userModel.dapurAsPIC.first.id;

  // Data Variables
  RxList<KaryawanModel> karyawanList = <KaryawanModel>[].obs;

  // State Variables
  RxBool isLoading = false.obs;
  RxnString deletingKaryawanId = RxnString();

  @override
  void onInit() {
    super.onInit();
    if (userModel.dapurAsPIC.isNotEmpty) {}
    fetchKaryawan(dapurId: dapurId);
  }

  Future<void> fetchKaryawan({required String dapurId}) async {
    try {
      isLoading.value = true;

      MBGHttpHelper.loadSessionToken();

      final response = await httpHelper.getRequest('dapur/$dapurId/karyawan');

      if (response.statusCode == 200) {
        final responseData = response.body;

        if (responseData['success'] == true) {
          final List<dynamic> karyawanJsonList = responseData['data']['data'];
          karyawanList.value = karyawanJsonList
              .map((json) => KaryawanModel.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat karyawan dapur',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addKaryawan({
    required String nama,
    required String posisi,
    required File foto,
  }) async {
    try {
      isLoading.value = true;

      MBGHttpHelper.loadSessionToken();

      final response = await httpHelper.postMultipartRequest(
        'karyawan',
        fields: {'nama': nama, 'posisi': posisi},
        file: foto,
        fileFieldName: 'foto',
      );

      if (response.statusCode != 201) {
        throw Exception(
          response.body?['message'] ?? 'Gagal menambahkan karyawan',
        );
      }

      final responseData = response.body;
      if (responseData == null || responseData['success'] != true) {
        throw Exception('Invalid response format');
      }

      isLoading.value = false;

      MBGLoaders.successSnackBar(
        title: 'Karyawan Ditambahkan',
        message: 'Karyawan baru berhasil ditambahkan ke dapur.',
      );

      if (Get.isRegistered<CameraController>()) {
        Get.find<CameraController>().clearImage();
      }

      await Future.delayed(const Duration(milliseconds: 400));
      Get.back(closeOverlays: true);

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

  Future<void> deleteKaryawan({required String karyawanId}) async {
    try {
      isLoading.value = true;
      deletingKaryawanId.value = karyawanId;

      MBGHttpHelper.loadSessionToken();

      final response = await httpHelper.deleteRequest('karyawan/$karyawanId');

      if (response.statusCode != 200) {
        throw Exception(
          response.body?['message'] ?? 'Gagal menghapus karyawan',
        );
      }

      final responseData = response.body;
      if (responseData == null || responseData['success'] != true) {
        throw Exception('Invalid response format');
      }

      isLoading.value = false;

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
      deletingKaryawanId.value = null;
      isLoading.value = false;
    }
  }

  Future<void> updateKaryawan({
    required String karyawanId,
    String? nama,
    String? posisi,
    File? foto,
  }) async {
    try {
      isLoading.value = true;

      MBGHttpHelper.loadSessionToken();

      final response = await httpHelper.postMultipartRequest(
        'karyawan/$karyawanId',
        fields: {
          if (nama != null) 'nama': nama,
          if (posisi != null) 'posisi': posisi,
        },
        file: foto,
        fileFieldName: 'foto',
        isPutMethod: true,
      );

      if (response.statusCode != 200) {
        throw Exception(
          response.body?['message'] ?? 'Gagal memperbarui karyawan',
        );
      }

      final responseData = response.body;
      if (responseData == null || responseData['success'] != true) {
        throw Exception('Invalid response format');
      }

      isLoading.value = false;

      MBGLoaders.successSnackBar(
        title: 'Karyawan Diperbarui',
        message: 'Data karyawan berhasil diperbarui.',
      );

      if (Get.isRegistered<CameraController>()) {
        Get.find<CameraController>().clearImage();
      }

      await Future.delayed(const Duration(milliseconds: 400));
      Get.back(closeOverlays: true);

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
}
