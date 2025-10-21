import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/checkpoint_controller.dart';
import '../../../models/menu_harian_model.dart';

/// List of menus for checkpoint selection
class CheckpointMenuListWidget extends StatelessWidget {
  final CheckpointController controller;
  final List<MenuHarianModel> menus;

  const CheckpointMenuListWidget({
    super.key,
    required this.controller,
    required this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(MBGSizes.md),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          final isSelected = controller.selectedMenu.value?.id == menu.id;

          return Obx(
            () => Card(
              elevation: isSelected ? 4 : 1,
              color: isSelected
                  ? MBGColors.primary.withValues(alpha: 0.1)
                  : null,
              margin: const EdgeInsets.only(bottom: MBGSizes.sm),
              child: ListTile(
                onTap: () => controller.selectMenu(menu),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MBGColors.primary
                        : MBGColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                  ),
                  child: Icon(
                    Iconsax.note,
                    color: isSelected ? Colors.white : MBGColors.primary,
                  ),
                ),
                title: Text(
                  menu.namaMenu,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${menu.jamMulaiMasak} - ${menu.jamSelesaiMasak}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Icon(
                  isSelected ? Iconsax.tick_circle5 : Iconsax.arrow_right_3,
                  color: isSelected ? MBGColors.primary : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
