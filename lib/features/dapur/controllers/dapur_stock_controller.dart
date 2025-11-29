import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';

import 'package:mbg_mobile_app/features/dapur/models/dapur_stock_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';

class DapurStokController extends GetxController {
  // Dependencies
  final DapurService _dapurService = Get.find<DapurService>();

  // Getter for dapurId
  // Getter for dapurId
  // Getter for dapurId
  String? get dapurId {
    final userModel = Get.find<UserController>().userModel.value;
    final list = userModel?.dapurAsPIC;
    if (list == null || list.isEmpty) return null;
    return list.first.id;
  }

  // Data Variables
  RxList<DapurStokModel> stokList = <DapurStokModel>[].obs;
  RxList<DapurStokModel> filteredStokList = <DapurStokModel>[].obs;

  // State Variables
  RxBool isLoading = false.obs;
  RxnString deletingStokId = RxnString();
  RxnString adjustingStokId = RxnString();
  Rxn<KategoriStok> selectedCategory = Rxn<KategoriStok>();

  List<KategoriStok> get kategoriOptions => KategoriStok.values;

  // =====================
  // CATEGORY HELPER METHODS
  // =====================
  Color getCategoryColor(KategoriStok kategori) {
    switch (kategori) {
      case KategoriStok.SAYURAN:
        return MBGColors.success;
      case KategoriStok.BUMBU:
        return MBGColors.warning;
      case KategoriStok.PROTEIN:
        return MBGColors.error;
      case KategoriStok.KARBOHIDRAT:
        return MBGColors.info;
      case KategoriStok.LAINNYA:
        return MBGColors.darkGrey;
    }
  }

  IconData getCategoryIcon(KategoriStok kategori) {
    switch (kategori) {
      case KategoriStok.SAYURAN:
        return Iconsax.shopping_bag;
      case KategoriStok.BUMBU:
        return Iconsax.tag;
      case KategoriStok.PROTEIN:
        return Iconsax.activity;
      case KategoriStok.KARBOHIDRAT:
        return Iconsax.box;
      case KategoriStok.LAINNYA:
        return Iconsax.category;
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Listen to user model changes
    ever(Get.find<UserController>().userModel, (_) {
      if (dapurId != null) {
        fetchStok(dapurId: dapurId!);
      }
    });

    // Initial fetch
    if (dapurId != null) {
      fetchStok(dapurId: dapurId!);
    }
  }

  // =================
  // FILTER MANAGEMENT
  // =================
  void selectCategory(KategoriStok? category) {
    selectedCategory.value = category;
    _applyFilter();
  }

  void _applyFilter() {
    final KategoriStok? category = selectedCategory.value;
    if (category == null) {
      filteredStokList.assignAll(stokList);
      return;
    }

    filteredStokList.assignAll(
      stokList.where((stok) => stok.kategori == category).toList(),
    );
  }

  // =====================
  // REFRESH STOK DATA
  // =====================
  Future<void> refreshStok() async {
    await fetchStok(dapurId: dapurId!);
  }

  // =================
  // GET STOK DATA
  // =================
  Future<void> fetchStok({required String dapurId}) async {
    try {
      isLoading.value = true;
      final stok = await _dapurService.getAllStok(dapurId: dapurId);
      stokList.assignAll(stok);
      _applyFilter();
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Memuat Stok',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =================
  // ADD STOK DATA
  // =================
  Future<void> addStok({
    required String nama,
    required KategoriStok kategori,
    required double stokKg,
  }) async {
    try {
      isLoading.value = true;

      await _dapurService.createStok({
        'nama': nama,
        'kategori': kategori.apiValue,
        'stokKg': stokKg,
        'dapurId': dapurId,
      });

      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Stok Ditambahkan',
        message: '$nama sebanyak $stokKg kg berhasil ditambahkan',
      );

      if (dapurId != null) {
        await fetchStok(dapurId: dapurId!);
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Menambahkan Stok',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==================
  // UPDATE STOK DATA
  // ==================
  Future<void> updateStok({
    required String stokId,
    required String nama,
    required KategoriStok kategori,
    required double stokKg,
  }) async {
    try {
      isLoading.value = true;

      final updatedStok = await _dapurService.updateStok(stokId, {
        'nama': nama,
        'kategori': kategori.apiValue,
        'stokKg': stokKg,
      });

      _replaceStok(updatedStok);

      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Stok Diperbarui',
        message: 'Data stok berhasil diperbarui.',
      );
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Memperbarui Stok',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===================
  // ADJUST STOK DATA
  // ===================
  Future<void> adjustStok({
    required String stokId,
    required double adjustment,
  }) async {
    if (adjustment == 0) {
      MBGLoaders.warningSnackBar(
        title: 'Penyesuaian Tidak Valid',
        message: 'Nilai penyesuaian tidak boleh nol.',
      );
      return;
    }

    try {
      adjustingStokId.value = stokId;
      final adjustedStok = await _dapurService.adjustStok(stokId, adjustment);
      _replaceStok(adjustedStok);

      // Close dialog
      Get.back();

      // If called from edit screen, go back to main stock screen
      if (Get.currentRoute.contains('DapurStokEdit')) {
        Get.back();
      }

      MBGLoaders.successSnackBar(
        title: 'Stok Disesuaikan',
        message: 'Penyesuaian stok berhasil disimpan.',
      );
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Menyesuaikan Stok',
        message: e.toString(),
      );
    } finally {
      adjustingStokId.value = null;
    }
  }

  void _replaceStok(DapurStokModel updatedStok) {
    final int index = stokList.indexWhere((stok) => stok.id == updatedStok.id);
    if (index != -1) {
      stokList[index] = updatedStok;
      stokList.refresh();
      _applyFilter();
    }
  }

  // ==================
  // DELETE STOK DATA
  // ==================
  Future<void> deleteStok(String stokId) async {
    try {
      deletingStokId.value = stokId;
      await _dapurService.deleteStok(stokId);

      Get.back(); // Close dialog

      MBGLoaders.successSnackBar(
        title: 'Stok Dihapus',
        message: 'Data stok berhasil dihapus.',
      );

      if (dapurId != null) {
        await fetchStok(dapurId: dapurId!);
      }
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal Menghapus Stok',
        message: e.toString(),
      );
    } finally {
      deletingStokId.value = null;
    }
  }
}
