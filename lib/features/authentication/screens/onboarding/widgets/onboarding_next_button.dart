import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/onboarding_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/device/device_utility.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final OnBoardingController onBoardingController = Get.put(
      OnBoardingController(),
    );

    return Positioned(
      right: MBGSizes.defaultSpace,
      bottom: MBGDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: onBoardingController.nextPage,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: MBGColors.primary,
        ),
        child: const Icon(Iconsax.arrow_right_3, color: MBGColors.white),
      ),
    );
  }
}
