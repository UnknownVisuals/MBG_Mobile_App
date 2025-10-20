import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/device/device_utility.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

class MBGAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MBGAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = false,
    this.showDrawerIcon = false,
  });

  final Widget? title;
  final List<Widget>? actions;
  final IconData? leadingIcon;
  final VoidCallback? leadingOnPressed;
  final bool showBackArrow;
  final bool showDrawerIcon;

  @override
  Widget build(BuildContext context) {
    final dark = MBGHelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MBGSizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Iconsax.arrow_left,
                  color: dark ? MBGColors.white : MBGColors.black,
                ),
              )
            : showDrawerIcon
            ? Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(
                    Iconsax.menu_1,
                    color: dark ? MBGColors.white : MBGColors.black,
                  ),
                ),
              )
            : leadingIcon != null
            ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
            : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MBGDeviceUtils.getAppBarHeight());
}
