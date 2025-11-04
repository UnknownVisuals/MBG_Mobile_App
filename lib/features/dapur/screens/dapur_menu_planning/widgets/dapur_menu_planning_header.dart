import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_planning_add.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurMenuPlanningHeader extends StatelessWidget {
  const DapurMenuPlanningHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Iconsax.menu,
              size: MBGSizes.iconLg,
              color: MBGColors.primary,
            ),

            const SizedBox(width: MBGSizes.spaceBtwItems / 2),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu Planning',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Manage weekly menu plans',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MBGColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: MBGSizes.spaceBtwItems),

        Row(
          children: [
            Row(
              children: [
                const Icon(
                  Iconsax.building_3,
                  size: MBGSizes.iconMd,
                  color: MBGColors.primary,
                ),
                const SizedBox(width: MBGSizes.spaceBtwItems),
                Text(
                  'Dapur A',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: MBGColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: () => Get.to(const DapurMenuPlanningAdd()),
              icon: const Icon(Iconsax.add, size: MBGSizes.iconSm),
              label: Text(
                'New Plan',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MBGColors.textWhite,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MBGColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: MBGSizes.md,
                  vertical: MBGSizes.xs,
                ),
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
