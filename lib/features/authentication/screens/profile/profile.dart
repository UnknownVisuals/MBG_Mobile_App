import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/common/widgets/info_row.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/authentication/controllers/user_controller.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: MBGAppBar(title: const Text('Profile'), showBackArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Obx(() {
          final user = userController.user.value;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                const MBGSectionHeading(title: 'Personal Information'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                MBGInfoRow(title: 'Name', value: user?.name ?? 'N/A'),
                MBGInfoRow(title: 'Email', value: user?.email ?? 'N/A'),
                MBGInfoRow(title: 'Phone', value: user?.phone ?? 'N/A'),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Role & Work Information Section
                const MBGSectionHeading(title: 'Role & Work Information'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                MBGInfoRow(title: 'Role', value: user?.role ?? 'N/A'),
                if (user?.nomorKendaraan != null)
                  MBGInfoRow(
                    title: 'Nomor Kendaraan',
                    value: user?.nomorKendaraan ?? 'N/A',
                  ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Assignment Information Section
                const MBGSectionHeading(title: 'Assignments'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                MBGInfoRow(
                  title: 'Dapur as PIC',
                  value: user?.dapurAsPIC.isEmpty ?? true
                      ? 'None'
                      : user!.dapurAsPIC.join(', '),
                ),
                MBGInfoRow(
                  title: 'Sekolah as PIC',
                  value: user?.sekolahAsPIC.isEmpty ?? true
                      ? 'None'
                      : user!.sekolahAsPIC.join(', '),
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Account Information Section
                const MBGSectionHeading(title: 'Account Information'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                MBGInfoRow(title: 'User ID', value: user?.id ?? 'N/A'),
                MBGInfoRow(
                  title: 'Created At',
                  value: user?.createdAt.toString().split('.')[0] ?? 'N/A',
                ),
                MBGInfoRow(
                  title: 'Updated At',
                  value: user?.updatedAt.toString().split('.')[0] ?? 'N/A',
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
