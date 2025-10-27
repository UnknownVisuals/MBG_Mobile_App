import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/image_strings.dart';
import 'package:mbg_mobile_app/utils/constants/text_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          const Image(height: 150, image: AssetImage(MBGImages.logo)),

          // Title
          Text(
            MBGTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),

          // Subtitle
          Text(
            MBGTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
