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

class SekolahSiswaScreen extends StatefulWidget {
  const SekolahSiswaScreen({super.key});

  @override
  State<SekolahSiswaScreen> createState() => _SekolahSiswaScreenState();
}

class _SekolahSiswaScreenState extends State<SekolahSiswaScreen> {
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

        return Column(
          children: [
            const SizedBox(height: MBGSizes.spaceBtwSections),
            _PaginationSection(controller: controller),
            const SizedBox(height: MBGSizes.spaceBtwItems),
            Expanded(
              child: RefreshIndicator(
                color: MBGColors.primary,
                onRefresh: controller.refreshSiswa,
                child: ListView.builder(
                  padding: MBGSpacingStyles.homeScreenPadding,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.siswaList.length,
                  itemBuilder: (context, index) {
                    final siswa = controller.siswaList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SekolahSiswaCardWidget(
                        siswa: siswa,
                        onTap: () => _openEditor(context, siswa, controller),
                        onDelete: () =>
                            _confirmDelete(context, siswa, controller),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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

class _PaginationSection extends StatelessWidget {
  const _PaginationSection({required this.controller});

  final SekolahSiswaController controller;

  @override
  Widget build(BuildContext context) {
    final hasPaginationData = controller.totalItems.value > 0;
    if (!hasPaginationData) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MBGSizes.spaceBtwItems),
      padding: const EdgeInsets.all(MBGSizes.sm),
      decoration: BoxDecoration(
        border: Border.all(color: MBGColors.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(MBGSizes.cardRadiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Iconsax.previous),
            onPressed: controller.currentPage.value > 1
                ? () {
                    final sekolahId = controller.sekolahId;
                    if (sekolahId != null) {
                      controller.currentPage.value = 1;
                      controller.fetchSiswa(sekolahId, page: 1);
                    }
                  }
                : null,
            tooltip: 'Halaman Pertama',
          ),
          IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: controller.canGoPreviousPage
                ? () {
                    controller.goToPreviousPage();
                  }
                : null,
            tooltip: 'Halaman Sebelumnya',
          ),
          Text(
            '${controller.currentPage.value} dari ${controller.totalPages.value}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          IconButton(
            icon: const Icon(Iconsax.arrow_right_3),
            onPressed: controller.canGoNextPage
                ? () {
                    controller.goToNextPage();
                  }
                : null,
            tooltip: 'Halaman Berikutnya',
          ),
          IconButton(
            icon: const Icon(Iconsax.next),
            onPressed:
                controller.currentPage.value < controller.totalPages.value
                ? () {
                    final sekolahId = controller.sekolahId;
                    if (sekolahId != null) {
                      controller.currentPage.value =
                          controller.totalPages.value;
                      controller.fetchSiswa(
                        sekolahId,
                        page: controller.totalPages.value,
                      );
                    }
                  }
                : null,
            tooltip: 'Halaman Terakhir',
          ),
        ],
      ),
    );
  }
}
