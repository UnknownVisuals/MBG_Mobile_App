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

class MBGDrawer extends StatelessWidget {
  const MBGDrawer({
    super.key,
    required this.userController,
    required this.logoutController,
    required this.dapurController,
  });

  final UserController userController;
  final LogoutController logoutController;
  final DapurController dapurController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Expanded(
        child: Obx(
          () => SidebarX(
            controller: SidebarXController(
              selectedIndex: dapurController.drawerSelectedIndex.value,
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
            // Drawer Items
            items: [
              SidebarXItem(
                icon: Iconsax.home,
                label: 'Home',
                onTap: () {
                  dapurController.drawerSelectedIndex.value = 0;
                  Navigator.of(context).pop(); // Close drawer
                },
              ),
              SidebarXItem(
                icon: Iconsax.setting,
                label: 'Setting',
                onTap: () {
                  dapurController.drawerSelectedIndex.value = 1;
                  Navigator.of(context).pop(); // Close drawer
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
