import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbg_mobile_app/features/dapur/models/checkpoint_model.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_harian_model.dart';
import 'package:mbg_mobile_app/utils/http/dapur_service.dart';
import 'package:mbg_mobile_app/utils/popups/loaders.dart';

class CheckpointController extends GetxController {
  final DapurService _dapurService = Get.find<DapurService>();
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final RxList<MenuHarianModel> todayMenus = <MenuHarianModel>[].obs;
  final Rx<MenuHarianModel?> selectedMenu = Rx<MenuHarianModel?>(null);
  final RxList<CheckpointModel> checkpoints = <CheckpointModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingCheckpoints = false.obs;

  @override
  void onInit() {
    super.onInit();
    // In a real app, fetch today's menus from the API
    // For now, we'll need to implement this based on menu planning
  }

  /// Fetch checkpoints for a specific menu harian
  Future<void> fetchCheckpoints(String menuHarianId) async {
    try {
      isLoadingCheckpoints.value = true;
      final data = await _dapurService.getCheckpointsByMenuHarian(menuHarianId);
      checkpoints.value = data;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to fetch checkpoints: ${e.toString()}',
      );
    } finally {
      isLoadingCheckpoints.value = false;
    }
  }

  /// Create a checkpoint with photo
  Future<bool> createCheckpoint({
    required String menuHarianId,
    required String tipe,
    File? foto,
  }) async {
    try {
      isLoading.value = true;

      await _dapurService.createCheckpoint(
        menuHarianId: menuHarianId,
        tipe: tipe,
        foto: foto,
      );

      MBGLoaders.successSnackBar(
        title: 'Success',
        message: 'Checkpoint created successfully',
      );

      await fetchCheckpoints(menuHarianId);
      return true;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to create checkpoint: ${e.toString()}',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to capture photo: ${e.toString()}',
      );
      return null;
    }
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      MBGLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to pick photo: ${e.toString()}',
      );
      return null;
    }
  }

  /// Select a menu to view its checkpoints
  void selectMenu(MenuHarianModel menu) {
    selectedMenu.value = menu;
    fetchCheckpoints(menu.id);
  }

  /// Clear selected menu
  void clearSelection() {
    selectedMenu.value = null;
    checkpoints.clear();
  }

  /// Get checkpoint types
  List<String> getCheckpointTypes() {
    return [
      'MULAI_MEMASAK',
      'SELESAI_MEMASAK',
      'SELESAI_PACKING',
      'KITCHEN_RECEIVED',
      'WASHING_COMPLETE',
      'SCHOOL_TO_DRIVER_RETURN',
      'DRIVER_TO_KITCHEN',
    ];
  }

  /// Get friendly name for checkpoint type
  String getCheckpointTypeName(String type) {
    switch (type) {
      case 'MULAI_MEMASAK':
        return 'Start Cooking';
      case 'SELESAI_MEMASAK':
        return 'Finished Cooking';
      case 'SELESAI_PACKING':
        return 'Finished Packing';
      case 'KITCHEN_RECEIVED':
        return 'Kitchen Received';
      case 'WASHING_COMPLETE':
        return 'Washing Complete';
      case 'SCHOOL_TO_DRIVER_RETURN':
        return 'School to Driver Return';
      case 'DRIVER_TO_KITCHEN':
        return 'Driver to Kitchen';
      default:
        return type;
    }
  }
}
