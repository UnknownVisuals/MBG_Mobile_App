import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/navigation_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.put(
      NavigationController(),
    );
    final isDark = MBGHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => GNav(
          selectedIndex: navigationController.selectedIndex.value,
          onTabChange: (index) =>
              navigationController.selectedIndex.value = index,
          haptic: true,
          gap: 8,
          iconSize: 24,
          tabBorderRadius: 100,
          duration: const Duration(milliseconds: 300),
          color: isDark ? MBGColors.white : MBGColors.darkGrey,
          backgroundColor: isDark ? MBGColors.black : MBGColors.white,
          activeColor: MBGColors.primary,
          hoverColor: MBGColors.primary.withValues(alpha: 0.2),
          rippleColor: MBGColors.primary.withValues(alpha: 0.2),
          tabBackgroundColor: MBGColors.primary.withValues(alpha: 0.1),
          tabs: [
            GButton(icon: Iconsax.house, text: 'PIC Dapur'),
            GButton(icon: Iconsax.box, text: 'PIC Delivery'),
            GButton(icon: Iconsax.buildings, text: 'PIC Sekolah'),
          ],
        ),
      ),
      body: Obx(
        () => IndexedStack(
          index: navigationController.selectedIndex.value,
          children: navigationController.menus,
        ),
      ),
    );
  }
}
