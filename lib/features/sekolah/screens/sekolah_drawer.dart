import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_footer.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_header.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/logout_controller.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:sidebarx/sidebarx.dart';

/// Drawer Sidebar untuk role SEKOLAH (versi sempurna)
class SekolahDrawer extends StatelessWidget {
  const SekolahDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final logoutController = Get.put(LogoutController());
    final sekolahController = Get.put(SekolahController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      elevation: 4,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      child: Obx(
        () => SidebarX(
          controller: SidebarXController(
            selectedIndex: sekolahController.drawerSelectedIndex.value,
            extended: true,
          ),
          theme: SidebarXTheme(
            margin: const EdgeInsets.symmetric(vertical: MBGSizes.sm),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
            ),
            hoverColor: isDark
                ? MBGColors.white.withOpacity(0.05)
                : MBGColors.primary.withOpacity(0.08),
            textStyle: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            selectedTextStyle: const TextStyle(
              color: MBGColors.white,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(
              color: isDark ? Colors.white70 : MBGColors.dark,
            ),
            selectedIconTheme: const IconThemeData(color: MBGColors.white),
            itemPadding: const EdgeInsets.symmetric(
                vertical: MBGSizes.sm, horizontal: MBGSizes.md),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              gradient: MBGColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: MBGColors.primary.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          // Header
          headerBuilder: (context, extended) =>
              MBGDrawerHeader(userController: userController),

          // Menu Items
          items: [
            SidebarXItem(
              icon: Iconsax.home,
              label: '  Dashboard',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 0;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.teacher,
              label: '  Sekolah Info',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 1;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.buildings,
              label: '  Kelas',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 2;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.profile_2user,
              label: '  Siswa',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 3;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.calendar_1,
              label: '  Absensi',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 4;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.health,
              label: '  Nutrisi',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 5;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.box,
              label: '  Receive Delivery',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 6;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.menu_board,
              label: '  Menu',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 7;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.clock,
              label: '  Delivery History',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 8;
                Navigator.pop(context);
              },
            ),
            // SidebarXItem(
            //   icon: Iconsax.scan_barcode,
            //   label: 'Scan QR',
            //   onTap: () {
            //     sekolahController.drawerSelectedIndex.value = 9;
            //     Navigator.pop(context);
            //   },
            // ),
            SidebarXItem(
              icon: Iconsax.chart,
              label: '  Laporan',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 9;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.setting,
              label: '  Pengaturan',
              onTap: () {
                sekolahController.drawerSelectedIndex.value = 10;
                Navigator.pop(context);
              },
            ),
          ],

          // Footer
          footerBuilder: (context, extended) => Container(
            padding: const EdgeInsets.symmetric(
                vertical: MBGSizes.md, horizontal: MBGSizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const SizedBox(height: MBGSizes.sm),
                MBGDrawerFooter(logoutController: logoutController),
                const SizedBox(height: MBGSizes.sm),
                Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          showToggleButton: false,
        ),
      ),
    );
  }
}
