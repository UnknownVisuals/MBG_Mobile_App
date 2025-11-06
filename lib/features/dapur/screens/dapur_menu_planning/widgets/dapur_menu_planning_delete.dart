import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/features/dapur/models/dapur_menu_planning_model.dart';

class DapurMenuPlanningDelete extends StatelessWidget {
  const DapurMenuPlanningDelete({super.key, required this.menuPlanning});

  final DapurMenuPlanningModel menuPlanning;
  @override
  Widget build(BuildContext context) {
    final DapurMenuPlanningController controller =
        Get.find<DapurMenuPlanningController>();

    return AlertDialog(
      title: const Text('Hapus Menu Planning'),
      content: Text(
        'Apakah Anda yakin ingin menghapus menu planning Mingguan Ke-${menuPlanning.mingguanKe}? Tindakan ini tidak dapat dibatalkan.',
      ),
      actions: [
        OutlinedButton(onPressed: () => Get.back(), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () async {
            await controller.deleteMenuPlanning(planningId: menuPlanning.id);
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
