import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_siswa_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/models/sekolah_siswa_model.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_siswa/widgets/sekolah_siswa_add.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_siswa/widgets/sekolah_siswa_card.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_siswa/widgets/sekolah_siswa_delete.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_siswa/widgets/sekolah_siswa_update.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahSiswaScreen extends StatelessWidget {
  const SekolahSiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SekolahSiswaController controller =
        Get.isRegistered<SekolahSiswaController>()
        ? Get.find()
        : Get.put(SekolahSiswaController());

    if (!Get.isRegistered<SekolahKelasController>()) {
      Get.put(SekolahKelasController());
    }

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.siswaList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: MBGColors.primary),
          );
        }

        if (controller.siswaList.isEmpty) {
          return RefreshIndicator(
            color: MBGColors.primary,
            onRefresh: controller.refreshSiswa,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: MBGSpacingStyles.homeScreenPadding,
              children: [
                const SizedBox(height: MBGSizes.spaceBtwSections * 2),
                Icon(
                  Iconsax.profile_2user,
                  size: MBGSizes.iconLg * 2,
                  color: MBGColors.textSecondary,
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                Text(
                  'Belum ada siswa terdaftar',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: MBGColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                Text(
                  'Tambahkan siswa baru dengan menekan tombol di bawah.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MBGColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: MBGColors.primary,
          onRefresh: controller.refreshSiswa,
          child: ListView.separated(
            padding: MBGSpacingStyles.homeScreenPadding,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.siswaList.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final siswa = controller.siswaList[index];
              return SekolahSiswaCardWidget(
                siswa: siswa,
                onTap: () => _openEditor(context, siswa, controller),
                onDelete: () => _confirmDelete(context, siswa, controller),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.to(() => const SekolahSiswaAdd());
          await controller.refreshSiswa();
        },
        backgroundColor: MBGColors.primary,
        icon: Icon(Iconsax.profile_add, color: MBGColors.white),
        label: Text(
          'Tambah Siswa',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: MBGColors.white),
        ),
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    SekolahSiswaModel siswa,
    SekolahSiswaController controller,
  ) async {
    await Get.to(() => SekolahSiswaUpdate(siswa: siswa));
    await controller.refreshSiswa();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SekolahSiswaModel siswa,
    SekolahSiswaController controller,
  ) async {
    final confirmed = await SekolahSiswaDelete.show(
      context: context,
      siswa: siswa,
    );
    if (confirmed == true) {
      await controller.deleteSiswa(siswa.id);
    }
  }
}
