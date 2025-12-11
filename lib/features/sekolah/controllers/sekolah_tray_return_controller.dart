import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_delivery_model.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_tray_return_model.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/sekolah_service.dart';

class SekolahTrayReturnController extends GetxController {
  final SekolahService _sekolahService = Get.find<SekolahService>();
  final UserController _userController = Get.find<UserController>();

  // Data
  final RxList<SekolahTrayReturnModel> trayReturns =
      <SekolahTrayReturnModel>[].obs;
  final RxList<SekolahDeliveryModel> completedPengirimanList =
      <SekolahDeliveryModel>[].obs;

  // State
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString selectedFilter = 'all'.obs;

  // Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchTrayReturns();
    fetchCompletedPengiriman();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<SekolahTrayReturnModel> get filteredTrayReturns {
    if (selectedFilter.value == 'all') {
      return trayReturns;
    }
    return trayReturns
        .where((item) => item.status == selectedFilter.value)
        .toList();
  }

  int get totalCount => trayReturns.length;
  int get menungguPickupCount =>
      trayReturns.where((item) => item.status == 'MENUNGGU_PICKUP').length;
  int get sedangReturnCount =>
      trayReturns.where((item) => item.status == 'SEDANG_RETURN').length;
  int get sampaiDapurCount =>
      trayReturns.where((item) => item.status == 'SAMPAI_DAPUR').length;
  final TextEditingController keteranganController = TextEditingController();
  final Rx<String?> selectedPengirimanId = Rx<String?>(null);

  @override
  void onClose() {
    keteranganController.dispose();
    super.onClose();
  }

  String? get sekolahId {
    final sekolahList = _userController.userModel.value?.sekolahAsPIC;
    return (sekolahList != null && sekolahList.isNotEmpty)
        ? sekolahList.first.id
        : null;
  }

  Future<void> fetchTrayReturns() async {
    try {
      isLoading.value = true;
      final results = await _sekolahService.getMyTrayReturns();
      trayReturns.assignAll(results);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat daftar pengembalian',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCompletedPengiriman() async {
    final sId = sekolahId;
    if (sId == null) return;

    try {
      final all = await _sekolahService.getPengirimanBySekolah(sId);
      // Filter only finished deliveries (TELAH_SAMPAI / COMPLETED)
      final completed = all.where((item) {
        return item.normalizedStatus == SekolahDeliveryStatus.completed;
      }).toList();

      completedPengirimanList.assignAll(completed);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data pengiriman',
        message: e.toString(),
      );
    }
  }

  Future<bool> createTrayReturn() async {
    if (!formKey.currentState!.validate()) return false;
    if (selectedPengirimanId.value == null) {
      MBGLoaders.warningSnackBar(
        title: 'Pilih Pengiriman',
        message: 'Silakan pilih pengiriman yang akan dikembalikan.',
      );
      return false;
    }

    try {
      isSubmitting.value = true;
      MBGLoadingOverlay.show();

      final payload = {
        'pengirimanId': selectedPengirimanId.value,
        'keterangan': keteranganController.text.trim(),
      };

      final newReturn = await _sekolahService.createTrayReturn(payload);

      MBGLoadingOverlay.hide();
      Get.back(); // Close form screen

      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Pengembalian tray berhasil dibuat.',
      );

      // Refresh list
      trayReturns.insert(0, newReturn);
      return true;
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal membuat pengembalian',
        message: e.toString(),
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    selectedPengirimanId.value = null;
    keteranganController.clear();
    completedPengirimanList.clear();
  }
}
