import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_dashboard/widgets/sekolah_dashboard_stat_card.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_dashboard/widgets/sekolah_dashboard_pending_delivery.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_dashboard/widgets/sekolah_dashboard_today_menu.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
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
              // 📊 STATISTICS
              const SekolahDashboardStatCard(),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // 🍱 TODAY’S MENU
              const MBGSectionHeading(title: 'Menu Hari Ini'),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              const SekolahDashboardTodayMenu(),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // 🚚 PENDING DELIVERIES
              const MBGSectionHeading(title: 'Pengiriman'),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              const SekolahDashboardPendingDelivery(),
              const SizedBox(height: MBGSizes.spaceBtwSections * 2),
            ],
          ),
        ),
      ),
    );
  }
}
