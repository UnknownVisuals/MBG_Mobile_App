import 'package:flutter/material.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/image_strings.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class MBGSocialButtons extends StatelessWidget {
  const MBGSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: MBGColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: MBGSizes.iconMd,
              height: MBGSizes.iconMd,
              image: AssetImage(MBGImages.google),
            ),
          ),
        ),
        const SizedBox(width: MBGSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: MBGColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: MBGSizes.iconMd,
              height: MBGSizes.iconMd,
              image: AssetImage(MBGImages.facebook),
            ),
          ),
        ),
      ],
    );
  }
}
