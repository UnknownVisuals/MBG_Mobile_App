import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/controllers/camera_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBGImagePickerBottomSheet extends StatelessWidget {
  const MBGImagePickerBottomSheet({super.key, this.addWatermark = false});

  final bool addWatermark;

  @override
  Widget build(BuildContext context) {
    final CameraController cameraController =
        Get.isRegistered<CameraController>()
        ? Get.find<CameraController>()
        : Get.put(CameraController());

    return Container(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text('Pilih Gambar', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: MBGSizes.spaceBtwSections),

          // Camera Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await cameraController.captureImageWithCamera(
                  addWatermark: addWatermark,
                );
              },
              icon: const Icon(Iconsax.camera),
              label: Text(
                'Ambil dari Kamera',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: MBGSizes.spaceBtwItems),

          // Gallery Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await cameraController.pickImageFromGallery(
                  addWatermark: addWatermark,
                );
              },
              icon: const Icon(Iconsax.gallery),
              label: Text(
                'Ambil dari Galeri',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: MBGSizes.spaceBtwSections),
        ],
      ),
    );
  }

  /// Static method to show the bottom sheet
  static void show({required BuildContext context, bool addWatermark = false}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return MBGImagePickerBottomSheet(addWatermark: addWatermark);
      },
    );
  }
}
