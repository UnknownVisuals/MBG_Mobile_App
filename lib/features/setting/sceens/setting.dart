import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/settings_menu_tile.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MBGSizes.defaultSpace),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MBGSettingsMenuTile(
              icon: Iconsax.hierarchy,
              title: 'Setting 1',
              subTitle: ' Description for setting 1',
              onTap: () {},
            ),
            MBGSettingsMenuTile(
              icon: Iconsax.language_circle,
              title: 'Setting 2',
              subTitle: ' Description for setting 2',
              onTap: () {},
            ),
            MBGSettingsMenuTile(
              icon: Iconsax.activity,
              title: 'Setting 3',
              subTitle: ' Description for setting 3',
              onTap: () {},
            ),
            MBGSettingsMenuTile(
              icon: Iconsax.setting_2,
              title: 'Setting 4',
              subTitle: ' Description for setting 4',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
