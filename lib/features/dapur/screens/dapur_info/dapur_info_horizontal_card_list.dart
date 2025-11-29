import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoHorizontalCardList<T> extends StatelessWidget {
  const DapurInfoHorizontalCardList({
    super.key,
    required this.items,
    required this.listHeight,
    required this.itemBuilder,
    required this.emptyMessage,
  });

  final List<T> items;
  final double listHeight;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: MBGColors.light,
          border: Border.all(color: MBGColors.borderPrimary),
          borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
        ),
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.warning_2,
                size: MBGSizes.iconLg,
                color: MBGColors.textSecondary,
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems / 2),
              Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MBGColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: listHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: MBGSizes.spaceBtwItems),
            itemBuilder: (context, index) {
              final T item = items[index];
              final Widget child = itemBuilder(context, item, index);

              return ConstrainedBox(
                constraints: BoxConstraints(
                  // ⛔ Mencegah card lebih tinggi dari listHeight
                  maxHeight: constraints.maxHeight,
                ),
                child: child,
              );
            },
            padding: const EdgeInsets.only(left: MBGSizes.defaultSpace),
          );
        },
      ),
    );
  }
}
