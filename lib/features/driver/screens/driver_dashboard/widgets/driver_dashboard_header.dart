import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class DriverDashboardHeader extends StatelessWidget {
  const DriverDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Driver Dashboard',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now().toLocal()),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: MBGColors.textSecondary),
        ),
      ],
    );
  }
}
