import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_controller.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_checkpoint/driver_checkpoint_screen.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/driver_dashboard_screen.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_drawer.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_tray_return/driver_tray_return_screen.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final driverController = Get.put(DriverController());

    return Obx(
      () => Scaffold(
        appBar: MBGAppBar(
          showDrawerIcon: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang Kembali',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                'Halo, ${userController.userModel.value?.name ?? 'Driver'}!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        drawer: const DriverDrawer(),
        body: IndexedStack(
          index: driverController.drawerSelectedIndex.value,
          children: [
            // 0 - Dashboard
            DriverDashboardScreen(),
            // 1 - Checkpoint
            DriverCheckpointScreen(),
            // 2 - Tray Return
            DriverTrayReturnScreen(),
          ],
        ),
      ),
    );
  }
}
