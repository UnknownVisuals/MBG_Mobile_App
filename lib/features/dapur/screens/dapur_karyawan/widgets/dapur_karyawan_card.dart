import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_karyawan_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_karyawan/widgets/dapur_karyawan_edit.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Karyawan content widget with grid view
class DapurKaryawanCard extends StatelessWidget {
  const DapurKaryawanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurKaryawanController dapurKaryawanController = Get.put(
      DapurKaryawanController(),
    );

    return Obx(
      () => GridView.builder(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: MBGSizes.gridViewSpacing,
          mainAxisSpacing: MBGSizes.gridViewSpacing,
          childAspectRatio: 0.44,
        ),
        itemCount: dapurKaryawanController.karyawanList.length,
        itemBuilder: (context, index) {
          final karyawan = dapurKaryawanController.karyawanList[index];
          final isDeleting =
              dapurKaryawanController.deletingKaryawanId.value == karyawan.id;
          return Container(
            decoration: BoxDecoration(
              color: MBGColors.light,
              border: Border.all(color: MBGColors.grey),
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Picture
                AspectRatio(
                  aspectRatio: 4 / 5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(MBGSizes.borderRadiusLg),
                    ),
                    child: Image.network(
                      karyawan.fotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: MBGColors.grey,
                          child: const Icon(
                            Iconsax.profile,
                            size: MBGSizes.iconLg,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Profile Details
                Padding(
                  padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        karyawan.nama,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: MBGSizes.spaceBtwItems / 2),

                      // Posisi
                      Row(
                        children: [
                          const Icon(
                            Iconsax.briefcase,
                            size: MBGSizes.iconSm,
                            color: MBGColors.primary,
                          ),
                          const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                          Text(
                            karyawan.posisi,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: MBGColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      const SizedBox(height: MBGSizes.spaceBtwItems),

                      // Status
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: MBGSizes.sm,
                          vertical: MBGSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: karyawan.status == 'AKTIF'
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            MBGSizes.borderRadiusSm,
                          ),
                          border: Border.all(
                            color: karyawan.status == 'AKTIF'
                                ? Colors.green.withValues(alpha: 0.8)
                                : Colors.red.withValues(alpha: 0.8),
                          ),
                        ),
                        child: Text(
                          karyawan.status,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: karyawan.status == 'AKTIF'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),

                      const SizedBox(height: MBGSizes.spaceBtwItems / 2),
                      const Divider(color: MBGColors.darkGrey),
                      const SizedBox(height: MBGSizes.spaceBtwItems / 2),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: MBGColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  side: BorderSide(
                                    color: MBGColors.primary.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      MBGSizes.borderRadiusSm,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  _openEditForm(karyawan: karyawan);
                                },
                                child: const Icon(
                                  Iconsax.edit,
                                  size: MBGSizes.iconSm,
                                  color: MBGColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: MBGSizes.spaceBtwItems / 2),
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.red.withValues(
                                    alpha: 0.15,
                                  ),
                                  side: BorderSide(
                                    color: Colors.red.withValues(alpha: 0.7),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      MBGSizes.borderRadiusSm,
                                    ),
                                  ),
                                ),
                                onPressed: isDeleting
                                    ? null
                                    : () {
                                        _confirmDelete(
                                          context: context,
                                          controller: dapurKaryawanController,
                                          karyawan: karyawan,
                                        );
                                      },
                                child: isDeleting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.red,
                                              ),
                                        ),
                                      )
                                    : const Icon(
                                        Iconsax.trash,
                                        size: MBGSizes.iconSm,
                                        color: Colors.red,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openEditForm({required KaryawanModel karyawan}) {
    Get.to(() => DapurKaryawanEdit(karyawan: karyawan));
  }

  void _confirmDelete({
    required BuildContext context,
    required DapurKaryawanController controller,
    required KaryawanModel karyawan,
  }) {
    Get.dialog(
      Obx(() {
        final isDeleting = controller.deletingKaryawanId.value == karyawan.id;
        return AlertDialog(
          title: const Text('Hapus Karyawan'),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${karyawan.nama}? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Get.back(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: isDeleting
                  ? null
                  : () async {
                      await controller.deleteKaryawan(karyawanId: karyawan.id);
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: isDeleting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Hapus'),
            ),
          ],
        );
      }),
      barrierDismissible: false,
    );
  }
}
