import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/image_strings.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MBGColors.primary,
              MBGColors.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
            const SizedBox(height: MBGSizes.md),

            // Loading text
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: MBGColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
