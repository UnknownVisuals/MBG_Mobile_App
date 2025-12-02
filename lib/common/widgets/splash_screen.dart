import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/image_strings.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBGSplashScreen extends StatelessWidget {
  const MBGSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: MBGColors.primaryGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(MBGImages.logo, width: 150, height: 150),
            const SizedBox(height: MBGSizes.spaceBtwSections),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MBGColors.white),
            ),
            const SizedBox(height: MBGSizes.spaceBtwItems),

            // Loading text - uses white color to maintain visibility on gradient
            const Text(
              'Loading...',
              style: TextStyle(
                color: MBGColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
