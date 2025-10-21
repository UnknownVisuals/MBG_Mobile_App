import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_pic_sekolah.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/absensi_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/kelas_management_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/menu_view_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/nutrition_monitor_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/receive_delivery_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_dashboard_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_management_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/siswa_management_screen.dart';
import 'package:mbg_mobile_app/features/setting/sceens/setting.dart';

class SekolahScreen extends StatelessWidget {
  const SekolahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final sekolahController = Get.put(SekolahController());

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
        drawer: MBGDrawerPicSekolah(
          userController: userController,
          sekolahController: sekolahController,
        ),
        body: IndexedStack(
          index: sekolahController.drawerSelectedIndex.value,
          children: const [
            // 0 - Dashboard
            SekolahDashboardScreen(),
            // 1 - Sekolah
            SekolahManagementScreen(),
            // 2 - Kelas
            KelasManagementScreen(),
            // 3 - Siswa
            SiswaManagementScreen(),
            // 4 - Absensi
            AbsensiScreen(),
            // 5 - Nutrisi
            NutritionMonitorScreen(),
            // 6 - Receive Delivery
            ReceiveDeliveryScreen(),
            // 7 - Menu
            MenuViewScreen(),
            // 8 - Setting
            SettingScreen(),
          ],
        ),
      ),
    );
  }
}
