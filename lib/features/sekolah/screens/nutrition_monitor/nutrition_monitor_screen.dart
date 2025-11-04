import 'package:flutter/material.dart';

class NutritionMonitorScreen extends StatelessWidget {
  const NutritionMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Nutrition Monitor',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Monitor student nutrition status'),
          ],
        ),
      ),
    );
  }
}
