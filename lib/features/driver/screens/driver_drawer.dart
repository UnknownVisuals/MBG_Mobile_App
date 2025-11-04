import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_footer.dart';
import 'package:mbg_mobile_app/common/widgets/drawer_header.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/logout_controller.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/driver/controllers/driver_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:sidebarx/sidebarx.dart';

/// Drawer for DRIVER role placed inside driver feature folder.
class DriverDrawer extends StatelessWidget {
  const DriverDrawer({
    super.key,
    required this.userController,
    required this.logoutController,
    required this.driverController,
  });

  final UserController userController;
  final LogoutController logoutController;
  final DriverController driverController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Expanded(
        child: Obx(
          () => SidebarX(
            controller: SidebarXController(
              selectedIndex: driverController.drawerSelectedIndex.value,
              extended: true,
            ),
            theme: SidebarXTheme(
              iconTheme: const IconThemeData(color: MBGColors.dark),
              selectedIconTheme: const IconThemeData(color: MBGColors.white),
              textStyle: const TextStyle(color: MBGColors.dark),
              selectedTextStyle: const TextStyle(color: MBGColors.white),
              itemTextPadding: const EdgeInsets.only(
                left: MBGSizes.spaceBtwItems,
              ),
              selectedItemTextPadding: const EdgeInsets.only(
                left: MBGSizes.spaceBtwItems,
              ),
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
            headerBuilder: (context, extended) =>
                MBGDrawerHeader(userController: userController),
            items: [
              SidebarXItem(
                icon: Iconsax.home,
                label: 'Dashboard',
                onTap: () {
                  driverController.drawerSelectedIndex.value = 0;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.truck_fast,
                label: 'My Deliveries',
                onTap: () {
                  driverController.drawerSelectedIndex.value = 1;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.scan,
                label: 'QR Scanner',
                onTap: () {
                  driverController.drawerSelectedIndex.value = 2;
                  Navigator.of(context).pop();
                },
              ),
              SidebarXItem(
                icon: Iconsax.clock,
                label: 'History',
                onTap: () {
                  driverController.drawerSelectedIndex.value = 3;
                  Navigator.of(context).pop();
                },
              ),
            ],
            footerBuilder: (context, extended) =>
                MBGDrawerFooter(logoutController: logoutController),
            showToggleButton: false,
          ),
        ),
      ),
    );
  }
}
