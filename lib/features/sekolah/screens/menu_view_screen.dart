import 'package:flutter/material.dart';

class MenuViewScreen extends StatelessWidget {
  const MenuViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Menu', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            Text('View weekly menu planning'),
          ],
        ),
      ),
    );
  }
}
