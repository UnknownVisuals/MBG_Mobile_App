import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/features/authentication/screens/profile/profile.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Reusable drawer header widget with user profile
class MBGDrawerHeader extends StatelessWidget {
  const MBGDrawerHeader({super.key, required this.userController});

  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = userController.userModel.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        decoration: BoxDecoration(gradient: MBGColors.primaryGradient),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Name and Email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: MBGSizes.spaceBtwItems),

                // Name
                Text(
                  user?.name ?? 'User',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: MBGColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Email
                Text(
                  user?.email ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: MBGColors.white),
                ),

                const SizedBox(height: MBGSizes.spaceBtwItems / 2),

                // Role Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MBGSizes.sm,
                    vertical: MBGSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: MBGColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                    border: Border.all(
                      color: MBGColors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    user?.role.toUpperCase() ?? 'USER',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: MBGColors.white),
                  ),
                ),
              ],
            ),

            // Profile Icon
            IconButton(
              icon: const Icon(Iconsax.user_octagon),
              color: MBGColors.white,
              iconSize: MBGSizes.iconLg,
              tooltip: 'Profile',
              onPressed: () => Get.to(const ProfileScreen()),
            ),
          ],
        ),
      );
    });
  }
}
