import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MBGAppBar(title: const Text('Driver Screen')),
      body: const Center(child: Text('Welcome to the Driver Screen!')),
    );
  }
}
