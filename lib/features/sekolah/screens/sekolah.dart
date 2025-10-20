import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';

class SekolahScreen extends StatelessWidget {
  const SekolahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: MBGAppBar(
        showDrawerIcon: true,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang Kembali,",
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: MBGColors.darkGrey),
              ),
              Text(
                "Halo, ${userController.user.value?.name ?? ''}!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(children: []),
    );
  }
}
