import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/onboarding_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/device/device_utility.dart';

class OnBoardingSkipButton extends StatelessWidget {
  const OnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final OnBoardingController onBoardingController = Get.put(
      OnBoardingController(),
    );

    return Positioned(
      top: MBGDeviceUtils.getAppBarHeight(),
      right: MBGSizes.defaultSpace,
      child: TextButton(
        onPressed: onBoardingController.skipPage,
        child: Text(
          'Lewati'.tr,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: MBGColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
