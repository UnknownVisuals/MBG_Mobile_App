import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_pic_dapur.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/checkpoint/checkpoint_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/dapur_dashboard_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_management_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/karyawan_management/karyawan_management_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/menu_planning/menu_planning_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/pengiriman/pengiriman_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/stok_management/stok_management_screen.dart';
import 'package:mbg_mobile_app/features/setting/sceens/setting.dart';

class DapurScreen extends StatelessWidget {
  const DapurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final dapurController = Get.put(DapurController());

    return Obx(
      () => Scaffold(
        appBar: MBGAppBar(
          showDrawerIcon: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang Kembali",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                "Halo, ${userController.user.value?.name ?? ''}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        drawer: MBGDrawerPicDapur(
          userController: userController,
          dapurController: dapurController,
        ),
        body: IndexedStack(
          index: dapurController.drawerSelectedIndex.value,
          children: [
            // 0 - Dashboard
            // Padding(
            //   padding: MBGSpacingStyles.homeScreenPadding,
            //   child: Obx(
            //     () => Column(
            //       children: [
            //         // Progress Summary Card
            //         ProgressSummaryCard(
            //           completedCount: dapurController.completedCount.value,
            //           totalCount: dapurController.totalCount.value,
            //         ),
            //         const SizedBox(height: MBGSizes.spaceBtwSections),

            //         // Timeline Header
            //         const TimelineHeader(),
            //         const SizedBox(height: MBGSizes.spaceBtwItems),

            //         // Timeline List
            //         Expanded(
            //           child: TimelineList(
            //             events: dapurController.events.toList(),
            //             scrollController: dapurController.scrollController,
            //             cardKeys: dapurController.cardKeys,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const DapurDashboardScreen(),
            // 1 - Dapur Management
            const DapurManagementScreen(),
            // 2 - Karyawan
            const KaryawanManagementScreen(),
            // 3 - Stok
            const StokManagementScreen(),
            // 4 - Menu Planning
            const MenuPlanningScreen(),
            // 5 - Checkpoint
            const CheckpointScreen(),
            // 6 - Pengiriman
            const PengirimanScreen(),
            // 7 - Setting
            const SettingScreen(),
          ],
        ),
      ),
    );
  }
}
