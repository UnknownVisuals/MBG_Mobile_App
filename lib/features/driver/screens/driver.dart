import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_driver.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_controller.dart';
import 'package:mbg_mobile_app/features/driver/screens/delivery_history/delivery_history_screen.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/driver_dashboard_screen.dart';
import 'package:mbg_mobile_app/features/driver/screens/my_deliveries_screen.dart';
import 'package:mbg_mobile_app/features/driver/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:mbg_mobile_app/features/setting/sceens/setting.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final driverController = Get.put(DriverController());

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
        drawer: MBGDrawerDriver(
          userController: userController,
          driverController: driverController,
        ),
        body: IndexedStack(
          index: driverController.drawerSelectedIndex.value,
          children: const [
            // 0 - Dashboard
            DriverDashboardScreen(),
            // 1 - My Deliveries
            MyDeliveriesScreen(),
            // 2 - QR Scanner
            QRScannerScreen(),
            // 3 - History
            DeliveryHistoryScreen(),
            // 4 - Setting
            SettingScreen(),
          ],
        ),
      ),
    );
  }
}
