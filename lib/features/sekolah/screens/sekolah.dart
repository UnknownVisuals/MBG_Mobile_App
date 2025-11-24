import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/laporan/laporan.screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_drawer.dart';

// Screens
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_dashboard/sekolah_dashboard_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_info/sekolah_info_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kelas_management/sekolah_kelas_management_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/siswa_management/siswa_management_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/absensi/absensi_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/receive_delivery/receive_delivery_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/menu_view/menu_view_screen.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/delivery_history/delivery_history_screen.dart';

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
            SiswaManagementScreen(),
            // 4 - Absensi
            AbsensiScreen(),
            // 5 - Receive Delivery
            ReceiveDeliveryScreen(),
            // 6 - Menu
            MenuViewScreen(),
            // 7 - Delivery History
            DeliveryHistoryScreen(),
            // 8 - Scan QR
            //SekolahQRScannerScreen(),
            // 9 - Laporan
            LaporanScreen(),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mbg_mobile_app/common/widgets/appbar.dart';
// import 'package:mbg_mobile_app/common/widgets/drawer_pic_sekolah.dart';
// import 'package:mbg_mobile_app/features/authentication/controllers/logout_controller.dart';
// import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/absensi_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_delivery_history_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_receive_delivery_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_menu_view_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_management_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_siswa_management_controller.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/absensi/absensi_screen.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/kelas_management/kelas_management_screen.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/menu_view/menu_view_screen.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/nutrition_monitor/nutrition_monitor_screen.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/receive_delivery/receive_delivery_screen.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_dashboard/sekolah_dashboard_screen.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_management/sekolah_management_screen.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/siswa_management/siswa_management_screen.dart';
// import 'package:mbg_mobile_app/features/sekolah/screens/delivery_history/delivery_history_screen.dart';
// import 'package:mbg_mobile_app/features/dapur/screens/dapur_kalender_akademik/kalender_akademik_screen.dart';

// class SekolahScreen extends StatelessWidget {
//   const SekolahScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final userController = Get.find<UserController>();
//     final logoutController = Get.find<LogoutController>();
//     final sekolahController = Get.put(SekolahController());

//     if (!Get.isRegistered<SekolahDeliveryHistoryController>()) {
//       Get.put(SekolahDeliveryHistoryController());
//     }
//     if (!Get.isRegistered<SekolahReceiveDeliveryController>()) {
//       Get.put(SekolahReceiveDeliveryController());
//     }
//     if (!Get.isRegistered<SekolahMenuViewController>()) {
//       Get.put(SekolahMenuViewController());
//     }
//     if (!Get.isRegistered<SekolahKelasManagementController>()) {
//       Get.put(SekolahKelasManagementController());
//     }
//     if (!Get.isRegistered<SekolahSiswaManagementController>()) {
//       Get.put(SekolahSiswaManagementController());
//     }
//     if (!Get.isRegistered<AbsensiController>()) {
//       Get.put(AbsensiController());
//     }

//     return Obx(
//       () => Scaffold(
//         appBar: MBGAppBar(
//           showDrawerIcon: true,
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Selamat Datang Kembali",
//                 style: Theme.of(context).textTheme.labelMedium,
//               ),
//               Text(
//                 "Halo, ${userController.userModel.value?.name ?? ''}!",
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         drawer: MBGDrawerPicSekolah(
//           userController: userController,
//           sekolahController: sekolahController,
//           logoutController: logoutController,
//         ),
//         body: IndexedStack(
//           index: sekolahController.drawerSelectedIndex.value,
//           children: const [
//             // 0 - Dashboard
//             SekolahDashboardScreen(),
//             // 1 - Sekolah
//             SekolahManagementScreen(),
//             // 2 - Kelas
//             KelasManagementScreen(),
//             // 3 - Siswa
//             SiswaManagementScreen(),
//             // 4 - Absensi
//             AbsensiScreen(),
//             // 5 - Nutrisi
//             NutritionMonitorScreen(),
//             // 6 - Receive Delivery
//             ReceiveDeliveryScreen(),
//             // 7 - Menu
//             MenuViewScreen(),
//             // 8 - Delivery History
//             DeliveryHistoryScreen(),
//             // 9 - Kalender Akademik
//             KalenderAkademikScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }
