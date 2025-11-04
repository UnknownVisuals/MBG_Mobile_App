import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class _MenuPlanCardData {
  final String title;
  final String range;
  final bool isHighlighted;

  const _MenuPlanCardData({
    required this.title,
    required this.range,
    this.isHighlighted = false,
  });
}

/// List widget displaying menu planning weeks using sample data
class DapurMenuPlanningList extends StatelessWidget {
  const DapurMenuPlanningList({super.key});

  static const List<_MenuPlanCardData> _plans = [
    _MenuPlanCardData(
      title: 'Week 1',
      range: '01 Nov - 07 Nov 2025',
      isHighlighted: true,
    ),
    _MenuPlanCardData(title: 'Week 2', range: '08 Nov - 14 Nov 2025'),
    _MenuPlanCardData(title: 'Week 3', range: '15 Nov - 21 Nov 2025'),
    _MenuPlanCardData(title: 'Week 4', range: '22 Nov - 28 Nov 2025'),
  ];

  @override
  Widget build(BuildContext context) {
    final DapurMenuPlanningController dapurMenuPlanningController =
        Get.find<DapurMenuPlanningController>();

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _plans.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: MBGSizes.spaceBtwItems),
        itemBuilder: (context, index) {
          final plan = _plans[index];
          final cardColor = plan.isHighlighted
              ? MBGColors.primary.withValues(alpha: 0.1)
              : MBGColors.light;
          return Container(
            width: 200,
            padding: const EdgeInsets.all(MBGSizes.defaultSpace / 2),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              border: Border.all(
                color: plan.isHighlighted
                    ? MBGColors.primary
                    : MBGColors.borderPrimary,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: plan.isHighlighted
                        ? MBGColors.primary
                        : MBGColors.textPrimary,
                  ),
                ),
                Text(plan.range, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      Iconsax.edit,
                      size: MBGSizes.iconSm,
                      color: MBGColors.primary,
                    ),
                    SizedBox(width: MBGSizes.spaceBtwItems),
                    Icon(
                      Iconsax.trash,
                      size: MBGSizes.iconSm,
                      color: MBGColors.error,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
