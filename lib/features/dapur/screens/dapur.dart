import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';

class DapurScreen extends StatelessWidget {
  const DapurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MBGAppBar(title: const Text('Dapur Screen')),
      body: const Center(child: Text('Welcome to the Dapur Screen!')),
    );
  }
}
