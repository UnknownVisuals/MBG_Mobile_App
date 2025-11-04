import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_drawer.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/logout_controller.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_dashboard_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_delivery_history_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_my_deliveries_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_qr_scanner_controller.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_delivery_history/driver_delivery_history_screen.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_dashboard/driver_dashboard_screen.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_my_deliveries/driver_my_deliveries_screen.dart';
import 'package:mbg_mobile_app/features/driver/screens/driver_qr_scanner/driver_qr_scanner_screen.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final logoutController = Get.find<LogoutController>();
    final driverController = Get.put(DriverController());

    // Ensure per-screen controllers are available while the driver shell is active
    if (!Get.isRegistered<DriverDashboardController>()) {
      Get.put(DriverDashboardController());
    }
    if (!Get.isRegistered<DriverMyDeliveriesController>()) {
      Get.put(DriverMyDeliveriesController());
    }
    if (!Get.isRegistered<DriverQrScannerController>()) {
      Get.put(DriverQrScannerController());
    }
    if (!Get.isRegistered<DriverDeliveryHistoryController>()) {
      Get.put(DriverDeliveryHistoryController());
    }

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
        drawer: DriverDrawer(
          userController: userController,
          logoutController: logoutController,
          driverController: driverController,
        ),
        body: IndexedStack(
          index: driverController.drawerSelectedIndex.value,
          children: const [
            // 0 - Dashboard
            DriverDashboardScreen(),
            // 1 - My Deliveries
            DriverMyDeliveriesScreen(),
            // 2 - QR Scanner
            DriverQrScannerScreen(),
            // 3 - History
            DriverDeliveryHistoryScreen(),
          ],
        ),
      ),
    );
  }
}
