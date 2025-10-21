import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/menu_planning_controller.dart';
import 'widgets/menu_planning_empty_state_widget.dart';
import 'widgets/menu_planning_list_widget.dart';
import 'widgets/menu_harian_view_widget.dart';

/// Main menu planning screen for managing weekly menus
class MenuPlanningScreen extends StatelessWidget {
  const MenuPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MenuPlanningController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.menuPlannings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Header
            Padding(
              padding: MBGSpacingStyles.homeScreenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu Planning',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Manage weekly menu plans',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _showCreatePlanningDialog(context, controller),
                    icon: const Icon(Iconsax.add, size: 20),
                    label: const Text('New Plan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MBGColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: MBGSizes.md,
                        vertical: MBGSizes.sm,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: controller.menuPlannings.isEmpty
                  ? const MenuPlanningEmptyStateWidget()
                  : Row(
                      children: [
                        // Planning List
                        Expanded(
                          flex: 2,
                          child: MenuPlanningListWidget(controller: controller),
                        ),

                        // Menu Harian Details
                        Expanded(
                          flex: 3,
                          child: MenuHarianViewWidget(
                            controller: controller,
                            onAddMenu: () => _showCreateMenuHarianDialog(
                              context,
                              controller,
                              controller.selectedPlanning.value!.id,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }

  /// Show create planning dialog
  void _showCreatePlanningDialog(
    BuildContext context,
    MenuPlanningController controller,
  ) {
    final formKey = GlobalKey<FormState>();
    final mingguanKeController = TextEditingController();
    final sekolahIdController = TextEditingController();
    DateTime? tanggalMulai;
    DateTime? tanggalSelesai;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Menu Planning'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: mingguanKeController,
                  decoration: const InputDecoration(
                    labelText: 'Week Number',
                    prefixIcon: Icon(Iconsax.calendar_1),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter week number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: sekolahIdController,
                  decoration: const InputDecoration(
                    labelText: 'School ID',
                    prefixIcon: Icon(Iconsax.building),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter school ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    children: [
                      ListTile(
                        title: Text(
                          tanggalMulai == null
                              ? 'Select Start Date'
                              : DateFormat('dd MMM yyyy').format(tanggalMulai!),
                        ),
                        leading: const Icon(Iconsax.calendar),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() => tanggalMulai = date);
                          }
                        },
                      ),
                      ListTile(
                        title: Text(
                          tanggalSelesai == null
                              ? 'Select End Date'
                              : DateFormat(
                                  'dd MMM yyyy',
                                ).format(tanggalSelesai!),
                        ),
                        leading: const Icon(Iconsax.calendar),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: tanggalMulai ?? DateTime.now(),
                            firstDate: tanggalMulai ?? DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() => tanggalSelesai = date);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  tanggalMulai != null &&
                  tanggalSelesai != null) {
                final success = await controller.createMenuPlanning(
                  mingguanKe: int.parse(mingguanKeController.text),
                  tanggalMulai: tanggalMulai!,
                  tanggalSelesai: tanggalSelesai!,
                  sekolahId: sekolahIdController.text,
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  /// Show create menu harian dialog
  void _showCreateMenuHarianDialog(
    BuildContext context,
    MenuPlanningController controller,
    String menuPlanningId,
  ) {
    final formKey = GlobalKey<FormState>();
    final namaMenuController = TextEditingController();
    final jamMulaiController = TextEditingController();
    final jamSelesaiController = TextEditingController();
    final biayaController = TextEditingController();
    final kaloriController = TextEditingController();
    final proteinController = TextEditingController();
    final karbohidratController = TextEditingController();
    final lemakController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Daily Menu'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaMenuController,
                  decoration: const InputDecoration(
                    labelText: 'Menu Name',
                    prefixIcon: Icon(Iconsax.note),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter menu name' : null,
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                StatefulBuilder(
                  builder: (context, setState) => ListTile(
                    title: Text(
                      selectedDate == null
                          ? 'Select Date'
                          : DateFormat('dd MMM yyyy').format(selectedDate!),
                    ),
                    leading: const Icon(Iconsax.calendar),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                  ),
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: jamMulaiController,
                        decoration: const InputDecoration(
                          labelText: 'Start Time',
                          hintText: '08:00',
                          prefixIcon: Icon(Iconsax.timer_start),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: MBGSizes.sm),
                    Expanded(
                      child: TextFormField(
                        controller: jamSelesaiController,
                        decoration: const InputDecoration(
                          labelText: 'End Time',
                          hintText: '10:00',
                          prefixIcon: Icon(Iconsax.timer_pause),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: biayaController,
                  decoration: const InputDecoration(
                    labelText: 'Cost per Tray',
                    prefixIcon: Icon(Iconsax.money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter cost' : null,
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: kaloriController,
                        decoration: const InputDecoration(
                          labelText: 'Calories',
                          suffixText: 'kcal',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: MBGSizes.sm),
                    Expanded(
                      child: TextFormField(
                        controller: proteinController,
                        decoration: const InputDecoration(
                          labelText: 'Protein',
                          suffixText: 'g',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: karbohidratController,
                        decoration: const InputDecoration(
                          labelText: 'Carbs',
                          suffixText: 'g',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: MBGSizes.sm),
                    Expanded(
                      child: TextFormField(
                        controller: lemakController,
                        decoration: const InputDecoration(
                          labelText: 'Fat',
                          suffixText: 'g',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedDate != null) {
                final success = await controller.createMenuHarian(
                  planningId: menuPlanningId,
                  namaMenu: namaMenuController.text,
                  tanggal: selectedDate!,
                  jamMulaiMasak: jamMulaiController.text,
                  jamSelesaiMasak: jamSelesaiController.text,
                  biayaPerTray: double.parse(biayaController.text),
                  kalori: double.tryParse(kaloriController.text) ?? 0,
                  protein: double.tryParse(proteinController.text) ?? 0,
                  karbohidrat: double.tryParse(karbohidratController.text) ?? 0,
                  lemak: double.tryParse(lemakController.text) ?? 0,
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
