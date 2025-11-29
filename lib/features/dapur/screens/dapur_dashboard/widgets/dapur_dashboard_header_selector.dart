import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_dashboard_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurDashboardHeaderSelector extends StatelessWidget {
  const DapurDashboardHeaderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DapurDashboardController>();

    return Obx(() {
      final options = controller.dapurOptions;
      if (options.isEmpty) {
        return _buildDapurItem(context, 'Dapur belum tersedia', 'Tunggu data');
      }

      final selected = controller.selectedDapur.value ?? options.first;
      if (options.length == 1) {
        return _buildDapurItem(
          context,
          selected.nama ?? 'Dapur',
          selected.alamat ?? 'Alamat belum tersedia',
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selected.id,
            isExpanded: true,
            icon: const Icon(Iconsax.arrow_down_1),
            onChanged: controller.selectDapurById,
            items: options.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.id,
                child: _buildDapurItem(
                  context,
                  entry.nama ?? 'Dapur',
                  entry.alamat ?? 'Alamat belum tersedia',
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildDapurItem(BuildContext context, String name, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Iconsax.building,
          size: MBGSizes.iconLg,
          color: MBGColors.primary,
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                address,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: MBGColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
