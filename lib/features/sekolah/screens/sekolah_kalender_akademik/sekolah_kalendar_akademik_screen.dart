import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kalender_akademik_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kalender_akademik/widgets/sekolah_event_list.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kalender_akademik/widgets/sekolah_kalender_akademik_add.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kalender_akademik/widgets/sekolah_main_kalendar.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahKalendarAkademikScreen extends StatelessWidget {
  const SekolahKalendarAkademikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SekolahKalenderAkademikController controller =
        Get.isRegistered<SekolahKalenderAkademikController>()
        ? Get.find()
        : Get.put(SekolahKalenderAkademikController());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.fetchKalenderAkademik,
        child: Obx(() {
          if (controller.isLoading.value && controller.allKalender.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: MBGColors.primary),
            );
          }

          return Padding(
            padding: MBGSpacingStyles.homeScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SekolahMainKalendar(controller: controller),
                const SizedBox(height: MBGSizes.spaceBtwSections),
                const MBGSectionHeading(title: 'Daftar Event'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                Expanded(
                  child: SekolahEventList(events: controller.allKalender),
                ),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const SekolahKalenderAkademikAdd()),
        label: const Text(
          'Tambah Event',
          style: TextStyle(color: MBGColors.white),
        ),
        icon: const Icon(Iconsax.add, color: MBGColors.white),
        backgroundColor: MBGColors.primary,
      ),
    );
  }
}
