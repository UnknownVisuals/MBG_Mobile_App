import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/menu_planning_model.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

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
                  ? _buildEmptyState(context)
                  : Row(
                      children: [
                        // Planning List
                        Expanded(
                          flex: 2,
                          child: _buildPlanningList(context, controller),
                        ),

                        // Menu Harian Details
                        Expanded(
                          flex: 3,
                          child: _buildMenuHarianView(context, controller),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.calendar, size: 80, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'No Menu Plans Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Create your first weekly menu plan',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanningList(
    BuildContext context,
    MenuPlanningController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(MBGSizes.md),
        itemCount: controller.menuPlannings.length,
        itemBuilder: (context, index) {
          final planning = controller.menuPlannings[index];
          final isSelected =
              controller.selectedPlanning.value?.id == planning.id;

          return Obx(
            () => Card(
              elevation: isSelected ? 4 : 1,
              color: isSelected ? MBGColors.primary.withOpacity(0.1) : null,
              margin: const EdgeInsets.only(bottom: MBGSizes.sm),
              child: ListTile(
                onTap: () => controller.selectPlanning(planning),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MBGColors.primary
                        : MBGColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'W${planning.mingguanKe}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : MBGColors.primary,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Week ${planning.mingguanKe}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${DateFormat('dd MMM').format(planning.tanggalMulai)} - ${DateFormat('dd MMM yyyy').format(planning.tanggalSelesai)}',
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

  Widget _buildMenuHarianView(
    BuildContext context,
    MenuPlanningController controller,
  ) {
    return Obx(() {
      if (controller.selectedPlanning.value == null) {
        return _buildSelectPlanningPrompt(context);
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
                  onPressed: () => _showCreateMenuHarianDialog(
                    context,
                    controller,
                    controller.selectedPlanning.value!.id,
                  ),
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
                ? _buildEmptyMenuHarian(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(MBGSizes.md),
                    itemCount: controller.menuHarians.length,
                    itemBuilder: (context, index) {
                      final menu = controller.menuHarians[index];
                      return _buildMenuHarianCard(context, menu);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildSelectPlanningPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.arrow_left, size: 60, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'Select a Menu Plan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Choose a week to view daily menus',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMenuHarian(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.note, size: 60, color: Colors.grey[300]),
          const SizedBox(height: MBGSizes.spaceBtwItems),
          Text(
            'No Daily Menus',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: MBGSizes.sm),
          Text(
            'Add daily menus for this week',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHarianCard(BuildContext context, dynamic menu) {
    return Card(
      margin: const EdgeInsets.only(bottom: MBGSizes.md),
      child: Padding(
        padding: const EdgeInsets.all(MBGSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.namaMenu,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: MBGSizes.xs),
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: MBGSizes.xs),
                          Text(
                            DateFormat(
                              'EEEE, dd MMM yyyy',
                            ).format(menu.tanggal),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MBGSizes.md,
                    vertical: MBGSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: MBGColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      MBGSizes.borderRadiusMd,
                    ),
                  ),
                  child: Text(
                    'Rp ${menu.biayaPerTray.toStringAsFixed(0)}/tray',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MBGColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: MBGSizes.spaceBtwItems),

            // Cooking Times
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    context,
                    Iconsax.timer_start,
                    'Start',
                    menu.jamMulaiMasak,
                    MBGColors.primary,
                  ),
                ),
                const SizedBox(width: MBGSizes.sm),
                Expanded(
                  child: _buildInfoChip(
                    context,
                    Iconsax.timer_pause,
                    'End',
                    menu.jamSelesaiMasak,
                    MBGColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: MBGSizes.sm),

            // Nutrition Info
            Container(
              padding: const EdgeInsets.all(MBGSizes.sm),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(MBGSizes.borderRadiusMd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNutritionInfo(
                    context,
                    'Kalori',
                    menu.kalori,
                    'kcal',
                    Icons.local_fire_department,
                  ),
                  _buildNutritionInfo(
                    context,
                    'Protein',
                    menu.protein,
                    'g',
                    Icons.egg,
                  ),
                  _buildNutritionInfo(
                    context,
                    'Karbo',
                    menu.karbohidrat,
                    'g',
                    Icons.grain,
                  ),
                  _buildNutritionInfo(
                    context,
                    'Lemak',
                    menu.lemak,
                    'g',
                    Icons.water_drop,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(MBGSizes.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(MBGSizes.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: MBGSizes.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo(
    BuildContext context,
    String label,
    double value,
    String unit,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: MBGColors.primary),
        const SizedBox(height: MBGSizes.xs),
        Text(
          '${value.toStringAsFixed(1)}$unit',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

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
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      tanggalMulai = date;
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    tanggalSelesai == null
                        ? 'Select End Date'
                        : DateFormat('dd MMM yyyy').format(tanggalSelesai!),
                  ),
                  leading: const Icon(Iconsax.calendar),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: tanggalMulai ?? DateTime.now(),
                      firstDate: tanggalMulai ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      tanggalSelesai = date;
                      (context as Element).markNeedsBuild();
                    }
                  },
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

  void _showCreateMenuHarianDialog(
    BuildContext context,
    MenuPlanningController controller,
    String planningId,
  ) {
    final formKey = GlobalKey<FormState>();
    final namaMenuController = TextEditingController();
    final biayaController = TextEditingController();
    final jamMulaiController = TextEditingController();
    final jamSelesaiController = TextEditingController();
    final kaloriController = TextEditingController();
    final proteinController = TextEditingController();
    final karbohidratController = TextEditingController();
    final lemakController = TextEditingController();
    DateTime? tanggal;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Daily Menu'),
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
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    tanggal == null
                        ? 'Select Date'
                        : DateFormat('dd MMM yyyy').format(tanggal!),
                  ),
                  leading: const Icon(Iconsax.calendar),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate:
                          controller.selectedPlanning.value!.tanggalMulai,
                      firstDate:
                          controller.selectedPlanning.value!.tanggalMulai,
                      lastDate:
                          controller.selectedPlanning.value!.tanggalSelesai,
                    );
                    if (date != null) {
                      tanggal = date;
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: biayaController,
                  decoration: const InputDecoration(
                    labelText: 'Cost per Tray (Rp)',
                    prefixIcon: Icon(Iconsax.money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: jamMulaiController,
                        decoration: const InputDecoration(
                          labelText: 'Start Time (HH:MM)',
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
                          labelText: 'End Time (HH:MM)',
                          prefixIcon: Icon(Iconsax.timer_pause),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                const Text(
                  'Nutritional Information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: MBGSizes.sm),
                TextFormField(
                  controller: kaloriController,
                  decoration: const InputDecoration(
                    labelText: 'Calories (kcal)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: proteinController,
                  decoration: const InputDecoration(labelText: 'Protein (g)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: karbohidratController,
                  decoration: const InputDecoration(
                    labelText: 'Carbohydrates (g)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: MBGSizes.spaceBtwInputFields),
                TextFormField(
                  controller: lemakController,
                  decoration: const InputDecoration(labelText: 'Fat (g)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
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
              if (formKey.currentState!.validate() && tanggal != null) {
                final success = await controller.createMenuHarian(
                  planningId: planningId,
                  tanggal: tanggal!,
                  namaMenu: namaMenuController.text,
                  biayaPerTray: double.parse(biayaController.text),
                  jamMulaiMasak: jamMulaiController.text,
                  jamSelesaiMasak: jamSelesaiController.text,
                  kalori: double.parse(kaloriController.text),
                  protein: double.parse(proteinController.text),
                  karbohidrat: double.parse(karbohidratController.text),
                  lemak: double.parse(lemakController.text),
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
}
