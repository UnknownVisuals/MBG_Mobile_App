import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mbg_mobile_app/common/styles/spacing_styles.dart';
import 'package:mbg_mobile_app/common/widgets/info_row.dart';
import 'package:mbg_mobile_app/common/widgets/section_heading.dart';
import 'package:mbg_mobile_app/features/dapur/controllers/dapur_info_controller.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_map_preview.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_driver_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_karyawan_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_pic_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_sekolah_card.dart';
import 'package:mbg_mobile_app/features/dapur/screens/dapur_info/widgets/dapur_info_stok_card.dart';
import 'package:mbg_mobile_app/utils/constants/colors.dart';
import 'package:mbg_mobile_app/utils/constants/sizes.dart';

class DapurInfoScreen extends StatelessWidget {
  const DapurInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DapurInfoController dapurInfoController = Get.put(
      DapurInfoController(),
    );

    return Obx(
      () => dapurInfoController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(color: MBGColors.primary),
            )
          : SingleChildScrollView(
              padding: MBGSpacingStyles.homeScreenPadding,
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  // Dapur Information Section
                  MBGSectionHeading(
                    showLeadingIcon: true,
                    leadingIcon: Iconsax.information,
                    title: 'Informasi Dapur',
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  MBGInfoRow(
                    title: 'Nama Dapur',
                    value:
                        dapurInfoController.dapurInfo.value?.nama ??
                        'Belum diisi',
                  ),
                  MBGInfoRow(
                    title: 'Alamat',
                    value:
                        dapurInfoController.dapurInfo.value?.alamat ??
                        'Belum diisi',
                  ),
                  MBGInfoRow(
                    title: 'Status',
                    value:
                        dapurInfoController.dapurInfo.value?.status ??
                        'Belum diisi',
                  ),
                  MBGInfoRow(
                    title: 'Koordinat',
                    value: dapurInfoController.dapurInfo.value != null
                        ? '${dapurInfoController.dapurInfo.value!.latitude.toStringAsFixed(6)}, ${dapurInfoController.dapurInfo.value!.longitude.toStringAsFixed(6)}'
                        : 'Belum diisi',
                  ),
                  MBGInfoRow(
                    title: 'Dibuat Pada',
                    value:
                        dapurInfoController.dapurInfo.value?.createdAt != null
                        ? DateFormat('dd MMMM yyyy, HH:mm').format(
                            dapurInfoController.dapurInfo.value!.createdAt
                                .toLocal(),
                          )
                        : 'Belum diisi',
                  ),
                  MBGInfoRow(
                    title: 'Diperbarui Pada',
                    value:
                        dapurInfoController.dapurInfo.value?.updatedAt != null
                        ? DateFormat('dd MMMM yyyy, HH:mm').format(
                            dapurInfoController.dapurInfo.value!.updatedAt
                                .toLocal(),
                          )
                        : 'Belum diisi',
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwSections),

                  // Map Preview
                  MBGSectionHeading(
                    showLeadingIcon: true,
                    leadingIcon: Iconsax.location,
                    title: 'Lokasi Dapur',
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  DapurInfoMapPreview(),
                  const SizedBox(height: MBGSizes.spaceBtwSections),

                  // PIC Dapur Section
                  MBGSectionHeading(
                    showLeadingIcon: true,
                    leadingIcon: Iconsax.profile_2user,
                    title:
                        'PIC Dapur (${dapurInfoController.dapurInfo.value?.picDapur.length ?? 0})',
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  if (dapurInfoController.dapurInfo.value?.picDapur.isEmpty ??
                      true)
                    Center(
                      child: Text(
                        'Tidak ada PIC yang ditugaskan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MBGColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dapurInfoController
                            .dapurInfo
                            .value!
                            .picDapur
                            .length,
                        itemBuilder: (context, index) {
                          final pic = dapurInfoController
                              .dapurInfo
                              .value!
                              .picDapur[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: MBGSizes.spaceBtwItems,
                              left: index == 0 ? 0 : 0,
                            ),
                            child: DapurInfoPicCard(pic: pic),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: MBGSizes.spaceBtwSections),

                  // Drivers Section
                  MBGSectionHeading(
                    showLeadingIcon: true,
                    leadingIcon: Iconsax.truck,
                    title:
                        'Driver (${dapurInfoController.dapurInfo.value?.drivers.length ?? 0})',
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  if (dapurInfoController.dapurInfo.value?.drivers.isEmpty ??
                      true)
                    Center(
                      child: Text(
                        'Tidak ada driver yang ditugaskan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MBGColors.darkGrey,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            dapurInfoController.dapurInfo.value!.drivers.length,
                        itemBuilder: (context, index) {
                          final driver = dapurInfoController
                              .dapurInfo
                              .value!
                              .drivers[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: MBGSizes.spaceBtwItems,
                              left: index == 0 ? 0 : 0,
                            ),
                            child: DapurInfoDriverCard(driver: driver),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: MBGSizes.spaceBtwSections),

                  // Karyawan Section
                  MBGSectionHeading(
                    showLeadingIcon: true,
                    leadingIcon: Iconsax.people,
                    title:
                        'Karyawan (${dapurInfoController.dapurInfo.value?.karyawan.length ?? 0})',
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  if (dapurInfoController.dapurInfo.value?.karyawan.isEmpty ??
                      true)
                    Center(
                      child: Text(
                        'Tidak ada karyawan terdaftar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MBGColors.darkGrey,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dapurInfoController
                            .dapurInfo
                            .value!
                            .karyawan
                            .length,
                        itemBuilder: (context, index) {
                          final karyawan = dapurInfoController
                              .dapurInfo
                              .value!
                              .karyawan[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: MBGSizes.spaceBtwItems,
                              left: index == 0 ? 0 : 0,
                            ),
                            child: DapurInfoKaryawanCard(karyawan: karyawan),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: MBGSizes.spaceBtwSections),

                  // Stok Bahan Baku Section
                  MBGSectionHeading(
                    showLeadingIcon: true,
                    leadingIcon: Iconsax.box,
                    title:
                        'Stok Bahan Baku (${dapurInfoController.dapurInfo.value?.stokBahanBaku.length ?? 0})',
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  if (dapurInfoController
                          .dapurInfo
                          .value
                          ?.stokBahanBaku
                          .isEmpty ??
                      true)
                    Center(
                      child: Text(
                        'Tidak ada stok bahan baku',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MBGColors.darkGrey,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dapurInfoController
                            .dapurInfo
                            .value!
                            .stokBahanBaku
                            .length,
                        itemBuilder: (context, index) {
                          final stok = dapurInfoController
                              .dapurInfo
                              .value!
                              .stokBahanBaku[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: MBGSizes.spaceBtwItems,
                              left: index == 0 ? 0 : 0,
                            ),
                            child: DapurInfoStokCard(stok: stok),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: MBGSizes.spaceBtwSections),

                  // Sekolah Dilayani Section
                  MBGSectionHeading(
                    showLeadingIcon: true,
                    leadingIcon: Iconsax.building_3,
                    title:
                        'Sekolah Dilayani (${dapurInfoController.dapurInfo.value?.sekolahDilayani.length ?? 0})',
                  ),
                  const SizedBox(height: MBGSizes.spaceBtwItems),
                  if (dapurInfoController
                          .dapurInfo
                          .value
                          ?.sekolahDilayani
                          .isEmpty ??
                      true)
                    Center(
                      child: Text(
                        'Tidak ada sekolah yang dilayani',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MBGColors.darkGrey,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dapurInfoController
                            .dapurInfo
                            .value!
                            .sekolahDilayani
                            .length,
                        itemBuilder: (context, index) {
                          final sekolahDilayani = dapurInfoController
                              .dapurInfo
                              .value!
                              .sekolahDilayani[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: MBGSizes.spaceBtwItems,
                              left: index == 0 ? 0 : 0,
                            ),
                            child: DapurInfoSekolahCard(
                              sekolahDilayani: sekolahDilayani,
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: MBGSizes.spaceBtwSections),
                ],
              ),
            ),
    );
  }
}
