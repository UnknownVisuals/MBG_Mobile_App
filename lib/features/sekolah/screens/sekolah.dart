import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_delivery/sekolah_delivery_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_drawer.dart';

// Screens
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_dashboard/sekolah_dashboard_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_info/sekolah_info_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kalender_akademik/sekolah_kalendar_akademik_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kelas/sekolah_kelas_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_siswa/sekolah_siswa_screen.dart';

class SekolahScreen extends StatelessWidget {
  const SekolahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    final SekolahController sekolahController = Get.put(SekolahController());

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
                "Halo, ${userController.userModel.value?.name ?? 'Guru Sekolah'}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        drawer: const SekolahDrawer(),
        body: IndexedStack(
          index: sekolahController.drawerSelectedIndex.value,
          children: const [
            // 0 - Dashboard
            SekolahDashboardScreen(),
            // 1 - Sekolah Info
            SekolahInfoScreen(),
            // 2 - Kelas
            SekolahKelasScreen(),
            // 3 - Siswa
            SekolahSiswaScreen(),
            // 4 - Absensi
            SekolahKalendarAkademikScreen(),
            // 5 - Delivery
            SekolahDeliveryScreen(),
          ],
        ),
      ),
    );
  }
}
