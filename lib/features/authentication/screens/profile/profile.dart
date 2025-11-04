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
    UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: MBGAppBar(title: const Text('Profil'), showBackArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Obx(() {
          final user = userController.userModel.value;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                const MBGSectionHeading(title: 'Informasi Pribadi'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                MBGInfoRow(title: 'Nama', value: user?.name ?? 'Belum diisi'),
                MBGInfoRow(title: 'Email', value: user?.email ?? 'Belum diisi'),
                MBGInfoRow(
                  title: 'Telepon',
                  value: user?.phone ?? 'Belum diisi',
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Role & Work Information Section
                const MBGSectionHeading(title: 'Peran & Informasi Pekerjaan'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                MBGInfoRow(title: 'Peran', value: user?.role ?? 'Belum diisi'),
                if (user?.nomorKendaraan != null)
                  MBGInfoRow(
                    title: 'Nomor Kendaraan',
                    value: user?.nomorKendaraan ?? 'Belum diisi',
                  ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Assignment Information Section
                const MBGSectionHeading(title: 'Tugas'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                MBGInfoRow(
                  title: 'Dapur sebagai PIC',
                  value: user?.dapurAsPIC.isEmpty ?? true
                      ? 'Tidak Ada'
                      : user!.dapurAsPIC.map((dapur) => dapur.nama).join(', '),
                ),
                MBGInfoRow(
                  title: 'Sekolah sebagai PIC',
                  value: user?.sekolahAsPIC.isEmpty ?? true
                      ? 'Tidak Ada'
                      : user!.sekolahAsPIC
                            .map((sekolah) => sekolah.nama)
                            .join(', '),
                ),

                const SizedBox(height: MBGSizes.spaceBtwSections),

                // Account Information Section
                const MBGSectionHeading(title: 'Informasi Akun'),
                const SizedBox(height: MBGSizes.spaceBtwItems),
                MBGInfoRow(
                  title: 'ID Pengguna',
                  value: user?.id ?? 'Belum diisi',
                ),
                MBGInfoRow(
                  title: 'Dibuat pada',
                  value:
                      user?.createdAt.toString().split('.')[0] ?? 'Belum diisi',
                ),
                MBGInfoRow(
                  title: 'Diperbarui pada',
                  value:
                      user?.updatedAt.toString().split('.')[0] ?? 'Belum diisi',
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
