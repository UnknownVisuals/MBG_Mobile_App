import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kalender_akademik_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kalender_akademik/widgets/sekolah_event_list.dart';
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
      appBar: const MBGAppBar(
        title: Text('Kalender Akademik'),
        showBackArrow: false,
      ),
      body: Obx(() {
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
              Expanded(child: SekolahEventList(events: controller.allKalender)),
            ],
          ),
        );
      }),
    );
  }
}
