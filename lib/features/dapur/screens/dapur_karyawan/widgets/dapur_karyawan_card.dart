import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_karyawan_model.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_karyawan/widgets/dapur_karyawan_delete.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_karyawan/widgets/dapur_karyawan_edit.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurKaryawanCard extends StatelessWidget {
  const DapurKaryawanCard({super.key, required this.karyawan});

  final DapurKaryawanModel karyawan;

  @override
  Widget build(BuildContext context) {
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
              child: karyawan.fotoUrl != null
                  ? Image.network(
                      karyawan.fotoUrl!,
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
                    )
                  : Container(
                      color: MBGColors.grey,
                      child: const Icon(Iconsax.profile, size: MBGSizes.iconLg),
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
                    Expanded(
                      child: Text(
                        karyawan.posisi,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: MBGColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
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
                    color: karyawan.status == KaryawanStatus.AKTIF
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusSm,
                    ),
                    border: Border.all(
                      color: karyawan.status == KaryawanStatus.AKTIF
                          ? Colors.green.withValues(alpha: 0.8)
                          : Colors.red.withValues(alpha: 0.8),
                    ),
                  ),
                  child: Text(
                    karyawan.status.displayName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: karyawan.status == KaryawanStatus.AKTIF
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: MBGSizes.spaceBtwItems / 2),
                const Divider(color: MBGColors.darkGrey),
                const SizedBox(height: MBGSizes.spaceBtwItems / 2),

                // Edit Buttton and Delete Button
                Row(
                  children: [
                    // Edit Button
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
                              color: MBGColors.primary.withValues(alpha: 0.7),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                MBGSizes.borderRadiusSm,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => DapurKaryawanEdit(karyawan: karyawan));
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
                    // Delete Button
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.red.withValues(alpha: 0.15),
                            side: BorderSide(
                              color: Colors.red.withValues(alpha: 0.7),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                MBGSizes.borderRadiusSm,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.dialog(
                              DapurKaryawanDelete(karyawan: karyawan),
                              barrierDismissible: false,
                            );
                          },
                          child: const Icon(
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
  }
}
