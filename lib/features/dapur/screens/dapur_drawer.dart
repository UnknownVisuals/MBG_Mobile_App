import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_footer.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_header.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/logout_controller.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:sidebarx/sidebarx.dart';

/// Drawer for PIC_DAPUR role
class DapurDrawer extends StatelessWidget {
  const DapurDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final logoutController = Get.put(LogoutController());
    final dapurController = Get.put(DapurController());

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      child: Obx(
        () => SidebarX(
          controller: SidebarXController(
            selectedIndex: dapurController.drawerSelectedIndex.value,
            extended: true,
          ),

          /// ---- THEME ----
          theme: SidebarXTheme(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                right: BorderSide(
                  width: 1,
                  color: colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),

            // ICON Colors
            iconTheme: IconThemeData(
              color: isDark ? colorScheme.onSurface : MBGColors.dark,
            ),
            selectedIconTheme: const IconThemeData(color: MBGColors.white),

            // TEXT Colors
            textStyle: TextStyle(
              color: isDark ? colorScheme.onSurface : MBGColors.dark,
            ),
            selectedTextStyle: const TextStyle(
              color: MBGColors.white,
              fontWeight: FontWeight.w600,
            ),

            // Padding
            itemTextPadding:
                const EdgeInsets.only(left: MBGSizes.spaceBtwItems),
            selectedItemTextPadding:
                const EdgeInsets.only(left: MBGSizes.spaceBtwItems),

            itemPadding: const EdgeInsets.all(MBGSizes.md),
            selectedItemPadding: const EdgeInsets.all(MBGSizes.md),

            itemMargin: const EdgeInsets.symmetric(
              horizontal: MBGSizes.md,
              vertical: MBGSizes.xs,
            ),
            selectedItemMargin: const EdgeInsets.symmetric(
              horizontal: MBGSizes.md,
              vertical: MBGSizes.xs,
            ),

            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              gradient: MBGColors.primaryGradient,
            ),
          ),

          /// ---- HEADER ----
          headerBuilder: (context, extended) =>
              MBGDrawerHeader(userController: userController),

          /// ---- ITEMS ----
          items: [
            SidebarXItem(
              icon: Iconsax.home,
              label: 'Dashboard',
              onTap: () {
                dapurController.drawerSelectedIndex.value = 0;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.building,
              label: 'Dapur',
              onTap: () {
                dapurController.drawerSelectedIndex.value = 1;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.people,
              label: 'Karyawan',
              onTap: () {
                dapurController.drawerSelectedIndex.value = 2;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.box,
              label: 'Stok',
              onTap: () {
                dapurController.drawerSelectedIndex.value = 3;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.calendar,
              label: 'Menu Planning',
              onTap: () {
                dapurController.drawerSelectedIndex.value = 4;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.camera,
              label: 'Checkpoint',
              onTap: () {
                dapurController.drawerSelectedIndex.value = 5;
                Navigator.pop(context);
              },
            ),
            SidebarXItem(
              icon: Iconsax.truck_fast,
              label: 'Pengiriman',
              onTap: () {
                dapurController.drawerSelectedIndex.value = 6;
                Navigator.pop(context);
              },
            ),
          ],

          /// ---- FOOTER ----
          footerBuilder: (context, extended) =>
              MBGDrawerFooter(logoutController: logoutController),

          showToggleButton: false,
        ),
      ),
    );
  }
}
