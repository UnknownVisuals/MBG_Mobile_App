import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_drawer.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_checkpoint/dapur_checkpoint_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_dashboard/dapur_dashboard_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/dapur_info_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_karyawan/dapur_karyawan_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/dapur_menu_planning_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_pengiriman/dapur_pengiriman_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_stok/dapur_stock_screen.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_tray_return/dapur_tray_return_screen.dart';

class DapurScreen extends StatelessWidget {
  const DapurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final DapurController dapurController = Get.put(DapurController());

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
                "Halo, ${userController.userModel.value?.name ?? ''}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        drawer: DapurDrawer(),
        body: IndexedStack(
          index: dapurController.drawerSelectedIndex.value,
          children: [
            // 0 - Dashboard
            DapurDashboardScreen(),
            // 1 - Dapur Info
            DapurInfoScreen(),
            // 2 - Karyawan
            DapurKaryawanScreen(),
            // 3 - Stok
            DapurStokScreen(),
            // 4 - Menu Planning
            DapurMenuPlanningScreen(),
            // 5 - Checkpoint
            DapurCheckpointScreen(),
            // 6 - Pengiriman
            DapurPengirimanScreen(),
            // 7 - Tray Return
            DapurTrayReturnScreen(),
          ],
        ),
      ),
    );
  }
}
