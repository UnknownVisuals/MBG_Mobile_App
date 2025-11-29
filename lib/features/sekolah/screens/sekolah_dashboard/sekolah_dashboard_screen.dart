import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

// Widgets
import 'widgets/sekolah_dashboard_header.dart';
import 'widgets/attendance_summary_widget.dart';
import 'widgets/sekolah_action_cards_widget.dart';
import 'widgets/sekolah_dashboard_today_menu.dart';
import 'widgets/sekolah_dashboard_pending_delivery.dart';

import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_dashboard_controller.dart';

/// 📄 Sekolah Dashboard Screen — Final Version (UI Only)
class SekolahDashboardScreen extends StatelessWidget {
  const SekolahDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SekolahDashboardController());

    return Scaffold(
      body: RefreshIndicator(
        color: MBGColors.primary,
        onRefresh: () async {
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MBGSpacingStyles.homeScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧩 HEADER
              const SekolahDashboardHeader(),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // 📊 ATTENDANCE SUMMARY
              const AttendanceSummaryWidget(),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // 🧮 ACTION CARDS
              const SekolahActionCardsWidget(),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // 🍱 TODAY’S MENU
              const SekolahDashboardTodayMenu(),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // 🚚 PENDING DELIVERIES
              const SekolahDashboardPendingDelivery(),
              const SizedBox(height: MBGSizes.spaceBtwSections * 2),
            ],
          ),
        ),
      ),
    );
  }
}
