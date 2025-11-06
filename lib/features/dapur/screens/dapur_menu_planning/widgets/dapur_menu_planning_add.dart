import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mbg_mobile_app/common/widgets/appbar.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_menu_planning_controller.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurMenuPlanningAdd extends StatelessWidget {
  const DapurMenuPlanningAdd({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependencies
    final DapurMenuPlanningController dapurMenuPlanningController =
        Get.find<DapurMenuPlanningController>();

    // Form input controllers
    final mingguanKeController = TextEditingController();
    final tanggalMulaiController = TextEditingController();
    final tanggalSelesaiController = TextEditingController();

    // Form state with GetX
    final tanggalMulai = Rx<DateTime?>(null);
    final tanggalSelesai = Rx<DateTime?>(null);
    final selectedSekolahId = Rx<String?>(null);

    // Form Key
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Future<void> selectTanggalMulai() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tanggalMulai.value ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );

      if (picked != null) {
        tanggalMulai.value = picked;
        tanggalMulaiController.text = picked.toString().split(' ')[0];
      }
    }

    Future<void> selectTanggalSelesai() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            tanggalSelesai.value ?? tanggalMulai.value ?? DateTime.now(),
        firstDate: tanggalMulai.value ?? DateTime.now(),
        lastDate: DateTime(2030),
      );

      if (picked != null) {
        tanggalSelesai.value = picked;
        tanggalSelesaiController.text = picked.toString().split(' ')[0];
      }
    }

    return Scaffold(
      appBar: const MBGAppBar(showBackArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MBGSizes.defaultSpace),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Form Tambah Menu Planning Mingguan',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: MBGSizes.spaceBtwSections),

              // Sekolah Dropdown
              Obx(() {
                if (dapurMenuPlanningController.isLoading.value &&
                    dapurMenuPlanningController.sekolahList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: MBGColors.primary),
                  );
                }

                final sekolahList = dapurMenuPlanningController.sekolahList;

                if (sekolahList.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(MBGSizes.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: MBGColors.borderPrimary),
                      borderRadius: BorderRadius.circular(
                        MBGSizes.borderRadiusMd,
                      ),
                    ),
                    child: const Text(
                      'Tidak ada data sekolah tersedia',
                      style: TextStyle(color: MBGColors.textSecondary),
                    ),
                  );
                }

                // Set initial value if not set
                if (selectedSekolahId.value == null) {
                  selectedSekolahId.value = sekolahList.first.id;
                }

                return DropdownButtonFormField<String>(
                  initialValue: selectedSekolahId.value,
                  items: sekolahList.map((sekolah) {
                    return DropdownMenuItem<String>(
                      value: sekolah.id,
                      child: Text(sekolah.nama),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedSekolahId.value = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Sekolah',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Iconsax.building_3),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Silakan pilih sekolah';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              // Mingguan Ke
              TextFormField(
                controller: mingguanKeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mingguan Ke',
                  prefixIcon: Icon(Iconsax.hashtag),
                  hintText: 'Contoh: 1, 2, 3',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan isi mingguan ke';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              // Tanggal Mulai
              TextFormField(
                controller: tanggalMulaiController,
                readOnly: true,
                onTap: selectTanggalMulai,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Mulai',
                  prefixIcon: Icon(Iconsax.calendar_1),
                  hintText: 'Pilih tanggal mulai',
                ),
                validator: (value) {
                  if (tanggalMulai.value == null) {
                    return 'Silakan pilih tanggal mulai';
                  }
                  return null;
                },
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),

              // Tanggal Selesai
              TextFormField(
                controller: tanggalSelesaiController,
                readOnly: true,
                onTap: selectTanggalSelesai,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Selesai',
                  prefixIcon: Icon(Iconsax.calendar_2),
                  hintText: 'Pilih tanggal selesai',
                ),
                validator: (value) {
                  if (tanggalSelesai.value == null) {
                    return 'Silakan pilih tanggal selesai';
                  }
                  if (tanggalMulai.value != null &&
                      tanggalSelesai.value!.isBefore(tanggalMulai.value!)) {
                    return 'Tanggal selesai harus setelah tanggal mulai';
                  }
                  return null;
                },
              ),
              const SizedBox(height: MBGSizes.spaceBtwInputFields),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MBGSizes.spaceBtwItems),
          child: ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await dapurMenuPlanningController.createMenuPlanning(
                  mingguanKe: int.parse(mingguanKeController.text),
                  tanggalMulai: tanggalMulai.value!,
                  tanggalSelesai: tanggalSelesai.value!,
                  sekolahId: selectedSekolahId.value!,
                );
              }
            },
            child: Text('Tambah Menu Planning'),
          ),
        ),
      ),
    );
  }
}
