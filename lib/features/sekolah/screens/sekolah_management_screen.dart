import 'package:flutter/material.dart';

class SekolahManagementScreen extends StatelessWidget {
  const SekolahManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Sekolah Management',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text('Manage school information'),
          ],
        ),
      ),
    );
  }
}
