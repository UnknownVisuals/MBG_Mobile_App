import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_pengiriman_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_sekolah_model.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';

class DapurPengirimanController extends GetxController {
  // Dependencies
  final DapurService _dapurService = Get.find<DapurService>();

  // Data Variables
  RxList<DapurSekolahModel> sekolahList = <DapurSekolahModel>[].obs;
  final RxList<DapurPengirimanModel> pengirimanList =
      <DapurPengirimanModel>[].obs;

  // State Variables
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString selectedFilter = 'all'.obs;

  // Form Variables
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController jumlahTrayController;
  late final TextEditingController jumlahKeranjangController;

  static const Set<String> _pendingStatuses = {
    'PENDING',
    'MENUNGGU_PENGIRIMAN',
    'MENUNGGU_PENGAMBILAN',
  };

  static const Set<String> _inTransitStatuses = {
    'IN_TRANSIT',
    'DIAMBIL',
    'SEDANG_DIJEMPUT',
    'SEDANG_DIANTAR',
    'DIANTAR',
  };

  static const Set<String> _completedStatuses = {
    'DITERIMA',
    'SELESAI',
    'TELAH_SAMPAI',
  };

  @override
  void onInit() {
    super.onInit();
    jumlahTrayController = TextEditingController();
    jumlahKeranjangController = TextEditingController();

    // Fetch sekolah first, then fetch pengiriman when sekolah list is loaded
    fetchAllSekolah().then((_) {
      // After sekolah list is loaded, fetch pengiriman for first sekolah
      if (sekolahList.isNotEmpty) {
        fetchPengiriman();
      }
    });
  }

  @override
  void onClose() {
    jumlahTrayController.dispose();
    jumlahKeranjangController.dispose();
    super.onClose();
  }

  String? get sekolahId {
    if (sekolahList.isEmpty) {
      return null;
    }
    final id = sekolahList.first.id;
    return id;
  }

  String? get sekolahNama {
    if (sekolahList.isEmpty) return null;
    return sekolahList.first.nama;
  }

  List<DapurPengirimanModel> get filteredPengiriman {
    final List<DapurPengirimanModel> list = pengirimanList.toList();
    switch (selectedFilter.value) {
      case 'pending':
        return list.where((item) => _isPending(item.status)).toList();
      case 'in_transit':
        return list.where((item) => _isInTransit(item.status)).toList();
      case 'completed':
        return list.where((item) => _isCompleted(item.status)).toList();
      default:
        return list;
    }
  }

  int get totalCount => pengirimanList.length;
  int get pendingCount =>
      pengirimanList.where((item) => _isPending(item.status)).length;
  int get inTransitCount =>
      pengirimanList.where((item) => _isInTransit(item.status)).length;
  int get completedCount =>
      pengirimanList.where((item) => _isCompleted(item.status)).length;

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Helper methods for status checking
  bool _isPending(String? status) {
    if (status == null) return false;
    return _pendingStatuses.contains(status);
  }

  bool _isInTransit(String? status) {
    if (status == null) return false;
    return _inTransitStatuses.contains(status);
  }

  bool _isCompleted(String? status) {
    if (status == null) return false;
    return _completedStatuses.contains(status);
  }

  // ===============
  // GET ALL SEKOLAH
  // ===============
  Future<void> fetchAllSekolah() async {
    try {
      isLoading.value = true;
      final data = await _dapurService.getAllSekolah();
      sekolahList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data sekolah',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==================
  // GET ALL PENGIRIMAN
  // ==================
  Future<void> fetchPengiriman() async {
    try {
      isLoading.value = true;

      // Get sekolah ID from dapur info
      final currentSekolahId = sekolahId;
      if (currentSekolahId == null) {
        pengirimanList.clear();
        return;
      }

      final data = await _dapurService.getPengirimanBySekolah(currentSekolahId);
      pengirimanList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data pengiriman',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ====================
  // CREATE PENGIRIMAN
  // ====================
  Future<DapurPengirimanModel?> createPengiriman(
    Map<String, dynamic> payload,
  ) async {
    try {
      isSubmitting.value = true;
      MBGLoadingOverlay.show();

      final DapurPengirimanModel newPengiriman = await _dapurService
          .createPengiriman(payload);

      MBGLoadingOverlay.hide();

      // Navigate back first
      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Pengiriman Berhasil Dibuat',
        message: 'Pengiriman dengan ID ${newPengiriman.id} berhasil dibuat.',
      );

      pengirimanList.insert(0, newPengiriman);

      return newPengiriman;
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal Membuat Pengiriman',
        message: e.toString(),
      );
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================
  // DELETE PENGIRIMAN
  // ==================
  Future<bool> deletePengiriman(String pengirimanId) async {
    try {
      isSubmitting.value = true;
      MBGLoadingOverlay.show();

      await _dapurService.deletePengiriman(pengirimanId);

      MBGLoadingOverlay.hide();

      // Close dialog
      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Pengiriman Berhasil Dihapus',
        message: 'Data pengiriman telah dihapus.',
      );

      // Remove from list
      pengirimanList.removeWhere((item) => item.id == pengirimanId);

      return true;
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal Menghapus Pengiriman',
        message: e.toString(),
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ==================
  // REFRESH PENGIRIMAN
  // ==================
  Future<void> refreshPengiriman() async {
    await fetchPengiriman();
  }
}
