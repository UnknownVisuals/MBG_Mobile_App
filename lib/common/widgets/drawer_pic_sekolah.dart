import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_footer.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_header.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:sidebarx/sidebarx.dart';

/// Drawer for PIC_SEKOLAH role
class MBGDrawerPicSekolah extends StatelessWidget {
  const MBGDrawerPicSekolah({
    super.key,
    required this.userController,
    required this.sekolahController,
  });

  final UserController userController;
  final SekolahController sekolahController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Expanded(
        child: Obx(
          () => SidebarX(
            controller: SidebarXController(
              selectedIndex: sekolahController.drawerSelectedIndex.value,
              extended: true,
            ),
            // Theme
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
            // Drawer Header
            headerBuilder: (context, extended) =>
                MBGDrawerHeader(userController: userController),
            // Drawer Items - PIC_SEKOLAH specific
            items: [
              SidebarXItem(
                icon: Iconsax.home,
                label: 'Dashboard',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 0;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.buildings,
                label: 'Sekolah',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 1;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.teacher,
                label: 'Kelas',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 2;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.people,
                label: 'Siswa',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 3;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.clipboard_tick,
                label: 'Absensi',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 4;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.heart,
                label: 'Nutrisi',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 5;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.scan,
                label: 'Receive Delivery',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 6;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.calendar,
                label: 'Menu',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 7;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.truck_fast,
                label: 'Delivery History',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 8;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.calendar_2,
                label: 'Kalender Akademik',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 9;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.setting,
                label: 'Setting',
                onTap: () {
                  sekolahController.drawerSelectedIndex.value = 10;
                  Navigator.of(context).pop();
                },
              ),
            ],
            // Drawer Footer
            footerBuilder: (context, extended) =>
                MBGDrawerFooter(userController: userController),
            showToggleButton: false,
          ),
        ),
      ),
    );
  }
}
