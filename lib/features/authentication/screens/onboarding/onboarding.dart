import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/onboarding_controller.dart';
import 'package:mbg_mobile_app/features/authentication/screens/onboarding/widgets/onboarding_dot_indicator.dart';
import 'package:mbg_mobile_app/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:mbg_mobile_app/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:mbg_mobile_app/features/authentication/screens/onboarding/widgets/onboarding_skip_button.dart';
import 'package:mbg_mobile_app/utils/constants/image_strings.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnBoardingController onBoardingController = Get.put(
      OnBoardingController(),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Scrollable Pages
          PageView(
            controller: onBoardingController.pageController,
            onPageChanged: onBoardingController.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: MBGImages.mbg,
                title: MBGTexts.onBoardingTitle1,
                subTitle: MBGTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: MBGImages.payment,
                title: MBGTexts.onBoardingTitle2,
                subTitle: MBGTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: MBGImages.delivery,
                title: MBGTexts.onBoardingTitle3,
                subTitle: MBGTexts.onBoardingSubTitle3,
              ),
            ],
          ),

          // Skip Button
          const OnBoardingSkipButton(),

          // Dots Indicator
          const OnBoardingDotIndicator(),

          // Next Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
