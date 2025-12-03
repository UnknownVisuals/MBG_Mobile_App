import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';

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

  /// Fungsi deteksi tablet (tanpa responsive.dart)
  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600; // standard threshold tablet
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = MBGHelperFunctions.isDarkMode(context);

    // ==============================
    // EMPTY STATE
    // ==============================
    if (items.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: isDarkMode ? MBGColors.dark : MBGColors.light,
          border: Border.all(
            color: isDarkMode
                ? MBGColors.lightGrey.withValues(alpha: 0.4)
                : MBGColors.grey,
          ),
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

    // ==============================
    // FIX OVERFLOW untuk tablet
    // ==============================
    final double adaptiveHeight =
        _isTablet(context) ? listHeight + 40 : listHeight;

    return SizedBox(
      height: adaptiveHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: MBGSizes.defaultSpace),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: MBGSizes.spaceBtwItems),
        itemBuilder: (context, index) {
          final T item = items[index];
          final Widget child = itemBuilder(context, item, index);

          return IntrinsicHeight(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: adaptiveHeight - 20, // fleksibel untuk tablet
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
