import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbg_mobile_app/utils/helpers/image_compression_helper.dart';
import 'package:mbg_mobile_app/features/driver/models/driver_tray_return_model.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/driver_service.dart';

class DriverTrayReturnController extends GetxController {
  final DriverService _driverService = Get.find<DriverService>();

  // Data
  final RxList<DriverTrayReturnModel> trayPickups =
      <DriverTrayReturnModel>[].obs;

  // State
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString selectedFilter = 'all'.obs;

  // Form Data
  final Rx<File?> selectedPhoto = Rx<File?>(null);

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<DriverTrayReturnModel> get filteredTrayPickups {
    // User requested to ONLY show SEDANG_RETURN items
    // and explicitly NOT show SAMPAI_DAPUR
    return trayPickups.where((item) => item.status == 'SEDANG_RETURN').toList();
  }

  int get totalCount => trayPickups.length;
  int get menungguPickupCount =>
      trayPickups.where((item) => item.status == 'MENUNGGU_PICKUP').length;
  int get sedangReturnCount =>
      trayPickups.where((item) => item.status == 'SEDANG_RETURN').length;
  int get sampaiDapurCount =>
      trayPickups.where((item) => item.status == 'SAMPAI_DAPUR').length;
  final TextEditingController jumlahTrayController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchTrayPickups();
  }

  @override
  void onClose() {
    jumlahTrayController.dispose();
    super.onClose();
  }

  Future<void> fetchTrayPickups() async {
    try {
      isLoading.value = true;
      final results = await _driverService.getMyTrayPickups();
      trayPickups.assignAll(results);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat daftar pickup',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitPickup(String qrCodeId) async {
    if (!formKey.currentState!.validate()) return;
    if (selectedPhoto.value == null) {
      MBGLoaders.warningSnackBar(
        title: 'Foto Wajib',
        message: 'Harap ambil foto bukti pickup.',
      );
      return;
    }

    try {
      isSubmitting.value = true;
      MBGLoadingOverlay.show();

      final int jumlah = int.tryParse(jumlahTrayController.text) ?? 0;

      final newPickup = await _driverService.scanTrayReturnPickup(
        qrCodeId: qrCodeId,
        foto: selectedPhoto.value!,
        jumlahTrayDiterima: jumlah,
      );

      MBGLoadingOverlay.hide();
      Get.back(); // Close form dialog

      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pickup tray berhasil dicatat.',
      );

      // Refresh list
      trayPickups.insert(0, newPickup);
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal memproses pickup',
        message: e.toString(),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxHeight: 1000,
        maxWidth: 1000,
      );

      if (pickedFile != null) {
        selectedPhoto.value = await compressImageFileToMaxSize(
          File(pickedFile.path),
        );
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Memilih Foto',
        message: e.toString(),
      );
    }
  }

  void resetForm() {
    selectedPhoto.value = null;
    jumlahTrayController.clear();
  }
}
