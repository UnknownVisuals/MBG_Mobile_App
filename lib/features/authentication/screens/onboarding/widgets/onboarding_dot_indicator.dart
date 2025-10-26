import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/onboarding_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';
import 'package:mbg_mobile_app/utils/device/device_utility.dart';
import 'package:mbg_mobile_app/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotIndicator extends StatelessWidget {
  const OnBoardingDotIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final OnBoardingController onBoardingController = Get.put(
      OnBoardingController(),
    );

    final bool dark = MBGHelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: MBGDeviceUtils.getBottomNavigationBarHeight() + 24,
      left: MBGSizes.defaultSpace,
      child: SmoothPageIndicator(
        count: 3,
        controller: onBoardingController.pageController,
        onDotClicked: onBoardingController.dotNavigationClick,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? MBGColors.light : MBGColors.dark,
          dotHeight: 8,
        ),
      ),
    );
  }
}
