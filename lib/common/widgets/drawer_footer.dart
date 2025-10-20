import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

/// Reusable drawer footer widget with logout button
class MBGDrawerFooter extends StatelessWidget {
  const MBGDrawerFooter({super.key, required this.userController});

  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(MBGSizes.md),
      child: OutlinedButton.icon(
        onPressed: () => userController.logout(),
        icon: const Icon(Iconsax.logout),
        label: const Text('Logout'),
      ),
    );
  }
}
