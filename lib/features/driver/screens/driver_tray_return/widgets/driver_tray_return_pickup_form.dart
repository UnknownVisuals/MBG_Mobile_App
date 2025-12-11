import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_tray_return_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/validators/validation.dart';

class DriverTrayReturnPickupForm extends StatelessWidget {
  const DriverTrayReturnPickupForm({super.key, required this.qrCodeId});

  final String qrCodeId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTrayReturnController>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: MBGSizes.md,
        right: MBGSizes.md,
        top: MBGSizes.md,
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MBGSectionHeading(title: 'Pickup Tray'),
            Text(
              qrCodeId,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
            ),
            const SizedBox(height: MBGSizes.spaceBtwSections),

            // Photo Picker
            Obx(() {
              final image = controller.selectedPhoto.value;
              return GestureDetector(
                onTap: () => _showImageSourceModal(context, controller),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: MBGColors.borderPrimary),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                    color: MBGColors.grey.withValues(alpha: 0.1),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            MBGSizes.borderRadiusMd,
                          ),
                          child: Image.file(image, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.camera,
                              size: 40,
                              color: MBGColors.textSecondary,
                            ),
                            SizedBox(height: MBGSizes.sm),
                            Text(
                              'Ambil Foto Bukti',
                              style: TextStyle(color: MBGColors.textSecondary),
                            ),
                          ],
                        ),
                ),
              );
            }),
            const SizedBox(height: MBGSizes.spaceBtwInputFields),

            // Input Jumlah
            TextFormField(
              controller: controller.jumlahTrayController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Tray Diterima',
                prefixIcon: Icon(Iconsax.box),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => MBGValidator.validateRequired(
                value,
                fieldName: 'Jumlah Tray',
              ),
            ),

            const SizedBox(height: MBGSizes.spaceBtwSections),

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () => controller.submitPickup(qrCodeId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MBGColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: MBGSizes.md),
                  ),
                  child: Text(
                    controller.isSubmitting.value
                        ? 'Memproses...'
                        : 'Konfirmasi Pickup',
                    style: const TextStyle(color: MBGColors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: MBGSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }

  void _showImageSourceModal(
    BuildContext context,
    DriverTrayReturnController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(MBGSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.gallery),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
