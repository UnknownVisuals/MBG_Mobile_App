import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/menu_planning_controller.dart';
import 'empty_menu_harian_widget.dart';
import 'menu_harian_card_widget.dart';
import 'select_planning_prompt_widget.dart';

/// Widget displaying menu harian view with list of daily menus
class MenuHarianViewWidget extends StatelessWidget {
  final MenuPlanningController controller;
  final VoidCallback onAddMenu;

  const MenuHarianViewWidget({
    super.key,
    required this.controller,
    required this.onAddMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedPlanning.value == null) {
        return const SelectPlanningPromptWidget();
      }

      if (controller.isLoadingMenuHarian.value &&
          controller.menuHarians.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(MBGSizes.md),
            decoration: BoxDecoration(
              color: MBGColors.primary.withOpacity(0.05),
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week ${controller.selectedPlanning.value!.mingguanKe} Menu',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${controller.menuHarians.length} daily menus',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onAddMenu,
                  icon: const Icon(Iconsax.add, size: 18),
                  label: const Text('Add Menu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MBGColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Menu List
          Expanded(
            child: controller.menuHarians.isEmpty
                ? const EmptyMenuHarianWidget()
                : ListView.builder(
                    padding: const EdgeInsets.all(MBGSizes.md),
                    itemCount: controller.menuHarians.length,
                    itemBuilder: (context, index) {
                      final menu = controller.menuHarians[index];
                      return MenuHarianCardWidget(menu: menu);
                    },
                  ),
          ),
        ],
      );
    });
  }
}
