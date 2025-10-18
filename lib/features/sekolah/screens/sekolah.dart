import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';

class SekolahScreen extends StatelessWidget {
  const SekolahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MBGAppBar(title: const Text('Sekolah Screen')),
      body: const Center(child: Text('Welcome to the Sekolah Screen!')),
    );
  }
}
