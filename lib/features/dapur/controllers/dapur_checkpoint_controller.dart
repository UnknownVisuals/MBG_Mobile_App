import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_checkpoint_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';
import 'package:mbg_mobile_app/utils/services/dapur_service.dart';

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
    final completedTypes = checkpointList.map((c) => c.tipe).toList();

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
        return MBGColors.primary;
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
      print('🔵 [CHECKPOINT] Starting createCheckpoint...');
      print('🔵 [CHECKPOINT] menuHarianId: $menuHarianId');
      print('🔵 [CHECKPOINT] tipe: $tipe');
      print('🔵 [CHECKPOINT] deskripsi: $deskripsi');
      print('🔵 [CHECKPOINT] foto path: ${foto.path}');

      print('🔵 [CHECKPOINT] Calling _dapurService.createCheckpoint...');
      await _dapurService.createCheckpoint(
        menuHarianId: menuHarianId,
        tipe: tipe,
        foto: foto,
        deskripsi: deskripsi,
      );
      print('✅ [CHECKPOINT] Service call completed successfully');

      // Fetch updated checkpoint list
      print('🔵 [CHECKPOINT] Fetching updated checkpoint list...');
      await fetchCheckpointsByMenuHarian(menuHarianId);
      print('✅ [CHECKPOINT] Checkpoint list refreshed');

      print('✅ [CHECKPOINT] Showing success message');
      MBGLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Checkpoint berhasil ditambahkan',
      );

      // Wait briefly for success message to show, then navigate back
      print('🔵 [CHECKPOINT] Waiting before navigation...');
      await Future.delayed(const Duration(milliseconds: 500));

      print('🔵 [CHECKPOINT] Navigating back...');
      Get.back();
      print('✅ [CHECKPOINT] createCheckpoint completed successfully');
    } catch (e, stackTrace) {
      print('❌ [CHECKPOINT] Error in createCheckpoint: $e');
      print('❌ [CHECKPOINT] Error type: ${e.runtimeType}');
      print('❌ [CHECKPOINT] Stack trace: $stackTrace');

      MBGLoaders.errorSnackBar(
        title: 'Gagal menambahkan checkpoint',
        message: e.toString(),
      );
      // Don't rethrow - error already handled with snackbar
    } finally {
      isLoading.value = false;
      print('🔵 [CHECKPOINT] isLoading set to false');
    }
  }

  // ================================
  // FETCH CHECKPOINTS BY MENU HARIAN
  // ================================
  Future<void> fetchCheckpointsByMenuHarian(String menuHarianId) async {
    try {
      isLoading.value = true;
      print('🔵 [FETCH] Fetching checkpoints for menuHarianId: $menuHarianId');

      final data = await _dapurService.getCheckpointsByMenuHarian(menuHarianId);
      print('✅ [FETCH] Received ${data.length} checkpoints');

      checkpointList.assignAll(data);
      print('✅ [FETCH] Checkpoint list updated');
    } catch (e, stackTrace) {
      print('❌ [FETCH] Error fetching checkpoints: $e');
      print('❌ [FETCH] Error type: ${e.runtimeType}');
      print('❌ [FETCH] Stack trace: $stackTrace');

      MBGLoaders.errorSnackBar(
        title: 'Gagal memuat data checkpoint',
        message: e.toString(),
      );
      rethrow; // Rethrow to propagate error
    } finally {
      isLoading.value = false;
      print('🔵 [FETCH] isLoading set to false');
    }
  }
}
