import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbg_mobile_app/features/sekolah/controllers/sekolah_kelas_controller.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kelas/widgets/sekolah_kelas_add.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kelas/widgets/sekolah_kelas_card.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kelas/widgets/sekolah_kelas_delete.dart';
import 'package:mbg_mobile_app/features/sekolah/screens/sekolah_kelas/widgets/sekolah_kelas_edit.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class SekolahKelasScreen extends StatelessWidget {
  const SekolahKelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SekolahKelasController controller = Get.put(SekolahKelasController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.kelasList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: MBGColors.primary),
          );
        }

        if (controller.kelasList.isEmpty) {
          return _buildEmptyState(context, controller);
        }

        return RefreshIndicator(
          color: MBGColors.primary,
          onRefresh: controller.refreshKelas,
          child: ListView.builder(
            padding: const EdgeInsets.all(MBGSizes.md),
            itemCount: controller.kelasList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final kelas = controller.kelasList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: MBGSizes.spaceBtwItems),
                child: SekolahKelasCard(
                  kelas: kelas,
                  index: index,
                  onEdit: () => Get.to(() => SekolahKelasEdit(kelas: kelas)),
                  onDelete: () => showDialog(
                    context: context,
                    builder: (_) => SekolahKelasDeleteDialog(kelas: kelas),
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => Get.to(() => const SekolahKelasAdd()),
          child: const Text('Tambah Kelas'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    SekolahKelasController controller,
  ) {
    return RefreshIndicator(
      color: MBGColors.primary,
      onRefresh: controller.refreshKelas,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.class_outlined, size: 88, color: Colors.grey[400]),
              const SizedBox(height: MBGSizes.spaceBtwItems),
              Text(
                'Belum ada kelas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: MBGSizes.spaceBtwItems / 2),
              Text(
                'Tambahkan kelas baru dengan tombol di bawah',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
