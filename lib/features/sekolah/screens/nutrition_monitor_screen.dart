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
            Icon(Icons.favorite, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nutrition Monitor',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text('Monitor student nutrition status'),
          ],
        ),
      ),
    );
  }
}
