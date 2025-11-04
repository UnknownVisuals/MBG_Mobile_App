import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_menu_planning/widgets/dapur_menu_harian_card.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Stateless showcase of the daily menus section using hardcoded sample data.
class DapurMenuHarianList extends StatelessWidget {
  const DapurMenuHarianList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DapurMenuHarianCard(
          data: MenuHarianCardData(
            title: 'Menu Hari Senin',
            date: DateTime(2025, 11, 3),
            costPerTray: 25000,
            startTime: '08:00',
            endTime: '10:00',
            calories: 550,
            protein: 25,
            carbs: 70,
            fat: 15,
          ),
        ),

        const SizedBox(height: MBGSizes.spaceBtwItems),

        DapurMenuHarianCard(
          data: MenuHarianCardData(
            title: 'Menu Hari Selasa',
            date: DateTime.now(),
            costPerTray: 27000,
            startTime: '08:00',
            endTime: '10:00',
            calories: 600,
            protein: 30,
            carbs: 80,
            fat: 20,
          ),
        ),

        const SizedBox(height: MBGSizes.spaceBtwItems),

        DapurMenuHarianCard(
          data: MenuHarianCardData(
            title: 'Menu Hari Rabu',
            date: DateTime(2025, 11, 5),
            costPerTray: 26000,
            startTime: '08:00',
            endTime: '10:00',
            calories: 580,
            protein: 28,
            carbs: 75,
            fat: 18,
          ),
        ),

        const SizedBox(height: MBGSizes.spaceBtwItems),
      ],
    );
  }
}
