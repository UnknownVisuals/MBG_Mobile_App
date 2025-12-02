import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_checkpoint_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';
import 'package:mbg_mobile_app/utils/helpers/loading_overlay.dart';

class DapurCheckpointController extends GetxController {
  // Dependencies
  final DapurService _dapurService = Get.find<DapurService>();

  // Data Variables
  RxList<DapurCheckpointModel> checkpointList = <DapurCheckpointModel>[].obs;
  final Rx<String?> currentMenuHarianId = Rx<String?>(null);

  // State Variables
  RxBool isLoading = false.obs;

  // All checkpoint types in order
  final List<String> allCheckpointTypes = [
    'MULAI_MEMASAK',
    'SELESAI_MEMASAK',
    'SELESAI_PACKING',
    'SCHOOL_TO_DRIVER_RETURN',
    'DRIVER_TO_KITCHEN',
    'KITCHEN_RECEIVED',
    'WASHING_COMPLETE',
  ];

  // Computed Properties
  int get completedCount => checkpointList.length;
  int get totalCount => allCheckpointTypes.length;

  // Get checkpoint status: 'completed', 'active', 'future'
  String getCheckpointStatus(String tipe) {
    final completedTypes = checkpointList
        .map((c) => c.tipe)
        .whereType<String>()
        .toList();

    if (completedTypes.contains(tipe)) {
      return 'completed';
    }

    final typeIndex = allCheckpointTypes.indexOf(tipe);
    final lastCompletedIndex = completedTypes.isEmpty
        ? -1
        : allCheckpointTypes.indexOf(completedTypes.last);

    if (typeIndex == lastCompletedIndex + 1) {
      return 'active';
    }

    return 'future';
  }

  // Get checkpoint model if exists
  DapurCheckpointModel? getCheckpointModel(String tipe) {
    try {
      return checkpointList.firstWhere((c) => c.tipe == tipe);
    } catch (e) {
      return null;
    }
  }

  // Get checkpoint icon
  IconData getCheckpointIcon(String tipe) {
    switch (tipe) {
      case 'MULAI_MEMASAK':
        return Iconsax.timer_start;
      case 'SELESAI_MEMASAK':
        return Iconsax.tick_circle;
      case 'SELESAI_PACKING':
        return Iconsax.box;
      case 'SCHOOL_TO_DRIVER_RETURN':
        return Iconsax.truck_fast;
      case 'DRIVER_TO_KITCHEN':
        return Iconsax.ship;
      case 'KITCHEN_RECEIVED':
        return Iconsax.receipt_square;
      case 'WASHING_COMPLETE':
        return Iconsax.tick_square;
      default:
        return Iconsax.record_circle;
    }
  }

  // Get checkpoint label
  String getCheckpointLabel(String tipe) {
    switch (tipe) {
      case 'MULAI_MEMASAK':
        return 'Mulai Memasak';
      case 'SELESAI_MEMASAK':
        return 'Selesai Memasak';
      case 'SELESAI_PACKING':
        return 'Selesai Packing';
      case 'SCHOOL_TO_DRIVER_RETURN':
        return 'Sekolah ke Driver (Pulang)';
      case 'DRIVER_TO_KITCHEN':
        return 'Driver ke Dapur';
      case 'KITCHEN_RECEIVED':
        return 'Diterima Dapur';
      case 'WASHING_COMPLETE':
        return 'Selesai Dicuci';
      default:
        return tipe;
    }
  }

  // Get checkpoint roles
  List<String> getCheckpointRoles(String tipe) {
    switch (tipe) {
      case 'MULAI_MEMASAK':
      case 'SELESAI_MEMASAK':
      case 'SELESAI_PACKING':
        return ['PIC_DAPUR'];
      case 'SCHOOL_TO_DRIVER_RETURN':
      case 'DRIVER_TO_KITCHEN':
        return ['DRIVER'];
      case 'KITCHEN_RECEIVED':
      case 'WASHING_COMPLETE':
        return ['PIC_DAPUR'];
      default:
        return [];
    }
  }

  // Get role display name
  String getRoleDisplayName(String role) {
    switch (role) {
      case 'PIC_DAPUR':
        return 'PIC Dapur';
      case 'DRIVER':
        return 'Driver';
      default:
        return role;
    }
  }

  // Get role color
  Color getRoleColor(String role) {
    switch (role) {
      case 'PIC_DAPUR':
        return MBGColors.success;
      case 'DRIVER':
        return MBGColors.warning;
      default:
        return MBGColors.grey;
    }
  }

  // Check if user can perform this checkpoint
  bool canUserPerformCheckpoint(String userRole, String checkpointType) {
    final requiredRoles = getCheckpointRoles(checkpointType);
    return requiredRoles.contains(userRole);
  }

  // =====================
  // INITIALIZE WITH MENU ID
  // =====================
  void initializeWithMenuId(String? menuHarianId) {
    currentMenuHarianId.value = menuHarianId;
    if (menuHarianId != null) {
      fetchCheckpointsByMenuHarian(menuHarianId);
    }
  }

  // =====================
  // CHANGE SELECTED MENU HARIAN
  // =====================
  void changeMenuHarian(String menuHarianId) {
    currentMenuHarianId.value = menuHarianId;
    fetchCheckpointsByMenuHarian(menuHarianId);
  }

  // =====================
  // CREATE NEW CHECKPOINT
  // =====================

  Future<void> createCheckpoint({
    required String menuHarianId,
    required String tipe,
    required File foto,
    String? deskripsi,
  }) async {
    try {
      isLoading.value = true;
      MBGLoadingOverlay.show();

      await _dapurService.createCheckpoint(
        menuHarianId: menuHarianId,
        tipe: tipe,
        foto: foto,
        deskripsi: deskripsi,
      );

      // Fetch updated checkpoint list
      await fetchCheckpointsByMenuHarian(menuHarianId);

      MBGLoadingOverlay.hide();

      // Navigate back first to avoid Get.back() closing the snackbar
      Get.back();

      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Checkpoint berhasil ditambahkan',
      );
    } catch (e) {
      MBGLoadingOverlay.hide();
      MBGLoaders.errorSnackBar(
        title: 'Gagal menambahkan checkpoint',
        message: e.toString(),
      );
      // Don't rethrow - error already handled with snackbar
    } finally {
      isLoading.value = false;
    }
  }

  // ================================
  // FETCH CHECKPOINTS BY MENU HARIAN
  // ================================
  Future<void> fetchCheckpointsByMenuHarian(String menuHarianId) async {
    try {
      isLoading.value = true;

      final data = await _dapurService.getCheckpointsByMenuHarian(menuHarianId);

      checkpointList.assignAll(data);
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data checkpoint',
        message: e.toString(),
      );
      rethrow; // Rethrow to propagate error
    } finally {
      isLoading.value = false;
    }
  }
}
