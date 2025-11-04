import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurDashboardHeaderSelector extends StatelessWidget {
  const DapurDashboardHeaderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final bool selected = false;

    return selected
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'dapur_id_1',
                isExpanded: true,
                icon: const Icon(Iconsax.arrow_down_1),
                onChanged: (value) {},
                selectedItemBuilder: (BuildContext context) {
                  return [
                    _buildDapurItem(context, 'Dapur 1', 'Alamat Dapur 1'),
                    _buildDapurItem(context, 'Dapur 2', 'Alamat Dapur 2'),
                  ];
                },
                items: [
                  DropdownMenuItem<String>(
                    value: 'dapur_id_1',
                    child: _buildDapurItem(
                      context,
                      'Dapur 1',
                      'Alamat Dapur 1',
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: 'dapur_id_2',
                    child: _buildDapurItem(
                      context,
                      'Dapur 2',
                      'Alamat Dapur 2',
                    ),
                  ),
                ],
              ),
            ),
          )
        : _buildDapurItem(context, 'Dapur', 'Alamat Dapur');
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
