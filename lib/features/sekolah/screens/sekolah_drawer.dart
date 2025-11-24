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

    return Drawer(
      child: Expanded(
        child: Obx(
          () => SidebarX(
            controller: SidebarXController(
              selectedIndex: sekolahController.drawerSelectedIndex.value,
              extended: true,
            ),
            theme: SidebarXTheme(
              // Icon Styles
              iconTheme: const IconThemeData(color: MBGColors.dark),
              selectedIconTheme: const IconThemeData(color: MBGColors.white),

              // Text Styles
              textStyle: const TextStyle(color: MBGColors.dark),
              selectedTextStyle: const TextStyle(color: MBGColors.white),

              // Item Text Padding
              itemTextPadding: const EdgeInsets.only(
                left: MBGSizes.spaceBtwItems,
              ),
              selectedItemTextPadding: const EdgeInsets.only(
                left: MBGSizes.spaceBtwItems,
              ),

              // Item Padding
              itemPadding: const EdgeInsets.all(MBGSizes.md),
              selectedItemPadding: const EdgeInsets.all(MBGSizes.md),

              // Item Margin
              itemMargin: const EdgeInsets.symmetric(
                horizontal: MBGSizes.md,
                vertical: MBGSizes.xs,
              ),
              selectedItemMargin: const EdgeInsets.symmetric(
                horizontal: MBGSizes.md,
                vertical: MBGSizes.xs,
              ),

              // Item Decoration
              selectedItemDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
                gradient: MBGColors.primaryGradient,
              ),
            ),

            // Header
            headerBuilder: (context, extended) =>
                MBGDrawerHeader(userController: userController),

            // Menu Items
            items: [
              SidebarXItem(
                icon: Iconsax.home,
                label: 'Dashboard',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 0;
                  Navigator.pop(context);
                },
              ),
              SidebarXItem(
                icon: Iconsax.teacher,
                label: 'Sekolah Info',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 1;
                  Navigator.pop(context);
                },
              ),
              SidebarXItem(
                icon: Iconsax.buildings,
                label: 'Kelas',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 2;
                  Navigator.pop(context);
                },
              ),
              SidebarXItem(
                icon: Iconsax.profile_2user,
                label: 'Siswa',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 3;
                  Navigator.pop(context);
                },
              ),
              SidebarXItem(
                icon: Iconsax.calendar_1,
                label: 'Kalender Akademik',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 4;
                  Navigator.pop(context);
                },
              ),

              SidebarXItem(
                icon: Iconsax.box,
                label: 'Delivery',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 5;
                  Navigator.pop(context);
                },
              ),
            ],

            // Drawer Footer
            footerBuilder: (context, extended) =>
                MBGDrawerFooter(logoutController: logoutController),
            showToggleButton: false,
          ),
        ),
      ),
    );
  }
}
